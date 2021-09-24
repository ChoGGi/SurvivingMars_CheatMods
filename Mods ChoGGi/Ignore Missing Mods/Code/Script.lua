-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- stops confirmation dialog about missing mods (still lets you know they're missing)
local ChoOrig_GetMissingMods = GetMissingMods
function GetMissingMods(...)
	if mod_EnableMod then
		return "", false
	else
		return ChoOrig_GetMissingMods(...)
	end
end
