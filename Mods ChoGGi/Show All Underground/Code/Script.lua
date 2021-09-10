-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	UIColony:RevealUndergroundDarkness()
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- check for being fired early with UICity
--~ OnMsg.ChangeMapDone = StartupCode
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- switch between different maps
OnMsg.ChangeMapDone = StartupCode
