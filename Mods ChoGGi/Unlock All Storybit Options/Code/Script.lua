-- See LICENSE for terms

local mod_EnableMod

-- Update mod options
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

-- all storybit/neg/etc options enabled
local ChoOrig_Condition_Evaluate = Condition.Evaluate
function Condition.Evaluate(...)
	if not mod_EnableMod then
		return ChoOrig_Condition_Evaluate(...)
	end

	return true
end

