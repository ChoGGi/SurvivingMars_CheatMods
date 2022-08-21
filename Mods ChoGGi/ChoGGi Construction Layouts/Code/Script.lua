-- See LICENSE for terms

local Random = ChoGGi.ComFuncs.Random

-- local is faster than global
local point = point
local PlaceObj = PlaceObj

local six_hex_buildings = {
	point(0, 0),
	point(3, 0),
	point(6, 0),
	point(9, 0),
	point(-4, 4),
	point(-1, 4),
	point(2, 4),
	point(5, 4),
}
local six_hex_buildings_dir2 = {
	point(-3, 3),
	point(0, 3),
	point(3, 3),
	point(6, 3),
	point(-7, 7),
	point(-4, 7),
	point(-1, 7),
	point(2, 7),
}
local three_hex_buildings = {
	point(0, 0),
	point(2, 0),
	point(4, 0),
	point(6, 0),
	point(-3, 3),
	point(-1, 3),
	point(1, 3),
	point(3, 3),
}
local three_hex_buildings_dir2 = {
	point(-2, 1),
	point(0, 1),
	point(2, 1),
	point(4, 1),
	point(-5, 4),
	point(-3, 4),
	point(-1, 4),
	point(1, 4),
}

local stirling_points = {
	point(0, 1),
	point(0, -1),
	point(0, 2),
	point(0, -2),
	point(0, 3),
	point(0, -3),
	point(0, 4),
	point(0, -4),
	point(0, 5),
	point(0, -5),
	point(0, 6),
	point(0, -6),
	point(0, 7),
	point(0, -7),
	point(0, -8),
	point(1, 0),
	point(1, 1),
	point(1, -1),
	point(-1, 1),
	point(1, 2),
	point(1, -2),
	point(-1, 2),
	point(1, 3),
	point(1, -3),
	point(-1, 3),
	point(1, 4),
	point(1, -4),
	point(-1, 4),
	point(1, 5),
	point(1, -5),
	point(-1, 5),
	point(1, -6),
	point(-1, 6),
	point(1, 6),
	point(1, -7),
	point(-1, 7),
	point(1, -8),
	point(-1, 8),
	point(2, 0),
	point(2, 1),
	point(2, -1),
	point(2, 2),
	point(2, -2),
	point(-2, 2),
	point(2, 3),
	point(2, -3),
	point(-2, 3),
	point(2, 4),
	point(2, -4),
	point(-2, 4),
	point(2, -5),
	point(-2, 5),
	point(2, 5),
	point(2, -6),
	point(-2, 6),
	point(2, -7),
	point(-2, 7),
	point(2, -8),
	point(-2, 8),
	point(3, 0),
	point(3, 1),
	point(3, -1),
	point(3, 2),
	point(3, -2),
	point(3, 3),
	point(3, -3),
	point(-3, 3),
	point(3, -4),
	point(-3, 4),
	point(3, 4),
	point(3, -5),
	point(-3, 5),
	point(3, -6),
	point(-3, 6),
	point(3, -7),
	point(-3, 7),
	point(3, -8),
	point(-3, 8),
	point(4, 0),
	point(4, 1),
	point(4, -1),
	point(4, 2),
	point(4, -2),
	point(4, -3),
	point(4, 3),
	point(4, -4),
	point(-4, 4),
	point(4, -5),
	point(-4, 5),
	point(4, -6),
	point(-4, 6),
	point(4, -7),
	point(-4, 7),
	point(4, -8),
	point(-4, 8),
	point(5, 0),
	point(5, 1),
	point(5, -1),
	point(5, -2),
	point(5, 2),
	point(5, -3),
	point(5, -4),
	point(5, -5),
	point(-5, 5),
	point(5, -6),
	point(-5, 6),
	point(5, -7),
	point(-5, 7),
	point(5, -8),
	point(-5, 8),
	point(6, 0),
	point(6, -1),
	point(6, 1),
	point(6, -2),
	point(6, -3),
	point(6, -4),
	point(6, -5),
	point(6, -6),
	point(-6, 6),
	point(6, -7),
	point(-6, 7),
	point(6, -8),
	point(-6, 8),
	point(7, 0),
	point(7, -1),
	point(7, -2),
	point(7, -3),
	point(7, -4),
	point(7, -5),
	point(7, -6),
	point(7, -7),
	point(-7, 7),
	point(7, -8),
	point(-7, 8),
	point(-8, 8),
}

