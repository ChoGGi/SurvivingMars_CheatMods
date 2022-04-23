-- See LICENSE for terms

local table, type, ipairs, pairs = table, type, ipairs, pairs
local IsValidThread = IsValidThread
local IsValid = IsValid
local DoneObject = DoneObject
local GetRealmByID = GetRealmByID
local GetRandomPassableAroundOnMap = GetRandomPassableAroundOnMap

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

--
function OnMsg.ClassesPostprocess()

	--[[
	https://forum.paradoxplaza.com/forum/threads/surviving-mars-colonists-repeatedly-satisfy-daily-interests.1464969/
	A colonist will repeatedly use a daily interest building to satisfy a daily interest already satisfied.
	Repeating a daily interest will gain a comfort boost "if" colonist comfort is below the service comfort threshold, but a resource will always be consumed each visit.

	This mod will block the colonist from having a visit, instead: An unemployed scientist will wander around outside till the Sol is over instead of chewing up 0.6 electronics.
	]]
	-- lua rev 1011030 Colonist:EnterBuilding()
	local ChoOrig_Colonist_EnterBuilding = Colonist.EnterBuilding
	function Colonist:EnterBuilding(building, ...)
		if mod_EnableMod and self.daily_interest ~= "" and IsValid(building)
			and building:HasMember("IsOneOfInterests") and building:IsOneOfInterests(self.daily_interest)
		then
--~ 			printC("daily_interest CLEARED", self.daily_interest)
			self.daily_interest = ""
			self.daily_interest_fail = 0
		end

		return ChoOrig_Colonist_EnterBuilding(self, building, ...)
	end
	--

	-- dozers and cave-in pathing (the game will freeze if you send dozers to certain cave-ins or certain paths? this is why I should keep save files around...).
	if g_AvailableDlc.armstrong then
		-- all of them use the same func
		local ChoOrig_RubbleBase_DroneApproach = RubbleBase.DroneApproach

		local ChoOrig_RCTerraformer_ClearRubble = RCTerraformer.ClearRubble
		function RCTerraformer:ClearRubble(rubble, ...)
			if not mod_EnableMod then
				return ChoOrig_RCTerraformer_ClearRubble(self, rubble, ...)
			end

			-- replace this func with working one
			rubble.DroneApproach = function()
				return self:GotoBuildingSpot(rubble, self.work_spot_task)
					or self:GotoBuildingSpot(rubble, self.work_spot_task, false, 6 * const.HexHeight)
			end

			ChoOrig_RCTerraformer_ClearRubble(self, rubble, ...)

			-- than restore orig func
			rubble.DroneApproach = ChoOrig_RubbleBase_DroneApproach

		end
	end
	--
	if g_AvailableDlc.picard then
		local bt = BuildingTemplates

		-- no refabbing wonders
		if bt.AncientArtifactInterface then
			bt.AncientArtifactInterface.can_refab = false
		end
		if bt.BottomlessPitResearchCenter then
			bt.BottomlessPitResearchCenter.can_refab = false
		end
		if bt.JumboCaveReinforcementStructure then
			bt.JumboCaveReinforcementStructure.can_refab = false
		end

		-- add underground elevator
		if not bt.UndergroundElevator then
			PlaceObj("BuildingTemplate", {
				"Group", "Infrastructure",
				"SaveIn", "picard",
				"Id", "UndergroundElevator",
				"template_class", "Elevator",
				"cargo_capacity", 0,
				"starting_drones", 0,
				"construction_cost_Concrete", 80000,
				"construction_cost_Metals", 20000,
				"construction_cost_MachineParts", 10000,
				"build_points", 20000,
				"dome_forbidden", true,
				"show_range_class", "DroneHub",
				"can_refab", false,
				"maintenance_resource_type", "MachineParts",
				"consumption_resource_stockpile_spot_name", "",
				"display_name", T(330073770544--[[Elevator]]),
				"display_name_pl", T(951268120259--[[Elevators]]),
				"description", T(365418570073--[[Transports vehicles, colonists and resources between the surface and the underground of Mars.]]),			"build_category", "Infrastructure",
				"display_icon", "UI/Icons/Buildings/elevator.tga",
				"build_pos", 19,
				"entity", "ElevatorUnderground",
				"show_range", true,
				"encyclopedia_id", "Elevator",
				"encyclopedia_text", T(177334925289--[[
<em>The Elevator</em> can only be built on top off <em>Underground Passages</em> on the surface of Mars or on top off <em>Surface Passages</em> in the Martian underground. <em>The Elevator</em> can be powered and maintained from either side.

Resources can be moved from one map to the other by using the <em>Edit Payload</em> action. Once a request for resources has been made it can be changed by using the <em>Edit Payload</em> action again and adjusting the resource amounts.]]),
				"encyclopedia_image", "UI/Encyclopedia/Elevator.tga",
				"label1", "OutsideBuildings",
				"palette_color1", "outside_accent_factory",
				"palette_color2", "outside_base",
				"palette_color3", "outside_base",
				"demolish_sinking", range(1, 5),
				"disabled_in_environment1", "Asteroid",
				"disabled_in_environment2", "Surface",
				"snap_target_type", "SurfacePassage",
				"only_build_on_snapped_locations", true,
				"snap_error_text", T(133850725904--[[Must be constructed over an Underground Entrance or Surface Tunnel.]]),
				"snap_error_short", T(726714269530--[[Must be built on an Underground Entrance or Surface Tunnel]]),
				"electricity_consumption", 10000,
			})
		end
	end

