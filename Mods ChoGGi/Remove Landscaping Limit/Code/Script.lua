-- See LICENSE for terms

local options
local mod_RemoveLandScapingLimits
local mod_StepSize
local mod_BlockObjects

-- fired when settings are changed/init
local function ModOptions()
	mod_RemoveLandScapingLimits = options.RemoveLandScapingLimits
	mod_StepSize = options.StepSize * guim
	mod_BlockObjects = options.BlockObjects

	ChoGGi.ComFuncs.SetLandScapingLimits(mod_RemoveLandScapingLimits, mod_BlockObjects)
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

function OnMsg.ClassesGenerate()
	-- no more limit to R+T
	local orig_Activate = LandscapeConstructionController.Activate
	function LandscapeConstructionController:Activate(...)
		if mod_RemoveLandScapingLimits then
			self.brush_radius_step = mod_StepSize or 10*guim
			self.brush_radius_max = max_int
			self.brush_radius_min = 100
		end
		return orig_Activate(self, ...)
	end
end