--~ 	local windturbine_points = {
--~ 		point(0, 1),
--~ 	}

-- id = entity
local single_hex_decorations = {
	{"GardenNatural_Small", "GardenNatural_01", "GardenNatural_02", "GardenNatural_03", "GardenNatural_07"},
	{"GardenAlleys_Small", "GardenAlleys_01", "GardenAlleys_02", "GardenAlleys_03"},
	{"FountainSmall", "GardenFountains_01", "GardenFountains_02"},
	{"Statue", "GardenStatue_01", "GardenStatue_02"},
}

local three_hex_decorations = {
	{"GardenAlleys_Medium", "GardenAlleys_04", "GardenAlleys_05", "GardenAlleys_06"},
	{"GardenNatural_Medium", "GardenNatural_04", "GardenNatural_05", "GardenNatural_06"},
	{"GardenStone", "GardenStone"},
	{"Lake", "GardenLake"},
	{"FountainLarge", "GardenFountains_03"},
}

local function BuildLayouts(params)
	PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"Id", params.id,
		"LayoutList", params.id,
		"Group", params.build_category,
		"build_category", params.build_category,
		"build_pos", params.build_pos,
		"display_name", params.display_name,
		"display_name_pl", params.display_name_pl,
		"description", params.description,
		"display_icon", params.display_icon,

		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})

	-- dir 0 == default

	if params.id == "ChoGGi_LayoutConstruction_TribbyStirling"
		or params.id == "ChoGGi_LayoutConstruction_Tribbywindturbine"
	then
		local layout = PlaceObj("LayoutConstruction", {
			group = "Default",
			id = params.id,

			PlaceObj("LayoutConstructionEntry", {
				"template", "TriboelectricScrubber",
				"entity", "TriboelectricScrubber",
			}),
		})

		-- add all the points as stirlings
		local c = #layout
		for i = 1, #params.points do
			c = c + 1
			layout[c] = PlaceObj("LayoutConstructionEntry", {
				"template", params.template,
				"entity", params.entity,
				"pos", params.points[i],
			})
		end

	elseif params.id == "ChoGGi_LayoutConstruction_WindTurbinesSmall"
		or params.id == "ChoGGi_LayoutConstruction_LargeSolarPanels"
		or params.id == "ChoGGi_LayoutConstruction_WindTurbinesLarge"
	then
		local layout = PlaceObj("LayoutConstruction", {
			group = "Default",
			id = params.id,
		})

		-- add all the points as stirlings
		local c = #layout
		for i = 1, #params.points do
			c = c + 1
			layout[c] = PlaceObj("LayoutConstructionEntry", {
				"template", params.template,
				"entity", params.entity,
				"pos", params.points[i],
				"dir", params.id == "ChoGGi_LayoutConstruction_WindTurbinesLarge" and 0 or 1,
			})
		end
		for i = 1, #params.points2 do
			c = c + 1
			layout[c] = PlaceObj("LayoutConstructionEntry", {
				"template", params.template,
				"entity", params.entity,
				"pos", params.points2[i],
				"dir", params.id == "ChoGGi_LayoutConstruction_WindTurbinesLarge" and 3 or 0,
			})
		end

	elseif params.id == "ChoGGi_LayoutConstruction_ServiceSlice" then
		PlaceObj("LayoutConstruction", {
			group = "Default",
			id = params.id,

			PlaceObj("LayoutConstructionEntry", {
				"template", single_hex_decorations[1][1],
				"entity", single_hex_decorations[1][2],
			}),

			PlaceObj("LayoutConstructionEntry", {
				"template", "Diner",
				"entity", "Restaurant",
				"pos", point(0, -1),
				"dir", 1,
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", "Infirmary",
				"entity", "Infirmary",
				"pos", point(-1, 1),
				"dir", 5,
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", "ShopsFood",
				"entity", "ShopsFood",
				"pos", point(2, -1),
				"dir", 1,
			}),
		})

	elseif params.id == "ChoGGi_LayoutConstruction_ParkSlice" then

		PlaceObj("LayoutConstruction", {
			group = "Default",
			id = params.id,

			PlaceObj("LayoutConstructionEntry", {
				"template", single_hex_decorations[1][1],
				"entity", single_hex_decorations[1][2],
			}),

			PlaceObj("LayoutConstructionEntry", {
				"template", three_hex_decorations[1][1],
				"entity", three_hex_decorations[1][2],
				"pos", point(0, -1),
				"dir", 1,
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", three_hex_decorations[1][1],
				"entity", three_hex_decorations[1][2],
				"pos", point(-1, 1),
				"dir", 5,
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", three_hex_decorations[1][1],
				"entity", three_hex_decorations[1][2],
				"pos", point(2, -1),
				"dir", 1,
			}),
		})

	elseif params.id == "ChoGGi_LayoutConstruction_ForestPlantGroup" then
		PlaceObj("LayoutConstruction", {
			group = "Default",
			id = params.id,

			PlaceObj("LayoutConstructionEntry", {
				"template", "DroneHub",
				"entity", "DroneHub",
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", "UniversalStorageDepot",
				"entity", "StorageDepot",
				"pos", point(-1, 2),
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", "StorageSeeds",
				"entity", "StorageDepotSmallArm",
				"pos", point(-1, -1),
			}),
			PlaceObj("LayoutConstructionEntry", {
				"template", "ForestationPlant",
				"entity", "ForestationPlant",
				"pos", point(-1, 0),
			}),
		})
	end

