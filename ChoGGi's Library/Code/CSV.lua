-- See LICENSE for terms

-- local some globals
local table = table
local CmpLower = CmpLower

local S = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName
local Trans = ChoGGi.ComFuncs.Translate

local function ExportDoneMsg(path)
	ChoGGi.ComFuncs.MsgPopup(path,S[302535920001449--[[Export--]]] .. " " .. S[302535920001448--[[CSV--]]])
	print(path)
end

do -- MapData
	local function MapChallengeRatingToDifficulty(rating)
		if rating <= 59 then
			return 4154 -- Relatively Flat
		elseif rating <= 99 then
			return 4155 -- Rough
		elseif rating <= 139 then
			return 4156 -- Steep
		else
			return 4157 -- Mountainous
		end
	end
	local TGetID = TGetID
	local GetOverlayValues = GetOverlayValues
	local FillRandomMapProps = FillRandomMapProps
	-- exported data temp stored here
	local export_data = objlist:new()
	-- it's an index based table
	local export_count = 0
	-- stores temp landing spot
	local landing

	local MapData = MapData
	local MarsLocales = MarsLocales
	local function AddLandingSpot(lat,long)
		-- updates map_params to location
		GetOverlayValues(
			lat * 60,
			long * 60,
			landing.overlay_grids,
			landing.map_params
		)
		-- updates threat/res map info
		landing:RecalcThreatResourceLevels()
		-- coord names in csv
		local lat_name,long_name = Trans(6886--[[S--]]),Trans(6888--[[E--]])
		-- we store all lat/long numbers as pos in csv
		if lat < 0 then
			lat_name = Trans(6887--[[N--]])
			lat = lat - lat * 2
		end
		if long < 0 then
			long_name = Trans(6889--[[W--]])
			long = long - long * 2
		end

		local params = landing.map_params
		local threat = landing.threat_resource_levels

		local map_name = FillRandomMapProps(nil,params)
		local mapdata = MapData[map_name]
		-- create item in export list
		export_count = export_count + 1
		export_data[export_count] = {
			latitude = lat_name,
			latitude_degree = lat,
			longitude = long_name,
			longitude_degree = long,

			topography = S[MapChallengeRatingToDifficulty(mapdata and mapdata.challenge_rating or 0)],
			diff_chall = g_TitleObj:GetDifficultyBonus(),
			altitude = params.Altitude,
			temperature = params.Temperature,

			metals = threat.Metals,
			metals_rare = threat.PreciousMetals,
			concrete = threat.Concrete,
			water = threat.Water,
			dust_devils = threat.DustDevils,
			dust_storms = threat.DustStorm,
			meteors = threat.Meteor,
			cold_waves = threat.ColdWave,

			map_name = map_name,
		}
		-- named location spots
		local spot_name = params.landing_spot or MarsLocales[params.Locales]
		if spot_name then
			export_data[export_count].landing_spot = S[TGetID(spot_name)]
		end
	end

	function ChoGGi.ComFuncs.ExportMapDataToCSV()
		-- save current g_CurrentMapParams to restore later
		local params = g_CurrentMapParams
		local params_saved = table.copy(params)

		-- g_TitleObj used for getting map topo
		if not g_TitleObj then
			PGTitleObjectCreate()
		end

		-- make a fake landing spot
		landing = LandingSiteObject:new()
		-- add fake grid info
		landing.overlay_grids = {}
		landing:LoadOverlayGrids()

		-- exported data temp stored here
		export_data:Clear()
		export_count = 0

