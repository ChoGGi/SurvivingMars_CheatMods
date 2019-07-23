-- See LICENSE for terms

DefineClass.ChoGGi_ExampleBuilding = {
	__parents = {
		"Building",
	},
}

function ChoGGi_ExampleBuilding:GameInit()
	self:SetColorModifier(-12374251)

	-- -128 to 127
	-- object, 1-4 , Color, Roughness, Metallic
	self:SetColorizationMaterial(1, -9175040, -128, 120)
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	self:SetColorizationMaterial(3, -5694693, -128, 48)
end

function ChoGGi_ExampleBuilding:Done()
	if IsValid(self.someobj) then
		DoneObject(self.someobj)
	end
end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_ExampleBuilding then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_ExampleBuilding",
		"template_class", "ChoGGi_ExampleBuilding",
		"construction_cost_Concrete", 40000,
		"palette_color1", "outside_base",
		"palette_color2", "inside_base",
		"palette_color3", "rover_base",

		"dome_forbidden", true,
		"display_name", T(302535920011000, [[Example]]),
		"display_name_pl", T(302535920011000, [[Examples]]),
		"description", T(302535920011000, [[Exampledesc]]),
--~ 		"display_icon", CurrentModPath .. "UI/rover_combat.png",
		"display_icon", "UI/Icons/Buildings/placeholder.tga",
		"entity", "Ice_Cliff_06",
--~ 		"construction_entity", "RocketLandingPlatform",
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"encyclopedia_exclude", true,
		"on_off_button", false,
		"prio_button", false,
--~ 		"use_demolished_state", false,
--~ 		"force_extend_bb_during_placement_checks", 30000,
--~ 		"demolish_sinking", range(0, 0),
--~ 		"demolish_debris", 0,
--~ 		"auto_clear", true,
	})

	local building = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_ChoGGi_ExampleBuilding_DoStuff", true)

	table.insert(
		building,
--~ 		#building+1,
		1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_ChoGGi_ExampleBuilding_DoStuff", true,
			"comment", "something something",
			"__context_of_kind", "ChoGGi_ExampleBuilding",
			"__template", "InfopanelButton",

			"RolloverText", T(302535920011000, [[Adjust lake level
<left_click> Raise <right_click> Lower]]),
			"RolloverTitle", T(302535920011000, [[Adjust Level]]),
			"RolloverHint", T(302535920011000, [[Ctrl + <left_click> Halve level adjust]]),
			"Icon", "UI/Icons/IPButtons/unload.tga",

			"OnPress", function (self, gamepad)
				-- left click action (second arg is if ctrl is being held down)
				self.context:AdjustLevel("up", not gamepad and IsMassUIModifierPressed())
				ObjModified(self.context)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				-- right click action
				if gamepad then
					self.context:AdjustLevel("down", true)
				else
					self.context:AdjustLevel("down", IsMassUIModifierPressed())
				end
				ObjModified(self.context)
			end,
		})
	)

end
