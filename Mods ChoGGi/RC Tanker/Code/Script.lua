-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 61
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","RC Tanker requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local TableConcat
local Random
local Strings
local Translate
-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	Strings = ChoGGi.Strings
	TableConcat = ChoGGi.ComFuncs.TableConcat
	Random = ChoGGi.ComFuncs.Random
	Translate = ChoGGi.ComFuncs.Translate
end

RCTankerMCR = {
	LimitStorage = 0,
}

-- local some globals
local IsValid = IsValid
local Sleep = Sleep
local MulDivRound = MulDivRound
local T = T
local table_remove = table.remove
local ResourceScale = const.ResourceScale

local name = [[RC Tanker]]
local description = [[Used to transport oxygen and water between tanks.
Tank will always refer to the storage on the ground, not the tank on the RC.]]
local display_icon = CurrentModPath .. "UI/rover_tanker.png"

local entity_tank = "AirTank"
if IsValidEntity("OxygenTankLargeCP3") then
	entity_tank = "OxygenTankLargeCP3"
end

local entity_rc = "RoverTransport"
if IsValidEntity("RoverChinaSolarRC") then
	entity_rc = "RoverChinaSolarRC"
end
local entity_rc_building = "RoverTransportBuilding"
if IsValidEntity("RoverChinaSolarRCBuilding") then
	entity_rc_building = "RoverChinaSolarRCBuilding"
end

DefineClass.RCTankerTank = {
	__parents = {
		"Shapeshifter",
		"StorageWithIndicators",
	},
	entity = entity_tank,
	indicator_class = "AirTankArrow",

	-- i want it fairly unique since we're using it as an id in ClassesPostprocess
	fx_actor_class = "ChoGGi_RCTankerTank",
}
function RCTankerTank:Init()
	-- otherwise the rc will get confused when you GotoFromUser
	self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)

	-- attach the arrow objs
	local id_start, id_end = self:GetSpotBeginIndex("Autoattach"),self:GetSpotEndIndex("Autoattach")
	for i = id_start, id_end do
		local spot_annotation = self:GetSpotAnnotation(i)
		if spot_annotation and spot_annotation:find("AirTankArrow") then
			self:Attach(PlaceObject("AirTankArrow"), i)
			-- attaching the tank to the rc makes all the tanks attach spots get mushed into origin (or somewhere)
			break
		end
	end
end

RCTankerTank.ResetIndicatorAnimations = StorageWithIndicators.ResetIndicatorAnimations

function RCTankerTank:ResetArrow()
	self:ForEachAttach("AirTankArrow",function(a)
		a:SetAnimPhase(1,3333)
	end)
end

function RCTankerTank:UpdateIndicators(res_obj)
	if not res_obj then
		return
	end
	-- we just use the capacity from whatever tank we're working with
	self:ForEachAttach("AirTankArrow",function(a)
		-- local StorageIndicatorAnimDuration = 3333
		local phase = MulDivRound(res_obj.current_storage, 3333, res_obj.storage_capacity)
		-- we want to build up to 3333 instead of down
		a:SetAnimPhase(1, 3333 - phase)
	end)
end

DefineClass.RCTanker = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
	},
  name = name,
	description = description,
	display_icon = display_icon,
	display_name = name,

	entity = entity_rc,
--~ 	accumulate_dust = false,
	status_text = _InternalTranslate(T(6722--[[Idle--]])),
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * ResourceScale, MachineParts = 20 * ResourceScale , Electronics = 10 * ResourceScale },

	-- "AirStorage" or "WaterStorage" (defaults to air)
	tank_type = false,
	-- green chemical leak? dunno just some visual indicator
	tank_particle = false,

	-- how close to interact
	min_dist_to_tank = 1400,

	amount_per_loop = 500,
	delay_per_loop = 100,

	-- how much are we storing
	storage_amount = false,

	-- ref to tank we're fiddling with
	tank_interact_obj = false,

	-- true = drain tank, false = fill
	tank_direction = true,

  palette = {
    "rover_base",
    "rover_dark",
    "rover_accent",
    "none"
  },

	-- show the pin info
	pin_rollover = T(0,"<ui_command>"),
}

