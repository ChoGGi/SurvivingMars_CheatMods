-- See LICENSE for terms

local mod_LimitStorage

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_LimitStorage = CurrentModOptions:GetProperty("LimitStorage")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local display_icon = CurrentModPath .. "UI/rover_tanker.png"

local Random = ChoGGi.ComFuncs.Random

-- local some globals
local IsValid = IsValid
local Sleep = Sleep
local MulDivRound = MulDivRound
local T = T
local ResourceScale = const.ResourceScale

local entity_tank = "AirTank"
if g_AvailableDlc.contentpack3 then
	if IsValidEntity("OxygenTankLargeCP3") then
		entity_tank = "OxygenTankLargeCP3"
	end
end

local entity_rc = "RoverTransport"
local entity_rc_building = "RoverTransportBuilding"
if g_AvailableDlc.gagarin then
	if IsValidEntity("RoverChinaSolarRC") then
		entity_rc = "RoverChinaSolarRC"
	end
	if IsValidEntity("RoverChinaSolarRCBuilding") then
		entity_rc_building = "RoverChinaSolarRCBuilding"
	end
end

DefineClass.RCTankerTank = {
	__parents = {
		"Shapeshifter",
		"StorageWithIndicators",
	},
	entity = entity_tank,
	indicator_class = "AirTankArrow",

	-- I want it fairly unique since we're using it as an id in ClassesPostprocess
	fx_actor_class = "ChoGGi_RCTankerTank",
}
function RCTankerTank:Init()
	-- otherwise the rc will get confused when you GotoFromUser
	self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)

	-- attach the arrow objs
	local id_start, id_end = self:GetSpotBeginIndex("Autoattach"), self:GetSpotEndIndex("Autoattach")
	for i = id_start, id_end do
		local spot_annotation = self:GetSpotAnnotation(i)
		if spot_annotation and spot_annotation:find("AirTankArrow") then
			self:Attach(PlaceObjectIn("AirTankArrow", self:GetMapID()), i)
			-- attaching the tank to the rc makes all the tanks attach spots get mushed into origin (or somewhere)
			break
		end
	end
end

RCTankerTank.ResetIndicatorAnimations = StorageWithIndicators.ResetIndicatorAnimations

function RCTankerTank:ResetArrow()
	self:ForEachAttach("AirTankArrow", function(a)
		a:SetAnimPhase(1, 3333)
	end)
end

function RCTankerTank:UpdateIndicators(res_obj)
	if not res_obj then
		return
	end
	-- we just use the capacity from whatever tank we're working with
	self:ForEachAttach("AirTankArrow", function(a)
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
	description = T(302535920011221, [[Used to transport oxygen and water between tanks.
Tank will always refer to the storage on the ground, not the tank on the RC.]]),

	entity = entity_rc,
--~ 	accumulate_dust = false,
	status_text = T(6722, "Idle"),
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
	pin_rollover = T(51, "<ui_command>"),

	-- skip anything else
	cls_storage = {"AirStorage", "WaterStorage"},

	-- needed for pinned icon
	display_icon = display_icon,

	-- picard dlc
  environment_entity = {
    base = entity_rc,
  },
}

function RCTanker:Init()
	self.tank_type = "AirStorage"
	self.storage_amount = 0

	local tank = PlaceObjectIn("RCTankerTank", self:GetMapID())
	self.tank_obj = tank

	-- slight delay needed or Attach() creates a phantom tank...
	CreateRealTimeThread(function()
		if entity_tank == "OxygenTankLargeCP3" then
			self:Attach(tank, self:GetSpotBeginIndex("Panel"))
			tank:SetScale(35)
			tank:SetAttachOffset(point(0, 0, 83))
		else
			self:Attach(tank, self:GetSpotBeginIndex("Drone"))
			tank:SetScale(70)
			tank:SetAttachOffset(point(-360, 0, 980))

			-- rotate it a bit
			local rotate = quaternion(0, 2700, 0) * quaternion(0, 2700, 0)
			local rotate_axis, rotate_angle = rotate:GetAxisAngle()
			tank:SetAttachAxis(rotate_axis)
			tank:SetAttachAngle(rotate_angle)
		end
	end)

	-- stop arrows from spinning round n round
	tank:ResetIndicatorAnimations()
