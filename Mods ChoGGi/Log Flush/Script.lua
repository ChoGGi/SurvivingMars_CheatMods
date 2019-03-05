local OnMsg = OnMsg
local FlushLogFile = FlushLogFile

-- early as possible
FlushLogFile()

OnMsg.ModsReloaded = FlushLogFile

-- loaded a saved game
OnMsg.LoadGame = FlushLogFile

-- started new game
OnMsg.CityStart = FlushLogFile

-- and for good measure.
OnMsg.ReloadLua = FlushLogFile

-- a daily flush is good for the sol.
OnMsg.NewDay = FlushLogFile

--~ OnMsg.NewHour = FlushLogFile

--~ OnMsg.NewMinute = FlushLogFile
