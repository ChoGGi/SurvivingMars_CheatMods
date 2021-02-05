-- See LICENSE for terms

-- local is faster than global
local point = point
local PlaceObj = PlaceObj

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

local windturbine_points = {
	point(0, 1),
}

-- id = entity
local single_hex_decorations = {
	{"GardenNatural_Small", "GardenNatural_01"},
	{"GardenAlleys_Small", "GardenAlleys_01"},
	{"FountainSmall", "GardenFountains_01"},
	{"Statue", "GardenStatue_01"},
}

local function BuildTribbyLayouts(params)
	PlaceObj("BuildingTemplate", {
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

	elseif params.id == "ChoGGi_LayoutConstruction_ServiceSlice" then
		-- pick a random decoration for the middle hex
		local dec = table.rand(single_hex_decorations)

		PlaceObj("LayoutConstruction", {
			group = "Default",
			id = params.id,

			PlaceObj("LayoutConstructionEntry", {
				"template", dec[1],
				"entity", dec[2],
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
	end

end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_LayoutConstruction_TribbyStirling then
		return
	end

	BuildTribbyLayouts{
		id = "ChoGGi_LayoutConstruction_TribbyStirling",
		build_pos = 1,
		display_name = T(302535920011776, "TribbyStirling Inf"),
		display_name_pl = T(302535920011777, "TribbyStirling Infs"),
		description = T(302535920011778, "Half-diamond maxed with Stirlings."),
		display_icon = "UI/Icons/Buildings/black_cube_monument_large.tga",
		points = stirling_points,
		template = "StirlingGenerator",
		entity = "StirlingGenerator",
		build_category = "Infrastructure",
	}
	BuildTribbyLayouts{
		id = "ChoGGi_LayoutConstruction_ServiceSlice",
		build_pos = 1,
		display_name = T(000, "Service Slice"),
		display_name_pl = T(000, "Service Slices"),
		description = T(000, "Service slice of Diner, Infirmary, and Grocer."),
		display_icon = "UI/Icons/Buildings/infirmary.tga",
--~ 		points = stirling_points,
--~ 		template = "StirlingGenerator",
--~ 		entity = "StirlingGenerator",
		build_category = "Dome Services",
	}

--~ 	BuildTribbyLayouts{
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