end

function RCTanker:GameInit()
	-- select sound
	self.fx_actor_class = "AttackRover"

	-- Colour #, Colour, Roughness, Metallic (r/m go from -128 to 127)
	-- middle area
	self:SetColorizationMaterial(1, -4450778, 12, 32)
	-- body
	self:SetColorizationMaterial(2, -4450778, 12, 32)
	-- color of bands
	self:SetColorizationMaterial(3, -4450778, 0, 12)

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
		temp_status_table[2] = T(1074, "Stored Air") .. " <image UI/Icons/Sections/Oxygen_1.tga> : " .. (self.storage_amount / ResourceScale)
	else
		temp_status_table[2] = T(33, "Stored Water") .. " <image UI/Icons/Sections/Water_1.tga> : " .. (self.storage_amount / ResourceScale)
	end

	return table.concat(temp_status_table, "<newline><left>")
end

function RCTanker:GotoFromUser(...)
	self.status_text = T(63, "Travelling")
	-- If user broke off TankInteract then clear this here
	self:TankInteractCleanup(2)
	return BaseRover.GotoFromUser(self, ...)
end

function RCTanker:Idle()
	self.status_text = T(6722, "Idle")

	self:SetState("idle")
	self:Gossip("Idle")

	DeleteThread(self.command_thread, true)
	self.command_thread = false
end

function RCTanker:RetResIconText()
	local res_type = ""
	if self.tank_type == "AirStorage" then
		res_type = "<image UI/Icons/Sections/Oxygen_1.tga> " .. T(682, "Oxygen")
	else
		res_type = "<image UI/Icons/Sections/Water_1.tga> " .. T(681, "Water")
	end
	return res_type
end