function RCTanker:Init()
	self.tank_type = "AirStorage"
	self.storage_amount = 0

	local tank = PlaceObject("RCTankerTank")
	self.tank_obj = tank

	if entity_tank == "OxygenTankLargeCP3" then
		self:Attach(tank, self:GetSpotBeginIndex("Panel"))
		tank:SetScale(35)
		tank:SetAttachOffset(point(0,0,83))
	else
		self:Attach(tank, self:GetSpotBeginIndex("Drone"))
		tank:SetScale(70)
		tank:SetAttachOffset(point(-360,0,980))

		-- rotate it a bit
		local rotate = quaternion(0, 2700, 0) * quaternion(0, 2700, 0)
		local rotate_axis, rotate_angle = rotate:GetAxisAngle()
		tank:SetAttachAxis(rotate_axis)
		tank:SetAttachAngle(rotate_angle)
	end

	-- stop arrows from spinning round n round
	tank:ResetIndicatorAnimations()
end

function RCTanker:GameInit()
--~ 	BaseRover.GameInit(self)

	-- select sound
	self.fx_actor_class = "AttackRover"

	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, -14710529, 12, 32)
	-- body
	self:SetColorizationMaterial(2, -14710529, 12, 32)
	-- color of bands
	self:SetColorizationMaterial(3, -13028496, 0, 12)

	-- air
	self.tank_obj:SetColorizationMaterial(1, -4450778, -24, 0)
--~ 	-- water
--~ 	self.tank_obj:SetColorizationMaterial(1, -12211457, -24, 0)
	self.tank_obj:SetColorizationMaterial(2, -3815995, 0, 0)
	self.tank_obj:SetColorizationMaterial(3, -15328580, -28, 0)
end

local temp_status_table = {}
function RCTanker:Getui_command()
	temp_status_table[1] = self.status_text
	if self.tank_type == "AirStorage" then
		temp_status_table[2] = Translate(1074--[[Stored Air--]]) .. " <image UI/Icons/Sections/Oxygen_1.tga> : " .. self.storage_amount / ResourceScale
	else
		temp_status_table[2] = Translate(33--[[Stored Water--]]) .. " <image UI/Icons/Sections/Water_1.tga> : " .. self.storage_amount / ResourceScale
	end

	return TableConcat(temp_status_table, "<newline><left>")
end

function RCTanker:GotoFromUser(...)
	self.status_text = Translate(63--[[Travelling--]])
	-- if user broke off TankInteract then clear this here
	self:TankInteractCleanup(2)
	return BaseRover.GotoFromUser(self,...)
end

function RCTanker:Idle()
	self.status_text = Translate(6722--[[Idle--]])

	self:SetState("idle")
	self:Gossip("Idle")

	DeleteThread(self.command_thread,true)
	self.command_thread = false
end

function RCTanker:RetResIconText()
	local res_type = ""
	if self.tank_type == "AirStorage" then
		res_type = "<image UI/Icons/Sections/Oxygen_1.tga> " .. Translate(682--[[Oxygen--]])
	else
		res_type = "<image UI/Icons/Sections/Water_1.tga> " .. Translate(681--[[Water--]])
	end
	return res_type
end

