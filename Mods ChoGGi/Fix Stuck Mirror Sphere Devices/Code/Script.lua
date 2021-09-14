-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SuspendPassEdits("ChoGGi.FixStuckMirrorSphereDevices.Startup")

	local DoneObject = DoneObject
	local objs = MapGet("map", "ParSystem", function(o)
		if o.polyline and o:GetParticlesName() == "PowerDecoy_Capture" then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end

	ResumePassEdits("ChoGGi.FixStuckMirrorSphereDevices.Startup")

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
