-- See LICENSE for terms

-- local some globals
local table = table
local CmpLower = CmpLower
local TranslationTable = TranslationTable

local Translate = ChoGGi.ComFuncs.Translate
local RetName = ChoGGi.ComFuncs.RetName
local RetMapSettings = ChoGGi.ComFuncs.RetMapSettings
local RetMapBreakthroughs = ChoGGi.ComFuncs.RetMapBreakthroughs

local testing = ChoGGi.testing

local function ExportDoneMsg(path)
	local msg = TranslationTable[302535920001449--[[Export]]] .. " " .. TranslationTable[302535920001448--[[CSV]]]
	ChoGGi.ComFuncs.MsgPopup(path, msg)
	print(msg, path)
end

do -- MapData
	local str_RelativelyFlat = TranslationTable[4154--[[Relatively Flat]]]
	local str_Rough = TranslationTable[4155--[[Rough]]]
	local str_Steep = TranslationTable[4156--[[Steep]]]
	local str_Mountainous = TranslationTable[4157--[[Mountainous]]]

	local MarsLocales = MarsLocales
	local str_MarsLocales = {}
	for idx, T_data in pairs(MarsLocales) do
		str_MarsLocales[idx] = Translate(T_data)
	end

	local GetOverlayValues = GetOverlayValues
	local FillRandomMapProps = FillRandomMapProps
	-- exported data temp stored here
	local export_data = {}
	local export_data_dupes = {}
	local export_count = 0
	-- stores temp landing spot
	local landing
	local north, east, south, west

	local loc_table = {"","","",""}
	local MapData = MapDataPresets
	local temp_g_SelectedSpotChallengeMods = {}

	local function AddLandingSpot(lat, long, breakthroughs, limit_count, skip_csv)
		-- coord names in csv
		local lat_0, long_0 = lat < 0, long < 0
		local lat_name, long_name = lat_0 and north or south, long_0 and west or east

		-- no dupes
		loc_table[1] = lat_name
		loc_table[2] = lat
		loc_table[3] = long_name
		loc_table[4] = long
		local location = table.concat(loc_table)
--~ 		local location = lat_name .. lat .. long_name .. long

		if export_data_dupes[location] then
			return
		end
		export_data_dupes[location] = true

		-- updates map_params to location
		GetOverlayValues(
			lat * 60,
			long * 60,
			landing.overlay_grids,
			landing.map_params
		)

		-- we store all lat/long numbers as pos in csv
		if lat_0 then
			lat = lat - lat * 2
		end
		if long_0 then
			long = long - long * 2
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
			topography =  str_RelativelyFlat
		elseif rating <= 99 then
			topography =  str_Rough
		elseif rating <= 139 then
			topography =  str_Steep
		end

		-- create item in export list
		export_count = export_count + 1
		export_data[export_count] = {
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
			-- last checked prunariu lua rev 1011140
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

		-- none of them have a params.landing_spot, so skip it...
--~ 		-- named location spots
--~ 		if params.landing_spot then
--~ 			data.landing_spot = Translate(params.landing_spot)
--~ 		elseif params.Locales then
--~ 			data.landing_spot = str_MarsLocales[params.Locales]
--~ 		end
		-- named location spots
		if params.Locales then
			data.landing_spot = str_MarsLocales[params.Locales]
		end
	end

	--[[
	ChoGGi.ComFuncs.ExportMapDataToCSV(XAction:new{
		setting_breakthroughs = true,
		setting_skip_csv = true,
		setting_limit_count = 12,
	})
	]]

	function ChoGGi.ComFuncs.ExportMapDataToCSV(action)
		local limit_count, skip_csv, breakthroughs
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

		north, east, south, west = TranslationTable[1000487--[[N]]], TranslationTable[1000478--[[E]]], TranslationTable[1000492--[[S]]], TranslationTable[1000496--[[W]]]

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

--~ ChoGGi.ComFuncs.TickStart("ExportMapDataToCSV")
		-- loop through all the spots, update landing spot and stick in export list
		for lat = 0, 70 do
			for long = 0, 180 do
				-- SE
				AddLandingSpot(lat, long, breakthroughs, limit_count, skip_csv)
				-- skip the rest for speed in testing
				if action.ActionId ~= "" or not testing then
					-- SW
					AddLandingSpot(lat, -long, breakthroughs, limit_count, skip_csv)
					-- NE
					AddLandingSpot(-lat, long, breakthroughs, limit_count, skip_csv)
					-- NW
					AddLandingSpot(-lat, -long, breakthroughs, limit_count, skip_csv)
				end
			end
		end
--~ ChoGGi.ComFuncs.TickEnd("ExportMapDataToCSV")

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
				{"latitude_degree", TranslationTable[6890--[[Latitude]]] .. " " .. TranslationTable[302535920001505--[[°]]]},
				{"latitude", TranslationTable[6890--[[Latitude]]]},
				{"longitude_degree", TranslationTable[6892--[[Longitude]]] .. " " .. TranslationTable[302535920001505--[[°]]]},
				{"longitude", TranslationTable[6892--[[Longitude]]]},
				{"topography", TranslationTable[284813068603--[[Topography]]]},
				{"diff_chall", TranslationTable[774720837511]:gsub(" <percent%(DifficultyBonus%)>", ""):gsub(" <percentage>%%", "")},
				{"altitude", TranslationTable[4135--[[Altitude]]]},
				{"temperature", TranslationTable[4141--[[Temperature]]]},

				{"metals", TranslationTable[3514--[[Metals]]]},
				{"metals_rare", TranslationTable[4139--[[Rare Metals]]]},
				{"concrete", TranslationTable[3513--[[Concrete]]]},
				{"water", TranslationTable[681--[[Water]]]},

				{"dust_devils", TranslationTable[4142--[[Dust Devils]]]},
				{"dust_storms", TranslationTable[4144--[[Dust Storms]]]},
				{"meteors", TranslationTable[4146--[[Meteors]]]},
				{"cold_waves", TranslationTable[4148--[[Cold Waves]]]},

				{"map_name", TranslationTable[302535920001503--[[Map Name]]]},
				{"landing_spot", TranslationTable[302535920001504--[[Named]]] .. " " .. TranslationTable[7396--[[Location]]]},
			}
			if breakthroughs then
				local b_str = TranslationTable[11451--[[Breakthrough]]]
				local c = #csv_columns
