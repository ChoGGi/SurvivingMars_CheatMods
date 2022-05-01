-- See LICENSE for terms

local table = table

local mod_EnableMod
local mod_LessDust

local function RemoveParticle(list, id)
	local idx = table.find(list, "Particles", id)
	if idx then
		RemoveFromRules(list[idx])
		table.remove(list, idx)
	end
end

local launch_particles = {
	Rocket_Launch = true,
	Rocket_LaunchWave = true,
	Rocket_LaunchWave_Middle = true,
}

local function DisableParticles()
	if not mod_EnableMod then
		return
	end

	RemoveParticle(FXRules.RocketLand["pre-hit-ground2"].FXRocket.any, "Rocket_LandSmoke_02")

	if not mod_LessDust then
		RemoveParticle(FXRules.RocketLand["pre-hit-ground"].FXRocket.any, "Rocket_LandSmoke")
	end

	local list = FXRules.RocketLaunch.start.FXRocket.any
	for i = #list, 1, -1 do
		local particle = list[i].Particles
		if launch_particles[particle] then
			RemoveFromRules(particle)
			table.remove(list, i)
		end
	end

end
OnMsg.CityStart = DisableParticles
OnMsg.LoadGame = DisableParticles

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_LessDust = CurrentModOptions:GetProperty("LessDust")

	-- make sure we're in-game
	if not UICity then
		return
	end
	DisableParticles()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