end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_LayoutConstruction_TribbyStirling then
		return
	end

	local g_AvailableDlc = g_AvailableDlc

	BuildLayouts{
		id = "ChoGGi_LayoutConstruction_TribbyStirling",
		build_pos = 1,
		display_name = T(302535920011776, "TribbyStirling Inf"),
		display_name_pl = T(302535920011777, "TribbyStirling Infs"),
		description = T(302535920011778, "Half-diamond maxed with Stirlings."),
		display_icon = "UI/Icons/Buildings/black_cube_monument_large.tga",
		points = stirling_points,
		template = "StirlingGenerator",
		entity = "StirlingGenerator",
		build_category = "Power",
	}

	BuildLayouts{
		id = "ChoGGi_LayoutConstruction_WindTurbinesSmall",
		build_pos = 4,
		display_name = T(0000, "Small Wind Turbine Layout"),
		display_name_pl = T(0000, "Small Wind Turbines"),
		description = T(0000, "Bunch of Small Wind Turbines."),
		display_icon = "UI/Icons/Buildings/wind_turbine.tga",
		points = three_hex_buildings,
		points2 = three_hex_buildings_dir2,
		template = "WindTurbine",
		entity = "WindTurbine",
		build_category = "Power",
	}
	BuildLayouts{
		id = "ChoGGi_LayoutConstruction_LargeSolarPanels",
		build_pos = 2,
		display_name = T(0000, "Large Solar Panel Layout"),
		display_name_pl = T(0000, "Large Solar Panels"),
		description = T(0000, "Bunch of large Solar Panel."),
		display_icon = "UI/Icons/Buildings/solar_aray.tga",
		points = three_hex_buildings,
		points2 = three_hex_buildings_dir2,
		template = "SolarPanelBig",
		entity = "SolarPanelBig",
		build_category = "Power",
	}
	BuildLayouts{
		id = "ChoGGi_LayoutConstruction_ServiceSlice",
		build_pos = 1,
		display_name = T(0000, "Service Slice"),
		display_name_pl = T(0000, "Service Slices"),
		description = T(0000, "Service slice of Diner, Infirmary, and Grocer."),
		display_icon = "UI/Icons/Buildings/infirmary.tga",
--~ 		points = stirling_points,
--~ 		template = "StirlingGenerator",
--~ 		entity = "StirlingGenerator",
		build_category = "Dome Services",
	}
		BuildLayouts{
			id = "ChoGGi_LayoutConstruction_ParkSlice",
			build_pos = 99,
			display_name = T(0000, "Park Slice"),
			display_name_pl = T(0000, "Park Slices"),
			description = T(0000, "Bunch of parks for dome slices."),
			display_icon = "UI/Icons/Buildings/small_garden.tga",
			build_category = "Decorations",
		}

	if g_AvailableDlc.armstrong then
		BuildLayouts{
			id = "ChoGGi_LayoutConstruction_ForestPlantGroup",
			build_pos = 2,
			display_name = T(0000, "Forest Plant Group"),
			display_name_pl = T(0000, "Forest Plant Groups"),
			description = T(0000, "Drone Hub, Universal Depot, Seed Depot, and Forestation Plant."),
			display_icon = "UI/Icons/Buildings/forestation_plant.tga",
			build_category = "Terraforming",
		}
	end
	if g_AvailableDlc.contentpack3 then
		BuildLayouts{
			id = "ChoGGi_LayoutConstruction_WindTurbinesLarge",
			build_pos = 4,
			display_name = T(0000, "Large Wind Turbine Layout"),
			display_name_pl = T(0000, "Large Wind Turbines"),
			description = T(0000, "Bunch of Large Wind Turbines."),
			display_icon = "UI/Icons/Buildings/wind_turbine_large.tga",
			points = six_hex_buildings,
			points2 = six_hex_buildings_dir2,
			template = "WindTurbine_Large",
			entity = "WindTurbineCP3",
			build_category = "Power",
		}
	end

