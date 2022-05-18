-- See LICENSE for terms

local table, type, pairs = table, type, pairs
local IsValidThread = IsValidThread
local IsValid = IsValid
local DoneObject = DoneObject
local GetRealmByID = GetRealmByID

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
end
--
do -- CityStart/LoadGame
	local function StartupCode()
		if not mod_EnableMod then
			return
		end

		-- speed up deleting/etc objs
		SuspendPassEdits("ChoGGi_FixBBBugs_loading")

		local UIColony = UIColony
		local main_realm = GetRealmByID(MainMapID)
		local GameMaps = GameMaps
		local bt = BuildingTemplates
		local ResourceScale = const.ResourceScale
		local GetDomeAtPoint = GetDomeAtPoint
		local Landscapes = Landscapes
		local bmpo = BuildMenuPrerequisiteOverrides
		local ResupplyItemDefinitions = ResupplyItemDefinitions


		-- Fix No Power Dome Buildings
		local ElectricityGridObject_GameInit = ElectricityGridObject.GameInit
		for _, map in pairs(GameMaps) do
			local objs = map.realm:MapGet("map", "ElectricityGridObject")
			for i = 1, #objs do
				local obj = objs[i]
				-- should be good enough to not get false positives?
				if obj.working == false and obj.signs.SignNoPower and IsValid(obj.parent_dome)
					and obj.electricity and not obj.electricity.parent_dome
				then
					obj:DeleteElectricity()
					ElectricityGridObject_GameInit(obj)
				end
			end
		end

		-- Fix Defence Towers Not Firing At Rovers (x2)
		local hostile = MainCity.labels.HostileAttackRovers or ""
		if #hostile > 0 then
			UIColony.mystery.can_shoot_rovers = true
		end

		-- Probably from a mod (a *badly* done mod)
		if type(g_ActiveOnScreenNotifications) ~= "table" then
			g_ActiveOnScreenNotifications = {}
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
				print("Fix Resupply Dialog Not Opening Borked cargo:", def.id)
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
-- Clearing waste rock
local ChoOrig_ClearWasteRockConstructionSite_InitBlockPass = ClearWasteRockConstructionSite.InitBlockPass
function ClearWasteRockConstructionSite:InitBlockPass(ls, ...)
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
