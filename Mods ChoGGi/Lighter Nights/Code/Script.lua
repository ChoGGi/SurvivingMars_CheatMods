-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	local lm = LightmodelPresets
	if mod_EnableMod then
		lm.TheMartian_Evening.sun_intensity = 50 * 2
		lm.TheMartian_Night.sun_intensity = 19 * 2
		lm.TheMartian_Dawn.sun_intensity = 30
		lm.Curiosity_Night.sun_intensity = 30

		lm.ColdWave_Dawn.sun_intensity = 30
		lm.DustStorm_Dawn.sun_intensity = 30
		lm.GreatDustStorm_Dawn.sun_intensity = 30

	else
		lm.TheMartian_Evening.sun_intensity = 50
		lm.TheMartian_Night.sun_intensity = 19
		lm.TheMartian_Dawn.sun_intensity = 0
		lm.Curiosity_Night.sun_intensity = 20

		lm.ColdWave_Dawn.sun_intensity = 0
		lm.DustStorm_Dawn.sun_intensity = 0
		lm.GreatDustStorm_Dawn.sun_intensity = 0
	end

end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
