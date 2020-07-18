-- See LICENSE for terms

-- manual list of rocks, maybe we'll do a sub EntityData ?
local rocks = {
	{"Rocks_01", "Rocks_02", "Rocks_03", "Rocks_04"},
	{"RocksDark_01", "RocksDark_02", "RocksDark_03", "RocksDark_04", "RocksDark_05"},
	{"RocksLight_01", "RocksLight_02", "RocksLight_03", "RocksLight_04", "RocksLight_05", "RocksLight_06"},
	{"RocksLightSmall_01", "RocksLightSmall_02", "RocksLightSmall_03", "RocksLightSmall_04", "RocksLightSmall_05", "RocksLightSmall_06", "RocksLightSmall_07", "RocksLightSmall_08"},
	{"RocksSlate_01", "RocksSlate_02", "RocksSlate_03", "RocksSlate_04", "RocksSlate_05", "RocksSlate_06", "RocksSlate_07"},
	{"Cliff_01", "Cliff_02", "Cliff_03"},
	{"CliffDark_01", "CliffDark_02", "CliffDark_03"},
	{"Ice_Cliff_01", "Ice_Cliff_02", "Ice_Cliff_03", "Ice_Cliff_04", "Ice_Cliff_05", "Ice_Cliff_06"},
}
local cats = {
	"LandscapeRockBuildingsRocks",
	"LandscapeRockBuildingsDark",
	"LandscapeRockBuildingsLight",
	"LandscapeRockBuildingsLightSmall",
	"LandscapeRockBuildingsSlate",
	"LandscapeRockBuildingsCliff",
	"LandscapeRockBuildingsCliffDark",
	"LandscapeRockBuildingsCliffIce",
}

local r = const.ResourceScale

local mod_LargeRocksCost

-- fired when settings are changed/init
local function ModOptions()
	mod_LargeRocksCost = CurrentModOptions:GetProperty("LargeRocksCost") * r

	-- update rocks
	local bt = BuildingTemplates
	local ct = ClassTemplates.Building
	for i = 1, #rocks do
		local group = rocks[i]
		local cat = cats[i]
		for j = 1, #group do
			local id = "ChoGGi_LandscapeRock_" .. group[j]
			local rock = bt[id]
			if rock then
				local cost = cat == "LandscapeRockBuildingsLightSmall" and 1000 or mod_LargeRocksCost
				rock.construction_cost_WasteRock = cost
				ct[id].construction_cost_WasteRock = cost
			end
		end
	end

end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local IsKindOf = IsKindOf
-- we don't specifiy a PrefabMarkers to use, so we skip this to skip the error msg
local orig_PlacePrefab = LevelPrefabController.PlacePrefab
function LevelPrefabController:PlacePrefab(...)
	if IsKindOf(self.template_obj, "ChoGGi_LevelPrefabBuilding") then
		return
	end
	return orig_PlacePrefab(self, ...)
end

DefineClass.ChoGGi_LevelPrefabBuilding = {
	__parents = {"LevelPrefabBuilding"},
	ip_template = "ipChoGGi_LevelPrefabBuilding",
}

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local PlaceObj = PlaceObj

local GetMaterialProperties = GetMaterialProperties
local GetStateMaterial = GetStateMaterial

local function AddToMenu(bt, cat, entity, desc, index)
	local id = "ChoGGi_LandscapeRock_" .. entity
	if not bt[id] then
		local mat = GetMaterialProperties(GetStateMaterial(entity, 0, 0), 0)
		if mat and mat.BaseColor and mat.BaseColor ~= "" then
			PlaceObj("BuildingTemplate", {
				"Group", cat,
				"build_category", cat,
				"Id", id,
				"template_class", "ChoGGi_LevelPrefabBuilding",
				"construction_cost_WasteRock", cat == "LandscapeRockBuildingsLightSmall" and 1000,
				"build_points", cat == "LandscapeRockBuildingsLightSmall" and 500 or 3500,
				"is_tall", cat ~= "LandscapeRockBuildingsLightSmall" and true,
				"use_demolished_state", false,
				"build_pos", index,
				"on_off_button", false,
				"prio_button", false,
				"count_as_building", false,

				"description", desc .. "\n\n<image " .. mat.BaseColor .. " 200>",
				"display_icon", mat.BaseColor,
				"display_name", entity,
				"display_name_pl", entity,
				"entity", entity,

				-- we don't want crystal rocks added along with
				"PrefabType", "Gameplay",
				"PrefabBaseName", "ChoGGi_Sez_Hello_There",
			})
		end
	end
