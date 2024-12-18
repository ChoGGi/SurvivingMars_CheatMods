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
