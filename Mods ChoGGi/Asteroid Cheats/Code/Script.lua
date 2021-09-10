-- See LICENSE for terms

local mod_EnableMod
--~ local mod_ResetTimers
local mod_UnlockAsteroids
local mod_SpawnAsteroids
local mod_AddAsteroidTime

local function StartupCode()
	if not mod_EnableMod then
		return
	end
	local UIColony = UIColony

	if mod_UnlockAsteroids then
		UIColony:UnlockAsteroids()
	end
	if mod_SpawnAsteroids > 0 then
		for _ = 1, mod_SpawnAsteroids do
			local asteroid = table.rand(Presets.DiscoveryAsteroidPreset.Default)
			UIColony:SpawnAsteroid(asteroid)
		end
	end
	if mod_AddAsteroidTime > 0 then
		local sols = mod_AddAsteroidTime * const.Scale.sols
		local asteroids = UIColony.asteroids
		for i = 1, #asteroids do
			local asteroid = asteroids[i]
			asteroid.end_time = asteroid.end_time + sols
		end
	end
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
--~ 	mod_ResetTimers = CurrentModOptions:GetProperty("ResetTimers")
	mod_UnlockAsteroids = CurrentModOptions:GetProperty("UnlockAsteroids")
	mod_SpawnAsteroids = CurrentModOptions:GetProperty("SpawnAsteroids")
	mod_AddAsteroidTime = CurrentModOptions:GetProperty("AddAsteroidTime")

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

--~ OnMsg.CityStart = StartupCode
--~ OnMsg.LoadGame = StartupCode
--~ -- switch between different maps
--~ OnMsg.ChangeMapDone = StartupCode