--~ 	BuildLayouts{
--~ 		id = "ChoGGi_LayoutConstruction_Tribbywindturbine",
--~ 		build_pos = 1,
--~ 		display_name = T(302535920011779, "TribbyWindTurbine Inf"),
--~ 		display_name_pl = T(302535920011780, "TribbyWindTurbine Infs"),
--~ 		description = T(302535920011781, "Half-diamond maxed with Large Wind Turbines."),
--~ 		display_icon = "UI/Icons/Buildings/black_cube_monument_large.tga",
--~ 		points = windturbine_points,
--~ 		template = "WindTurbine_Large",
--~ 		entity = "WindTurbineCP3",
--~ 	}


end

local ChoOrig_LayoutConstructionController_Activate = LayoutConstructionController.Activate
function LayoutConstructionController:Activate(template, params, ...)
  local template_obj = ClassTemplates.Building[template] or g_Classes[template] or empty_table
  local layout_preset = Presets.LayoutConstruction.Default[template_obj.LayoutList] or params.layout_preset or empty_table
	-- add random decorations
	if layout_preset.id == "ChoGGi_LayoutConstruction_ServiceSlice" then
		local dec = table.rand(single_hex_decorations)
		layout_preset[1].entity = dec[Random(2, #dec)]
		layout_preset[1].dir = Random(0, 5)
	elseif layout_preset.id == "ChoGGi_LayoutConstruction_ParkSlice" then
		local dec = table.rand(single_hex_decorations)
		local dec1 = table.rand(three_hex_decorations)
		local dec2 = table.rand(three_hex_decorations)
		local dec3 = table.rand(three_hex_decorations)
		layout_preset[1].entity = dec[Random(2, #dec)]
		layout_preset[1].dir = Random(0, 5)
		layout_preset[2].entity = dec1[Random(2, #dec1)]
		layout_preset[3].entity = dec2[Random(2, #dec2)]
		layout_preset[4].entity = dec3[Random(2, #dec3)]
	end

	return ChoOrig_LayoutConstructionController_Activate(self, template, params, ...)
end
