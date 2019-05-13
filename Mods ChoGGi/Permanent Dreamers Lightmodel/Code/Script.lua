local lightmodel = "Dreamers_Morning"
--[[
use ECM and in the console type ~DataInstances.Lightmodel to see all of them
or just use Menu>Game>Lightmodels

you can also use:
Dreamers_Dawn
Dreamers_Dusk
Dreamers_Evening
Dreamers_Night
Dreamers_Night Green
Dreamers_Noon
--]]

local SetLightmodelOverride = SetLightmodelOverride
local DelayedCall = DelayedCall

function OnMsg.CityStart()
  SetLightmodelOverride(1, lightmodel)
end

function OnMsg.LoadGame()
  SetLightmodelOverride(1, lightmodel)
end

local orig_ClosePlanetCamera = ClosePlanetCamera
function ClosePlanetCamera(planet)
  -- needs a slight delay
	DelayedCall(100, function()
    SetLightmodelOverride(1, lightmodel)
  end)
  return orig_ClosePlanetCamera(planet)
end
