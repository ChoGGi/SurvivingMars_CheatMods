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
	-- CPp is too early for mod_
	if not BuildingTemplates.ChoGGi_ExampleBuilding then
		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_ExampleBuilding",
			-- class name from DefineClass
			"template_class", "ChoGGi_ExampleBuilding",

			"palette_color1", "outside_base",
			"palette_color2", "inside_base",
			"palette_color3", "rover_base",

--~ 			"Asteroid","Underground","Surface",
			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"dome_forbidden", true,
			"display_name", T(0000, "Example"),
			"display_name_pl", T(0000, "Examples"),
			"description", T(0000, "Exampledesc"),
--~ 			"display_icon", CurrentModPath .. "UI/rover_combat.png",
			"display_icon", "UI/Icons/Buildings/placeholder.tga",
			"entity", "Ice_Cliff_06",
--~ 			"construction_entity", "RocketLandingPlatform",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,
--~ 			"instant_build", true,
--~ 			"on_off_button", false,
--~ 			"prio_button", false,
--~ 			"use_demolished_state", false,
--~ 			"force_extend_bb_during_placement_checks", 30000,
--~ 			"demolish_sinking", range(0, 0),
--~ 			"demolish_debris", 0,
--~ 			"auto_clear", true,
--~ 			"indestructible", true,
		})
	end


	local xtemplate = XTemplates.ipBuilding[1]

	-- Check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_ExampleBuilding_DoStuff", true)

	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_ExampleBuilding_DoStuff",
			-- No need to add this (I use it for my RemoveXTemplateSections func)
			"ChoGGi_Template_ExampleBuilding_DoStuff", true,
			-- The button only shows when the class object is selected
			"__context_of_kind", "ChoGGi_ExampleBuilding",
			-- Main button
			"__template", "InfopanelButton",
			-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
--~ 			"__template", "InfopanelSection",
			-- Only show button when it meets the req
			"__condition", function(_, context)
				return context:IsKindOf("RequiresMaintenance") and context:DoesRequireMaintenance()
			end,
			-- Updates every sec (or so) when object selection panel is shown
			"OnContextUpdate", function(self, context)
				local name = RetName(context)
				if context.ChoGGi_DisableMaintenance then
					self:SetRolloverText(T{302535920011071, "This <name> will not be maintained.", name = name})
					self:SetTitle(T(302535920011072, "Maintenance Disabled"))
					self:SetIcon("UI/Icons/traits_disapprove.tga")
				else
					self:SetRolloverText(T{302535920011073, "This <name> will be maintained.", name = name})
					self:SetTitle(T(302535920011074, "Maintenance Enabled"))
					self:SetIcon("UI/Icons/traits_approve.tga")
				end
			end,
			--
			"Title", T(0000, "Adjust Level"),
			"RolloverTitle", T(0000, "Adjust Level"),
			"RolloverText", T(0000, [[Adjust lake level
<left_click> Raise <right_click> Lower]]),
			"RolloverHint", T(0000, "Ctrl + <left_click> Halve level adjust"),
			"Icon", "UI/Icons/IPButtons/unload.tga",
			--
			"OnPress", function(self, gamepad)
				-- left click action (second arg is if ctrl is being held down)
				self.context:AdjustLevel("up", not gamepad and IsMassUIModifierPressed())
				ObjModified(self.context)
			end,
			--
			"AltPress", true,
			"OnAltPress", function(self, gamepad)
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
