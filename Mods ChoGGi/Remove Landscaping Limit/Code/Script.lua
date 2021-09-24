-- See LICENSE for terms

local guim = guim
local SetLandScapingLimits = ChoGGi.ComFuncs.SetLandScapingLimits

local mod_RemoveLandScapingLimits
local mod_StepSize
local mod_BlockObjects
local mod_AllowOutOfBounds

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_RemoveLandScapingLimits = options:GetProperty("RemoveLandScapingLimits")
	mod_StepSize = options:GetProperty("StepSize") * guim
	mod_BlockObjects = options:GetProperty("BlockObjects")
	mod_AllowOutOfBounds = options:GetProperty("AllowOutOfBounds")

	SetLandScapingLimits(mod_RemoveLandScapingLimits, mod_BlockObjects, mod_AllowOutOfBounds)
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
local ChoOrig_Activate = LandscapeConstructionController.Activate
function LandscapeConstructionController:Activate(...)
	if mod_RemoveLandScapingLimits then
		self.brush_radius_step = mod_StepSize or 10 * guim
		self.brush_radius_max = max_int
		self.brush_radius_min = 100
	end
	return ChoOrig_Activate(self, ...)
end
