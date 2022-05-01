-- See LICENSE for terms

local PlaceResourcePile = PlaceResourcePile
local DoneObject = DoneObject
local Sleep = Sleep
local CreateRealTimeThread = CreateRealTimeThread

function OnMsg.ColonistDied(colonist)
	PlaceResourcePile(colonist:GetVisualPos(), "Food", 1000)

	-- gotta wait for a tad else log gets spammed with changepath and other stuff
	CreateRealTimeThread(function()
		Sleep(100)
		colonist:Done()
		DoneObject(colonist)
	end)

end
