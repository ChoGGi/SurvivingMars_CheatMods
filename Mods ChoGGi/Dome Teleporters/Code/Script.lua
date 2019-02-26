-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 56
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Dome Teleporters requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local IsValid = IsValid
local Sleep = Sleep
local SetRollPitchYaw = SetRollPitchYaw
local PlayFX = PlayFX
local CalcOrientation = CalcOrientation
local CreateDomeNetworks = CreateDomeNetworks
local ConnectDomesWithPassage = ConnectDomesWithPassage
local IsObjInDome = IsObjInDome
local SetState = g_CObjectFuncs.SetState
local TableRemove = table.remove
local TableFind = table.find
local TableClear = table.clear

local function RemoveTableItem(list,name,value)
	local idx = TableFind(list, name, value)
	if idx then
		if not type(list[idx]) == "function" then
			list[idx]:delete()
		end
		TableRemove(list,idx)
	end
end

-- build menu button
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.DomeTeleporter then
		PlaceObj("BuildingTemplate",{
			"Id","DomeTeleporter",
			"template_class","DomeTeleporter",
			"can_rotate_during_placement",true,

			"construction_cost_Concrete",2000,
			"build_points",1000,
			"palette_color1", "mining_base",
			"palette_color2", "life_base",
			"palette_color3", "outside_base",

			"electricity_consumption", 500,

			"dome_required",true,
			"display_name",[[Dome Teleporter]],
			"description",[[It's a teleporter for your domes that acts like a passage.]],
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/orbital_drop.png",
			"encyclopedia_exclude",true,
			"on_off_button",true,
			"prio_button", true,
			"entity","RechargeStation",
			"demolish_sinking", range(0,0),

			"construction_mode", "dome_teleporter_construction",
			"ip_template", "ipBuilding",

--~ 			count_as_building
		})
	end
end

-- we fire our own modified GameInit, so we don't want the one from tunnel (not sure how else to remove it)
function OnMsg.ClassesBuilt()
	RemoveTableItem(DomeTeleporter.___GameInit,Tunnel.GameInit)
end
function OnMsg.ClassesPreprocess()
	RemoveTableItem(DomeTeleporter.__parents,"LifeSupportGridObject")
end

DefineClass.DomeTeleporter = {
	__parents = {
		"Tunnel",
		"ElectricityConsumer",
		-- let people shut down shifts
--~ 		"OutsideBuildingWithShifts",
		"ShiftsBuilding",
	},
	construction_mode = "dome_teleporter_construction",
	spinner_toggle_thread = false,

	-- passage stuff
	domes_connected = false,
}
-- we don't want to carry water
DomeTeleporter.CreateLifeSupportElements = empty_func
DomeTeleporter.MergeGrids = empty_func
DomeTeleporter.CleanTunnelMask = empty_func
DomeTeleporter.CreateElectricityElement = ElectricityConsumer.CreateElectricityElement
-- passage stuff
DomeTeleporter.DisconnectDomes = Passage.DisconnectDomes
DomeTeleporter.CleanHackedPotentials = Passage.CleanHackedPotentials

local function StartStopSpinner(obj,working)
	DeleteThread(obj.spinner_toggle_thread)
	obj.spinner_toggle_thread = CreateGameTimeThread(function()
		if not IsValid(obj.rotating_thing) then
			return
		end
		if working then
			obj.rotating_thing:SetState("workingStart")
			Sleep(obj.rotating_thing:TimeToAnimEnd())
			obj.rotating_thing:SetState("workingIdle")
		else
			obj.rotating_thing:SetState("workingEnd")
		end
	end)
end
--~ -- if we get persist errors
--~ function OnMsg.SaveGame()
--~ end

function DomeTeleporter:GameInit()
	RechargeStation.GameInit(self)
	self.fx_actor_class = "RechargeStation"

--~ 	Tunnel.GameInit(self)
	if not self.registered_point then
		self.registered_point = self:GetPointToReg(self)
		self.linked_obj.registered_point = self:GetPointToReg(self.linked_obj)
		self:RegPoints(self.registered_point, self.linked_obj.registered_point)
	end
--~ 	Notify(self, "AddPFTunnel")
	-- we skip the elec/water stuff from tunnel

	-- passage stuff
	self:Notify("TryConnectDomes")
	self.traversing_colonists = empty_table

	-- slightly smaller
	self:SetScale(75)

	if IsValid(self.parent_dome) then
		self:MoveInside(self.parent_dome)
	end

	DelayedCall(0,function()
		self:ForEachAttach("RechargeStationPlatform",function(a)
			-- we don't want it looking too much like a drone thang
			a:SetColorizationMaterial(1, -16777216, -128, 120)
			a:SetColorizationMaterial(2, -12189696, 120, 20)
			a:SetColorizationMaterial(3, -11579569, 0, 0)

			self.rotating_thing = a.auto_attach_state_attaches[1][1]
			-- spin!
			self.rotating_thing.entity = "FarmSprinkler"
			self.rotating_thing:ChangeEntity("FarmSprinkler")
			self.rotating_thing:SetAttachOffset(point(0,0,300))
			self.rotating_thing:SetColorizationMaterial(2, -10986395, 120, 20)
			self.rotating_thing:SetColorizationMaterial(3, -11436131, -128, 48)
			StartStopSpinner(self,self.working)
--~ DefenceLaserBeam 10
--~ DefenceTurretPlatform 50
--~ DroneHubRobots 80
--~ :SetAttachOffset(point(200,00,80))
		end)
	end)

end

function DomeTeleporter:Done()
	-- Passage
	Passage.Done(self)

	-- Tunnel
	self:KickUnitsFromHolder()
	self:RemovePFTunnel()
	-- kill friend
	if IsValid(self.linked_obj) then
		self:RegPoints(self.registered_point, self.linked_obj.registered_point, true)
		self.linked_obj.linked_obj = false
		DoneObject(self.linked_obj)
		self.linked_obj = false
	end
end

-- Tunnel
function DomeTeleporter:OnDestroyed()
	self:CleanTunnelMask()
	ElectricityGridObject.OnDestroyed(self)
end

function DomeTeleporter:OnSetWorking(working,...)
	BaseBuilding.OnSetWorking(self,working,...)
	-- maybe make it look a little cleaner when somebody toggles it a bunch
	StartStopSpinner(self,working)

	if working then
		PlayFX("DroneRechargePulse", "start", self)
	end
end

function DomeTeleporter:TryConnectDomes()
	-- check if passage is constructed
	if self.domes_connected or not IsValid(self.parent_dome) then
		return
	end

	self:UpdateWorking()
	if IsGameRuleActive("FreeConstruction") then
		self.construction_cost_at_completion = {
			Concrete = self.city:GetConstructionCost(self, "Concrete"),
		}
	end

	self.elements_under_construction = {}
	self.traversing_colonists = {}
	self.elements = {
		{dome = self.parent_dome},
		{dome = self.linked_obj.parent_dome},
	}

	--first and last element should have the domes we need to connect
	local d1 = self.elements[1] and self.elements[1].dome
	local d2 = self.elements[#self.elements] and self.elements[#self.elements].dome

	ConnectDomesWithPassage(d1, d2)
	self.domes_connected = {d1, d2}
	CreateDomeNetworks(self.city or UICity)
	self:Notify("AddPFTunnel")
end

-- match up workshifts with each other
function DomeTeleporter:ToggleShift(shift,...)
	ShiftsBuilding.ToggleShift(self,shift,...)
	if self:IsClosedShift(shift) then
		self.linked_obj:CloseShift(shift)
	else
		self.linked_obj:OpenShift(shift)
	end
end

local function AliceGaveUpTheCokeHabit(unit)
--~ The bigger the figure the better I like her
--~ The better I like her the better I feed her
--~ The better I feed her the bigger the figure
--~ The bigger the figure the more I can love
	Sleep(500)
	local num = 1
	while num ~= 100 do
		unit:SetScale(num)
		num = num + 1
		Sleep(10)
	end
end

-- makes units step onto the porters
local GetEntranceFallback = WaypointsObj.GetEntranceFallback
function DomeTeleporter:GetEntranceFallback()
	-- needs be false for func
	self.entrance_fallback = false
	GetEntranceFallback(self)
	return {
		self:GetPos(),
		self.entrance_fallback[2],
	}, self.entrance_fallback[2]
end

local times36060 = 360*60

-- no go unless both work
function DomeTeleporter:TraverseTunnel(unit, start_point, exit_point, param)

	if self.working and self.linked_obj.working and IsValid(self) and IsValid(self.linked_obj) then
		PlayFX("MysteryDream", "end", self)
		PlayFX("MysteryDream", "start", self)

	--~ 	Tunnel.TraverseTunnel()
		unit:PushDestructor(function(unit)
			local linked_obj = self.linked_obj
			if not IsValid(self) or not IsValid(linked_obj) then
				return
			end
			SetState(self.platform, "chargingStart")
			SetState(self.platform, "chargingIdle")

			-- needs to happen before TraverseTunnel
--~ 			local angle = CalcOrientation(self:GetVisualPos(), unit:GetVisualPos())
--~ 			self.platform:SetAngle(angle - self:GetAngle(), 100)
--~ 			unit:Face(self.platform, 500)

			local entrance = self:GetEntranceFallback()
			local exit = linked_obj:GetEntranceFallback()
			local tunnel_len = entrance[1]:Dist2D(exit[1])
			-- halfies ( / 2 )
			local travel_time = (self.travel_time_per_hex * tunnel_len / const.GridSpacing) / 2
			self:LeadIn(unit, entrance)

			-- have some coke alice
			local num = 100
			while num ~= 1 do
				unit:SetScale(num)
				num = num - 1
				Sleep(10)
			end

			local unit_pos = unit:GetPos()
			if not IsValid(unit) then
				return
			end

			unit:DetachFromMap()
			local dummy_obj = false
			if IsValid(linked_obj) then
				unit:SetHolder(linked_obj)
				if camera3p.IsActive() and unit == CameraFollowObj then
					dummy_obj = PlaceObject("Movable");
					dummy_obj:SetPos(unit_pos)
					camera3p.DetachObject(unit)
					camera3p.AttachObject(dummy_obj)
					dummy_obj:SetPos(exit[1], travel_time)
				end

				unit.current_dome = IsObjInDome(linked_obj)
				Sleep(travel_time)
				if dummy_obj then
					if camera3p.IsActive() then
						camera3p.DetachObject(dummy_obj)
						camera3p.AttachObject(unit)
					end
					DoneObject(dummy_obj)
				end

				if IsValid(unit) and IsValid(linked_obj) then
					linked_obj:ExitTunnel(unit,self)
				end
			elseif IsValid(self) then
				self:ExitTunnel(unit)
			end

		end)

		unit:PopAndCallDestructor()
		return true
	end
end

function DomeTeleporter:ExitTunnel(unit,other)
	PlayFX("MysteryDream", "end", self)
	PlayFX("MysteryDream", "start", self)
	Sleep(100)
	SetState(self.platform, "chargingIdle")
	SetRollPitchYaw(self,0,0,self:Random(times36060),600)
	Sleep(650)
--~ 	AliceGaveUpTheCokeHabit(unit)
	unit:SetScale(100)
	unit:ExitBuilding(self)
	SetState(self.platform, "chargingEnd")
	if other then
		SetState(other.platform, "chargingEnd")
	end
end
