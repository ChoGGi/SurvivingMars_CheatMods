-- See LICENSE for terms

local options
local mod_NewDay
local mod_NewHour
local mod_NewMinute

-- fired when settings are changed and new/load
local function ModOptions()
	mod_NewDay = options.NewDay
	mod_NewHour = options.NewHour
	mod_NewMinute = options.NewMinute
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_LogFlush" then
		return
	end

	ModOptions()
end

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
function OnMsg.NewDay()
	if mod_NewDay then
		FlushLogFile()
	end
end

-- that's a bit much
function OnMsg.NewHour()
	if mod_NewHour then
		FlushLogFile()
	end
end

-- now you're just acting crazy
function OnMsg.NewMinute()
	if mod_NewMinute then
		FlushLogFile()
	end
end

-- I wouldn't...
--~ OnMsg.OnRender = FlushLogFile
