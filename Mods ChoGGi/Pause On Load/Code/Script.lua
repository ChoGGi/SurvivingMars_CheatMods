-- See LICENSE for terms

function OnMsg.CityStart()
	CreateRealTimeThread(function()
		-- just throwing them out there
		WaitMsg("MarsResume")
		Sleep(1000)
		SetGameSpeedState("pause")
	end)
end

function OnMsg.LoadGame()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		SetGameSpeedState("pause")
	end)
end