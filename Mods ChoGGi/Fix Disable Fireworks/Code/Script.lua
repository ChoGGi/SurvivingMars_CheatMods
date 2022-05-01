local function StartupCode()
	hr.ShowFireworks = 0
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- since that didn't work then goodbye func
Dome.TriggerFireworks = empty_func

-- this will cause some log spam, but hey no log on xbox
GetRandomFirework = empty_func
