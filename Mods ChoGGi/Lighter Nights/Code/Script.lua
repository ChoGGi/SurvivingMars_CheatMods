-- See LICENSE for terms

local mod_EnableMod
local mod_TheMartian_Evening
local mod_TheMartian_Night
local mod_TheMartian_Dawn
local mod_ColdWave_Dawn
local mod_DustStorm_Dawn
local mod_GreatDustStorm_Dawn

local function StartupCode()
	local lm = LightmodelPresets
	if mod_EnableMod then
		lm.TheMartian_Evening.sun_intensity = mod_TheMartian_Evening
		lm.TheMartian_Night.sun_intensity = mod_TheMartian_Night
		lm.TheMartian_Dawn.sun_intensity = mod_TheMartian_Dawn
		-- I don't actually know what this lm is for, maybe used before TheMartian?
		lm.Curiosity_Night.sun_intensity = 30

		lm.ColdWave_Dawn.sun_intensity = mod_ColdWave_Dawn
		lm.DustStorm_Dawn.sun_intensity = mod_DustStorm_Dawn
		lm.GreatDustStorm_Dawn.sun_intensity = mod_GreatDustStorm_Dawn

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
	mod_TheMartian_Evening = CurrentModOptions:GetProperty("TheMartian_Evening")
	mod_TheMartian_Night = CurrentModOptions:GetProperty("TheMartian_Night")
	mod_TheMartian_Dawn = CurrentModOptions:GetProperty("TheMartian_Dawn")
	mod_ColdWave_Dawn = CurrentModOptions:GetProperty("ColdWave_Dawn")
	mod_DustStorm_Dawn = CurrentModOptions:GetProperty("DustStorm_Dawn")
	mod_GreatDustStorm_Dawn = CurrentModOptions:GetProperty("GreatDustStorm_Dawn")

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
