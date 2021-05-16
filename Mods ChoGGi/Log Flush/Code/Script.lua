-- See LICENSE for terms

local options
local mod_NewDay
local mod_NewHour
local mod_NewMinute
local mod_NewRender

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_NewDay = options:GetProperty("NewDay")
	mod_NewHour = options:GetProperty("NewHour")
	mod_NewMinute = options:GetProperty("NewMinute")
	mod_NewRender = options:GetProperty("NewRender")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local OnMsg = OnMsg
local FlushLogFile = FlushLogFile

-- early as possible
FlushLogFile()

-- errors from mods? no...
OnMsg.ModsReloaded = FlushLogFile

-- loaded a saved game
OnMsg.LoadGame = FlushLogFile

-- started new game
OnMsg.CityStart = FlushLogFile

-- and for good measure.
OnMsg.ReloadLua = FlushLogFile

OnMsg.ClassesGenerate = FlushLogFile
OnMsg.ClassesPreprocess = FlushLogFile
OnMsg.ClassesPostprocess = FlushLogFile
OnMsg.ClassesBuilt = FlushLogFile

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

-- I wouldn't... (it works fine though)
function OnMsg.OnRender()
	if mod_NewRender then
		FlushLogFile()
	end
end
