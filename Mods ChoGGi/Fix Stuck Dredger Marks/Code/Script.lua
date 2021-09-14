-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

GlobalVar("g_ChoGGi_FixStuckDredgerMarks", false)

local function StartupCode()
	if g_ChoGGi_FixStuckDredgerMarks then
		return
	end

	if not mod_EnableMod then
		return
	end

	local function HasParticles(par)
		return par:GetParticlesName() == "Rocket_Landing_Pos_02"
	end

	local markers = MapGet("map", "AlienDiggerMarker")
	for i = 1, #markers do
		local marker = markers[i]

		local rocket_mark = MapGet(marker:GetPos(), 0, "ParSystem", HasParticles)
		if rocket_mark[1] then
			rocket_mark[1]:delete()
		end

		marker:delete()
	end

	g_ChoGGi_FixStuckDredgerMarks = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
