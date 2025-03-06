-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

-- local some globals
local ChoGGi_Funcs = ChoGGi_Funcs
local table = table
local table_remove = table.remove
local CmpLower = CmpLower

local Translate = ChoGGi_Funcs.Common.Translate
local RetName = ChoGGi_Funcs.Common.RetName
local RetMapSettings = ChoGGi_Funcs.Common.RetMapSettings
local RetMapBreakthroughs = ChoGGi_Funcs.Common.RetMapBreakthroughs

local testing = ChoGGi.testing
if testing then
end

local function ExportDoneMsg(path)
	local msg = Translate(302535920001449--[[Export]]) .. " " .. Translate(302535920001448--[[CSV]])
	ChoGGi_Funcs.Common.MsgPopup(path, msg)
	print(Translate(msg), path)
end

do -- MapData
	local str_RelativelyFlat = Translate(4154--[[Relatively Flat]])
	local str_Rough = Translate(4155--[[Rough]])
	local str_Steep = Translate(4156--[[Steep]])
	local str_Mountainous = Translate(4157--[[Mountainous]])

	local MarsLocales = MarsLocales
	local str_MarsLocales = {}
	for idx, T_data in pairs(MarsLocales) do
		str_MarsLocales[idx] = Translate(T_data)
	end

	local GetOverlayValues = GetOverlayValues
	local FillRandomMapProps = FillRandomMapProps
	-- exported data temp stored here
	local export_data = {}
	local export_count = 0
	local export_data_dupes = {}
	-- Stores temp landing spot
	local landing
	-- If I translate these, then I get issues in not English when using Find Map Locations.
	-- I could do an if, but best keep it simple for whatever speed I can get
	local north, east, south, west = "N", "E", "S", "W"

	local MapData = ChoGGi.is_gp and MapData or MapDataPresets
	local temp_g_SelectedSpotChallengeMods = {}

	local limit_count = 13
	local skip_csv = false
	local breakthroughs = false
	local bb_dlc_skip = false

	local function AddLandingSpot(lat, long)
		-- coord names in csv
		local lat_neg, long_neg = lat < 0, long < 0
		local lat_name, long_name = lat_neg and north or south, long_neg and west or east

		-- no dupes
		local location_user = lat .. lat_name .. long .. long_name

		if export_data_dupes[location_user] then
			return
		end
		export_data_dupes[location_user] = true

		-- updates map_params to location
		GetOverlayValues(
			lat * 60,
			long * 60,
			landing.overlay_grids,
			landing.map_params
		)

		-- we store all lat/long numbers as positive in csv
		if lat_neg then
			lat = -lat
		end
		if long_neg then
			long = -long
		end

		-- updates threat/res map info
		landing:RecalcThreatAndResourceLevels()

		local map_name, gen, params
		if breakthroughs then
			map_name, params, gen = RetMapSettings(true, landing.map_params)
		else
			map_name = FillRandomMapProps(nil, params)
			params = landing.map_params
		end

		local threat = landing.threat_resource_levels
		local mapdata = MapData[map_name]

		local topography
		local rating = mapdata and mapdata.challenge_rating or 0
		if rating <= 59 then
			topography = str_RelativelyFlat
		elseif rating <= 99 then
			topography = str_Rough
		elseif rating <= 139 then
			topography = str_Steep
		end

		-- create item in export list
		export_count = export_count + 1
		export_data[export_count] = {
			coordinates = lat .. lat_name .. long .. long_name,
			seed = params.seed,
			latitude = lat_name,
			latitude_degree = lat,
			longitude = long_name,
			longitude_degree = long,

			topography = topography or str_Mountainous,
			diff_chall = g_TitleObj:GetDifficultyBonus(),
			altitude = params.Altitude,
			temperature = params.Temperature,

			metals = threat.Metals,
--~ 			metals_rare = threat.PreciousMetals,
			-- last checked 1011140
			metals_rare = threat.Metals,
			concrete = threat.Concrete,
			water = threat.Water,
			dust_devils = threat.DustDevils,
			dust_storms = threat.DustStorm,
			meteors = threat.Meteor,
			cold_waves = threat.ColdWave,

			map_name = map_name,
		}
		local data = export_data[export_count]

		if breakthroughs then
			local tech_list = RetMapBreakthroughs(gen, limit_count)

			-- remove first four
			if bb_dlc_skip then
				for _ = 1, 4 do
					table_remove(tech_list, 1)
				end
			end

			if skip_csv then
				for i = 1, #tech_list do
					data[i] = tech_list[i]
				end
			else
				for i = 1, #tech_list do
					data["break" .. i] = tech_list[i]
				end
			end
		end

		-- named location spots
		if params.Locales then
			data.landing_spot = str_MarsLocales[params.Locales]
		end
	end

	--[[

ChoGGi_Funcs.Common.ExportMapDataToCSV(XAction:new{
	setting_breakthroughs = true,
	setting_skip_csv = false,
	setting_limit_count = 6,
})

	]]

	function ChoGGi_Funcs.Common.ExportMapDataToCSV(action)
		-- fired from action menu
		if action and IsKindOf(action, "XAction") then
			if action.setting_breakthroughs then
				breakthroughs = true
			end
			if action.setting_limit_count then
				limit_count = action.setting_limit_count
			end
			if action.setting_skip_csv then
				skip_csv = action.setting_skip_csv
			end

		end

		-- Remove first four if bb dlc and my fix bugs mod not enabled
		if skip_csv then
			local fix_bugs = table.find(ModsLoaded, "id", "ChoGGi_FixBBBugs")
			local ava_bb_dlc = g_AvailableDlc.picard
			bb_dlc_skip = ava_bb_dlc and not fix_bugs
			if bb_dlc_skip then
				print("ExportMapDataToCSV: B&B DLC detected and Fix Bugs mod not loaded: Skipping first four breakthroughs!")
			end
		end

		-- save current g_CurrentMapParams to restore later
		local params = g_CurrentMapParams
		local params_saved = table.copy(params)

		-- g_TitleObj used for getting map topo
		local not_title
		if not g_TitleObj then
			PGTitleObjectCreate()
			not_title = true
		end

		-- make a fake landing spot
		landing = LandingSiteObject:new()
		-- add fake grid info
		landing.overlay_grids = {}
		landing:LoadOverlayGrids()

		-- exported data temp stored here
		table.iclear(export_data)
		export_count = 0
		table.clear(export_data_dupes)

		-- needed for RecalcThreatResourceLevels func
		local ChoOrig_GameState = GameState.gameplay
		GameState.gameplay = false
		local ChoOrig_spotchall = g_SelectedSpotChallengeMods
		table.clear(temp_g_SelectedSpotChallengeMods)
		g_SelectedSpotChallengeMods = temp_g_SelectedSpotChallengeMods

