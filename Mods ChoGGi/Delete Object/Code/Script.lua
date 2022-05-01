-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- Check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_ModDeleteObject_button", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_ModDeleteObject_button",
		-- No need to add this (I use it for my RemoveXTemplateSections func)
		"ChoGGi_Template_ModDeleteObject_button", true,
		-- The button only shows when the class object is selected
		"__context_of_kind", "CObject",
		-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
		"__template", "InfopanelActiveSection",
		-- Only show button when it meets the req
		"__condition", function(_, context)
			return mod_EnableMod and IsValid(context)
		end,
		--
		"Title", T(0000, "Delete Object"),
		"RolloverTitle", T(0000, "Delete Object"),
		"RolloverText", T(0000, "Forcefully delete selected object!"),
		"Icon", "UI/Icons/IPButtons/stop.tga",
		}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
				return self.parent
			end,
			"func", function(_, context)
				ChoGGi.ComFuncs.DeleteObjectQuestion(context)
			end,
		}),
	})

end