end
--
-- populated below (needed for CityStart/LoadGame)
local FixCubeAnomalyOnDeposit_CheckObjs
GlobalVar("g_ChoGGi_FixCubeAnomalyOnDeposit", false)
do -- CityStart/LoadGame
	local function StartupCode()
		if not mod_EnableMod then
			return
		end

		-- speed up deleting/etc objs
		SuspendPassEdits("ChoGGi_FixBBBugs_loading")

		local UIColony = UIColony
		local MainCity = MainCity
		local main_realm = GetRealmByID(MainMapID)
		local GameMaps = GameMaps
		local bt = BuildingTemplates
		local ResourceScale = const.ResourceScale
		local GetDomeAtPoint = GetDomeAtPoint
		local Landscapes = Landscapes
		local bmpo = BuildMenuPrerequisiteOverrides
		local ResupplyItemDefinitions = ResupplyItemDefinitions

		-- Fix Cube Anomaly On Deposit
		if not g_ChoGGi_FixCubeAnomalyOnDeposit then
			local objs = main_realm:MapGet("map", "SubsurfaceAnomaly")
			for i = 1, #objs do
				FixCubeAnomalyOnDeposit_CheckObjs(objs[i], MainCity, GameMaps)
			end
			g_ChoGGi_FixCubeAnomalyOnDeposit = true
		end

		-- If you removed modded rules from your current save then the Mission Profile dialog will be blank.
		local rules = g_CurrentMissionParams.idGameRules
		if rules then
			local GameRulesMap = GameRulesMap
			for rule_id in pairs(rules) do
				-- If it isn't in the map then it isn't a valid rule
				if not GameRulesMap[rule_id] then
					rules[rule_id] = nil
				end
			end
		end

		--[[
		If you have broken down buildings the drones won't repair. This will check for them on load game.
		The affected buildings will say something about exceptional circumstances.
		Any buildings affected by this issue will need to be repaired with 000.1 resource after the fix happens.

		This also has a fix for buildings hit with lightning during a cold wave.
		]]
		local blds = UIColony:GetCityLabels("Building")
		for i = 1, #blds do
			local bld = blds[i]

			-- clear out non-task requests in task_requests
			local task_requests = bld.task_requests or ""
			for j = #task_requests, 1, -1 do
				local req = task_requests[j]
				if type(req) ~= "userdata" then
					table.remove(task_requests, j)
				end
			end

			-- Buildings hit with lightning during a cold wave
			if bld.is_malfunctioned and bld.accumulated_maintenance_points == 0 then
				bld:AccumulateMaintenancePoints(bld.maintenance_threshold_base * 2)

			-- Exceptional circumstance buildings
			elseif not bld.maintenance_resource_request and bld:DoesMaintenanceRequireResources() then
				-- restore main res request
				local resource_unit_count = 1 + (bld.maintenance_resource_amount / (ResourceScale * 10)) --1 per 10
				local r_req = bld:AddDemandRequest(bld.maintenance_resource_type, 0, 0, resource_unit_count)
				bld.maintenance_resource_request = r_req
				bld.maintenance_request_lookup[r_req] = true
				-- needs to be fired off to complete the reset?
				bld:SetExceptionalCircumstancesMaintenance(bld.maintenance_resource_type, 1)
				bld:Setexceptional_circumstances(false)
			end
		end

		-- Some colonists are allergic to doors and suffocate inside a dome with their suit still on.
		local colonists = UIColony:GetCityLabels("Colonist")
		for i = 1, #colonists do
			local colonist = colonists[i]
			-- Check if lemming is currently in a dome while wearing a suit
			if colonist.entity:sub(1, 15) == "Unit_Astronaut_" then
				local dome_at_pt = GetDomeAtPoint(
					GameMaps[colonist.city.map_id].object_hex_grid, colonist:GetVisualPos()
				)
				if dome_at_pt then
					-- Normally called when they go through the airlock
					colonist:OnEnterDome(dome_at_pt)
					-- The colonist will wait around for a bit till they start moving, this forces them to do something
					colonist:SetCommand("Idle")
				end
			end
		end

		-- Fix Farm Oxygen 1
		local domes = UIColony:GetCityLabels("Dome")
		for i = 1, #domes do
			local dome = domes[i]
			local mods = dome:GetPropertyModifiers("air_consumption")
			if mods then
				local farms = dome.labels.Farm or empty_table
				for j = #mods, 1, -1 do
					local mod_item = mods[j]
					local idx = table.find(farms, "farm_id", mod_item.id)
					-- Can't find farm id, so it's a removed farm
					if not idx then
						dome:SetModifier("air_consumption", mod_item.id, 0, 0)
					end
				end
				dome:UpdateWorking()
			end
		end

		-- For some reason LandscapeLastMark gets set to around 4090, when LandscapeMark hits 4095 bad things happen.
		-- This resets LandscapeLastMark to whatever is the highest number in Landscapes when a save is loaded (assuming it's under 3000, otherwise 0).
		-- If there's placed landscapes grab the largest number
		if Landscapes and next(Landscapes) then
			local largest = 0
			for idx in pairs(Landscapes) do
				if idx > largest then
					largest = idx
				end
			end
			-- If over 3K then reset to 0
			if largest > 3000 then
				LandscapeLastMark = 0
			else
				LandscapeLastMark = largest + 1
			end
		else
			-- no landscapes so 0 it is
			LandscapeLastMark = 0
		end

		-- Wind turbine gets locked by a game event.
		if bmpo.WindTurbine and TGetID(bmpo.WindTurbine) == 401896326435--[[You can't construct this building at this time]] then
			bmpo.WindTurbine = nil
		end

		-- Removes any meteorites stuck on the map when you load a save.
		local meteors = main_realm:MapGet("map", "BaseMeteor")
		for i = #meteors, 1, -1 do
			local obj = meteors[i]

			-- Same pt as the dest means stuck on ground
			if obj:GetPos() == obj.dest
			-- Stuck on roof of dome
				or not IsValidThread(obj.fall_thread)
			then
				DoneObject(obj)
			end
		end

		-- For some reason the devs put it in the Decorations instead of the Outside Decorations category.
		bt.LampProjector.build_category = "Outside Decorations"
		bt.LampProjector.group = "Outside Decorations"
		bt.LampProjector.label1 = ""

		-- https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-game-freezes-when-deploying-drones-from-rc-commander-after-one-was-destroyed.1168779/
		local rovers = UIColony:GetCityLabels("RCRoverAndChildren")
		for i = 1, #rovers do
			local attached_drones = rovers[i].attached_drones
			for j = #attached_drones, 1, -1 do
				local drone = attached_drones[j]
				if not IsValid(drone) then
					table.remove(attached_drones, j)
				end
			end
		end

		-- Probably caused by a mod badly adding cargo.
		for i = #ResupplyItemDefinitions, 1, -1 do
			local def = ResupplyItemDefinitions[i]
			if not def.pack then
				print("Fix Resupply Menu Not Opening Borked cargo:", def.id)
				table.remove(ResupplyItemDefinitions, i)
			end
		end

		-- Check for transport rovers with negative amounts of resources carried.
		local trans = UIColony:GetCityLabels("RCTransportAndChildren")
		for i = 1, #trans do
			local obj = trans[i]
			for j = 1, #(obj.storable_resources or "") do
				local res = obj.storable_resources[j]
				if obj.resource_storage[res] < 0 then
					obj.resource_storage[res] = 0
				end
			end
		end

		--	Move any floating underground rubble to within reach of drones (might have to "push" drones to make them go for it).
		if UIColony.underground_map_unlocked then
			local map = GameMaps[UIColony.underground_map_id]
			map.realm:MapForEach("map", "CaveInRubble", function(obj)
				local pos = obj:GetVisualPos()
				if pos:z() > 0 then
					-- Likely the ground floor is 0, so I can just move it, instead of having to check height.
					obj:SetPos(pos:SetZ(0))
				end
			end)
		end
		--

		ResumePassEdits("ChoGGi_FixBBBugs_loading")
	end

	OnMsg.CityStart = StartupCode
	OnMsg.LoadGame = StartupCode
end -- do
--
do -- The first Black Cube anomaly can sometimes spawn on a deposit, this'll move it off to a side. (Fix Cube Anomaly On Deposit)
	FixCubeAnomalyOnDeposit_CheckObjs = function(obj, city, maps)
		-- check if there's a deposit below it
		local pos = obj:GetPos()
		if not city then
			city = Cities[obj:GetMapID()]
			maps = GameMaps
		end
		local map = maps[city.map_id]
		local objs = map.realm:MapGet(pos, 100)
		-- anything "directly" below it
		for i = 1, #objs do
			local temp_obj = objs[i]
			-- anomalies are also deposits
			if temp_obj ~= obj and temp_obj:IsKindOf("SubsurfaceDeposit") then
				local rand_pos = GetRandomPassableAroundOnMap(city.map_id, pos, 1000)
				-- pretty sure SetTerrainZ doesn't work if active map is diff, so
				obj:SetPos(rand_pos:SetZ(map.terrain:GetHeight(pos)))
				break
			end
		end
		-- if we don't find one then nothing to fix
	end

	local ChoOrig_SpawnObject = SA_SpawnAnomaly.SpawnObject
	function SA_SpawnAnomaly.SpawnObject(...)
		local anomaly = ChoOrig_SpawnObject(...)
		FixCubeAnomalyOnDeposit_CheckObjs(anomaly)
		return anomaly
	end
end -- do
--
do -- I dunno, maybe paradox should push another update?
	if Platform.linux then
		local UIL = UIL
		local ui_images = {}

		local ChoOrig_UIL_RequestImage = UIL.RequestImage
		function UIL.RequestImage(image)
			table.insert_unique(ui_images, image)
			ChoOrig_UIL_RequestImage(image)
		end
		--
		function OnMsg.SystemActivate()
			hr.TR_ForceReload = 1
			for _, image in ipairs(ui_images) do
				UIL.ReloadImage(image)
			end
		end
	end
end
--
do -- fix FindWater milestone
	Presets.Milestone.Default.FindWater.Complete = function (self)
--~     if GetRealmByID(MainMapID):MapContains("map", "SubsurfaceDeposit", function(o)
    if GetRealmByID(MainMapID):MapForEach("map", "SubsurfaceDeposit", function(o)
      return o.revealed and o.resource == "Water"
    end) then
      return true
    end
		while true do
			local _, deposit = WaitMsg("WaterDepositRevealed")
			if deposit:GetMapID() == MainMapID then
				return true
			end
		end
	end
end
--
do -- landscaping
	local function UpdateRenderLandscape()
		local landscape_found = false
		for _, landscape in pairs(Landscapes) do
			if landscape and landscape.map_id == ActiveMapID then
				landscape_found = true
				break
			end
		end
		hr.RenderLandscape = landscape_found and 1 or 0
	end
	OnMsg.SwitchMap = UpdateRenderLandscape

	local ChoOrig_ResetLandscapeGrid = ResetLandscapeGrid
	function ResetLandscapeGrid(...)
		ChoOrig_ResetLandscapeGrid(...)
		UpdateRenderLandscape()
	end
end
--
do -- fixup map id
	local ChoOrig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
	function AddCustomOnScreenNotification(id, title, text, image, callback, params, map_id, ...)
		if map_id == nil then
			map_id = MainMapID
		elseif map_id == false then
			map_id = ""
		end

		return ChoOrig_AddCustomOnScreenNotification(id, title, text, image, callback, params, map_id, ...)
	end
end
--
do -- SA_Gameplay.lua SA_CustomNotification:Exec
	local ChoOrig_GetOnScreenNotification = GetOnScreenNotification
	local function ChoFake_GetOnScreenNotification(id, ...)
		return table.find(g_ActiveOnScreenNotifications, 1, id)
			and ChoOrig_GetOnScreenNotification(id, ...)
	end

	local ChoOrig_SA_CustomNotification_Exec = SA_CustomNotification.Exec
	function SA_CustomNotification.Exec(...)
		GetOnScreenNotification = ChoFake_GetOnScreenNotification
		pcall(ChoOrig_SA_CustomNotification_Exec, ...)
		GetOnScreenNotification = ChoOrig_GetOnScreenNotification
	end
end
--
local ChooseTraining = ChooseTraining
function Workforce:ChooseTraining(colonist)
  local training_centers = self.labels.TrainingBuilding or empty_table
  local workplace, shift = ChooseTraining(colonist, training_centers)
  return workplace, shift
end
function Workforce:HasFreeWorkplacesAround(colonist)
  for _, b in ipairs(self.labels.Workplace or empty_table) do
    if not b.destroyed and b.ui_working and b:CanWorkHere(colonist) and b:HasFreeWorkSlots() then
      return true
    end
  end
  return false
end
--
do -- Check if selected before updating hex range on drone hub extenders
	function DroneHub:OnModifiableValueChanged(prop)
		if prop == "service_area_max" and IsObjectSelected(self) then
			ChangeHexRanges(self)
		end
	end
	if g_AvailableDlc.picard then
		function DroneHubExtender:OnModifiableValueChanged(prop)
			if prop == "work_radius" and IsObjectSelected(self) then
				ChangeHexRanges(self)
			end
		end
	end
end
--
function DoesAnyDroneControlServiceAtPoint(map_id, pt)
  local realm = GetRealmByID(map_id)
--~   return realm:MapContains(pt, "hex", const.CommandCenterMaxRadius, "DroneNode", function(center)
  return realm:MapForEach(pt, "hex", const.CommandCenterMaxRadius, "DroneNode", function(center)
    return (IsKindOfClasses(center, "DroneHub") or center.working) and HexAxialDistance(center, pt) <= center.work_radius
  end)
end
--
do -- ResupplyItems.lua
	local GetResupplyItem = GetResupplyItem
	local ChoOrig_ModifyResupplyParam = ModifyResupplyParam
	function ModifyResupplyParam(id, ...)
		return GetResupplyItem(id) and ChoOrig_ModifyResupplyParam(id, ...)
	end
	local ChoOrig_IsResupplyItemAvailable = IsResupplyItemAvailable
	function IsResupplyItemAvailable(name, ...)
		local item = GetResupplyItem(name)
		if item then
			return ChoOrig_IsResupplyItemAvailable(name, ...)
		end
		return false
	end
end
-- Clearing waste rock
local ChoOrig_ClearWasteRockConstructionSite_InitBlockPass = ClearWasteRockConstructionSite.InitBlockPass
function ClearWasteRockConstructionSite:InitBlockPass(ls, ...)
	if not ls then
		ls = Landscapes[self.mark]
	end
  if ls and ls.pass_bbox then
    return ChoOrig_ClearWasteRockConstructionSite_InitBlockPass(self, ls, ...)
  end
end

-- Newly constructed domes birth rate (thanks Athenium).
local ChoOrig_Community_GameInit = Community.GameInit
function Community:GameInit(...)
  self.next_birth_check_time = GameTime()
	return ChoOrig_Community_GameInit(self, ...)
end
-- If you set a transport route between two resources/stockpiles/etc and the transport just sits there like an idiot...
local ChoOrig_RCTransport_TransferResources = RCTransport.TransferResources
function RCTransport:TransferResources(...)
	if not mod_EnableMod then
		return ChoOrig_RCTransport_TransferResources(self, ...)
	end

	if not self.unreachable_objects then
		self.unreachable_objects = {}
	end
	return ChoOrig_RCTransport_TransferResources(self, ...)
end

-- Some mods will try to add a notification without specifying an id for it; that makes baby Jesus cry.
local ChoOrig_LoadCustomOnScreenNotification = LoadCustomOnScreenNotification
function LoadCustomOnScreenNotification(notification, ...)
	if not mod_EnableMod then
		return ChoOrig_LoadCustomOnScreenNotification(notification, ...)
	end

	-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
	if type(notification) == "table" and table.unpack(notification) then
		return ChoOrig_LoadCustomOnScreenNotification(notification, ...)
	end
end

-- Layout construction allows building buildings that should be locked by tech (Triboelectric Scrubber).
local ChoOrig_LayoutConstructionController_Activate = LayoutConstructionController.Activate
function LayoutConstructionController:Activate(...)
	-- fire first so it builds the tables/etc
	local ret = ChoOrig_LayoutConstructionController_Activate(self, ...)

	if not mod_EnableMod then
		return ret
	end

	-- now remove what shouldn't be there
	local GetBuildingTechsStatus = GetBuildingTechsStatus
	local city = self.city or UICity
	local BuildingTemplates = BuildingTemplates

	local controllers = self.controllers or empty_table
	for entry in pairs(controllers) do
		local template = BuildingTemplates[entry.template]
		if template then
			local _, tech_enabled = GetBuildingTechsStatus(template.id, template.build_category)

			-- If it isn't unlocked and there's no prefabs then remove it
			if not tech_enabled and city:GetPrefabs(template.id) == 0 then
				self.skip_items[entry] = true
				controllers[entry]:Deactivate()
				controllers[entry] = nil
			end

		end
	end

	return ret
end

-- Fix Farm Oxygen 2
-- If you remove a farm that has an oxygen producing crop (workers not needed) the oxygen will still count in the dome.
local ChoOrig_Farm_Done = Farm.Done
function Farm:Done(...)
	if not mod_EnableMod then
		return ChoOrig_Farm_Done(self, ...)
	end

	self:ApplyOxygenProductionMod(false)

	return ChoOrig_Farm_Done(self, ...)
end

-- The devs broke this in Tito update and haven't fixed it yet.
local ChoOrig_SelectionModeDialog_OnMouseButtonDoubleClick = SelectionModeDialog.OnMouseButtonDoubleClick
function SelectionModeDialog:OnMouseButtonDoubleClick(pt, button, ...)
	if button ~= "L" or not mod_EnableMod then
		return ChoOrig_SelectionModeDialog_OnMouseButtonDoubleClick(self, pt, button, ...)
	end

	-- from orig func:
  local result = UnitDirectionModeDialog.OnMouseButtonDoubleClick(self, pt, button)
  if result == "break" then
    return result
  end

	-- we already checked what button it is above, so no need to check again

	local obj = SelectionMouseObj()
	-- copied SelectObj(obj) up here so SelectedObj == obj works...
	SelectObj(obj)

	if obj and SelectedObj == obj and IsKindOf(obj, "SupplyGridSwitch") and obj.is_switch then
		obj:Switch()
	end
	if obj and SelectedObj == obj then
		local selection_class = GetSelectionClass(obj)
		local new_objs = GatherObjectsOnScreen(obj, selection_class)
		if new_objs and 1 < #new_objs then
			obj = MultiSelectionWrapper:new({selection_class = selection_class, objects = new_objs})
		end
	end
	SelectObj(obj)
	return "break"
end
--
do -- SupplyGrid.lua SupplyGridFragment:UpdateGrid
	local ChoOrig_GetRealm = GetRealm
	local function ChoFake_GetRealm(obj)
		-- if no .city then it's bugged
		return GetRealmByID(obj.city and obj.city.map_id or MainMapID)
	end
	local ChoOrig_SupplyGridFragment_UpdateGrid = SupplyGridFragment.UpdateGrid
	function SupplyGridFragment.UpdateGrid(...)
		GetRealm = ChoFake_GetRealm
		pcall(ChoOrig_SupplyGridFragment_UpdateGrid, ...)
--~ 		ChoOrig_SupplyGridFragment_UpdateGrid(...)
		GetRealm = ChoOrig_GetRealm
	end
end
--
do -- _GameUtils.lua GetAvailableResidences/GetDomesInWalkableDistance
	local function ReturnCity(func, city, ...)
		if not city then
			city = MainCity
		end
		return func(city, ...)
	end

	local ChoOrig_GetAvailableResidences = GetAvailableResidences
	function GetAvailableResidences(city, ...)
		return ReturnCity(ChoOrig_GetAvailableResidences, city, ...)
	end
	local ChoOrig_GetDomesInWalkableDistance = GetDomesInWalkableDistance
	function GetDomesInWalkableDistance(city, ...)
		return ReturnCity(ChoOrig_GetDomesInWalkableDistance, city, ...)
	end
end
--
do -- Colonist:CanReachBuilding
	local bld_from_canreach
	local ChoOrig_FindNearestObject = FindNearestObject
	local function ChoFake_FindNearestObject(list, _, ...)
		return ChoOrig_FindNearestObject(list, bld_from_canreach, ...)
	end

	local ChoOrig_Colonist_CanReachBuilding = Colonist.CanReachBuilding
	function Colonist:CanReachBuilding(bld, ...)
		FindNearestObject = ChoFake_FindNearestObject
		bld_from_canreach = bld
		local result, ret = pcall(ChoOrig_Colonist_CanReachBuilding, self, bld, ...)
		FindNearestObject = ChoOrig_FindNearestObject
		if result then
			return ret
		else
			print("ChoOrig_Colonist_CanReachBuilding failed!: ", ret)
		end
	end
end
--
do -- GridSwitchConstruction.lua GridSwitchConstructionController:UpdateConstructionStatuses
	local HexGetBuildingNoDome = HexGetBuildingNoDome

	local ChoOrig_HexGetBuilding = HexGetBuilding
	local function ChoFake_HexGetBuilding(...)
		return HexGetBuildingNoDome(...)
	end
	local ChoOrig_GridSwitchConstructionController_UpdateConstructionStatuses = GridSwitchConstructionController.UpdateConstructionStatuses
	function GridSwitchConstructionController.UpdateConstructionStatuses(...)
		HexGetBuilding = ChoFake_HexGetBuilding
		pcall(ChoOrig_GridSwitchConstructionController_UpdateConstructionStatuses, ...)
		HexGetBuilding = ChoOrig_HexGetBuilding
	end
end
--
do -- AreDomesConnectedWithPassage (Fix Colonists Long Walks)
	--[[
	Changes the AreDomesConnectedWithPassage func to also check the walking distance instead of assuming passages == walkable.
	This [i]should[/i] stop the random colonist has died from dehydration events we know and love.
	]]
	local dome_walk_dist = const.ColonistMaxDomeWalkDist
	local ChoOrig_AreDomesConnectedWithPassage = AreDomesConnectedWithPassage
	function AreDomesConnectedWithPassage(d1, d2, ...)
		if not mod_EnableMod then
			return ChoOrig_AreDomesConnectedWithPassage(d1, d2, ...)
		end

		return ChoOrig_AreDomesConnectedWithPassage(d1, d2, ...)
			-- If orig func returns true then check if domes are within walking dist
			-- "d1 == d2" is from orig func (no need to check dist if both domes are the same)
			and (d1 == d2 or d1:GetDist2D(d2) <= dome_walk_dist)
	end
end -- do
-- Fix Defence Towers Not Firing At Rovers
--[[
It's from a mystery (trying to keep spoilers to a minimum).
If you're starting a new game than this is fixed, but for older saves on this mystery you'll need this mod.
]]
local ChoOrig_SA_Exec_Exec = SA_Exec.Exec
function SA_Exec:Exec(sequence_player, ip, seq, ...)
	if not mod_EnableMod then
		return ChoOrig_SA_Exec_Exec(self, sequence_player, ip, seq, ...)
	end

	if seq and seq[111] and seq[111].expression == "UICity.mystery.can_shoot_rovers = true" then
		-- loop through the seqs and replace any UICity.mystery with UIColony.mystery
		for i = 1, #seq do
			local seq_idx = seq[i]
			if seq_idx:IsKindOf("SA_Exec") then
				seq_idx.expression = seq_idx.expression:gsub("UICity.mystery", "UIColony.mystery")
			end
		end
	end

	return ChoOrig_SA_Exec_Exec(self, sequence_player, ip, seq, ...)
end
-- log spam April13 found
-- [LUA ERROR] Mars/Lua/Buildings/CargoTransporter.lua:1062: attempt to index a nil value (field '?')
local ChoOrig_CargoTransporter_DroneLoadResource = CargoTransporter.DroneLoadResource
function CargoTransporter:DroneLoadResource(drone, request, resource, ...)
	if not mod_EnableMod then
		return ChoOrig_CargoTransporter_DroneLoadResource(self, drone, request, resource, ...)
	end

	if self.cargo[resource] then
		return ChoOrig_CargoTransporter_DroneLoadResource(self, drone, request, resource, ...)
	end
end
--
--
--
--
--
-- B&B fixes
if not g_AvailableDlc.picard then
	return
end
--
--
--
--
--
do -- Elevator prefabs
	local function UpdatePrefabs(self, req, city, other_city)
		for id, item in pairs(req) do
			if item.type == "Prefab" then
				local other_count = other_city:GetPrefabs(id)
				if other_count >= item.amount then
					-- There's enough to fulfill req
					city:AddPrefabs(id, item.amount)
				elseif other_count > 0 then
					-- Not enough, send what there is
					city:AddPrefabs(id, other_count)
				end
			end
		end
	end

	local ChoOrig_Elevator_UISetCargoRequest = Elevator.UISetCargoRequest
	function Elevator:UISetCargoRequest(cargo_loading, ...)
		-- automode doesn't need the fix
		if not self:IsAutoModeEnabled() then
			-- I stopped caring why it doesn't transfer prefabs and just stuck something here to add them as it has no issue removing them.
			UpdatePrefabs(self, cargo_loading:GetDestinationCargoList(), self.city, self.other.city)
			UpdatePrefabs(self, cargo_loading:GetOriginCargoList(), self.other.city, self.city)
		end
		return ChoOrig_Elevator_UISetCargoRequest(self, cargo_loading, ...)
	end
end -- do
--
local ChoOrig_Building_SetDome = Building.SetDome
function Building:SetDome(dome, ...)
	if not mod_EnableMod then
		return ChoOrig_Building_SetDome(self, dome, ...)
	end

  ChoOrig_Building_SetDome(self, dome, ...)
  if dome and dome.refab_work_request then
    dome:ToggleRefab()
  end
end
-- No Planetary Anomaly Breakthroughs when B&B is installed.
local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City:InitBreakThroughAnomalies(...)
	if not mod_EnableMod then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- This func is called for each new city (surface/underground/asteroids)
	-- Calling it more than once removes the BreakthroughOrder list
	-- That list is used to spawn planetary anomalies
	if self.map_id == MainMapID then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- underground or asteroid city
	local ChoOrig_BreakthroughOrder = BreakthroughOrder
	ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	BreakthroughOrder = ChoOrig_BreakthroughOrder
end
--
local function SnappedObjectPlaced(self, building)
	if IsKindOf(building, "ConstructionSite") then
		self.elevator_construction = building
		self.other.elevator_construction = building.linked_obj
	end
end
UndergroundPassage.SnappedObjectPlaced = SnappedObjectPlaced
SurfacePassage.SnappedObjectPlaced = SnappedObjectPlaced
--
function OnMsg.ConstructionSiteRemoved(construction_site)
  if construction_site and IsKindOf(construction_site.building_class_proto, "Elevator") then
    local passage = construction_site.snapped_to
    if passage then
      passage.elevator_construction = false
      passage.other.elevator_construction = false
    end
  end
end
--
function BaseMicroGExtractor:GatherConstructionStatuses(statuses)
  BuildingDepositExploiterComponent.GatherConstructionStatuses(self, statuses)
  if #self.nearby_deposits > 0 then
    local amounts = {}
    local grades = {}
    for _, deposit in ipairs(self.nearby_deposits) do
      if self:CanExploitResource(deposit) then
        amounts[deposit.resource] = (amounts[deposit.resource] or 0) + deposit.amount
        grades[deposit.resource] = Max(grades[deposit.resource] or 1, table.find(DepositGradesTable, deposit.grade) or 1)
      end
    end
    for res, amount in pairs(amounts) do
      local status = table.copy(ConstructionStatus.DepositInfo)
      local grade = grades[res]
      grade = DepositGradesTable[grade]
      grade = DepositGradeToDisplayName[grade]
      status.text = T({
        status.text,
        {
          resource = FormatResource(empty_table, amount, res),
          grade = grade,
          col = ConstructionStatusColors.info.color_tag
        }
      })
      statuses[#statuses + 1] = status
    end
  end
end
--
function Elevator:IsShroudedInRubble()
  return not Shroudable.IsShroudedInRubble(self) and self.other and Shroudable.IsShroudedInRubble(self.other)
end
--
if not SavegameFixups.BottomlessPitSwapResources then
	function SavegameFixups.BottomlessPitSwapResources_ChoGGi()
		local pits = UIColony:GetCityLabels("BottomlessPitResearchCenter")
		for _, pit in ipairs(pits) do
			pit.enabled_resources = {}
			local disabled_resources = pit.disabled_resources
			for _, resource in pairs(pit.accepted_resources) do
				if not table.find(disabled_resources, resource) then
					pit.enabled_resources[#pit.enabled_resources + 1] = resource
				end
			end
			pit.disabled_resources = nil
		end
	end

end
function BottomlessPitResearchCenter:DroneUnloadResource(drone, request, resource, amount)
  drone:PushDestructor(function(drone)
    local target = drone:IsValidPos() and drone or RotateRadius(100 * guim, AsyncRand(21600), self:GetPos())
    local entrance_type = drone.entrance_type or "entrance"
    local entrance = self:GetEntrance(target, entrance_type, nil, drone)
    self:LeadOut(drone, entrance)
  end)
  drone:SetCarriedResource(false)
  if self.demand[resource] and self.demand[resource] == request then
    local idx = table.find(self.stored_resources, "class", resource)
    self.stored_resources[idx].amount = self.stored_resources[idx].amount + amount / const.ResourceScale
  end
  Building.DroneUnloadResource(self, drone, request, resource, amount)
  drone:PopAndCallDestructor()
end
--
if not AncientArtifactInterface.GetEntrance then
	function AncientArtifactInterface:GetEntrance()
		return {
			self:GetPos(),
			GetRandomPassableAroundOnMap(Cities[self:GetMapID()].map_id, self:GetPos(), 2 * const.HexSize, const.HexSize)
--~ 			GetRandomPassableAround(self:GetPos(), 2 * const.HexSize, const.HexSize)
		}
	end
end
-- Elevator prefabs
local ChoOrig_Elevator_Arrive = Elevator.Arrive
function Elevator:Arrive(rovers, drones, crew, prefabs, ...)
  for _, entry in pairs(prefabs) do
    self.city:AddPrefabs(entry.class, entry.amount, false)
  end
	return ChoOrig_Elevator_Arrive(self, rovers, drones, crew, prefabs, ...)
end
--