--~ 				for i = 1, (const.BreakThroughTechsPerGame + Consts.PlanetaryBreakthroughCount) do
				for i = 1, 12 do
					c = c + 1
					csv_columns[c] = {"break" .. i, b_str .. " " .. i}
				end
			end

	--~ ex(export_data)
			-- and now we can save it to disk
			SaveCSV("AppData/MapData-" .. os.time() .. ".csv", export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
			-- let user know where the csv is
			ExportDoneMsg(ConvertToOSPath("AppData/MapData-" .. os.time() .. ".csv"))
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
		local str = TranslationTable[3720--[[Trait]]]
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

	function ChoGGi.ComFuncs.ExportColonistDataToCSV()
		local csv_columns = {
			{"name", TranslationTable[1000037--[[Name]]]},
			{"age", TranslationTable[302535920001222--[[Age]]]},
			{"age_trait", TranslationTable[302535920001222--[[Age]]] .. " " .. TranslationTable[3720--[[Trait]]]},
			{"death_age", TranslationTable[4284--[[Age of death]]]},
			{"birthplace", TranslationTable[4357--[[Birthplace]]]:gsub("<right><UIBirthplace>", "")},
			{"gender", TranslationTable[4356--[[Sex]]]:gsub("<right><Gender>", "")},
			{"race", TranslationTable[302535920000741--[[Race]]]},
			{"specialist", TranslationTable[240--[[Specialization]]]},
			{"performance", TranslationTable[4283--[[Worker performance]]]},
			{"health", TranslationTable[4291--[[Health]]]},
			{"comfort", TranslationTable[4295--[[Comfort]]]},
			{"morale", TranslationTable[4297--[[Morale]]]},
			{"sanity", TranslationTable[4293--[[Sanity]]]},
			{"handle", TranslationTable[302535920000955--[[Handle]]]},
			{"last_meal", TranslationTable[302535920001229--[[Last Meal]]]},
			{"last_rest", TranslationTable[302535920001235--[[Last Rest]]]},
			{"dome_name", TranslationTable[1234--[[Dome]]] .. " " .. TranslationTable[1000037--[[Name]]]},
			{"dome_pos", TranslationTable[1234--[[Dome]]] .. " " .. TranslationTable[302535920000461--[[Position]]]},
			{"dome_handle", TranslationTable[1234--[[Dome]]] .. " " .. TranslationTable[302535920000955--[[Handle]]]},
			{"residence_name", TranslationTable[4809--[[Residence]]] .. " " .. TranslationTable[1000037--[[Name]]]},
			{"residence_pos", TranslationTable[4809--[[Residence]]] .. " " .. TranslationTable[302535920000461--[[Position]]]},
			{"residence_dome", TranslationTable[4809--[[Residence]]] .. " " .. TranslationTable[1234--[[Dome]]]},
			{"workplace_name", TranslationTable[4801--[[Workplace]]] .. " " .. TranslationTable[1000037--[[Name]]]},
			{"workplace_pos", TranslationTable[4801--[[Workplace]]] .. " " .. TranslationTable[302535920000461--[[Position]]]},
			{"workplace_dome", TranslationTable[4801--[[Workplace]]] .. " " .. TranslationTable[1234--[[Dome]]]},
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
		local colonists = UICity.labels.Colonist or ""

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

	function ChoGGi.ComFuncs.ExportGraphsToCSV()
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
				name = TranslationTable[547--[[Colonists]]] .. " " .. TranslationTable[1000100--[[Amount]]],
				data = "ts_colonists",
			},
			Unemployed = {
				name = TranslationTable[547--[[Colonists]]] .. " " .. TranslationTable[6859--[[Unemployed]]],
				data = "ts_colonists_unemployed",
			},
			Homeless = {
				name = TranslationTable[547--[[Colonists]]] .. " " .. TranslationTable[7553--[[Homeless]]],
				data = "ts_colonists_homeless",
			},
			Drone = {
				name = TranslationTable[517--[[Drones]]],
				data = "ts_drones",
			},
		}
		local loop_table_count1 = {
			{
				name = TranslationTable[745--[[Shuttles]]],
				func = "CountShuttles",
				data = "ts_shuttles",
			},
			{
				name = TranslationTable[3980--[[Buildings]]],
				func = "CountBuildings",
				data = "ts_buildings",
			},
		}
		local loop_table_count2 = {
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[79--[[Power]]] .. " " .. TranslationTable[302535920001457--[[Stored]]],
				func = "GetTotalStoredPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "stored",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[32--[[Power Production]]],
				func = "GetTotalProducedPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "production",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[683--[[Power Consumption]]],
				func = "GetTotalRequiredPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "consumption",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[682--[[Oxygen]]] .. " " .. TranslationTable[302535920001457--[[Stored]]],
				func = "GetTotalStoredAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "stored",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[923--[[Oxygen Production]]],
				func = "GetTotalProducedAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "production",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[657--[[Oxygen Consumption]]],
				func = "GetTotalRequiredAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "consumption",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[681--[[Water]]] .. " " .. TranslationTable[302535920001457--[[Stored]]],
				func = "GetTotalStoredWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "stored",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[4806--[[Water Production]]],
				func = "GetTotalProducedWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "production",
			},
			{
				name = TranslationTable[302535920000035--[[Grids]]] .. " " .. TranslationTable[750--[[Water Consumption]]],
				func = "GetTotalRequiredWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "consumption",
			},
		}
		local UICity = UICity
		local labels = UICity.labels
		local ResourceOverviewCity = g_ResourceOverviewCity[UICity.map_id]

		-- the rest are sols
		local csv_columns = {
			{"category", TranslationTable[1000097--[[Category]]]},
			{"current", TranslationTable[302535920000106--[[Current]]] .. " " .. TranslationTable[4031--[[Sol <day>]]]:gsub(" <day>", "")},
		}
		local c = #csv_columns

		-- add all the sols as columns
		local sol_str = TranslationTable[4031--[[Sol <day>]]]
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
				TranslationTable[692--[[Resources]]] .. " " .. name .. " " .. TranslationTable[302535920001454--[[Stockpiled]]],
				ResourceOverviewCity["GetAvailable" .. id](ResourceOverviewCity),
				res.stockpile
			)
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				TranslationTable[692--[[Resources]]] .. " " .. name .. " " .. TranslationTable[302535920001455--[[Produced]]],
				ResourceOverviewCity["Get" .. id .. "ProducedYesterday"](ResourceOverviewCity),
				res.produced
			)
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				TranslationTable[692--[[Resources]]] .. " " .. name .. " " .. TranslationTable[302535920001456--[[Consumed]]],
				ResourceOverviewCity["Get" .. id .. "ConsumedByConsumptionYesterday"](ResourceOverviewCity),
				res.consumed
			)
		end

		-- the one entry that needs to count two labels
		c = c + 1
		export_data = BuildTable(
			export_data,
			c,
			TranslationTable[5426--[[Building]]] .. " " .. TranslationTable[302535920000971--[[Sites]]] .. " " .. TranslationTable[302535920001453--[[Completed]]],
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
