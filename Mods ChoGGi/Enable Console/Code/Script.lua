-- See LICENSE for terms

local mod_id = "ChoGGi_EnableConsole"
local mod = Mods[mod_id]

local mod_EnableLog = mod.options and mod.options.EnableLog or true

local function ModOptions()
	mod_EnableLog = mod.options.EnableLog

	if mod_EnableLog then
		ShowConsoleLog(true)
	else
		ShowConsoleLog(false)
	end
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

local function StartupCode()
	ConsoleEnabled = true

	-- for some reason mod options aren't retrieved before this script is loaded...
	ModOptions()
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
