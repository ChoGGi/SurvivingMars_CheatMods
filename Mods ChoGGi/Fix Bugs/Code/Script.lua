-- See LICENSE for terms

local table, type, pairs, tostring = table, type, pairs, tostring
local AsyncRand = AsyncRand
local IsValidThread = IsValidThread
local IsValid = IsValid
local ValidateBuilding = ValidateBuilding
local DoneObject = DoneObject
local GetCity = GetCity
local GetRealmByID = GetRealmByID
local GetDomeAtPoint = GetDomeAtPoint
local GetRandomPassableAroundOnMap = GetRandomPassableAroundOnMap
local HexGetUnits = HexGetUnits
local GetRealm = GetRealm
local IsKindOf = IsKindOf
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local GetBuildingTechsStatus = GetBuildingTechsStatus
-- Fix for Silva's Orion Rocket mod (part 1, backing up the func he overrides)
local ChoOrig_PlacePlanet = PlacePlanet

local empty_table = empty_table

local mod_EnableMod
local mod_FarmOxygen
local mod_DustDevilsBlockBuilding
local mod_UnevenTerrain
--~ local mod_TurnOffUpgrades
local mod_SupplyPodSoundEffects
local mod_MainMenuMusic
local mod_ColonistsWrongMap
local mod_NoFlyingDronesUnderground

local function UpdateMap(game_map)
	-- Suspend funcs speed up "doing stuff"
	game_map.realm:SuspendPassEdits("ChoGGi_FixBBBugs_UnevenTerrain")
	SuspendTerrainInvalidations("ChoGGi_FixBBBugs_UnevenTerrain")
	game_map:RefreshBuildableGrid()
	ResumeTerrainInvalidations("ChoGGi_FixBBBugs_UnevenTerrain")
	game_map.realm:ResumePassEdits("ChoGGi_FixBBBugs_UnevenTerrain")
end

local function FixUnevenTerrain(game_map)
	if game_map then
		UpdateMap(game_map)
	else
		for _, map in pairs(GameMaps) do
			UpdateMap(map)
		end
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_FarmOxygen = CurrentModOptions:GetProperty("FarmOxygen")
	mod_DustDevilsBlockBuilding = CurrentModOptions:GetProperty("DustDevilsBlockBuilding")
	mod_UnevenTerrain = CurrentModOptions:GetProperty("UnevenTerrain")
--~ 	mod_TurnOffUpgrades = CurrentModOptions:GetProperty("TurnOffUpgrades")
	mod_SupplyPodSoundEffects = CurrentModOptions:GetProperty("SupplyPodSoundEffects")
	mod_MainMenuMusic = CurrentModOptions:GetProperty("MainMenuMusic")
	mod_ColonistsWrongMap = CurrentModOptions:GetProperty("ColonistsWrongMap")
	mod_NoFlyingDronesUnderground = CurrentModOptions:GetProperty("NoFlyingDronesUnderground")

	-- Update all maps for uneven terrain (if using mod that allows landscaping maps other than surface)
	if UIColony and mod_UnevenTerrain then
		FixUnevenTerrain()
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.SectorScanned()
	if not mod_EnableMod then
		return
	end

	--
	-- The Philosopher's Stone Mystery doesn't update sector scanned count when paused.
	-- I could add something to check if this is being called multiple times per unpause, but it's not doing much
	-- Check if we're on the right mystery
	local stone_seq
	local players = s_SeqListPlayers or ""
	for i = 1, #players do
		local player = players[i]
		if player.seq_list and player.seq_list.file_name
			and player.seq_list.file_name == "Mystery_10"
		then
			stone_seq = player
			break
		end
	end
	--
	if not stone_seq then
		return
	end

	-- Get count of scanned sectors
	local count = 0
	local sectors = MainCity.MapSectors
	for sector in pairs(sectors) do
		if type(sector) == "table" then
			if IsValid(sector.revealed_obj) then
				count = count + 1
			end
		end
	end

	-- Update mystery with proper count
	if count > 0 then
		CreateRealTimeThread(function()
			Sleep(100)
			stone_seq.registers._sectors_scanned = count
		end)
	end

end

function OnMsg.NewDay()
	if not mod_EnableMod then
		return
	end

	--
	-- Fix Landscaping Freeze
	local Landscapes = Landscapes
	if Landscapes and next(Landscapes) then
		-- If there's placed landscapes grab the largest number
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
		-- No landscapes so 0 it is
		LandscapeLastMark = 0
	end

end

--
function OnMsg.ClassesPostprocess()
	-- Fix Colonist Daily Interest Loop
	-- last checked 1011030 Colonist:EnterBuilding()
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
-- Copied from ChoGGi_Funcs.Common.GetCityLabels()
function GetCityLabels(label)
	local UIColony = UIColony
	local labels = UIColony and UIColony.city_labels.labels or UICity.labels
	return labels[label] or empty_table
end

