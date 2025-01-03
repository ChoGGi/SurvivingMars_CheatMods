-- See LICENSE for terms

local SetLandScapingLimits = ChoGGi_Funcs.Common.SetLandScapingLimits

local mod_EnableMod
local mod_StepSize
local mod_BlockObjects
local mod_AllowOutOfBounds

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("RemoveLandScapingLimits")
	mod_StepSize = CurrentModOptions:GetProperty("StepSize") * guim
	mod_BlockObjects = CurrentModOptions:GetProperty("BlockObjects")
	mod_AllowOutOfBounds = CurrentModOptions:GetProperty("AllowOutOfBounds")

	SetLandScapingLimits(mod_EnableMod, mod_BlockObjects, mod_AllowOutOfBounds)
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- no more limit to R+T keys (enlarge/shrink)
local ChoOrig_Activate = LandscapeConstructionController.Activate
function LandscapeConstructionController:Activate(...)
	if mod_EnableMod then
		self.brush_radius_step = mod_StepSize or 10 * guim
		self.brush_radius_max = max_int
		self.brush_radius_min = 100
	end
	return ChoOrig_Activate(self, ...)
end


function OnMsg.ClassesPostprocess()
--~ 	local xtemplate = XTemplates.ipConstruction[1]
	local xtemplate = XTemplates.ipBuilding[1]

	-- Check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_ResetLandscapingSize_Button", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_ResetLandscapingSize_Button",
		-- No need to add this (I use it for my RemoveXTemplateSections func)
		"ChoGGi_Template_ResetLandscapingSize_Button", true,
		-- The button only shows when the class object is selected
		"__context_of_kind", "LandscapeConstructionSite",
		-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
		"__template", "InfopanelButton",
		-- Only show button when it meets the req
		"__condition", function(_, context)
			return mod_EnableMod and IsValid(context)
		end,

		"RolloverText", T(0000, "Sometimes resizing during landscaping will bug out and max the size, use this to reset the size for the next time you open it."),
		"RolloverTitle", T(0000, "Reset Size"),
		"OnPressParam", "ChoGGi_ResetLandscapeSize",
		"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
	})

end

function LandscapeConstructionSite:ChoGGi_ResetLandscapeSize()
	for i = 1, #Cities do
		local control = Cities[i].construction_controllers
		if control.LandscapeTerraceController then
			control.LandscapeTerraceController.brush_radius = 6000
		end
	end
end
