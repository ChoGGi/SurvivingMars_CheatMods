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

local ChoOrig_HasParadoxSponsor = HasParadoxSponsor
function HasParadoxSponsor(...)
	if not mod_EnableMod then
		return ChoOrig_HasParadoxSponsor(...)
	end

	MarkParadoxSponsorActive()
	return true
end