-- returns false or number value (0 working, 1+ error)
function RCTanker:RetInteractInfo(obj)
  if self.command == "Dead" or not IsValid(obj) then
    return false
  end

	local tank_type = self.tank_type

	local res_obj,text
	if self.tank_type == "AirStorage" then
		res_obj,text = obj.air,Translate(682--[[Oxygen--]])
	else
		res_obj,text = obj.water,Translate(681--[[Water--]])
	end

	local interact = self.interaction_mode
	if (interact == false or interact == "default" or interact == "move") then
		if res_obj and obj:IsKindOf(tank_type) then

			local direction = self.tank_direction
			local amount = self.storage_amount

			-- 0 means no limit
			local limit = RCTankerMCR.LimitStorage
			-- resources use 1 to display 1000, so that's what we edit in MCR
			limit = limit > 0 and limit * ResourceScale or false

			-- true = drain tank, false = fill
			if direction == true then
				if limit and amount >= limit then
					-- 3 rc tank is full
					return 3
				end
				if res_obj.current_storage == 0 then
					-- 4 tank is empty
					return 4
				end
			else
				if amount == 0 then
					-- 5 rc tank is empty
					return 5
				end
				if res_obj.current_storage == res_obj.storage_capacity then
					-- 6 tank is full
					return 6
				end
			end

			-- 0 all good
			return 0
		elseif obj:IsKindOfClasses("AirStorage","WaterStorage") and not res_obj then
			-- 2 tank but wrong tank type
			return 2
		end
	end

	-- 1 nothing we can interact with
	return 1
end

function RCTanker:CanInteractWithObject(obj, ...)
	local status = self:RetInteractInfo(obj)
	if status then
		if status == 0 then
			return true, T(0, "<UnitMoveControl('ButtonA',interaction_mode)>:    "
				.. (self.tank_direction and "<image UI/Icons/IPButtons/unload.tga> Drain" or "<image UI/Icons/IPButtons/load.tga> Fill")
				.. " " .. self:RetResIconText() .. " Tank.")
		elseif status == 1 then
			return BaseRover.CanInteractWithObject(self, obj, ...)
		elseif status == 2 then
			return false, T(0, "<image UI/Common/mission_no.tga 1600>: Not "
				.. self:RetResIconText() .. " Tank.")
		elseif status == 3 then
			return false, T(0, "<image UI/Common/mission_no.tga 1600>: RC tank is full!")
		elseif status == 4 then
			return false, T(0, "<image UI/Common/mission_no.tga 1600>: "
				.. self:RetResIconText() .. " Tank is empty!")
		elseif status == 5 then
			return false, T(0, "<image UI/Common/mission_no.tga 1600>: RC tank is empty!")
		elseif status == 6 then
			return false, T(0, "<image UI/Common/mission_no.tga 1600>: "
				.. self:RetResIconText() .. " Tank is full!")
		end
	end

	return BaseRover.CanInteractWithObject(self, obj, ...)
end

function RCTanker:InteractWithObject(obj, ...)
	local status = self:RetInteractInfo(obj)
	if status == 0 then
		self.tank_interact_obj = obj
		self:SetCommand("TankInteract")
		SetUnitControlInteractionMode(self, false) --toggle button
	end

	return BaseRover.InteractWithObject(self, obj, ...)
end

function RCTanker:TankInteractCleanup(skip)
	if IsValid(self.tank_particle) then
		self.tank_particle:delete()
	end

	if skip ~= 1 then
		-- reset this so loadgame doesn't start it up
		self.tank_interact_obj = false
	end

	if skip ~= 2 then
		self.tank_obj:ResetArrow()
	end
end

