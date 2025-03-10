-- See LICENSE for terms

local mod_EnableMod
local mod_FreeFormPlacement
local mod_FullRotation

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_FreeFormPlacement = CurrentModOptions:GetProperty("FreeFormPlacement")
	mod_FullRotation = CurrentModOptions:GetProperty("FullRotation")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local tree_objs = {
	{
		entity = "TreeArm_01",
		icon = "plant_trees"
	},
	{
		entity = "TreeArm_02",
		icon = "plant_trees"
	},
	{
		entity = "TreeArm_03",
		icon = "plant_trees"
	},
	{
		entity = "TreeArm_04",
		icon = "plant_trees"
	},
	{
		entity = "Tree_01",
		icon = "plant_trees"
	},
	{
		entity = "Tree_02",
		icon = "plant_trees"
	},
	{
		entity = "Tree_03",
		icon = "plant_trees"
	},
	{
		entity = "Tree_04",
		icon = "plant_trees"
	},
	{
		entity = "Tree_05",
		icon = "plant_trees"
	},
	--
	{
		entity = "BushArm_01",
		icon = "plant_shrubs"
	},
	{
		entity = "BushArm_02",
		icon = "plant_shrubs"
	},
	{
		entity = "BushArm_03",
		icon = "plant_shrubs"
	},
	{
		entity = "Bush_01",
		icon = "plant_shrubs"
	},
	{
		entity = "Bush_02",
		icon = "plant_shrubs"
	},
	{
		entity = "Bush_03",
		icon = "plant_shrubs"
	},
	{
		entity = "Bush_04",
		icon = "plant_shrubs"
	},
	{
		entity = "Bush_05",
		icon = "plant_shrubs"
	},
	{
		entity = "Bush_06",
		icon = "plant_shrubs"
	},
	--
	{
		entity = "GrassArm_01",
		icon = "plant_grass"
	},
	{
		entity = "GrassArm_02",
		icon = "plant_grass"
	},
}
local nicknack_objs = {
	{
		entity = "LampInt_03",
		icon = "projector_lamp"
	},
	{
		entity = "LampInt_04",
		icon = "projector_lamp"
	},
	{
		entity = "LampInt_05",
		icon = "projector_lamp"
	},
	{
		entity = "DecorInt_01",
		icon = "long_garden"
	},
	{
		entity = "DecorInt_02",
		icon = "long_garden"
	},
	{
		entity = "DecorInt_03",
		icon = "boomerang_garden"
	},
	{
		entity = "DecorInt_04",
		icon = "boomerang_garden"
	},
	{
		entity = "DecorInt_05",
		icon = "boomerang_garden"
	},
	{
		entity = "DecorInt_06",
		icon = "long_garden"
	},
}


local function AddTemplate(entity, icon, category, build_pos)
	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_VegObj_" .. entity,
		"template_class", "ChoGGi_VegetationObject",

		"display_name", entity,
		"display_name_pl", entity,
		"description", T(0000, "Plant a tree"),
		"display_icon", "UI/Icons/Buildings/" .. icon .. ".tga",
		"disabled_entity", entity,
		"entity", entity,
		"build_pos", build_pos,

		"build_category", category,
		"group", category,

		-- "Asteroid","Underground","Surface",
		-- defaults to surface only!
		-- use the below to remove realm limitation
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"encyclopedia_exclude", true,
		"instant_build", true,
		"on_off_button", false,
		"prio_button", false,
		"can_refab", false,
		"use_demolished_state", false,
		"count_as_building", false,
	})
end

