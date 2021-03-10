-- See LICENSE for terms

local mod_RemoveLandScapingLimits
local mod_StepSize
local mod_BlockObjects

-- fired when settings are changed/init
local function ModOptions()
	mod_RemoveLandScapingLimits = CurrentModOptions:GetProperty("RemoveLandScapingLimits")
	mod_StepSize = CurrentModOptions:GetProperty("StepSize") * guim
	mod_BlockObjects = CurrentModOptions:GetProperty("BlockObjects")

	ChoGGi.ComFuncs.SetLandScapingLimits(mod_RemoveLandScapingLimits, mod_BlockObjects)
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

-- no more limit to R+T keys (enlarge/shrink)
local orig_Activate = LandscapeConstructionController.Activate
function LandscapeConstructionController:Activate(...)
	if mod_RemoveLandScapingLimits then
		self.brush_radius_step = mod_StepSize or 10*guim
		self.brush_radius_max = max_int
		self.brush_radius_min = 100
	end
	return orig_Activate(self, ...)
end
