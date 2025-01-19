-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	-- Speeds up obj manipulation
	SuspendPassEdits("ChoGGi.FixStuckMirrorSphereDevices.Startup")

	local objs = MapGet("map", "ParSystem", function(o)
		if o.polyline and o:GetParticlesName() == "PowerDecoy_Capture" then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	ResumePassEdits("ChoGGi.FixStuckMirrorSphereDevices.Startup")
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