end

-- skip the Missing spot 'Top' in 'ConstructionSite' state 'idle' msg
-- remove ' or "Origin"' to just skip (it'll default to -1 i think?)
local orig_AttachToObject = AttachToObject
function AttachToObject(to, childclass, spot_type, ...)
	return orig_AttachToObject(to, childclass,
		to:HasSpot(spot_type) and spot_type or "Origin", ...
	)
end
local orig_AttachPartToObject = AttachPartToObject
function AttachPartToObject(to, part, spot_type, ...)
	return orig_AttachPartToObject(to, part,
		to:HasSpot(spot_type) and spot_type or "Origin", ...
	)
end


function OnMsg.ClassesPostprocess()
	-- if entities aren't loaded then wait it out
	if not GetMaterialProperties(GetStateMaterial("Rocks_01", 0, 0), 0) or Presets.BuildMenuSubcategory.Default.LandscapeRockBuildingsRocks then
		return
	end

	local desc = T(622475429978, "A stylish composition made of native Martian rocks.")

	PlaceObj("BuildMenuSubcategory", {
		build_pos = 1,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011436, "Rocks"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_01.tga",
		category_name = "LandscapeRockBuildingsRocks",
		id = "LandscapeRockBuildingsRocks"
	})
	PlaceObj("BuildMenuSubcategory", {
		build_pos = 2,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011437, "Dark"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_02.tga",
		category_name = "LandscapeRockBuildingsDark",
		id = "LandscapeRockBuildingsDark"
	})
	PlaceObj("BuildMenuSubcategory", {
		build_pos = 3,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011438, "Light"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_03.tga",
		category_name = "LandscapeRockBuildingsLight",
		id = "LandscapeRockBuildingsLight"
	})
	PlaceObj("BuildMenuSubcategory", {
		build_pos = 4,
		category = "RockFormations_ChoGGi",
		description = T(544067769859, "Small stylish composition made of native Martian rocks."),
		display_name = T(302535920011439, "Light Small"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_04.tga",
		category_name = "LandscapeRockBuildingsLightSmall",
		id = "LandscapeRockBuildingsLightSmall"
	})
	PlaceObj("BuildMenuSubcategory", {
		build_pos = 5,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011440, "Slate"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_05.tga",
		category_name = "LandscapeRockBuildingsSlate",
		id = "LandscapeRockBuildingsSlate"
	})

	PlaceObj("BuildMenuSubcategory", {
		build_pos = 6,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011441, "Cliff"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_06.tga",
		category_name = "LandscapeRockBuildingsCliff",
		id = "LandscapeRockBuildingsCliff"
	})

	PlaceObj("BuildMenuSubcategory", {
		build_pos = 7,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011442, "Cliff Dark"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_07.tga",
		category_name = "LandscapeRockBuildingsCliffDark",
		id = "LandscapeRockBuildingsCliffDark"
	})

	PlaceObj("BuildMenuSubcategory", {
		build_pos = 8,
		category = "RockFormations_ChoGGi",
		description = desc,
		display_name = T(302535920011443, "Cliff Ice"),
		group = "Default",
		icon = "UI/Icons/Buildings/numbers_08.tga",
		category_name = "LandscapeRockBuildingsCliffIce",
		id = "LandscapeRockBuildingsCliffIce"
	})

	desc = T(544067769859, "Small stylish composition made of native Martian rocks.")
	local bt = BuildingTemplates
	for i = 1, #rocks do
		local rock = rocks[i]
		local cat = cats[i]
		for j = 1, #rock do
			AddToMenu(bt, cat, rock[j], desc, j)
		end
	end

	if not bt.RockFormations_ChoGGi_Ignore then
		-- fake item to make build menu show up
		PlaceObj("BuildingTemplate", {
			"Group", "RockFormations_ChoGGi",
			"build_category", "RockFormations_ChoGGi",
			"Id", "RockFormations_ChoGGi_Ignore",
			"display_name", T(302535920011444, "Ignore me"),
			"display_name_pl", T(302535920011444, "Ignore me"),
			"description", T(302535920011445, [[Build menus need at least one actual item or they won't show up.
You can build this if you want it won't hurt anything.]]),
			"template_class", "Building",
			"display_icon", "UI/Icons/Buildings/placeholder.tga",
		})
	end


--~ end

--~ function OnMsg.ClassesBuilt()
	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_LevelPrefabBuilding then
		XTemplates.ipChoGGi_LevelPrefabBuilding:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_LevelPrefabBuilding",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ChoGGi_LevelPrefabBuilding",
			"__template", "Infopanel",
		}, {

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(1000081, "Scale"),
				"RolloverText", T(1000081, "Scale") .. " " .. T(1000541, "+"),
				"RolloverHint", T(608042494285, "<left_click> Activate"),
				"OnPress", function(self)
					-- speeds it up if it's a large scale
					SuspendPassEdits("ChoGGi.LevelPrefabBuilding.Scale")
					self.context:SetScale(self.context:GetScale()+25)
					ResumePassEdits("ChoGGi.LevelPrefabBuilding.Scale")
				end,
				"Icon", "UI/Icons/IPButtons/drone_assemble.tga",
			}),
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(1000081, "Scale"),
				"RolloverText", T(1000081, "Scale") .. " " .. T(1000540, "-"),
				"RolloverHint", T(608042494285, "<left_click> Activate"),
				"OnPress", function(self)
					SuspendPassEdits("ChoGGi.LevelPrefabBuilding.Scale")
					self.context:SetScale(self.context:GetScale()-25)
					ResumePassEdits("ChoGGi.LevelPrefabBuilding.Scale")
				end,
				"Icon", "UI/Icons/IPButtons/drone_dismantle.tga",
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(1000077, "Rotate"),
				"RolloverText", T(312752058553, "Rotate Building Left"),
				"RolloverHint", T(608042494285, "<left_click> Activate"),
				"OnPress", function(self)
					SuspendPassEdits("ChoGGi.LevelPrefabBuilding.Rotate")
					self.context:SetAngle((self.context:GetAngle() or 0) + -3600)
					ObjModified(self.context)
					ResumePassEdits("ChoGGi.LevelPrefabBuilding.Rotate")
				end,
				"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			}),

------------------- Salvage
			PlaceObj('XTemplateTemplate', {
				'comment', "salvage",
				'__context_of_kind', "Demolishable",
				'__condition', function (_, context) return context:ShouldShowDemolishButton() end,
				'__template', "InfopanelButton",
				'RolloverTitle', T(3973, --[[XTemplate ipBuilding RolloverTitle]] "Salvage"),
				'RolloverHintGamepad', T(7657, --[[XTemplate ipBuilding RolloverHintGamepad]] "<ButtonY> Activate"),
				'Id', "idSalvage",
				'OnContextUpdate', function (self, context, ...)
					local refund = context:GetRefundResources() or empty_table
					local rollover = T(7822, "Destroy this building.")
					if IsKindOf(context, "LandscapeConstructionSiteBase") then
						self:SetRolloverTitle(T(12171, "Cancel Landscaping"))
						rollover = T(12172, "Cancel this landscaping project. The terrain will remain in its current state")
					end
					if refund[1] then
						rollover = rollover .. "<newline><newline>" .. T(7823, "<UIRefundRes> will be refunded upon salvage.")
					end
					self:SetRolloverText(rollover)
					context:ToggleDemolish_Update(self)
				end,
				'OnPressParam', "ToggleDemolish",
				'Icon', "UI/Icons/IPButtons/salvage_1.tga",
			}, {
				PlaceObj('XTemplateFunc', {
					'name', "OnXButtonDown(self, button)",
					'func', function (self, button)
						if button == "ButtonY" then
							return self:OnButtonDown(false)
						elseif button == "ButtonX" then
							return self:OnButtonDown(true)
						end
						return (button == "ButtonA") and "break"
					end,
				}),
				PlaceObj('XTemplateFunc', {
					'name', "OnXButtonUp(self, button)",
					'func', function (self, button)
						if button == "ButtonY" then
							return self:OnButtonUp(false)
						elseif button == "ButtonX" then
							return self:OnButtonUp(true)
						end
						return (button == "ButtonA") and "break"
					end,
				}),
				}),
------------------- Salvage
	}),
-------------
	})


	local bc = BuildCategories
	if not table.find(bc, "id", "RockFormations_ChoGGi") then
		bc[#bc+1] = {
			id = "RockFormations_ChoGGi",
			name = T(255661810896, "Rock Formations"),
			image = "UI/Icons/Buildings/rock_formation.tga",
		}
	end
end

function OnMsg.ConstructionSitePlaced(site)
	if site.building_class_proto:IsKindOf("ChoGGi_LevelPrefabBuilding") then
		site:SetScale(25)
	end
end