--~ ChoGGi_Funcs.Common.TickStart("ExportMapDataToCSV")
		-- loop through all the spots, update landing spot and stick in export list
		for lat = 0, 70 do
			for long = 0, 180 do
				-- SE
				AddLandingSpot(lat, long)
				-- SW
				AddLandingSpot(lat, -long)
				-- NE
				AddLandingSpot(-lat, long)
				-- NW
				AddLandingSpot(-lat, -long)
			end
		end
--~ ChoGGi_Funcs.Common.TickEnd("ExportMapDataToCSV")

		-- not needed anymore so restore back to orig
		GameState.gameplay = ChoOrig_GameState
		g_SelectedSpotChallengeMods = ChoOrig_spotchall

		-- remove landing spot obj (not needed anymore)
		landing:delete()
		-- and title obj
		if g_TitleObj and not_title then
			g_TitleObj:delete()
			g_TitleObj = false
		end
		-- restore saved map params (just in case anything uses the values)
		for key, value in pairs(params_saved) do
			params[key] = value
		end

		if skip_csv then
			return export_data
		else
			local csv_columns = {
				{"coordinates", Translate(11457--[[Coordinates]])},
				{"latitude_degree", Translate(6890--[[Latitude]]) .. " " .. Translate(302535920001505--[[°]])},
				{"latitude", Translate(6890--[[Latitude]])},
				{"longitude_degree", Translate(6892--[[Longitude]]) .. " " .. Translate(302535920001505--[[°]])},
				{"longitude", Translate(6892--[[Longitude]])},
				{"topography", Translate(284813068603--[[Topography]])},
				{"diff_chall", Translate(774720837511):gsub(" <percent%(DifficultyBonus%)>", ""):gsub(" <percentage>%%", "")},
				{"altitude", Translate(4135--[[Altitude]])},
				{"temperature", Translate(4141--[[Temperature]])},

				{"metals", Translate(3514--[[Metals]])},
				{"metals_rare", Translate(4139--[[Rare Metals]])},
				{"concrete", Translate(3513--[[Concrete]])},
				{"water", Translate(681--[[Water]])},

				{"dust_devils", Translate(4142--[[Dust Devils]])},
				{"dust_storms", Translate(4144--[[Dust Storms]])},
				{"meteors", Translate(4146--[[Meteors]])},
				{"cold_waves", Translate(4148--[[Cold Waves]])},

				{"map_name", Translate(302535920001503--[[Map Name]])},
				{"landing_spot", Translate(302535920001504--[[Named]]) .. " " .. Translate(7396--[[Location]])},
			}
			if breakthroughs then
				local b_str = Translate(11451--[[Breakthrough]])
				local c = #csv_columns
				for i = 1, limit_count do
					c = c + 1
					csv_columns[c] = {"break" .. i, b_str .. " " .. i}
				end
			end

			-- Use DLCs in exported filename
			local dlc = g_AvailableDlc
			local name = "MapData "
			if breakthroughs then
				name = "MapData Breakthroughs "
				if dlc.armstrong and dlc.picard then
					name = "MapData Breakthroughs GP BB "
				elseif dlc.armstrong then
					name = "MapData Breakthroughs GP "
				elseif dlc.picard then
					name = "MapData Breakthroughs BB "
				end
			end
			name = "AppData/" .. name .. os.time() .. ".csv"

	--~ ex(export_data)
			-- and now we can save it to disk
			SaveCSV(name, export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
			-- let user know where the csv is
			ExportDoneMsg(ConvertToOSPath(name))
		end
	end
end --do

do -- ColonistData
	-- build list of traits to skip (added as columns, we don't want dupes)
	local function AddSkipped(traits, list)
		for i = 1, #traits do
			list[traits[i]] = true
		end
		return list
	end

	local function AddTraits(traits, list)
		local str = Translate(3720--[[Trait]])
		local c = #list
		for i = 1, #traits do
			local trait = traits[i]
			c = c + 1
			list[c] = {
				"trait_" .. trait,
				str .. " " .. trait,
			}
		end
		return list
	end

	function ChoGGi_Funcs.Common.ExportColonistDataToCSV()
		local csv_columns = {
			{"name", Translate(1000037--[[Name]])},
			{"age", Translate(302535920001222--[[Age]])},
			{"age_trait", Translate(302535920001222--[[Age]]) .. " " .. Translate(3720--[[Trait]])},
			{"death_age", Translate(4284--[[Age of death]])},
			{"birthplace", Translate(4357--[[Birthplace]]):gsub("<right><UIBirthplace>", "")},
			{"gender", Translate(4356--[[Sex]]):gsub("<right><Gender>", "")},
			{"race", Translate(302535920000741--[[Race]])},
			{"specialist", Translate(240--[[Specialization]])},
			{"performance", Translate(4283--[[Worker performance]])},
			{"health", Translate(4291--[[Health]])},
			{"comfort", Translate(4295--[[Comfort]])},
			{"morale", Translate(4297--[[Morale]])},
			{"sanity", Translate(4293--[[Sanity]])},
			{"handle", Translate(302535920000955--[[Handle]])},
			{"last_meal", Translate(302535920001229--[[Last Meal]])},
			{"last_rest", Translate(302535920001235--[[Last Rest]])},
			{"dome_name", Translate(1234--[[Dome]]) .. " " .. Translate(1000037--[[Name]])},
			{"dome_pos", Translate(1234--[[Dome]]) .. " " .. Translate(302535920000461--[[Position]])},
			{"dome_handle", Translate(1234--[[Dome]]) .. " " .. Translate(302535920000955--[[Handle]])},
			{"residence_name", Translate(4809--[[Residence]]) .. " " .. Translate(1000037--[[Name]])},
			{"residence_pos", Translate(4809--[[Residence]]) .. " " .. Translate(302535920000461--[[Position]])},
			{"residence_dome", Translate(4809--[[Residence]]) .. " " .. Translate(1234--[[Dome]])},
			{"workplace_name", Translate(4801--[[Workplace]]) .. " " .. Translate(1000037--[[Name]])},
			{"workplace_pos", Translate(4801--[[Workplace]]) .. " " .. Translate(302535920000461--[[Position]])},
			{"workplace_dome", Translate(4801--[[Workplace]]) .. " " .. Translate(1234--[[Dome]])},
		}
		local t = ChoGGi.Tables
		csv_columns = AddTraits(t.NegativeTraits, csv_columns)
		csv_columns = AddTraits(t.PositiveTraits, csv_columns)
		csv_columns = AddTraits(t.OtherTraits, csv_columns)
		-- we need to make sure these are added (but only once)
		local skipped_traits = {}
		skipped_traits = AddSkipped(t.ColonistAges, skipped_traits)
		skipped_traits = AddSkipped(t.ColonistGenders, skipped_traits)
		skipped_traits = AddSkipped(t.ColonistSpecializations, skipped_traits)

		local export_data = {}
--~ 		local colonists = UICity.labels.Colonist or ""
		local colonists = UIColony:GetCityLabels("Colonist")

		for i = 1, #colonists do
			local c = colonists[i]

			export_data[i] = {
				name = RetName(c),
				age = c.age,
				age_trait = c.age_trait,
				birthplace = c.birthplace,
				gender = c.gender,
				death_age = c.death_age,
				race = c.race,
				health = c.stat_health,
				comfort = c.stat_comfort,
				morale = c.stat_morale,
				sanity = c.stat_sanity,
				performance = c.performance,
				handle = c.handle,
				specialist = c.specialist,
				last_meal = c.last_meal,
				last_rest = c.last_rest,
			}
			-- dome
			if c.dome then
				export_data[i].dome_name = RetName(c.dome)
				export_data[i].dome_pos = c.dome:GetVisualPos()
				export_data[i].dome_handle = c.dome.handle
			end
			-- residence
			if c.residence then
				export_data[i].residence_name = RetName(c.residence)
				export_data[i].residence_pos = c.residence:GetVisualPos()
				export_data[i].residence_dome = RetName(c.residence.parent_dome)
			end
			-- workplace
			if c.workplace then
				export_data[i].workplace_name = RetName(c.workplace)
				export_data[i].workplace_pos = c.workplace:GetVisualPos()
				export_data[i].workplace_dome = RetName(c.workplace.parent_dome)
			end
			-- traits
			for trait_id in pairs(c.traits) do
				if trait_id and trait_id ~= "" and not skipped_traits[trait_id] then
					export_data[i]["trait_" .. trait_id] = true
				end
			end
		end

		table.sort(export_data, function(a, b)
			return CmpLower(a.name, b.name)
		end)

--~ ex(export_data)
		-- and now we can save it to disk
		SaveCSV("AppData/Colonists-" .. os.time() .. ".csv", export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
		ExportDoneMsg(ConvertToOSPath("AppData/Colonists-" .. os.time() .. ".csv"))
	end
end -- do

do -- Graphs
	local Resources = Resources
	local StockpileResourceList = StockpileResourceList

	local function BuildTable(export_data, c, cat, current, list)
		export_data[c] = {
			category = cat,
			current = current,
		}
		-- add all sol counts
		local data = list.data
		for i = 1, #data do
			-- last recorded sol
			if i > list.next_index then
				break
			end
			export_data[c]["sol" .. i] = data[i]
		end
		return export_data
	end

	function ChoGGi_Funcs.Common.ExportGraphsToCSV()
		local res_list = {}
		for i = 1, #StockpileResourceList do
			local id = StockpileResourceList[i]
			res_list[i] = {
				id = id,
				name = Translate(Resources[id].display_name),
			}
		end
		local loop_table_label = {
			Colonist = {
				name = Translate(547--[[Colonists]]) .. " " .. Translate(1000100--[[Amount]]),
				data = "ts_colonists",
			},
			Unemployed = {
				name = Translate(547--[[Colonists]]) .. " " .. Translate(6859--[[Unemployed]]),
				data = "ts_colonists_unemployed",
			},
			Homeless = {
				name = Translate(547--[[Colonists]]) .. " " .. Translate(7553--[[Homeless]]),
				data = "ts_colonists_homeless",
			},
			Drone = {
				name = Translate(517--[[Drones]]),
				data = "ts_drones",
			},
		}
		local loop_table_count1 = {
			{
				name = Translate(745--[[Shuttles]]),
				func = "CountShuttles",
				data = "ts_shuttles",
			},
			{
				name = Translate(3980--[[Buildings]]),
				func = "CountBuildings",
				data = "ts_buildings",
			},
		}
		local loop_table_count2 = {
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(79--[[Power]]) .. " " .. Translate(302535920001457--[[Stored]]),
				func = "GetTotalStoredPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "stored",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(32--[[Power Production]]),
				func = "GetTotalProducedPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "production",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(683--[[Power Consumption]]),
				func = "GetTotalRequiredPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "consumption",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(682--[[Oxygen]]) .. " " .. Translate(302535920001457--[[Stored]]),
				func = "GetTotalStoredAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "stored",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(923--[[Oxygen Production]]),
				func = "GetTotalProducedAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "production",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(657--[[Oxygen Consumption]]),
				func = "GetTotalRequiredAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "consumption",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(681--[[Water]]) .. " " .. Translate(302535920001457--[[Stored]]),
				func = "GetTotalStoredWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "stored",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(4806--[[Water Production]]),
				func = "GetTotalProducedWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "production",
			},
			{
				name = Translate(302535920000035--[[Grids]]) .. " " .. Translate(750--[[Water Consumption]]),
				func = "GetTotalRequiredWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "consumption",
			},
		}
		local UICity = UICity
		local labels = UICity.labels
		local ResourceOverviewCity = g_ResourceOverviewCity[ActiveMapID]

		-- the rest are sols
		local csv_columns = {
			{"category", Translate(1000097--[[Category]])},
			{"current", Translate(302535920000106--[[Current]]) .. " " .. Translate(4031--[[Sol <day>]]):gsub(" <day>", "")},
		}
		local c = #csv_columns

		-- add all the sols as columns
		local sol_str = Translate(4031--[[Sol <day>]])
		for i = 1, (UIColony.day - 1) do
			c = c + 1
			csv_columns[c] = {
				"sol" .. i,
				sol_str:gsub("<day>", i)
			}
		end

		local export_data = {}
		c = 0

		-- build csv lists
		for label, list in pairs(loop_table_label) do
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				list.name,
				#(labels[label] or ""),
				UICity[list.data]
			)
		end

		for i = 1, #loop_table_count1 do
			local list = loop_table_count1[i]
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				list.name,
				UICity[list.func](UICity),
				UICity[list.data]
			)
		end

		for i = 1, #loop_table_count2 do
			local list = loop_table_count2[i]
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				list.name,
				ResourceOverviewCity[list.func](ResourceOverviewCity),
				UICity[list.data1][list.data2][list.data3]
			)
		end
		-- resources
		for i = 1, #res_list do
			local res = res_list[i]
			local id = res.id
			local name = res.name
			res = UICity.ts_resources[id]

			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				Translate(692--[[Resources]]) .. " " .. name .. " " .. Translate(302535920001454--[[Stockpiled]]),
				ResourceOverviewCity["GetAvailable" .. id](ResourceOverviewCity),
				res.stockpile
			)
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				Translate(692--[[Resources]]) .. " " .. name .. " " .. Translate(302535920001455--[[Produced]]),
				ResourceOverviewCity["Get" .. id .. "ProducedYesterday"](ResourceOverviewCity),
				res.produced
			)
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				Translate(692--[[Resources]]) .. " " .. name .. " " .. Translate(302535920001456--[[Consumed]]),
				ResourceOverviewCity["Get" .. id .. "ConsumedByConsumptionYesterday"](ResourceOverviewCity),
				res.consumed
			)
		end

		-- the one entry that needs to count two labels
		c = c + 1
		export_data = BuildTable(
			export_data,
			c,
			Translate(302535920001712--[[Building]]) .. " " .. Translate(302535920000971--[[Sites]]) .. " " .. Translate(302535920001453--[[Completed]]),
			#(labels.ConstructionSite or "") + #(labels.ConstructionSiteWithHeightSurfaces or ""),
			UICity.ts_constructions_completed
		)

		table.sort(export_data, function(a, b)
			return CmpLower(a.category, b.category)
		end)

--~ ex(export_data)
--~ ex(csv_columns)
		-- and now we can save it to disk
		SaveCSV("AppData/Graphs-" .. os.time() .. ".csv", export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
		ExportDoneMsg(ConvertToOSPath("AppData/Graphs-" .. os.time() .. ".csv"))
	end
end -- do
