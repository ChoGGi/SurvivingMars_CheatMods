local lightmodel = "Dreamers_Morning"
--[[
use ECM and in the console type ~DataInstances.Lightmodel to see all of them
or use ECM>Menu>Game>Lightmodel

you can also use:
Dreamers_Dawn
Dreamers_Dusk
Dreamers_Evening
Dreamers_Night
Dreamers_Night Green
Dreamers_Noon
]]

local SetLightmodelOverride = SetLightmodelOverride

local function OverrideIt()
	CreateRealTimeThread(function()
		Sleep(100)
		SetLightmodelOverride(1, lightmodel)
	end)
end

OnMsg.CityStart = OverrideIt
OnMsg.LoadGame = OverrideIt
OnMsg.AfterLightmodelChange = OverrideIt

local orig_ClosePlanetCamera = ClosePlanetCamera
function ClosePlanetCamera(...)
	OverrideIt()
	return orig_ClosePlanetCamera(...)
end
