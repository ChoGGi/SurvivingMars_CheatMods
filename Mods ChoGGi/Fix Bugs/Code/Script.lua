-- See LICENSE for terms

local table, type, pairs, tostring = table, type, pairs, tostring
local IsValidThread = IsValidThread
local IsValid = IsValid
local ValidateBuilding = ValidateBuilding
local DoneObject = DoneObject
local GetRealmByID = GetRealmByID
local GetDomeAtPoint = GetDomeAtPoint
local GetRandomPassableAroundOnMap = GetRandomPassableAroundOnMap
local HexGetUnits = HexGetUnits
local GetRealm = GetRealm
local IsKindOf = IsKindOf
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local GetBuildingTechsStatus = GetBuildingTechsStatus

local empty_table = empty_table

local mod_EnableMod
local mod_FarmOxygen
local mod_DustDevilsBlockBuilding
local mod_PlanetaryAnomalyBreakthroughs
local mod_UnevenTerrain
--~ local mod_TurnOffUpgrades
local mod_SupplyPodSoundEffects

local function FixUnevenTerrain(game_map)
	pcall(function()
		local map = game_map or GameMaps[UICity.map_id]
		map.realm:SuspendPassEdits("ChoGGi_FixBBBugs_UnevenTerrain")
		SuspendTerrainInvalidations("ChoGGi_FixBBBugs_UnevenTerrain")
		map:RefreshBuildableGrid()
		ResumeTerrainInvalidations("ChoGGi_FixBBBugs_UnevenTerrain")
		map.realm:ResumePassEdits("ChoGGi_FixBBBugs_UnevenTerrain")
	end)
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_FarmOxygen = CurrentModOptions:GetProperty("FarmOxygen")
	mod_DustDevilsBlockBuilding = CurrentModOptions:GetProperty("DustDevilsBlockBuilding")
	mod_PlanetaryAnomalyBreakthroughs = CurrentModOptions:GetProperty("PlanetaryAnomalyBreakthroughs")
	mod_UnevenTerrain = CurrentModOptions:GetProperty("UnevenTerrain")
--~ 	mod_TurnOffUpgrades = CurrentModOptions:GetProperty("TurnOffUpgrades")
	mod_SupplyPodSoundEffects = CurrentModOptions:GetProperty("SupplyPodSoundEffects")

	if GameState.gameplay and mod_UnevenTerrain then
		FixUnevenTerrain()
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

--
function OnMsg.ClassesPostprocess()

	-- Fix Colonist Daily Interest Loop
	-- last checked lua rev 1011030 Colonist:EnterBuilding()
	local ChoOrig_Colonist_EnterBuilding = Colonist.EnterBuilding
	function Colonist:EnterBuilding(building, ...)
		if not mod_EnableMod then
			return ChoOrig_Colonist_EnterBuilding(self, building, ...)
		end

		if self.daily_interest ~= "" and ValidateBuilding(building)
			and building.IsOneOfInterests and building:IsOneOfInterests(self.daily_interest)
		then
			self.daily_interest = ""
			self.daily_interest_fail = 0
		end

		return ChoOrig_Colonist_EnterBuilding(self, building, ...)
	end
	--