function RCTanker:TankInteract()
	self:TankInteractCleanup(1)

	local obj = self.tank_interact_obj
	-- make sure we're "close" enough
	if obj:GetPos():Dist2D(self:GetPos()) > self.min_dist_to_tank then
		self.status_text = Translate(63--[[Travelling--]])
		local nearest = obj:GetNearestSpot("idle", "Workrover", self)
		self:Goto(obj:GetSpotPos(nearest))
		self:SetState("idle")
		self.status_text = Translate(6722--[[Idle--]])
	end

	-- if something went sideways between clicking and starting
	if self:RetInteractInfo(obj) ~= 0 then
		return false
	end

	local tank_type = self.tank_type
	local res_obj,res_type

	if tank_type == "AirStorage" then
		res_obj = obj.air
		res_type = "air"
	else
		res_obj = obj.water
		res_type = "water"
	end

	local current_storage = res_obj.current_storage

	-- 0 means no limit
	local limit = RCTankerMCR.LimitStorage
	-- resources use 1 to display 1000, so that's what we edit in MCR
	limit = limit > 0 and limit * ResourceScale or false

	SetUnitControlInteraction(false, self)

	-- spawn a water particle and pos it
	local part = PlaceParticles("HydroponicFarm_Shower")
	-- greeny
	part:SetColorModifier(-12539077)
	-- we start at the nightlight spot
	part:SetAngle(self:GetAngle())
	self:Attach(part, self:GetSpotBeginIndex("Particle1"))
	self.tank_particle = part

	if entity_tank == "OxygenTankLargeCP3" then
		part:SetAttachAngle(8800 + Random(1,2700))
		part:SetAttachOffset(point(-300,475,525))
	else
		part:SetAttachAngle(9800 + Random(1,2700))
		part:SetAttachOffset(point(-250,550,700))
	end

	local amount = self.amount_per_loop
	local delay = self.delay_per_loop

	-- drain tank to rc loop
	if self.tank_direction then
		self.status_text = Translate(11039--[[Loading cargo--]])
		while self.tank_interact_obj and res_obj.current_storage > 0 do
			Sleep(delay)

			-- see if we can remove 500 from the tank to add to the rc
			local take_from = res_obj.current_storage - amount
			local add_to = amount
			if take_from < 1 then
				take_from = 0
				add_to = res_obj.current_storage
			end
			-- update rc
			self.storage_amount = self.storage_amount + add_to
			-- update tank
			res_obj:SetStoredAmount(take_from, res_type)

			-- the wee little arrow
			self.tank_obj:UpdateIndicators(res_obj)
			obj:UpdateIndicators()

			-- if there's a limit than check if we're there
			if limit and self.storage_amount == limit then
				break
			end
		end
	-- fill tank from rc
	else
		self.status_text = Translate(11409--[[Unloading cargo--]])
		local max_cap = res_obj.storage_capacity
		while self.tank_interact_obj and self.storage_amount > 0 do
			Sleep(delay)
			--
			local new_amount = amount
			if self.storage_amount - new_amount < 1 then
				new_amount = self.storage_amount
			end
			self.storage_amount = self.storage_amount - new_amount
			res_obj:SetStoredAmount(res_obj.current_storage + new_amount, res_type)

			self.tank_obj:UpdateIndicators(res_obj)
			obj:UpdateIndicators()

			-- don't overfill tanks (waste of res)
			if res_obj.current_storage == max_cap then
				break
			end
		end
	end

	-- reverse the polarity
	self.tank_direction = not self.tank_direction
	self:TankInteractCleanup()

	self:SetCommand("Idle")
end

DefineClass.RCTankerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "RCTanker",
}

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.RCTankerBuilding then
		PlaceObj("BuildingTemplate",{
			"Id","RCTankerBuilding",
			"template_class","RCTankerBuilding",
			-- pricey?
			"construction_cost_Metals",40000,
			"construction_cost_MachineParts",40000,
			"construction_cost_Electronics",20000,
			-- add a bit of pallor to the skeleton
			"palette_color1", "rover_base",

			"dome_forbidden",true,
			"display_name",name,
			"display_name_pl",name,
			"description",description,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude",true,
			"on_off_button",false,
			"entity", entity_rc_building,
		})
	end
end

