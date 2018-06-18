local FlushLogFile = FlushLogFile

function OnMsg.LoadGame()
  FlushLogFile()
end
function OnMsg.CityStart()
  FlushLogFile()
end

--and for good measure
function OnMsg.ReloadLua()
  FlushLogFile()
end

function OnMsg.NewDay()
  FlushLogFile()
end

--i left this one commented out as it happens a bit too often
--~ function OnMsg.NewHour()
--~   FlushLogFile()
--~ end
