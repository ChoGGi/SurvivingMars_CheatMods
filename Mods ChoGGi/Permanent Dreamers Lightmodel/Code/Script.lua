-- See LICENSE for terms

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

local function OverrideIt()
	CreateRealTimeThread(function()
		WaitMsg("AfterLightmodelChange", 10000)
		SetLightmodelOverride(1, lightmodel)
	end)
end

OnMsg.CityStart = OverrideIt
OnMsg.LoadGame = OverrideIt

function OnMsg.AfterLightmodelChange()
	CreateRealTimeThread(function()
--~ 		Sleep(100)
		WaitMsg("OnRender")
		SetLightmodelOverride(1, lightmodel)
	end)
end

local ChoOrig_ClosePlanetCamera = ClosePlanetCamera
function ClosePlanetCamera(...)
	OverrideIt()
	return ChoOrig_ClosePlanetCamera(...)
end
