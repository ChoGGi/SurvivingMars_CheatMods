function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		SetGameSpeedState("pause")
	end)
end

function OnMsg.LoadGame()
	SetGameSpeedState("pause")
end
