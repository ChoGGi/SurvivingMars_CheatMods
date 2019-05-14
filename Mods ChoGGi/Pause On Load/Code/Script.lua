-- See LICENSE for terms

local function StartUp()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		SetGameSpeedState("pause")
	end)
end
OnMsg.LoadGame = StartUp
OnMsg.CityStart = StartUp
