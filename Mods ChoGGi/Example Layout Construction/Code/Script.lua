-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_LayoutConstruction_Example then
		return
	end

	PlaceObj("BuildingTemplate", {
		-- keep it unique folks
		"Id", "ChoGGi_LayoutConstruction_Example",
		-- LayoutList id corresponds to the LayoutConstruction below
		"LayoutList", "ChoGGi_LayoutConstruction_Example",
		-- what group to add it to
		"Group", "Infrastructure",
		"build_category", "Infrastructure",
		-- pos in build menu
		"build_pos", 1,
		-- don't look at me (0 means no id, use in-game mod editor to generate ids)
		"display_name", T(0, "Layout Construction Example ChoGGi"),
		"display_name_pl", T(0, "Layout Construction Example ChoGGis"),
		"description", T(0, "Some buildings"),
		"display_icon", "UI/Icons/Buildings/self-sufficient_dome.tga",
		-- hands off
		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})

	PlaceObj("LayoutConstruction", {
		group = "Default",
		id = "ChoGGi_LayoutConstruction_Example",

		-- you can find template names here:
		-- https://github.com/HaemimontGames/SurvivingMars/blob/master/Data/BuildingTemplate.lua
		-- for DLC use my Expanded Cheat Menu mod, and in the console type in ~BuildingTemplates

		-- they usually have the same entity name, but not always (check the template).

		PlaceObj("LayoutConstructionEntry", {
			"template", "DomeBasic",
--~ 			"entity", "DomeBasic",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "OxygenTank",
			"pos", point(1, -9),
			-- 0-5 (six hex angles), test with an existing obj with SelectedObj:SetAngle(5*3600) (3600 == 60*60)
			"dir", 5,
			"entity", "AirTank",
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "MOXIE",
			-- you can use ECM to figure out the pos numbers
			-- select obj>press f4 to examine>go to objects>hex shape toggle>see position numbers
			-- or press Shift-F3 to have a grid follow the cursor
			"pos", point(1, -8),
			"entity", "Moxie",
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "MoistureVaporator",
			"pos", point(-1, -6),
			"dir", 1,
			"entity", "MoistureVaporator",
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "WaterTank",
			"pos", point(-2, -7),
			"dir", 4,
			"entity", "WaterTank",
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "life_support_grid",
			"pos", point(0, -7),
			-- end points for cables, pipes, or (I assume) dome connectors.
			-- https://steamcommunity.com/workshop/discussions/18446744073709551615/1642043267245064779/?appid=464920&tscn=1563856870
			"cur_pos1", point(0, -8),
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "MoistureVaporator",
			"pos", point(7, -1),
			"dir", 3,
			"entity", "MoistureVaporator",
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "life_support_grid",
			"pos", point(7, 0),
			"cur_pos1", point(7, 0),
		}),
		PlaceObj("LayoutConstructionEntry", {
			"template", "StorageFood",
			"pos", point(5, -7),
			"instant", true,
		}),
	})

--[[
{ category = "Layout",   id = "template",      name = "Template",         editor = "choice", default = false, items = function() return BuildingsCombo() end, },
{ category = "Layout",   id = "pos",           name = "Offset Pos (Hex)", editor = "point",  default = point20 },
{ category = "Layout",   id = "cur_pos1",      name = "Grid Placement p1 (Hex)", editor = "point",  default = point20 },
{ category = "Layout",   id = "cur_pos2",      name = "Grid Placement p2 (Hex)", editor = "point",  default = point20 },
{ category = "Layout",   id = "switch_dobule_line_directions",  name = "Pipes Rotated?", editor = "bool",  default = false },
{ category = "Layout",   id = "dir",           name = "Offset Dir (Hex)", editor = "number", default = 0 },
{ category = "Layout",   id = "instant",       name = "Instant",       editor = "bool",   default = false, },
{ category = "Building", id = "entity",        name = "Entity",           editor = "text",   default = "", },
{ category = "Building", id = "palette",       name = "Palette",          editor = "text",   default = "", },
{ category = "Grid",     id = "grid_skin",     name = "Grid Skin",        editor = "text",   default = "Default", },
]]

end