--~ ChoGGi.ComFuncs.TickStart("ExportMapDataToCSV")

		-- needed for RecalcThreatResourceLevels func
		local orig_GameState = GameState.gameplay
		GameState.gameplay = false
		local orig_spotchall = g_SelectedSpotChallengeMods
		g_SelectedSpotChallengeMods = {}

		-- loop through all the spots, update landing spot and stick in export list
		for lat = 0, 70 do
			for long = 0, 180 do
				-- SE
				AddLandingSpot(lat,long)
				-- SW
				AddLandingSpot(lat,long * -1)
				-- NE
				AddLandingSpot(lat * -1,long)
				-- NW
				AddLandingSpot(lat * -1,long * -1)
			end
		end
		-- not needed anymore so restore back to orig
		GameState.gameplay = orig_GameState
		g_SelectedSpotChallengeMods = orig_spotchall

--~ ChoGGi.ComFuncs.TickEnd("ExportMapDataToCSV")

		-- remove landing spot obj (not needed anymore)
		landing:delete()
		-- and title obj
		if g_TitleObj then
			g_TitleObj:delete()
			g_TitleObj = false
		end
		-- restore saved map params (just in case anything uses the values)
		for key,value in pairs(params_saved) do
			params[key] = value
		end

		local csv_columns = {
			{"latitude_degree",Trans(6890--[[Latitude--]]) .. " " .. S[302535920001505--[[°--]]]},
			{"latitude",Trans(6890--[[Latitude--]])},
			{"longitude_degree",Trans(6892--[[Longitude--]]) .. " " .. S[302535920001505--[[°--]]]},
			{"longitude",Trans(6892--[[Longitude--]])},
			{"topography",Trans(284813068603--[[Topography--]])},
			{"diff_chall",Trans(774720837511--[[Difficulty Challenge --]]):gsub("<percent%(DifficultyBonus%)>","")},
			{"altitude",Trans(4135--[[Altitude--]])},
			{"temperature",Trans(4141--[[Temperature--]])},

			{"metals",Trans(3514--[[Metals--]])},
			{"metals_rare",Trans(4139--[[Rare Metals--]])},
			{"concrete",Trans(3513--[[Concrete--]])},
			{"water",Trans(681--[[Water--]])},

			{"dust_devils",Trans(4142--[[Dust Devils--]])},
			{"dust_storms",Trans(4144--[[Dust Storms--]])},
			{"meteors",Trans(4146--[[Meteors--]])},
			{"cold_waves",Trans(4148--[[Cold Waves--]])},

			{"map_name",S[302535920001503--[[Map Name--]]]},
			{"landing_spot",S[302535920001504--[[Named--]]] .. " " .. Trans(7396--[[Location--]])},
		}