--
-- CityStart/LoadGame
do

	local function StartupCode(event)
		if not mod_EnableMod then
			return
		end

		-- Speed up adding/deleting/etc objs
		SuspendPassEdits("ChoGGi_FixBBBugs_Startup")

		-- If this is called on a save from before B&B (it does update, but after LoadGame)
		local main_city = MainCity or UICity

		local main_realm = GetRealmByID(MainMapID)
		local UIColony = UIColony
		local Cities = Cities
		local const = const
		local GameMaps = GameMaps
		local ResupplyItemDefinitions = ResupplyItemDefinitions
		local BuildingTemplates = BuildingTemplates
 		local CargoPreset = CargoPreset
		local objs

		-- Anything that only needs a specific event
		if event == "LoadGame" then

			--
			-- Gene Forging tech doesn't increase rare traits chance.
			-- See OnMsg.TechResearched below for more info about GeneForging
			if UIColony:IsTechResearched("GeneForging") then
				TechDef.GeneSelection.param1 = 150
			end

			--
			-- Fix Defence Towers Not Firing At Rovers (1/2)
			if #(main_city.labels.HostileAttackRovers or "") > 0 then
				UIColony.mystery.can_shoot_rovers = true
			end

			--
			-- Update all maps for uneven terrain (if using mod that allows landscaping maps other than surface)
			if mod_UnevenTerrain then
				FixUnevenTerrain()
			end

			--
			-- Fix FindDroneToRepair Log Spam
			local broke = g_BrokenDrones
			for i = #broke, 1, -1 do
				if not IsValid(broke[i]) then
					table.remove(broke, i)
				end
			end

			--
			-- Fix Destroyed Tunnels Still Work
			-- Update path finding tunnels to stop rovers from using them
			main_realm:MapForEach("map", "Tunnel", function(t)
				t:RemovePFTunnel()
				t:AddPFTunnel()
			end)

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
			-- Wind turbine gets locked by a game event.
			local bmpo = BuildMenuPrerequisiteOverrides
			if bmpo.WindTurbine
				and TGetID(bmpo.WindTurbine) == 401896326435--[[You can't construct this building at this time]]
			then
				bmpo.WindTurbine = nil
			end

			--
			-- Removes any meteorites stuck on the map.
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

		elseif event == "CityStart" then

			--
			-- Possible fix for main menu music not stopping when starting a new game
			-- Hopefully delay helps?
			CreateRealTimeThread(function()
				Sleep(5000)
				-- What the game usually does
				SetMusicPlaylist("")
				Sleep(1000)
				-- Make sure menu music is stopped... Hopefully
				Music = Music or MusicClass:new()
				Music:StopTrack(false)
				Sleep(1000)
				StartRadioStation(GetStoredRadioStation())
			end)

		end

		--
		-- Anything that needs to loop through GameMaps
		local ElectricityGridObject_GameInit = ElectricityGridObject.GameInit
		for _, map in pairs(GameMaps) do

			--
			-- Remove stuck cursor buildings (reddish coloured).
			map.realm:MapDelete("map", "CursorBuilding")

			--
			-- Fix No Power Dome Buildings
			map.realm:MapGet("map", "ElectricityGridObject", function(obj)
				-- should be good enough to not get false positives?
				if obj.working == false and obj.signs and obj.signs.SignNoPower and ValidateBuilding(obj.parent_dome)
					and obj.electricity and not obj.electricity.parent_dome
				then
					obj:DeleteElectricity()
					ElectricityGridObject_GameInit(obj)
				end
			end)

			--
			-- Leftover particles from re-fabbing rare extractors with particles attached (concrete/reg metals seem okay)
			-- Leftover from before my fix to stop it from happening
			map.realm:MapGet("map", "ParSystem", function(par_obj)
				local par_name = par_obj:GetParticlesName()
				if par_name == "UniversalExtractor_Steam_02"
					or par_name == "UniversalExtractor_Smoke"
				then
					local q, r = WorldToHex(par_obj:GetPos())
					if not map.object_hex_grid:GetObject(q, r, "PreciousMetalsExtractor") then
						DoneObject(par_obj)
					end
				end
			end)

		end

		--
		-- Fix Storybits
 		local StoryBits = StoryBits
		-- Just in case something changes (hah)
		pcall(function()
			-- No breakthrough tech reward for The Door To Summer: Let No Noble Deed first/second options (they only give regular tech)
			-- The Satoshi Nisei option doesn't mention a breakthrough, but the second option does;
			-- One gives a colonist and the other gives money so guessing it's supposed to give a break
			StoryBits.TheDoorToSummer_LetNoNobleDeed[3].Effects[1].Field = "Breakthroughs"
			StoryBits.TheDoorToSummer_LetNoNobleDeed[5].Effects[1].Field = "Breakthroughs"


			-- Blank Slate doesn't remove any applicants for options 23 (fix 1/2)
			local slate = StoryBits.BlankSlate[9].Effects
			slate[#slate+1] = PlaceObj("ChoGGi_RemoveApplicants", {"Amount", 20})
			slate = StoryBits.BlankSlate[12].Effects
			slate[#slate+1] = PlaceObj("ChoGGi_RemoveApplicants", {"Amount", 20})

			-- Fhtagn! Fhtagn! "Let's wait it out" makes all colonists cowards instead of only religious ones
			local fhtagn = StoryBits.FhtagnFhtagn[4].Effects[1].Filters
			fhtagn[#fhtagn+1] = PlaceObj("HasTrait", {"Trait", "Religious"})

			-- Dust Sickness: Deaths doesn't apply morale penalty
			local outcome = PlaceObj("StoryBitOutcome", {
				"Prerequisites", {},
				"Effects", {
					PlaceObj("ForEachExecuteEffects", {
						"Label", "Colonist",
						"Filters", {},
						"Effects", {
							PlaceObj("ModifyObject", {
								"Prop", "base_morale",
								"Amount", "<morale_penalty>",
								"Sols", "<morale_penalty_duration>",
							}),
						},
					}),
				},
			})
			table.insert(StoryBits.DustSickness_Deaths, 5, outcome)
			table.insert(StoryBits.DustSickness_Deaths, 7, outcome)
			table.insert(StoryBits.DustSickness_Deaths, 9, PlaceObj("StoryBitOutcome", {
				"Prerequisites", {},
				"Effects", {
					PlaceObj("ForEachExecuteEffects", {
						"Label", "Colonist",
						"Filters", {},
						"Effects", {
							PlaceObj("ModifyObject", {
								"Prop", "base_morale",
								"Amount", "<lower_morale_penalty>",
								"Sols", "<morale_penalty_duration>",
							}),
						},
					}),
				},
			}))

		end)

		-- New fixes go here
		--
		--
		--
		--
		--
		--
		--

		--
		-- Rivals Trade Minerals mod hides Exotic Minerals from lander UI
		if table.find(ModsLoaded, "id", "LH_RivalsMinerals") then
			local cargo = Presets.Cargo["Basic Resources"].PreciousMinerals
			if cargo then
				cargo.group = "Other Resources"
				Presets.Cargo["Other Resources"].PreciousMinerals = cargo
			end
			ResupplyItemsInit()
		end

		--
		-- tech_field log spam from a mod
		local TechFields = TechFields
		for _, item in pairs(TechFields) do
			if not item.SortKey then
				item.SortKey = 9999
			end
		end

		--
		-- Cargo presets are missing images for some buildings/all resources
		local articles = Presets.EncyclopediaArticle.Resources
		local lookup_res = {
			Concrete = articles.Concrete.image,
			Electronics = articles.Electronics.image,
			Food = articles.Food.image,
			Fuel = articles.Fuel.image,
			MachineParts = articles["Mechanical Parts"].image,
			Metals = articles.Metals.image,
			Polymers = articles.Polymers.image,
			PreciousMetals = articles["Rare Metals"].image,
			-- Close enough
			WasteRock = "UI/Messages/Tutorials/Tutorial1/Tutorial1_WasteRockConcreteDepot.tga",
		}
		if g_AvailableDlc.picard then
			lookup_res.PreciousMinerals = articles.ExoticMinerals.image
		end
		if g_AvailableDlc.armstrong then
			lookup_res.Seeds = articles.Seeds.image
		end

		for id, cargo in pairs(CargoPreset) do
			if not cargo.icon then

				if lookup_res[id] then
					cargo.icon = lookup_res[id]
				elseif BuildingTemplates[id] then
					cargo.icon = BuildingTemplates[id].encyclopedia_image
				end

			end
		end

		--
		-- Fix Future Contemporary Asset Pack when placing spires.
		if g_AvailableDlc.ariane then
			local hex = HexOutlineShapes.PeakNodeCCP2
			if #hex == 8 then
				table.remove(hex, 6)
				-- Removing HexOutlineShapes seems to fix it, but it doesn't hurt to remove HexCombinedShapes as well.
				table.remove(HexCombinedShapes.PeakNodeCCP2, 6)

				-- The other borked buildings
				table.remove(HexOutlineShapes.FusionArcologyCCP2, 6)
				table.remove(HexCombinedShapes.FusionArcologyCCP2, 6)
				table.remove(HexOutlineShapes.VerticalGardenCCP2, 6)
				table.remove(HexCombinedShapes.VerticalGardenCCP2, 6)
			end
		end

		--
		-- Fix for Silva's Orion Heavy Rocket mod (part 2, restoring the original func)
		-- He only calls the original func when the rocket mod isn't installed, so I have to remove it completely.
		PlacePlanet = ChoOrig_PlacePlanet

		--
		-- Add Xeno-Extraction tech to Automatic Metals Extractor, Micro-G Extractors, RC Harvester, and RC Driller
		local tech = TechDef.XenoExtraction
		-- Figure it's safer to check for both dlcs then just checking the table length (in case some other mod)
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
		-- Probably from a mod?
		if type(g_ActiveOnScreenNotifications) ~= "table" then
			g_ActiveOnScreenNotifications = {}
		end

		--
		-- For some reason the devs put it in the Decorations instead of the Outside Decorations category.
		BuildingTemplates.LampProjector.build_category = "Outside Decorations"
		BuildingTemplates.LampProjector.group = "Outside Decorations"
		BuildingTemplates.LampProjector.label1 = ""

		--
		-- Probably caused by a mod badly adding cargo.
		for i = #ResupplyItemDefinitions, 1, -1 do
			local def = ResupplyItemDefinitions[i]
			if not def.pack then
				print("Fix Bugs: Resupply Dialog Not Opening Borked cargo", def.id)
				table.remove(ResupplyItemDefinitions, i)
			end
		end


		-------- GetCityLabels below --------

		--
		-- Force heat grid to update (if you paused game on new game load then cold areas don't update till you get a working Subsurface Heater).
		objs = GetCityLabels("SubsurfaceHeater")
		if #objs == 0 then
			CreateGameTimeThread(function()
				-- When game isn't paused wait 5 secs and call it for main city (no cold areas underground?, eh can always do it later).
				Sleep(5000)
				GetGameMapByID(MainMapID).heat_grid:WaitLerpFinish()
			end)
		end

		if event == "LoadGame" then

			--
			-- Fix Shuttles Stuck Mid-Air (req has an invalid building)
			CreateRealTimeThread(function()
				Sleep(1000)
				objs = GetCityLabels("CargoShuttle")
				local reset_shuttles = {}
				local c = 0
				for i = 1, #objs do
					local obj = objs[i]
					if obj.command == "Idle" then
						-- Remove borked requests
						local req = obj.assigned_to_d_req and obj.assigned_to_d_req[1]
						if type(req) == "userdata" and req.GetBuilding and not IsValid(req:GetBuilding()) then
							obj.assigned_to_d_req[1]:UnassignUnit(obj.assigned_to_d_req[2], false)
							obj.assigned_to_d_req = false
						end

						req = obj.assigned_to_s_req and obj.assigned_to_s_req[1]
						if type(req) == "userdata" and req.GetBuilding and not IsValid(req:GetBuilding()) then
							obj.assigned_to_s_req[1]:UnassignUnit(obj.assigned_to_s_req[2], false)
							obj.assigned_to_s_req = false
						end
						c = c + 1
						reset_shuttles[c] = obj
					end
				end
				-- Reset stuck shuttles
				Sleep(1000)
				for i = 1, #reset_shuttles do
					local obj = reset_shuttles[i]
					if IsValid(obj) then
						obj:Idle()
						obj:SetCommand("GoHome")
					end
				end

			end)

			--
			-- St. Elmo's Fire: Stop meteoroids from destroying sinkholes (existing saves)
			objs = GetCityLabels("Sinkhole")
			for i = 1, #objs do
				objs[i].indestructible = true
			end

			--
			-- Fix Buildings Broken Down And No Repair
			objs = GetCityLabels("Building")
			for i = 1, #objs do
				local obj = objs[i]

				-- clear out non-task requests in task_requests
				local task_requests = obj.task_requests or ""
				for j = #task_requests, 1, -1 do
					local req = task_requests[j]
					if type(req) ~= "userdata" then
						table.remove(task_requests, j)
					end
				end

				-- Buildings hit with lightning during a cold wave
				if obj.is_malfunctioned and obj.accumulated_maintenance_points == 0 then
					obj:AccumulateMaintenancePoints(obj.maintenance_threshold_base * 2)

				-- Exceptional circumstance buildings
				elseif not obj.maintenance_resource_request and obj:DoesMaintenanceRequireResources() then
					-- restore main res request
					local resource_unit_count = 1 + (obj.maintenance_resource_amount / (const.ResourceScale * 10)) --1 per 10
					local r_req = obj:AddDemandRequest(obj.maintenance_resource_type, 0, 0, resource_unit_count)
					obj.maintenance_resource_request = r_req
					obj.maintenance_request_lookup[r_req] = true
					-- needs to be fired off to complete the reset?
					obj:SetExceptionalCircumstancesMaintenance(obj.maintenance_resource_type, 1)
					obj:Setexceptional_circumstances(false)
				end
			end

			--
			local GetDomeAtPoint = GetDomeAtPoint
			objs = GetCityLabels("Colonist")
			for i = 1, #objs do
				local colonist = objs[i]

				-- Some colonists are allergic to doors and suffocate inside a dome with their suit still on.
				-- Check if lemming is currently in a dome while wearing a suit
				if colonist.entity:sub(1, 15) == "Unit_Astronaut_" then
					local grid = GameMaps[colonist.city.map_id].object_hex_grid
					local dome_at_pt = GetDomeAtPoint(grid, colonist:GetVisualPos())
					if dome_at_pt then
						-- Normally called when they go through the airlock
						colonist:OnEnterDome(dome_at_pt)
						-- The colonist will wait around for a bit till they start moving, this forces them to do something
						colonist:SetCommand("Idle")
					end
				end

				-- Leftover transport_ticket in colonist objs (assign to residence grayed out, from Trains DLC)
				local ticket = colonist.transport_ticket
				if ticket and ticket.reason and ticket.reason == "Idle" then
					if not IsValid(ticket.dst_station)
						or not IsValid(ticket.src_station)
					then
						colonist.transport_ticket = nil
					end
				end

			end -- GetCityLabels("Colonist")

			--
			-- Fix Farm Oxygen 1
			if mod_FarmOxygen then
				objs = GetCityLabels("Dome")
				for i = 1, #objs do
					local dome = objs[i]
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
			-- https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-game-freezes-when-deploying-drones-from-rc-commander-after-one-was-destroyed.1168779/
			objs = GetCityLabels("RCRoverAndChildren")
			for i = 1, #objs do
				local attached_drones = objs[i].attached_drones
				for j = #attached_drones, 1, -1 do
					if not IsValid(attached_drones[j]) then
						table.remove(attached_drones, j)
					end
				end
			end

			--
			-- Check for transport rovers with negative amounts of resources carried.
			objs = GetCityLabels("RCTransportAndChildren")
			for i = 1, #objs do
				local obj = objs[i]
				for j = 1, #(obj.storable_resources or "") do
					local res = obj.storable_resources[j]
					if obj.resource_storage[res] and obj.resource_storage[res] < 0 then
						obj.resource_storage[res] = 0
					end
				end
			end

			--
			-- Fix Stuck Malfunctioning Drones At DroneHub
			local positions = {}
			local radius = 100 * guim
			local InvalidPos = InvalidPos()

			objs = GetCityLabels("DroneHub")
			for i = 1, #objs do
				table.clear(positions)

				local hub = objs[i]
				for j = 1, #(hub.drones or "") do
					local drone = hub.drones[j]
					local pos = drone:GetVisualPos()
					if pos == InvalidPos and drone.command == "Malfunction" then
						-- Make sure they're not all bunched up
						if not positions[tostring(pos)] then
							local new_pos = GetRandomPassableAroundOnMap(hub.city.map_id, hub:GetPos(), radius)
							drone:SetPos(new_pos)
							positions[tostring(new_pos)] = true
						end
					end
				end
			end

		end
		-------- GetCityLabels above --------

		--
		if UIColony.underground_map_unlocked then

			local underground_map = GameMaps[UIColony.underground_map_id]
			local underground_city = Cities[UIColony.underground_map_id]

			--
			-- Colonists showing up on wrong map in infobar.
			if mod_ColonistsWrongMap then
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
				for i = 1, #Cities do
					local city = Cities[i]
					local map_id = city.map_id
					for label, label_value in pairs(city.labels) do
						if label ~= "Consts" then
							local labels = city.labels[label]
							--
							for j = #labels, 1, -1 do
								local obj = labels[j]
								CleanObj(obj, label, map_id, city)
								if label == "Dome" then
									--
									for label_d in pairs(label_value.labels or empty_table) do
										for k = #label_d, 1, -1 do
											CleanObj(label_d[k], label_d, map_id, city)
										end
									end
									--
								end
							end
							--
						end
					end
				end
			end

			--
			--	Move any floating underground rubble to within reach of drones (might have to "push" drones to make them go for it).
			underground_map.realm:MapForEach("map", "CaveInRubble", function(obj)
				local pos = obj:GetVisualPos()
				if pos:z() > 0 then
					-- The ground floor is 0 (or close enough to not matter), so I can just move it instead of having to check height.
					obj:SetPos(pos:SetZ(0))
				end
			end)

			--
			-- Unpassable underground rocks stuck in path (not cavein rubble, but small rocks you can't select).
			-- https://forum.paradoxplaza.com/forum/threads/surviving-mars-completely-blocked-tunnel-not-the-collapsed-tunnel.1541240/
			underground_map.realm:MapForEach("map", "WasteRockObstructorSmall", function(obj)
				obj:SetBlockPass(false)
			end)

			--
			-- Move any underground dome prefabs (underground anomaly "storybit") to underground city (instead of being stuck on surface)
			-- https://www.reddit.com/r/SurvivingMars/comments/1013afl/no_way_to_moveuse_underground_dome_prefabs/
			-- Rare Anomaly Analyzed: Mona Lisa
			if main_city.available_prefabs.UndergroundDome then
				local prefabs = underground_city.available_prefabs
				-- They default to nil
				if not prefabs.UndergroundDome then
					prefabs.UndergroundDome = 0
				end
				-- and we can't do math on nil
				prefabs.UndergroundDome = prefabs.UndergroundDome + main_city.available_prefabs.UndergroundDome
				main_city.available_prefabs.UndergroundDome = nil
			end
			--
		end

		--
		ResumePassEdits("ChoGGi_FixBBBugs_Startup")
	end

	function OnMsg.CityStart()
		StartupCode("CityStart")
	end
	function OnMsg.LoadGame()
		StartupCode("LoadGame")
	end
end -- StartupCode do
-- do

--
-- Clearing waste rock
local ChoOrig_ClearWasteRockConstructionSite_InitBlockPass = ClearWasteRockConstructionSite.InitBlockPass
function ClearWasteRockConstructionSite:InitBlockPass(ls, ...)
	if not mod_EnableMod then
		return ChoOrig_ClearWasteRockConstructionSite_InitBlockPass(self, ls, ...)
	end

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
-- AreDomesConnectedWithPassage (Fix Colonists Long Walks)
do
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
-- Fix Defence Towers Not Firing At Rovers (2/2)
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
-- Stop buildings placed on top of dust devils
do
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

	FixUnevenTerrain(GameMaps[landscape.map_id])
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
-- Personal Space storybit (and anything else that changes the resident capacity amount)
local ChoOrig_GetConstructionDescription = GetConstructionDescription
function GetConstructionDescription(template, ...)
	if not mod_EnableMod then
		return ChoOrig_GetConstructionDescription(template, ...)
	end

	-- Get modified capacity count
	local modifier_count = 0
	local res_modifier = UIColony.city_labels.label_modifiers.Residence
	if res_modifier then
		for label, modifier in pairs(res_modifier) do
			if label.Prop == "capacity" then
				modifier_count = modifier_count + modifier.amount
			end
		end
	end
	-- Nothing to change abort
	if modifier_count == 0 then
		return ChoOrig_GetConstructionDescription(template, ...)
	end

	local list = ChoOrig_GetConstructionDescription(template, ...)
	if list[1] then
		for i = 1, list[1].j do
			local item = list[1].table[i]
			if type(item) == "table" and item[1] == 3961--[[Residential space: ]] then
				item.capacity = item.capacity + modifier_count
				break
			end
		end
	end

	return list
end

--
-- Fix Destroyed Tunnels Still Work
local ChoOrig_Tunnel_AddPFTunnel = Tunnel.AddPFTunnel
function Tunnel:AddPFTunnel(...)
	if not mod_EnableMod then
		return ChoOrig_Tunnel_AddPFTunnel(self, ...)
	end

	if not self.working and not self:CanDemolish() and not self:IsDemolishing() then
		return
	end

	return ChoOrig_Tunnel_AddPFTunnel(self, ...)
end

--
-- These were moved from City to Colony, shouldn't hurt anything...
function City.IsTechResearched(_, ...)
	return UIColony:IsTechResearched(...)
end
function City.IsTechDiscovered(_, ...)
	return UIColony:IsTechDiscovered(...)
end

--
-- Refabbing certain buildings with particles (so far both rare extractor skins) will leave the particles behind
-- I clean them out on load, and use this to stop new ones from appearing.
function OnMsg.Refabricated(obj)
	-- This msg is called before it deletes the building object
	obj:ChangeWorkingStateAnim(false)
end

--
-- St. Elmo's Fire: Stop meteoroids from destroying sinkholes
if g_AvailableDlc.contentpack1 then
	local ChoOrig_Sinkhole_GameInit = Sinkhole.GameInit
	function Sinkhole:GameInit(...)
		if not mod_EnableMod then
			return ChoOrig_Sinkhole_GameInit(self, ...)
		end

		self.indestructible = true

		return ChoOrig_Sinkhole_GameInit(self, ...)
	end
end

--
-- Uneven Terrain mod options calls RefreshBuildableGrid(), that causes any geoscape domes with spire points to be marked as uneven
-- I don't see why the game should be checking for uneven terrain in a dome, so... skip!
local ChoOrig_ConstructionController_IsTerrainFlatForPlacement = ConstructionController.IsTerrainFlatForPlacement
function ConstructionController:IsTerrainFlatForPlacement(...)
	if not mod_EnableMod or not mod_UnevenTerrain then
		return ChoOrig_ConstructionController_IsTerrainFlatForPlacement(self, ...)
	end

	-- if it's a spire and we're inside a dome then return true
	if self.template_obj.dome_spot == "Spire" then
		local pos = self.cursor_obj:GetVisualPos()
		if GetDomeAtPoint(GetObjectHexGrid(self.city), pos) then
			return true
		end
	end

	return ChoOrig_ConstructionController_IsTerrainFlatForPlacement(self, ...)
end

--
-- GeneForging doesn't interact with anything unlike GeneSelection
-- and you can only have GeneForging if you have GeneSelection
-- This boosts GeneSelection to 150 (seems a safe enough way of doing it).
function OnMsg.TechResearched(tech_id)
	if tech_id == "GeneForging" then
		TechDef.GeneSelection.param1 = 150
	end
end

--
-- EsoCorp rovers .name uses a T() userdata name instead of a string name like every other rover,
-- so the sort func used in this func errors out.
-- This will change any with userdata to use a string instead.
local ChoOrig_GetCommandCenterTransportsList = GetCommandCenterTransportsList
function GetCommandCenterTransportsList(...)
	if not mod_EnableMod then
		return ChoOrig_GetCommandCenterTransportsList(...)
	end

	local objs = GetCityLabels("AttackRover")
	for i = 1, #objs do
		local obj = objs[i]
		if not obj.ChoGGi_FixedRoverNameForCCC or type(obj.name) == "userdata" then
			obj.name = _InternalTranslate(obj.name)
			obj.ChoGGi_FixedRoverNameForCCC = true
		end
	end

	return ChoOrig_GetCommandCenterTransportsList(...)
end

--
-- Colonists on an expedition show unknown as their status, since their command is WaitToAppear instead of Embark

-- WaitToAppear isn't listed in ColonistCommands, though Embark = T(4321, "On an expedition") is listed...
-- Maybe they planned to use WaitToAppear elsewhere?
local ChoOrig_Colonist_Getui_command = Colonist.Getui_command
function Colonist:Getui_command(...)
	if not mod_EnableMod then
		return ChoOrig_Colonist_Getui_command(self, ...)
	end

	if self.disappeared and IsKindOf(self.holder, "RocketBase") then
		return T(4321--[[On an expedition]])
	end

	return ChoOrig_Colonist_Getui_command(self, ...)
end

--
-- Gale crater name doesn't show up for 4S138E, 5S138E
local ChoOrig_LandingSiteObject_ResolveSpotName = LandingSiteObject.ResolveSpotName
function LandingSiteObject:ResolveSpotName(...)
	if not mod_EnableMod or self.challenge_mode then
		return ChoOrig_LandingSiteObject_ResolveSpotName(self, ...)
	end

	local p = self.map_params
	if (p.latitude == 5 or p.latitude == 4) and p.longitude == 138 then
		return MarsLocales[17]
	end

	return ChoOrig_LandingSiteObject_ResolveSpotName(self, ...)
end

--
-- Pins Missing Some Status Icons
local ChoOrig_PinsDlg_GetPinConditionImage = PinsDlg.GetPinConditionImage
function PinsDlg:GetPinConditionImage(obj, ...)
	if not mod_EnableMod then
		return ChoOrig_PinsDlg_GetPinConditionImage(self, obj, ...)
	end

	local img = ChoOrig_PinsDlg_GetPinConditionImage(self, obj, ...)

	if not img and obj:IsKindOf("BaseRover")
		and obj.command == "TransferResources"
	then
		if obj.fx == "Unload" then
			img = "UI/Icons/pin_unload.tga"
		elseif obj.fx == "Load" then
			img = "UI/Icons/pin_load.tga"
		end
	end

	return img
end

--
-- Remove log spam (SetScale doesn't like anything below 0 and above 2047)
local ChoOrig_g_CObjectFuncs_SetScale = g_CObjectFuncs.SetScale
function g_CObjectFuncs:SetScale(scale, ...)
	if not mod_EnableMod then
		return ChoOrig_g_CObjectFuncs_SetScale(self, scale, ...)
	end

	if scale < 0 then
		scale = 0
	elseif scale > 2047 then
		scale = 2047
	end

	return ChoOrig_g_CObjectFuncs_SetScale(self, scale, ...)
end

--
-- Modded sponsor using DLC user doesn't have results in black screen in new game second screen
local ChoOrig_GetRocketClass = GetRocketClass
function GetRocketClass(...)
	if not mod_EnableMod then
		return ChoOrig_GetRocketClass(...)
	end

	local rocket_class = GetMissionSponsor().rocket_class or "SupplyRocket"
	-- Check with what PlacePlanetRocket(rocket_class) uses
	if rocket_class ~= "SupplyRocket" and not BuildingTemplates[rocket_class] then
		return "SupplyRocket"
	end

	return rocket_class
end

--
-- Some deposit mod causing log spam from a deleted? concrete deposit
local ChoOrig_TerrainDepositExtractor_OnDepositDepleted = TerrainDepositExtractor.OnDepositDepleted
function TerrainDepositExtractor:OnDepositDepleted(...)
	if not mod_EnableMod then
		return ChoOrig_TerrainDepositExtractor_OnDepositDepleted(self, ...)
	end

	if IsValid(self:GetDeposit()) then
		return ChoOrig_TerrainDepositExtractor_OnDepositDepleted(self, ...)
	end

	-- Might as well set this (from OnDepositDepleted())
	self.depleted = true
end

--
-- Some storybits will show a notification, but the dialog box won't popup (the notif will just disappear)
-- The rockets already left (and aren't valid) by the time this is called.
-- The Door To Summer: Let No Noble Deed/Sleepers Have Awaken
local ChoOrig_StoryBitState_OnStartRunning = StoryBitState.OnStartRunning
function StoryBitState:OnStartRunning(...)
	if not mod_EnableMod then
		return ChoOrig_StoryBitState_OnStartRunning(self, ...)
	end

	if self.id == "TheDoorToSummer_SleepersHaveAwaken"
		or self.id == "TheDoorToSummer_LetNoNobleDeed"
	then
		self.object = false
		-- just in case (has the same issue)
		local sleepers = g_StoryBitStates.TheDoorToSummer_SleepersHaveAwaken
		if sleepers then
			sleepers.object = false
		end
	end

	return ChoOrig_StoryBitState_OnStartRunning(self, ...)
end

--
-- A modded trait without an id?
local ChoOrig_IsTraitAvailable = IsTraitAvailable
function IsTraitAvailable(trait, ...)
	if not mod_EnableMod then
		return ChoOrig_IsTraitAvailable(trait, ...)
	end

	if trait then
		local trait_type = type(trait)
		if trait_type == "string" or trait_type == "table" then
			return ChoOrig_IsTraitAvailable(trait, ...)
		end
	end
end

--
-- When testing an unrelated mod with no dlc enabled, I noticed an error in the log
local ChoOrig_GetCurrentLightModel = GetCurrentLightModel
function GetCurrentLightModel(...)
	if not mod_EnableMod then
		return ChoOrig_GetCurrentLightModel(...)
	end

	if type(CurrentLightmodel[ActiveMapID]) == "table" then
		return ChoOrig_GetCurrentLightModel(...)
	end
end

--
-- Storybit Blank Slate doesn't remove any applicants for options 23 (fix 2/2)
DefineClass.ChoGGi_RemoveApplicants = {
	__parents = { "Effect", },
	properties = {
		{ id = "Amount", help = "Set the number of applicants to remove.",
			editor = "number", default = false,
			buttons = { { "Param", "StoryBit_PickParam" } },
		},
	},
	Description = T(0000, "Remove Applicants <Amount>"),
	Documentation = "Remove a specific amount of applicants.",
}
function ChoGGi_RemoveApplicants:Execute(map_id, obj, context)
	-- I doubt it's needed but...
	if type(self.Amount) ~= "number" then
		return
	end

	local pool = g_ApplicantPool
	for _ = 1, self.Amount do
		table.remove(pool, AsyncRand(#pool)+1)
	end
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

--
-- Second fix for Rare Anomaly Analyzed: Mona Lisa
-- SA_ResuppyInventory:Exec() doesn't check the map, it only uses MainCity to spawn prefabs, so I override the prefab spawner.
-- I only cleaned up wrong map prefabs in LoadGame, this'll send them to the correct map when the storybit happens
-- Added any underground buildings, not sure if any other get added as a prefab
local underground_blds = {
	UndergroundDome = true,
	UndergroundDomeMedium = true,
	UndergroundDomeMicro = true,
	LightTripod = true,
	SupportStrut = true,
}
local ChoOrig_City_AddPrefabs = City.AddPrefabs
function City:AddPrefabs(class, ...)
	if not mod_EnableMod then
		return ChoOrig_City_AddPrefabs(self, class, ...)
	end

	if underground_blds[class] then
		return ChoOrig_City_AddPrefabs(Cities[UIColony.underground_map_id], class, ...)
	end

	return ChoOrig_City_AddPrefabs(self, class, ...)
end

--
-- If there's too many cave=in rubble then it'll get laggy when trying to place another one
local ChoOrig_FindCaveInLocation = FindCaveInLocation
function FindCaveInLocation(map_id, ...)
	if not mod_EnableMod then
		return ChoOrig_FindCaveInLocation(map_id, ...)
	end

	-- Max seems to be 483, but that might depend on map and I can't be bothered to check all four (it's like I'm a game dev)
	if GameMaps[map_id].realm:MapCount("map", "CaveInRubble") > 400 then
		return
	end

	return ChoOrig_FindCaveInLocation(map_id, ...)
end
--
-- Why it doesn't check if the cargo resource exists is anyones guess.
-- Seen an error in a log file, no idea what it's from though.
local ChoOrig_Elevator_DeliverResource = Elevator.DeliverResource
function Elevator:DeliverResource(resource, ...)
	if not mod_EnableMod then
		return ChoOrig_Elevator_DeliverResource(self, resource, ...)
	end

	-- This is from the func, it can't hurt to have it happen, and it might hurt not to.
	-- last checked lua rev 1011166
  if not self.other.cargo[resource] then
    self.other.cargo[resource] = {
      class = resource,
      requested = 0,
      amount = 0
    }
  end

	if not self.cargo[resource] then
		return
	end

	return ChoOrig_Elevator_DeliverResource(self, resource, ...)
end

--
-- No flying drones underground
if g_AvailableDlc.gagarin then
	local caller_city_id

	local ChoOrig_GetDroneClass = GetDroneClass
	function GetDroneClass(...)
		if not mod_NoFlyingDronesUnderground then
			return ChoOrig_GetDroneClass(...)
		end
		-- Should be set by City:CreateDrone
		if not caller_city_id then
			caller_city_id = ActiveMapID
		end
		local map = ActiveMaps[caller_city_id]
		caller_city_id = nil

		local environment = map and map.Environment
		if environment and environment == "Underground" then
			return "Drone"
		end

		return ChoOrig_GetDroneClass(...)
	end

	-- this func calls GetDroneClass
	local ChoOrig_City_CreateDrone = City.CreateDrone
	function City:CreateDrone(...)
		caller_city_id = self.map_id
		return ChoOrig_City_CreateDrone(self, ...)
	end
end

--
-- On one underground map, the bottomless pit anomaly is removed:
-- SpawnAnomaly() calls FindUnobstructedDepositPos() which for whatever reason,
-- takes the pos from in front of the wonder and sticks it in the passage behind it... (BlankUnderground_02 map)
local ChoOrig_FindUnobstructedDepositPos = FindUnobstructedDepositPos
function FindUnobstructedDepositPos(marker, ...)
	if not mod_EnableMod then
		return ChoOrig_FindUnobstructedDepositPos(marker, ...)
	end

	-- Make sure it's the right obj/map
	if marker.sequence_list == "BuriedWonder_Bottomless_Pit"
		and GetCity(marker).map_id == "BlankUnderground_02"
	then
		-- Ignore the obstructed bool and DepositMarker:PlaceDeposit() is happy
		local x, y, unobstructed, obstructed = ChoOrig_FindUnobstructedDepositPos(marker, ...)
		return x, y, unobstructed, false
	end
	return ChoOrig_FindUnobstructedDepositPos(marker, ...)
end

--
-- Some mod added a borked spec?
-- [LUA ERROR] attempt to compare nil with number
-- Mars/Lua/CargoRequest.lua(6): global GetCargoColonistSpecializationItems
local ChoOrig_GetCargoColonistSpecializationItems = GetCargoColonistSpecializationItems
function GetCargoColonistSpecializationItems(...)
	if not mod_EnableMod then
		return ChoOrig_GetCargoColonistSpecializationItems(...)
	end

	local specs = const.ColonistSpecialization
	for _, item in pairs(specs) do
		if not item.sort_key then
			-- The usual specs are under 10000, so make whatever it is be at the end (luke's brothel uses 20000 I went bigger)
			item.sort_key = 50000
		end
	end

	return ChoOrig_GetCargoColonistSpecializationItems(...)
end

--
-- Badly modded cargo (or some combination of mods)
-- [LUA ERROR] Mars/Lua/CargoRequest.lua:373: bad argument #1 to 'pairs' (table expected, got boolean)
local ChoOrig_CargoRequest_GetDestinationCargoList = CargoRequest.GetDestinationCargoList
function CargoRequest:GetDestinationCargoList(...)
	if not mod_EnableMod then
		return ChoOrig_CargoRequest_GetDestinationCargoList(self, ...)
	end

	if not self.cargo_items then
		self.cargo_items = {}
	end

	return ChoOrig_CargoRequest_GetDestinationCargoList(self, ...)
end

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
-- last checked lua rev 1011166
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
-- This func is called for each new city (surface/underground/asteroids)
-- Calling it more than once clears the BreakthroughOrder list
-- That list is used to spawn planetary anomalies
local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City:InitBreakThroughAnomalies(...)
	if not mod_EnableMod then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- It can be called normally for the surface map
	if self.map_id == MainMapID then
		return ChoOrig_City_InitBreakThroughAnomalies(self, ...)
	end

	-- Save the list when called for other cities (underground or asteroid)
	local ChoOrig_BreakthroughOrder = BreakthroughOrder

	-- pcall just in case
	pcall(ChoOrig_City_InitBreakThroughAnomalies, self, ...)

	-- and restore it afterwards
	BreakthroughOrder = ChoOrig_BreakthroughOrder
end
--
