-- See LICENSE for terms

local function AddToMenu(bt, t, desc, index)
	local id = "LandscapeTexture" .. t.name
	if not bt[id] then
		PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

			"Group", t.cat,
			"build_category", t.cat,
			"Id", id,
			"template_class", "LandscapeTextureBuilding",
			"can_rotate_during_placement", false,
			"can_resize_during_placement", true,
			"dome_forbidden", true,
			"display_name", t.name,
			"display_name_pl", t.name,
			"description", desc .. "\n\n<image " .. t.texture .. ">",
--~ 			"display_icon", "UI/Icons/Buildings/terrain_sands.tga",
			"display_icon", t.texture,
			"entity", "InvisibleObject",
			"indestructible", true,
			"demolish_sinking", range(0, 0),
			"construction_mode", "landscape_texture",
			"refund_on_salvage", false,
			"count_as_building", false,
			"texture_type", t.name,
			-- Use next texture since I group them?
--~ 			"texture_alt", "Sand_02",
			-- Wonder if this works as a range?
			"texture_ratio", 60,
			"texture_pattern", "Landscape",
			"build_pos", index,
		})
	end
end

local CmpLower = CmpLower
local function NameSort(a, b)
	return CmpLower(a.name, b.name)
end

function OnMsg.ClassesPostprocess()
	local TerrainTextures = TerrainTextures

	-- only do stuff when textures have been loaded
	if not TerrainTextures[0].texture then
		return
	end

	local bc = BuildCategories
	if not table.find(bc, "id", "LandscapeTextures_ChoGGi") then
		bc[#bc+1] = {
			id = "LandscapeTextures_ChoGGi",
			name = T(12400, "Change Surface"),
			image = "UI/Icons/Buildings/terrain.tga",
		}
	end

	local cs = T(12400, "Change Surface")
	local desc = T(12445, "Mark the top layer of a surface to be rearranged by Drones. The marked ground will gradually change towards the desired texture.<if(has_dlc('armstrong'))><newline><newline><em>Degrades local Soil Quality.</em></if>")
	if not Presets.BuildMenuSubcategory.Default.LandscapeTextureBuildingsTerra then
		PlaceObj("BuildMenuSubcategory", {
			build_pos = 1,
			category = "LandscapeTextures_ChoGGi",
			description = desc,
			display_name = cs .. " " .. T(302535920011447, "Terra"),
			group = "Default",
			icon = "UI/Icons/Buildings/numbers_01.tga",
			category_name = "LandscapeTextureBuildingsTerra",
			id = "LandscapeTextureBuildingsTerra"
		})
		PlaceObj("BuildMenuSubcategory", {
			build_pos = 2,
			category = "LandscapeTextures_ChoGGi",
			description = desc,
			display_name = cs .. " " .. T(302535920011448, "Sand"),
			group = "Default",
			icon = "UI/Icons/Buildings/numbers_02.tga",
			category_name = "LandscapeTextureBuildingsSand",
			id = "LandscapeTextureBuildingsSand"
		})
		PlaceObj("BuildMenuSubcategory", {
			build_pos = 3,
			category = "LandscapeTextures_ChoGGi",
			description = desc,
			display_name = cs .. " " .. T(302535920011449, "Chaos"),
			group = "Default",
			icon = "UI/Icons/Buildings/numbers_03.tga",
			category_name = "LandscapeTextureBuildingsChaos",
			id = "LandscapeTextureBuildingsChaos"
		})
		PlaceObj("BuildMenuSubcategory", {
			build_pos = 4,
			category = "LandscapeTextures_ChoGGi",
			description = desc,
			display_name = cs .. " " .. T(302535920011450, "Rock"),
			group = "Default",
			icon = "UI/Icons/Buildings/numbers_04.tga",
			category_name = "LandscapeTextureBuildingsRock",
			id = "LandscapeTextureBuildingsRock"
		})
		PlaceObj("BuildMenuSubcategory", {
			build_pos = 5,
			category = "LandscapeTextures_ChoGGi",
			description = desc,
			display_name = cs .. " " .. T(302535920011451, "Misc"),
			group = "Default",
			icon = "UI/Icons/Buildings/numbers_05.tga",
			category_name = "LandscapeTextureBuildingsMisc",
			id = "LandscapeTextureBuildingsMisc"
		})
		PlaceObj("BuildMenuSubcategory", {
			build_pos = 6,
			category = "LandscapeTextures_ChoGGi",
			description = desc,
			display_name = cs .. " " .. T(302535920011452, "Prefab"),
			group = "Default",
			icon = "UI/Icons/Buildings/numbers_08.tga",
			category_name = "LandscapeTextureBuildingsPrefab",
			id = "LandscapeTextureBuildingsPrefab"
		})
	end


	local lookup = {
		Terr = "LandscapeTextureBuildingsTerra",
		Sand = "LandscapeTextureBuildingsSand",
		Chao = "LandscapeTextureBuildingsChaos",
		Pref = "LandscapeTextureBuildingsPrefab",
		Rock = "LandscapeTextureBuildingsRock",
	}

	-- we get a list of textures then sort them by name
	local lists = {
		Terr = {},
		Sand = {},
		Chao = {},
		Pref = {},
		Rock = {},
		Misc = {},
	}

	for i = 1, #TerrainTextures do
		local t = TerrainTextures[i]
		-- grab from first 4 and last 4 to check for names
		local list_name1 = t.name:sub(1, 4)
		local list_name2 = t.name:sub(-4)
		local cat1 = lookup[list_name1]
		local cat2 = lookup[list_name2]
		if cat1 or cat2 then
			local list
			if cat1 then
				list = lists[list_name1]
			else
				list = lists[list_name2]
			end

			list[#list+1] = {
				cat = cat1 or cat2,
				name = t.name,
				texture = t.texture,
			}
		else
			local list = lists.Misc
			list[#list+1] = {
				cat = "LandscapeTextureBuildingsMisc",
				name = t.name,
				texture = t.texture,
			}
		end
	end

	-- sort lists by name so we can use the list index for sorting
	local sort = table.sort
	sort(lists.Terr, NameSort)
	sort(lists.Sand, NameSort)
	sort(lists.Chao, NameSort)
	sort(lists.Pref, NameSort)
	sort(lists.Rock, NameSort)
	sort(lists.Misc, NameSort)

	desc = T(527078695208, "Marks a surface for Drones to change into the Sands type.<if(has_dlc('armstrong'))><newline><newline><em>Degrades local Soil Quality.</em></if>")
	local bt = BuildingTemplates

	for _, list in pairs(lists) do
		for i = 1, #list do
			AddToMenu(bt, list[i], desc, i)
		end
	end

	if not bt.LandscapeTextures_ChoGGi_Ignore then
		-- fake item to make build menu show up
		PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

			"Group", "LandscapeTextures_ChoGGi",
			"build_category", "LandscapeTextures_ChoGGi",
			"Id", "LandscapeTextures_ChoGGi_Ignore",
			"display_name", T(302535920011444,"Ignore me"),
			"display_name_pl", T(302535920011444,"Ignore me"),
			"description", T(302535920011445,[[Build menus need at least one actual item or they won't show up.
You can build this if you want it won't hurt anything.]]),
			"template_class", "Building",
			"display_icon", "UI/Icons/Buildings/placeholder.tga",
		})
	end

end
