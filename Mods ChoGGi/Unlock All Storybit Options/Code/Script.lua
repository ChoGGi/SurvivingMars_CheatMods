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

local function FakeEvaluate(func, ...)
	if not mod_EnableMod then
		return func(...)
	end

	return true
end

function OnMsg.ClassesPostprocess()
	local ChoOrig_IsCommander_Evaluate = IsCommander.Evaluate
	function IsCommander.Evaluate(...)
		return FakeEvaluate(ChoOrig_IsCommander_Evaluate, ...)
	end
	local ChoOrig_IsCommander2_Evaluate = IsCommander2.Evaluate
	function IsCommander2.Evaluate(...)
		return FakeEvaluate(ChoOrig_IsCommander2_Evaluate, ...)
	end
end