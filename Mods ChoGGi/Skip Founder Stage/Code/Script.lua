-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	Msg("ColonyApprovalPassed")
	g_ColonyNotViableUntil = -1
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

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
