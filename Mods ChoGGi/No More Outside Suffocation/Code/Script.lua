-- See LICENSE for terms

local mod_EnableMod
-- some stuff checks one some other...
local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local function StartupCode()
	local lotta_sols = const.Scale.sols * 100

	local time = mod_EnableMod and lotta_sols or 120000
	SetConstsG("OxygenMaxOutsideTime", time)

	time = mod_EnableMod and lotta_sols or 180000
	SetConstsG("WaterMaxOutsideTime", time)
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