--~ ex(export_data)
		-- and now we can save it to disk
		SaveCSV("AppData/MapData.csv", export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
		-- let user know where the csv is
		ExportDoneMsg(ConvertToOSPath("AppData/MapData.csv"))
	end
end --do

do -- ColonistData
	-- build list of traits to skip (added as columns, we don't want dupes)
	local function AddSkipped(traits,list)
		for i = 1, #traits do
			list[traits[i]] = true
		end
		return list
	end

	local function AddTraits(traits,list)
		for i = 1, #traits do
			list[#list+1] = {
				"trait_" .. traits[i],
				Trans(3720--[[Trait--]]) .. " " .. traits[i],
			}
		end
		return list
	end

	function ChoGGi.ComFuncs.ExportColonistDataToCSV()
		local csv_columns = {
			{"name",Trans(1000037--[[Name--]])},
			{"age",S[302535920001222--[[Age--]]]},
			{"age_trait",S[302535920001222--[[Age--]]] .. " " .. Trans(3720--[[Trait--]])},
			{"death_age",Trans(4284--[[Age of death--]])},
			{"birthplace",Trans(4357--[[Birthplace--]]):gsub("<right><UIBirthplace>","")},
			{"gender",Trans(4356--[[Sex--]]):gsub("<right><Gender>","")},
			{"race",S[302535920000741--[[Race--]]]},
			{"specialist",Trans(240--[[Specialization--]])},
			{"performance",Trans(4283--[[Worker performance--]])},
			{"health",Trans(4291--[[Health--]])},
			{"comfort",Trans(4295--[[Comfort--]])},
			{"morale",Trans(4297--[[Morale--]])},
			{"sanity",Trans(4293--[[Sanity--]])},
			{"handle",S[302535920000955--[[Handle--]]]},
			{"last_meal",S[302535920001229--[[Last Meal--]]]},
			{"last_rest",S[302535920001235--[[Last Rest--]]]},
			{"dome_name",Trans(1234--[[Dome--]]) .. " " .. Trans(1000037--[[Name--]])},
			{"dome_pos",Trans(1234--[[Dome--]]) .. " " .. S[302535920001237--[[Position--]]]},
			{"dome_handle",Trans(1234--[[Dome--]]) .. " " .. S[302535920000955--[[Handle--]]]},
			{"residence_name",Trans(4809--[[Residence--]]) .. " " .. Trans(1000037--[[Name--]])},
			{"residence_pos",Trans(4809--[[Residence--]]) .. " " .. S[302535920001237--[[Position--]]]},
			{"residence_dome",Trans(4809--[[Residence--]]) .. " " .. Trans(1234--[[Dome--]])},
			{"workplace_name",Trans(4801--[[Workplace--]]) .. " " .. Trans(1000037--[[Name--]])},
			{"workplace_pos",Trans(4801--[[Workplace--]]) .. " " .. S[302535920001237--[[Position--]]]},
			{"workplace_dome",Trans(4801--[[Workplace--]]) .. " " .. Trans(1234--[[Dome--]])},
		}
		local t = ChoGGi.Tables
		csv_columns = AddTraits(t.NegativeTraits,csv_columns)
		csv_columns = AddTraits(t.PositiveTraits,csv_columns)
		csv_columns = AddTraits(t.OtherTraits,csv_columns)
		-- we need to make sure these are added (but only once)
		local skipped_traits = {}
		skipped_traits = AddSkipped(t.ColonistAges,skipped_traits)
		skipped_traits = AddSkipped(t.ColonistGenders,skipped_traits)
		skipped_traits = AddSkipped(t.ColonistSpecializations,skipped_traits)


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
		SaveCSV("AppData/Colonists.csv", export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
		ExportDoneMsg(ConvertToOSPath("AppData/Colonists.csv"))
	end
end -- do

do -- Graphs
	local Resources = Resources
	local StockpileResourceList = StockpileResourceList

	local function BuildTable(export_data,c,cat,current,list)
		export_data[c] = {
			category = cat,
			current = current,
		}
		-- add all sol counts
		for i = 1, #list.data do
			-- last recorded sol
			if i > list.next_index then
				break
			end
			export_data[c]["sol" .. i] = list.data[i]
		end
		return export_data
	end

	function ChoGGi.ComFuncs.ExportGraphsToCSV()
		local res_list = {}
		for i = 1, #StockpileResourceList do
			local id = StockpileResourceList[i]
			res_list[i] = {
				id = id,
				name = Trans(Resources[id].display_name),
			}
		end
		local loop_table_label = {
			Colonist = {
				name = Trans(547--[[Colonists--]]) .. " " .. Trans(1000100--[[Amount--]]),
				data = "ts_colonists",
			},
			Unemployed = {
				name = Trans(547--[[Colonists--]]) .. " " .. Trans(6859--[[Unemployed--]]),
				data = "ts_colonists_unemployed",
			},
			Homeless = {
				name = Trans(547--[[Colonists--]]) .. " " .. Trans(7553--[[Homeless--]]),
				data = "ts_colonists_homeless",
			},
			Drone = {
				name = Trans(517--[[Drones--]]),
				data = "ts_drones",
			},
		}
		local loop_table_count1 = {
			{
				name = Trans(745--[[Shuttles--]]),
				func = "CountShuttles",
				data = "ts_shuttles",
			},
			{
				name = Trans(3980--[[Buildings--]]),
				func = "CountBuildings",
				data = "ts_buildings",
			},
		}
		local loop_table_count2 = {
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(79--[[Power--]]) .. " " .. S[302535920001457--[[Stored--]]],
				func = "GetTotalStoredPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "stored",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(32--[[Power Production--]]),
				func = "GetTotalProducedPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "production",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(683--[[Power Consumption--]]),
				func = "GetTotalRequiredPower",
				data1 = "ts_resources_grid",
				data2 = "electricity",
				data3 = "consumption",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(682--[[Oxygen--]]) .. " " .. Trans(302535920001457--[[Stored--]]),
				func = "GetTotalStoredAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "stored",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(923--[[Oxygen Production--]]),
				func = "GetTotalProducedAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "production",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(657--[[Oxygen Consumption--]]),
				func = "GetTotalRequiredAir",
				data1 = "ts_resources_grid",
				data2 = "air",
				data3 = "consumption",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(681--[[Water--]]) .. " " .. S[302535920001457--[[Stored--]]],
				func = "GetTotalStoredWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "stored",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(4806--[[Water Production--]]),
				func = "GetTotalProducedWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "production",
			},
			{
				name = S[302535920000035--[[Grids--]]] .. " " .. Trans(750--[[Water Consumption--]]),
				func = "GetTotalRequiredWater",
				data1 = "ts_resources_grid",
				data2 = "water",
				data3 = "consumption",
			},
		}
		local UICity = UICity
		local ResourceOverviewObj = ResourceOverviewObj

		-- the rest are sols
		local csv_columns = {
			{"category",Trans(1000097--[[Category--]])},
			{"current",S[302535920000106--[[Current--]]]},
		}
		local c = 2

		-- add all the sols as columns
		for i = 1, UICity.day-1 do
			c = c + 1
			csv_columns[c] = {
				"sol" .. i,
				Trans(T{4031--[[Sol <day>--]],day = i})
			}
		end

		local export_data = {}
		c = 0

		-- build csv lists
		for label,list in pairs(loop_table_label) do
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				list.name,
				#(UICity.labels[label] or ""),
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
				ResourceOverviewObj[list.func](ResourceOverviewObj),
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
				Trans(692--[[Resources--]]) .. " " .. name .. " " .. S[302535920001454--[[Stockpiled--]]],
				ResourceOverviewObj["GetAvailable" .. id](ResourceOverviewObj),
				res.stockpile
			)
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				Trans(692--[[Resources--]]) .. " " .. name .. " " .. S[302535920001455--[[Produced--]]],
				ResourceOverviewObj["Get" .. id .. "ProducedYesterday"](ResourceOverviewObj),
				res.produced
			)
			c = c + 1
			export_data = BuildTable(
				export_data,
				c,
				Trans(692--[[Resources--]]) .. " " .. name .. " " .. S[302535920001456--[[Consumed--]]],
				ResourceOverviewObj["Get" .. id .. "ConsumedByConsumptionYesterday"](ResourceOverviewObj),
				res.consumed
			)
		end

		-- the one entry that needs to count two labels
		c = c + 1
		export_data = BuildTable(
			export_data,
			c,
			Trans(5426--[[Building--]]) .. " " .. S[302535920000971--[[Sites--]]] .. " " .. S[302535920001453--[[Completed--]]],
			#(UICity.labels.ConstructionSite or "") + #(UICity.labels.ConstructionSiteWithHeightSurfaces or ""),
			UICity.ts_constructions_completed
		)

		table.sort(export_data, function(a, b)
			return CmpLower(a.category, b.category)
		end)

--~ ex(export_data)
--~ ex(csv_columns)
		-- and now we can save it to disk
		SaveCSV("AppData/Graphs.csv", export_data, table.map(csv_columns, 1), table.map(csv_columns, 2))
		ExportDoneMsg(ConvertToOSPath("AppData/Graphs.csv"))
	end
end -- do
