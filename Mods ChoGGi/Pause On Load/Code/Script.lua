function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		UICity:SetGameSpeed(0)
	end)
end

function OnMsg.LoadGame()
	UICity:SetGameSpeed(0)
end