function OnMsg.ClassesPostprocess()
	-- Add build cat
	if not BuildMenuSubcategories.ChoGGi_FreeFormVegetation then
		PlaceObj('BuildMenuSubcategory', {
			build_pos = 0,
			category = "Decorations",
			description = T(0000, "Various forms of vegetation"),
			display_name = T(0000, "Vegetation"),
			group = "Default",
			icon = "UI/Icons/Buildings/plant_trees.tga",
			category_name = "ChoGGi_FreeFormVegetation",
			id = "ChoGGi_FreeFormVegetation",
		})
		PlaceObj('BuildMenuSubcategory', {
			build_pos = 1,
			category = "Decorations",
			description = T(0000, "Little things to add variety to your domes / outside areas."),
			display_name = T(0000, "Nick-Nacks"),
			group = "Default",
			icon = "UI/Icons/Buildings/boomerang_garden.tga",
			category_name = "ChoGGi_FreeFormNickNacks",
			id = "ChoGGi_FreeFormNickNacks",
		})
	end

	if BuildingTemplates.ChoGGi_VegObj_TreeArm_01 then
		return
	end

	local EntityData = EntityData
	local ChoGGi_VegetationObject = ChoGGi_VegetationObject
	local HexOutlineShapes = HexOutlineShapes
	local empty_table = empty_table

	for i = 1, #tree_objs do
		local obj = tree_objs[i]

		-- check if entity dlc is installed
		if EntityData[obj.entity] then

			AddTemplate(
				obj.entity,
				obj.icon,
				"ChoGGi_FreeFormVegetation",
				-- Close enough even if missing some
				i
			)
			-- An empty_table in HexOutlineShapes removes the grids, so they can be placed closer
			-- It will need the efSelectable true to be selectable without a grid
			HexOutlineShapes[obj.entity] = empty_table
		end

	end
	for i = 1, #nicknack_objs do
		local obj = nicknack_objs[i]
		if EntityData[obj.entity] then
			AddTemplate(
				obj.entity,
				obj.icon,
				"ChoGGi_FreeFormNickNacks",
				i
			)
			HexOutlineShapes[obj.entity] = empty_table
		end
	end

end

-- Stop snapping to grid
local ChoOrig_ConstructionController_Activate = ConstructionController.Activate
function ConstructionController:Activate(template, params, ...)
	if not mod_EnableMod or not mod_FreeFormPlacement then
		return ChoOrig_ConstructionController_Activate(self, template, params, ...)
	end

	if not params then
		params = {}
	end
	params.snap_to_grid = false

	return ChoOrig_ConstructionController_Activate(self, template, params, ...)
end

-- Use Building class for all funcs XBuildMenu complains about
DefineClass.ChoGGi_VegetationObject = {
	__parents = {
		"Building",
		"VegetationObject",
	},

  flags = {
    efSelectable = true,
  },
}


--~ local ChoOrig_CursorBuilding_SetAngle = CursorBuilding.SetAngle
--~ function CursorBuilding:SetAngle(angle, ...)
--~ 	if not mod_EnableMod or not mod_FullRotation then
--~ 		return ChoOrig_CursorBuilding_SetAngle(self, angle, ...)
--~ 	end
--~ print(self)
--~ ex(self)
--~ 	if self.template
--~ 		and self.template.class == "ChoGGi_VegetationObject"
--~ 	then
--~ 		-- clockwise or counter
--~ 		if angle == -3600 then
--~ 			angle = self:GetAngle() + 1*60*10
--~ 		else
--~ 			angle = self:GetAngle() + -1*60*10
--~ 		end
--~ 	end

--~ 	return ChoOrig_CursorBuilding_SetAngle(self, angle, ...)
--~ end

--~ function ConstructionController:Rotate(delta)
--~ print(delta)
--~ 	if self.cursor_obj and (not self.is_template or self.template_obj.can_rotate_during_placement) then
--~ 		PlayFX("RotateConstruction", "start", self.cursor_obj)
--~ 		self.cursor_obj:SetAngle(self.cursor_obj:GetAngle() + delta*60*60)
--~ 		self:UpdateConstructionObstructors()
--~ 		self:UpdateConstructionStatuses()
--~ 		self:UpdateShortConstructionStatus()
--~ 	end
--~ 	return "break"
--~ end
