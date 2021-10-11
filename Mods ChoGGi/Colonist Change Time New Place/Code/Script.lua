-- See LICENSE for terms

local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local mod_EnableMod
local mod_ForcedByUserLockTimeout

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SetConstsG("ForcedByUserLockTimeout", mod_ForcedByUserLockTimeout)
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ForcedByUserLockTimeout = CurrentModOptions:GetProperty("ForcedByUserLockTimeout") * const.Scale.sols

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
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = StartupCode
