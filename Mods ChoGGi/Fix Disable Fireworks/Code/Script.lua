local function StartupCode()
	hr.ShowFireworks = 0
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