-- returns false or number value (0 working, 1+ error)
function RCTanker:RetInteractInfo(obj)
	if self.command == "Dead" or not IsValid(obj) then
		return false
	end

	local tank_type = self.tank_type

	local res_obj, text
	if self.tank_type == "AirStorage" then
		res_obj, text = obj.air, T(682, "Oxygen")
	else
		res_obj, text = obj.water, T(681, "Water")
	end

	local interact = self.interaction_mode
	if (interact == false or interact == "default" or interact == "move") then
		if res_obj and obj:IsKindOf(tank_type) then

			local direction = self.tank_direction
			local amount = self.storage_amount

			-- 0 means no limit
			local limit = mod_LimitStorage
			-- resources use 1 to display 1000, so that's what we edit in mod options
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
		elseif obj:IsKindOfClasses(self.cls_storage) and not res_obj then
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
		local icon_stat = "<image UI/Common/mission_no.tga 1600>: "

		if status == 0 then
			return true, T{302535920011222,
				"<UnitMoveControl('ButtonA', interaction_mode)>:<right><which> <icon> Tank.",
				which = self.tank_direction
				and "<image UI/Icons/IPButtons/unload.tga> " .. T(302535920011223, "Drain")
				or "<image UI/Icons/IPButtons/load.tga> " .. T(302535920011224, "Fill"),
				icon = self:RetResIconText(),
			}
		elseif status == 1 then
			return BaseRover.CanInteractWithObject(self, obj, ...)
		elseif status == 2 then
			return false, icon_stat .. T{302535920011225,
				"Not <icon> Tank.",
				icon = self:RetResIconText(),
			}
		elseif status == 3 then
			return false, T(302535920011226, "RC tank is full!")
		elseif status == 4 then
			return false, icon_stat .. T{302535920011227,
				"<icon> Tank is empty!",
				icon = self:RetResIconText(),
			}
		elseif status == 5 then
			return false, icon_stat .. T(302535920011228, "RC tank is empty!")
		elseif status == 6 then
			return false, icon_stat .. T{302535920011229,
				"<icon> Tank is full!",
				icon = self:RetResIconText(),
			}
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
	if obj:GetVisualDist(self:GetPos()) > self.min_dist_to_tank then
		self.status_text = T(63, "Travelling")
		local nearest = obj:GetNearestSpot("idle", "Workrover", self)
		self:Goto(obj:GetSpotPos(nearest))
		self:SetState("idle")
		self.status_text = T(6722, "Idle")
	end

	-- If something went sideways between clicking and starting
	if self:RetInteractInfo(obj) ~= 0 then
		return false
	end

	local tank_type = self.tank_type
	local res_obj, res_type

	if tank_type == "AirStorage" then
		res_obj = obj.air
		res_type = "air"
	else
		res_obj = obj.water
		res_type = "water"
	end

	-- 0 means no limit
	local limit = mod_LimitStorage
	-- resources use 1 to display 1000, so that's what we edit in mod optns
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
		part:SetAttachAngle(8800 + Random(1, 2700))
		part:SetAttachOffset(point(-300, 475, 525))
	else
		part:SetAttachAngle(9800 + Random(1, 2700))
		part:SetAttachOffset(point(-250, 550, 700))
	end

	local amount = self.amount_per_loop
	local delay = self.delay_per_loop

	-- drain tank to rc loop
	if self.tank_direction then
		self.status_text = T(11039, "Loading cargo")
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
			-- Silva's large water tank has none
			if obj:HasMember("UpdateIndicators") then
				obj:UpdateIndicators()
			end

			-- If there's a limit than check if we're there
			if limit and self.storage_amount == limit then
				break
			end
		end
	-- fill tank from rc
	else
		self.status_text = T(11409, "Unloading cargo")
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
			-- Silva's large water tank has none
			if obj:HasMember("UpdateIndicators") then
				obj:UpdateIndicators()
			end

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
	-- add some prod info to selection panel
	local rover = XTemplates.ipRover[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover, "ChoGGi_Template_RCTanker_ToggleDir", true)
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover, "ChoGGi_Template_RCTanker_ToggleRes", true)

	local function UpdateToggleDir(self, button)
		if self.tank_interact_obj then
			self:TankInteractCleanup()
			self:SetCommand("Idle")
		end

		if self.tank_direction then
			self.tank_direction = false
			button:SetRolloverText(T(302535920011230, [[Fill tank resource from RC.

Press to toggle.]]))
			button:SetRolloverTitle(T(302535920011231, [[Fill Tank]]))
			button:SetIcon("UI/Icons/IPButtons/load.tga")
		else
			self.tank_direction = true
			button:SetRolloverText(T(302535920011232, [[Drain resource from tank to RC.

Press to toggle.
]]))
			button:SetRolloverTitle(T(302535920011133, [[Drain Tank]]))
			button:SetIcon("UI/Icons/IPButtons/unload.tga")
		end

	end

	table.insert(
		rover,
		#rover+1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_RCTanker_ToggleDir", true,
			"Id", "ChoGGi_RCTanker_ToggleDir",
			"comment", "fill/drain toggle",
			"__context_of_kind", "RCTanker",
			"__template", "InfopanelButton",
			"RolloverText", T(302535920011232, [[Drain resource from tank to RC.

Press to toggle.]]),
			"RolloverTitle", T(302535920011133, [[Drain Tank]]),
			"Icon", "UI/Icons/IPButtons/unload.tga",
			"OnPress", function (self)
				UpdateToggleDir(self.context, self)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				if gamepad then
					UpdateToggleDir(self.context, self)
				end
			end,
		})
	)

	local function UpdateToggleRes(self, button)
		if self.tank_interact_obj then
			self:TankInteractCleanup()
			self:SetCommand("Idle")
		end
		if self.tank_type == "AirStorage" then
			self.tank_type = "WaterStorage"
			button:SetRolloverTitle(T(681, "Water") .. "\n\n" .. T(302535920011234, "Press to toggle."))
			button:SetIcon("UI/Icons/Sections/Water_1.tga")
			self.tank_obj:SetColorizationMaterial(1, -12211457, -24, 0)
			self:SetColorizationMaterial(1, -12211457, 12, 32)
			self:SetColorizationMaterial(2, -12211457, 12, 32)
			self:SetColorizationMaterial(3, -12211457, 0, 12)
		else
			self.tank_type = "AirStorage"
			button:SetRolloverTitle(T(682, "Oxygen") .. "\n\n" .. T(302535920011234, "Press to toggle."))
			button:SetIcon("UI/Icons/Sections/Oxygen_1.tga")
			self.tank_obj:SetColorizationMaterial(1, -4450778, -24, 0)
			self:SetColorizationMaterial(1, -4450778, 12, 32)
			self:SetColorizationMaterial(2, -4450778, 12, 32)
			self:SetColorizationMaterial(3, -4450778, 0, 12)
		end
		-- type changed so "dump" stored
		self.storage_amount = 0
	end

	table.insert(
		rover,
		#rover+1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_RCTanker_ToggleRes", true,
			"Id", "ChoGGi_RCTanker_ToggleRes",
			"comment", "air/water toggle",
			"__context_of_kind", "RCTanker",
			"__template", "InfopanelButton",
			"Icon", "UI/Icons/Sections/Oxygen_1.tga",
			"RolloverTitle", T(682, "Oxygen") .. "\n\n" .. T(302535920011234, "Press to toggle."),
			"RolloverText", T{302535920011235, [[Type of resource you can transfer with this RC.


<color 255 50 50>WARNING</color>: Changing will empty RC tank of current resource!]]},
			"OnPress", function (self)
				UpdateToggleRes(self.context, self)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				if gamepad then
					UpdateToggleRes(self.context, self)
				end
			end,
		})
	)

	if BuildingTemplates.RCTankerBuilding then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "RCTankerBuilding",
		"template_class", "RCTankerBuilding",
		-- pricey?
		"construction_cost_Metals", 40000,
		"construction_cost_MachineParts", 40000,
		"construction_cost_Electronics", 20000,
		-- add a bit of pallor to the skeleton
		"palette_color1", "rover_base",

		"dome_forbidden", true,
		"display_name", T(302535920011220, [[RC Tanker]]),
		"display_name_pl", T(302535920011220, [[RC Tanker]]),
		"description", T(302535920011221, [[Used to transport oxygen and water between tanks.
Tank will always refer to the storage on the ground, not the tank on the RC.]]),
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"display_icon", display_icon,
		"encyclopedia_exclude", true,
		"on_off_button", false,
		"entity", entity_rc_building,
		"can_refab", true,
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",
	})

	local bt = BuildingTemplates.RCTankerBuilding
	-- add cargo option
	PlaceObj("Cargo", {
		description = bt.description,
		icon = "UI/Icons/Payload/RCRover.tga",
		name = bt.display_name,
		id = "RCTanker",
		kg = 10000,
		locked = false,
		price = 200000000,
		group = "Rovers",
	})

end

-- add cargo entry for saved games
local function UpdateCargo()
	if not table.find(ResupplyItemDefinitions, "id", "RCTanker") then
		ResupplyItemsInit()
	end
end
--~ OnMsg.CityStart = UpdateCargo
OnMsg.LoadGame = UpdateCargo

-- the below is for removing the persist warnings from the log

-- Idle any tankers, and save state of tankers fiddling with tanks
function OnMsg.SaveGame()
	-- kill off the threads (spews c func persist errors in log)
	local tankers = UICity.labels.RCTanker or ""
	for i = 1, #tankers do
		local t = tankers[i]
		-- If user said go somewhere then we store the pos
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
			t:SetCommand("GotoFromUser", pos)
		end
	end
end
OnMsg.LoadGame = RestoreCmds
-- PostSaveGame is added by my lib mod
OnMsg.PostSaveGame = RestoreCmds
