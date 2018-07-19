local OnMsg = OnMsg
local FlushLogFile = FlushLogFile

-- early as possible
FlushLogFile()

function OnMsg.ModsLoaded()
  FlushLogFile()
end

-- loaded a saved game
function OnMsg.LoadGame()
  FlushLogFile()
end

-- started new game
function OnMsg.CityStart()
  FlushLogFile()
end

-- and for good measure.
function OnMsg.ReloadLua()
  FlushLogFile()
end

-- daily flush is good for the sol.
function OnMsg.NewDay()
  FlushLogFile()
end

--~ function OnMsg.NewHour()
--~   FlushLogFile()
--~ end

--~ function OnMsg.NewMinute()
--~   FlushLogFile()
--~ end