-- add some prod info to selection panel
function OnMsg.ClassesBuilt()
	local rover = XTemplates.ipRover[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCTanker_ToggleDir",true)
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCTanker_ToggleRes",true)

	local function UpdateToggleDir(self,button)
		if self.tank_interact_obj then
			self:TankInteractCleanup()
			self:SetCommand("Idle")
		end

		if self.tank_direction then
			self.tank_direction = false
			button:SetRolloverText([[Fill tank resource from RC.

Press to toggle.]])
			button:SetRolloverTitle([[Fill Tank]])
			button:SetIcon("UI/Icons/IPButtons/load.tga")
		else
			self.tank_direction = true
			button:SetRolloverText([[Drain resource from tank to RC.

Press to toggle.]])
			button:SetRolloverTitle([[Drain Tank]])
			button:SetIcon("UI/Icons/IPButtons/unload.tga")
		end

	end

	table.insert(
		rover,
		#rover+1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_RCTanker_ToggleDir", true,
			"comment", "fill/drain toggle",
			"__context_of_kind", "RCTanker",
			"__template", "InfopanelButton",
			"RolloverText", [[Drain resource from tank to RC.

Press to toggle.]],
			"RolloverTitle", [[Drain Tank]],
			"Icon", "UI/Icons/IPButtons/unload.tga",
			"OnPress", function (self, gamepad)
				UpdateToggleDir(self.context,self)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				if gamepad then
					UpdateToggleDir(self.context,self)
				end
			end,
		})
	)

	local function UpdateToggleRes(self,button)
		if self.tank_interact_obj then
			self:TankInteractCleanup()
			self:SetCommand("Idle")
		end
		if self.tank_type == "AirStorage" then
			self.tank_type = "WaterStorage"
			button:SetRolloverTitle(Translate(681--[[Water--]]) .. "\n\nPress to toggle.")
			button:SetIcon("UI/Icons/Sections/Water_1.tga")
			self.tank_obj:SetColorizationMaterial(1, -12211457, -24, 0)
		else
			self.tank_type = "AirStorage"
			button:SetRolloverTitle(Translate(682--[[Oxygen--]]) .. "\n\nPress to toggle.")
			button:SetIcon("UI/Icons/Sections/Oxygen_1.tga")
			self.tank_obj:SetColorizationMaterial(1, -4450778, -24, 0)
		end
		-- type changed so "dump" stored
		self.storage_amount = 0
	end

	table.insert(
		rover,
		#rover+1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_RCTanker_ToggleRes", true,
			"comment", "air/water toggle",
			"__context_of_kind", "RCTanker",
			"__template", "InfopanelButton",
			"Icon", "UI/Icons/Sections/Oxygen_1.tga",
			"RolloverTitle", Translate(682--[[Oxygen--]]) .. "\n\nPress to toggle.",
			"RolloverText", T(0,[[Type of resource you can transfer with this RC.

<image UI/Common/mission_no.tga 1600> Warning: Changing will empty RC tank!]]),
			"OnPress", function (self, gamepad)
				UpdateToggleRes(self.context,self)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				if gamepad then
					UpdateToggleRes(self.context,self)
				end
			end,
		})
	)

end

-- the below is for removing the persist warnings from the log
local orig_PersistGame = PersistGame
function PersistGame(...)
	local ret = orig_PersistGame(...)
	Msg("PostSaveGame")
	return ret
end

-- idle any tankers, and save state of tankers fiddling with tanks
function OnMsg.SaveGame()
	-- kill off the threads (spews c func persist errors in log)
	local tankers = UICity.labels.RCTanker or ""
	for i = 1, #tankers do
		local t = tankers[i]
		-- if user said go somewhere then we store the pos
		if t.command == "GotoFromUser" and t.goto_target and t.goto_target:IsValid() then
			t.resume_goto = t.goto_target
		end

		-- there's a DeleteThread in my Idle cmd
		t:SetCommand("Idle")
	end
end
-- restore GotoFromUser or TankInteract
local function RestoreCmds()
	local tankers = UICity.labels.RCTanker or ""
	for i = 1, #tankers do
		local t = tankers[i]
		if IsValid(t.tank_interact_obj) then
			t:SetCommand("TankInteract")
		elseif t.resume_goto and t.resume_goto:IsValid() then
			local pos = t.resume_goto
			t.resume_goto = nil
			t:SetCommand("GotoFromUser",pos)
		end
	end
end
OnMsg.LoadGame = RestoreCmds
OnMsg.PostSaveGame = RestoreCmds