end
--
do -- CityStart/LoadGame

	-- If you see (MainCity or UICity) that's for older saves (it does update, but after LoadGame)
	local function StartupCode()
		if not mod_EnableMod then
			return
		end

		-- speed up deleting/etc objs
		SuspendPassEdits("ChoGGi_FixBBBugs_loading")

		local UIColony = UIColony
		local const = const
		local GameMaps = GameMaps
		local ResupplyItemDefinitions = ResupplyItemDefinitions
		local bt = BuildingTemplates
		local bmpo = BuildMenuPrerequisiteOverrides
		local main_realm = GetRealmByID(MainMapID)

		--
		-- Force heat grid to update (if you paused game on new game load then cold areas don't update till you get a working Subsurface Heater).
		CreateGameTimeThread(function()
			-- When game isn't paused wait 5 secs and call it for main city (no cold areas underground?, eh can always do it later).
			Sleep(5000)
			GetGameMapByID(MainMapID).heat_grid:WaitLerpFinish()
		end)

		--
		-- Add Xeno-Extraction tech to Automatic Metals Extractor, Micro-G Extractors, RC Harvester, and RC Driller
		local tech = TechDef.XenoExtraction
		-- Figure it's safer to check for both dlcs then just checking the table length (incase some other mod)
		if not table.find(tech, "Label", "AutomaticMetalsExtractor")
			and not table.find(tech, "Label", "MicroGAutoExtractor")
		then
			local function AddBld(obj)
				tech[#tech+1] = PlaceObj("Effect_ModifyLabel", {
					Label = obj,
					Percent = 50,
					Prop = obj == "MicroGAutoWaterExtractor" and "water_production" or "production_per_day1",
				})
			end

			if g_AvailableDlc.gagarin then
				local objs = {
					"AutomaticMetalsExtractor",
					"RCHarvester",
					"RCDriller",
				}
				for i = 1, #objs do
					AddBld(objs[i])
				end
			end
			if g_AvailableDlc.picard then
				local objs = {
					"MicroGAutoExtractor",
					"MicroGExtractor",
					"MicroGAutoWaterExtractor",
				}
				for i = 1, #objs do
					AddBld(objs[i])
				end
			end
		end
		--
		-- Clean up city labels of wrong map / invalid objs
		local function CleanObj(obj, label, map_id, city)
			if IsValid(obj) then
				if obj.GetMapID and obj:GetMapID() ~= map_id then
					city:RemoveFromLabel(label, obj)
				end
			else
				city:RemoveFromLabel(label, obj)
			end
		end
		--
		local Cities = Cities
		for i = 1, #Cities do
			local city = Cities[i]
			local map_id = city.map_id
			for label, label_value in pairs(city.labels) do
				if label ~= "Consts" then
					local labels = city.labels[label]
					for j = #labels, 1, -1 do
						local obj = labels[j]
						CleanObj(obj, label, map_id, city)
						if label == "Dome" then
							for label_d in pairs(label_value.labels or empty_table) do
								for k = #label_d, 1, -1 do
									CleanObj(label_d[k], label_d, map_id, city)
								end
							end
						end
					end
				end
			end
		end
		--
		-- Fix No Power Dome Buildings
		local ElectricityGridObject_GameInit = ElectricityGridObject.GameInit
		for _, map in pairs(GameMaps) do
			local objs = map.realm:MapGet("map", "ElectricityGridObject")
			for i = 1, #objs do
				local obj = objs[i]
				-- should be good enough to not get false positives?
				if obj.working == false and obj.signs and obj.signs.SignNoPower and ValidateBuilding(obj.parent_dome)
					and obj.electricity and not obj.electricity.parent_dome
				then
					obj:DeleteElectricity()
					ElectricityGridObject_GameInit(obj)
				end
			end
		end
		--
		-- Fix Defence Towers Not Firing At Rovers (x2)
		local hostile = (MainCity or UICity).labels.HostileAttackRovers or ""
		if #hostile > 0 then
			UIColony.mystery.can_shoot_rovers = true
		end
		--
		-- Probably from a mod?
		if type(g_ActiveOnScreenNotifications) ~= "table" then
			g_ActiveOnScreenNotifications = {}
		end
		--
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
		--
		-- Fix Buildings Broken Down And No Repair
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
				local resource_unit_count = 1 + (bld.maintenance_resource_amount / (const.ResourceScale * 10)) --1 per 10
				local r_req = bld:AddDemandRequest(bld.maintenance_resource_type, 0, 0, resource_unit_count)
				bld.maintenance_resource_request = r_req
				bld.maintenance_request_lookup[r_req] = true
				-- needs to be fired off to complete the reset?
				bld:SetExceptionalCircumstancesMaintenance(bld.maintenance_resource_type, 1)
				bld:Setexceptional_circumstances(false)
			end
		end
		--
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
		--
		-- Fix Farm Oxygen 1
		if mod_FarmOxygen then
			local domes = UIColony:GetCityLabels("Dome")
			for i = 1, #domes do
				local dome = domes[i]
				local mods = dome:GetPropertyModifiers("air_consumption")
				if mods then
					local farms = dome.labels.Farm or empty_table
					-- Backwards?
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
		end
		--
		-- Wind turbine gets locked by a game event.
		if bmpo.WindTurbine and TGetID(bmpo.WindTurbine) == 401896326435--[[You can't construct this building at this time]] then
			bmpo.WindTurbine = nil
		end
		--
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
		--
		-- For some reason the devs put it in the Decorations instead of the Outside Decorations category.
		bt.LampProjector.build_category = "Outside Decorations"
		bt.LampProjector.group = "Outside Decorations"
		bt.LampProjector.label1 = ""
		--
		-- https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-game-freezes-when-deploying-drones-from-rc-commander-after-one-was-destroyed.1168779/
		local rovers = UIColony:GetCityLabels("RCRoverAndChildren")
		for i = 1, #rovers do
			local attached_drones = rovers[i].attached_drones
			for j = #attached_drones, 1, -1 do
				if not IsValid(attached_drones[j]) then
					table.remove(attached_drones, j)
				end
			end
		end
		--
		-- Probably caused by a mod badly adding cargo.
		for i = #ResupplyItemDefinitions, 1, -1 do
			local def = ResupplyItemDefinitions[i]
			if not def.pack then
				print("Fix Bugs: Resupply Dialog Not Opening Borked cargo", def.id)
				table.remove(ResupplyItemDefinitions, i)
			end
		end
		--
		-- Check for transport rovers with negative amounts of resources carried.
		local trans = UIColony:GetCityLabels("RCTransportAndChildren")
		for i = 1, #trans do
			local obj = trans[i]
			for j = 1, #(obj.storable_resources or "") do
				local res = obj.storable_resources[j]
				if obj.resource_storage[res] and obj.resource_storage[res] < 0 then
					obj.resource_storage[res] = 0
				end
			end
		end
		--
		if UIColony.underground_map_unlocked then
			--
			--	Move any floating underground rubble to within reach of drones (might have to "push" drones to make them go for it).
			local map = GameMaps[UIColony.underground_map_id]
			map.realm:MapForEach("map", "CaveInRubble", function(obj)
				local pos = obj:GetVisualPos()
				if pos:z() > 0 then
					-- The ground floor is 0 (or close enough to not matter), so I can just move it instead of having to check height.
					obj:SetPos(pos:SetZ(0))
				end
			end)
			--
			-- Unpassable underground rocks stuck in path (not cavein rubble, but small rocks you can't select).
			-- https://forum.paradoxplaza.com/forum/threads/surviving-mars-completely-blocked-tunnel-not-the-collapsed-tunnel.1541240/
			map.realm:MapForEach("map", "WasteRockObstructorSmall", function(obj)
				obj:SetBlockPass(false)
			end)
			--
		end
		--
		-- Fix Stuck Malfunctioning Drones At DroneHub
		local positions = {}
		local radius = 100 * guim
		local InvalidPos = InvalidPos()

		local hubs = UIColony:GetCityLabels("DroneHub")
		for i = 1, #hubs do
			table.clear(positions)

			local hub = hubs[i]
			for j = 1, #(hub.drones or "") do
				local drone = hub.drones[j]
				local pos = drone:GetVisualPos()
				if pos == InvalidPos and drone.command == "Malfunction" then
					-- don't move more than one malf drone to same pos
					if not positions[tostring(pos)] then
						local new_pos = GetRandomPassableAroundOnMap(hub.city.map_id, hub:GetPos(), radius)
						drone:SetPos(new_pos:SetTerrainZ())
						positions[tostring(new_pos)] = true
					end
				end
			end
		end
		--

		--
		ResumePassEdits("ChoGGi_FixBBBugs_loading")
	end

	OnMsg.CityStart = StartupCode
	OnMsg.LoadGame = StartupCode
end -- do
--
-- Clearing waste rock
local ChoOrig_ClearWasteRockConstructionSite_InitBlockPass = ClearWasteRockConstructionSite.InitBlockPass
function ClearWasteRockConstructionSite:InitBlockPass(ls, ...)
  if ls and ls.pass_bbox then
    return ChoOrig_ClearWasteRockConstructionSite_InitBlockPass(self, ls, ...)
  end
end
--
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
--
-- Some mods will try to add a notification without specifying an id for it; that makes baby Jesus cry.
local ChoOrig_LoadCustomOnScreenNotification = LoadCustomOnScreenNotification
function LoadCustomOnScreenNotification(notification, ...)
	if not mod_EnableMod then
		return ChoOrig_LoadCustomOnScreenNotification(notification, ...)
	end

	-- the first param is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
	if type(notification) == "table" and table.unpack(notification) then
		return ChoOrig_LoadCustomOnScreenNotification(notification, ...)
	end
end
--
-- Layout construction allows building buildings that should be locked by tech (Triboelectric Scrubber).
local ChoOrig_LayoutConstructionController_Activate = LayoutConstructionController.Activate
function LayoutConstructionController:Activate(...)
	-- fire first so it builds the tables/etc
	local ret = ChoOrig_LayoutConstructionController_Activate(self, ...)

	if not mod_EnableMod then
		return ret
	end

	-- Remove what shouldn't be there
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
	if not mod_FarmOxygen or not mod_EnableMod then
		return ChoOrig_Farm_Done(self, ...)
	end

	self:ApplyOxygenProductionMod(false)

	return ChoOrig_Farm_Done(self, ...)
end
--
-- The devs broke this in Tito update and haven't fixed it yet (double click selects all of type on screen).
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
--
-- Fix Defence Towers Not Firing At Rovers
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
--
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
-- Mars/Lua/Buildings/RocketBase.lua:319: attempt to get length of a boolean value (local 'cargo')
-- Guessing a mod?
local ChoOrig_RocketBase_RemovePassengers = RocketBase.RemovePassengers
function RocketBase:RemovePassengers(...)
	if not mod_EnableMod then
		return ChoOrig_RocketBase_RemovePassengers(self, ...)
	end

	if not self.cargo then
		-- something went horribly wrong...
		self.cargo = {}
	end

	return ChoOrig_RocketBase_RemovePassengers(self, ...)
end
--
do -- Stop buildings placed on top of dust devils
	local ChoGGi_OnTopOfDustDevil = {
		type = "error",
		priority = 100,
		text = T(0000, "Dust devil rejects your futile attempt of cheese."),
		short = T(0000, "Overlaps dust devil")
	}
	ConstructionStatus.ChoGGi_OnTopOfDustDevil = ChoGGi_OnTopOfDustDevil

	local ChoOrig_ConstructionController_FinalizeStatusGathering = ConstructionController.FinalizeStatusGathering
	function ConstructionController:FinalizeStatusGathering(...)
		if not mod_DustDevilsBlockBuilding or not mod_EnableMod then
			return ChoOrig_ConstructionController_FinalizeStatusGathering(self, ...)
		end

		-- shameless copy pasta of function ConstructionController:HasDepositUnderneath()
		-- last checked lua rev 1011166
		local force_extend_bb = self.template_obj:HasMember("force_extend_bb_during_placement_checks") and self.template_obj.force_extend_bb_during_placement_checks ~= 0 and self.template_obj.force_extend_bb_during_placement_checks or false
		local underneath = HexGetUnits(GetRealm(self), self.cursor_obj, self.template_obj:GetEntity(), nil, nil, true, function(o)
			return IsKindOf(o, "BaseDustDevil")
		end, "BaseDustDevil", force_extend_bb, self.template_obj_points)

		if underneath then
			self.construction_statuses[#self.construction_statuses + 1] = ChoGGi_OnTopOfDustDevil
		end

		return ChoOrig_ConstructionController_FinalizeStatusGathering(self, ...)
	end
end -- do
--
-- Log spam if you call this with an invalid dome
local ChoOrig_IsBuildingInDomeRange = IsBuildingInDomeRange
function IsBuildingInDomeRange(bld, dome, ...)
	if not mod_EnableMod then
		return ChoOrig_IsBuildingInDomeRange(bld, dome, ...)
	end

	-- Looking at IsBuildingInDomeRange(), I don't think I need to valid the bld
	if ValidateBuilding(dome) then
		return ChoOrig_IsBuildingInDomeRange(bld, dome, ...)
	end
	return false
end
--
-- Uneven Terrain
local ChoOrig_LandscapeFinish = LandscapeFinish
function LandscapeFinish(mark, ...)
	if not mod_EnableMod or not mod_UnevenTerrain then
		return ChoOrig_LandscapeFinish(mark, ...)
	end

	local landscape = Landscapes[mark]
	if not landscape then
		return
	end

--~ 	ex(landscape)

	-- This is false for Clear/Texture, and we don't care about those.
	if not landscape.changed then
		return ChoOrig_LandscapeFinish(mark, ...)
	end

	-- No return value
	-- last checked lua rev 1011166
	ChoOrig_LandscapeFinish(mark, ...)

	local map_id = landscape.map_id
	local game_map = GameMaps[map_id]
	-- Just in case Asteroid
	if game_map then
		FixUnevenTerrain(game_map)
	end
end
--
-- Disable upgrades when demoing a building (prevents modifiers from staying modified)
local ChoOrig_Building_Done = Building.Done
function Building:Done(...)
	-- Skip if not an upgradeable building
	if not mod_EnableMod or not self.upgrade_on_off_state then
		return ChoOrig_Building_Done(self, ...)
	end

	-- Goes through list of enabled upgrades and turns them off.
	-- You'd figure it'd do this when demoing building?
	for id, enabled in pairs(self.upgrade_on_off_state or empty_table) do
		if enabled then
			self:ToggleUpgradeOnOff(id)
		end
	end

	return ChoOrig_Building_Done(self, ...)
end
--~ -- Also do the same when turning off a building
--~ local ChoOrig_BaseBuilding_OnSetWorking = BaseBuilding.OnSetWorking
--~ function BaseBuilding:OnSetWorking(working, ...)
--~ 	-- Skip if the building is being turned on or it's not an upgradeable building
--~ 	if not mod_EnableMod or not mod_TurnOffUpgrades then
--~ 		return ChoOrig_BaseBuilding_OnSetWorking(self, working, ...)
--~ 	end

--~ 	if working then
--~ 		-- Enable any upgrades I disabled
--~ 		for id, enabled in pairs(self.upgrades_built or empty_table) do
--~ 			if self["ChoGGi_" .. id] then
--~ 				self:ToggleUpgradeOnOff(id)
--~ 				self["ChoGGi_" .. id] = nil
--~ 			end
--~ 		end
--~ 	else
--~ 		-- Goes through list of enabled upgrades and turns them off.
--~ 		-- You'd figure the game would do this?
--~ 		for id, enabled in pairs(self.upgrade_on_off_state or empty_table) do
--~ 			if enabled then
--~ 				self:ToggleUpgradeOnOff(id)
--~ 				-- Used above to re-enable
--~ 				self["ChoGGi_" .. id] = true
--~ 			end
--~ 		end
--~ 	end

--~ 	return ChoOrig_BaseBuilding_OnSetWorking(self, working, ...)
--~ end
--
-- Add sound effects to SupplyPods
local ChoOrig_SupplyPod_GameInit = SupplyPod.GameInit
function SupplyPod:GameInit(...)
	-- Skip if the building is being turned on or it's not an upgradeable building
	if not mod_EnableMod or not mod_SupplyPodSoundEffects then
		return ChoOrig_SupplyPod_GameInit(self, ...)
	end

	-- Not sure why it updates the value from GameInit, but it makes it easy to override with a mod option I suppose.
	ChoOrig_SupplyPod_GameInit(self, ...)
	self.fx_actor_class = RocketBase.fx_actor_class
end
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
--
--
--
--
-- Stop ceiling/floating rubble
local ChoOrig_TriggerCaveIn = TriggerCaveIn
function TriggerCaveIn(...)
	if not mod_EnableMod then
		return ChoOrig_TriggerCaveIn(...)
	end

	local rubble = ChoOrig_TriggerCaveIn(...)

	local pos = rubble:GetVisualPos()
	if pos:z() > 0 then
		-- The ground floor is 0 (or close enough to not matter), so I can just move it instead of having to check height.
		rubble:SetPos(pos:SetZ(0))
	end

	return rubble
end
--
-- Devs didn't check for EasyMaintenance when overriding AccumulateMaintenancePoints for picard
local ChoOrig_SupportStruts_AccumulateMaintenancePoints = SupportStruts.AccumulateMaintenancePoints
function SupportStruts:AccumulateMaintenancePoints(new_points, ...)
	if not mod_EnableMod then
		return ChoOrig_SupportStruts_AccumulateMaintenancePoints(new_points, ...)
	end

	-- last checked lua rev 1011166
  RequiresMaintenance.AccumulateMaintenancePoints(self, new_points, ...)
  if self.accumulated_maintenance_points >= self.maintenance_threshold_current then
		if IsGameRuleActive("EasyMaintenance") then
			self:SetNeedsMaintenanceState()
		else
			self:SetMalfunction()
		end
  end
end
--
-- Added some varargs (5 bucks says if they change the base func then they forget to change the overridden func)
-- last checked lua rev 1011166
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
--
-- No Planetary Anomaly Breakthroughs when B&B is installed.
local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City:InitBreakThroughAnomalies(...)
	if not mod_EnableMod or not mod_PlanetaryAnomalyBreakthroughs then
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
