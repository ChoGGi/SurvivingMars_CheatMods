-- See LICENSE for terms

local SetConsts = ChoGGi_Funcs.Common.SetConsts

local mod_EnableMod
local mod_ForcedByUserLockTimeout

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SetConsts("ForcedByUserLockTimeout", mod_ForcedByUserLockTimeout)
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

-- Switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = StartupCode
