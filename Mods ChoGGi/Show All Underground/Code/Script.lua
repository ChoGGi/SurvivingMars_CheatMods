-- See LICENSE for terms

local mod_EnableMod
local mod_RevealDarkness

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	if RevealDarkness then
		hr.RenderRevealDarkness = 0
	else
		hr.RenderRevealDarkness = 1
	end
	UIColony:RevealUndergroundDarkness()
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_RevealDarkness = CurrentModOptions:GetProperty("RevealDarkness")

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
