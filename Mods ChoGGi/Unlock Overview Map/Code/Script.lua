-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	ActiveMapData.IsAllowedToEnterOverview = true
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- switch between different maps
OnMsg.ChangeMapDone = StartupCode


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end

	StartupCode()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
