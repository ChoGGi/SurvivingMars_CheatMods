-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) 2018-2025 ChoGGi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- before GP means black screen after mods loaded
-- Use older version of mod
if LuaRevision < 249143 then
	return
end

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
	-- Anyone examining ChoGGi will see this first
	_LICENSE = LICENSE,
	-- Easy access to them
	id_lib = CurrentModId,
	def_lib = CurrentModDef,
	-- Is ECM shanghaied by the blacklist?
	blacklist = true,
	-- Constants
	Consts = {InvalidPos = InvalidPos()},
	-- Default ECM settings
	Defaults = false,
	-- Means of communication
	email = "SurvivingMarsMods@choggi.org",
	-- Font used for various UI stuff
	font = "droid",
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- Path to this mods' folder
	library_path = CurrentModPath,
	-- Easier access to some data
	Tables = {
		Cargo = {},
		CargoPresets = {},
		ColonistAges = {},
		ColonistBirthplaces = {},
		ColonistGenders = {},
		ColonistSpecializations = {},
		Mystery = {},
		NegativeTraits = {},
		OtherTraits = {},
		PositiveTraits = {},
		Resources = {},
		SchoolTraits = {},
		SanatoriumTraits = {},
		Sponsors = {},
		Commanders = {},
		ConstructionStatus = {},
		-- don't want to have to declare these more than i have to
		const_names = {
			"BreakThroughTechsPerGame",
			"CommandCenterMaxRadius",
			"DroneBatteryMax",
			"DroneRestrictRadius",
			"ExplorationQueueMaxSize",
			"fastGameSpeed",
			"MaxToxicRainPools",
			"mediumGameSpeed",
			"MoistureVaporatorPenaltyPercent",
			"MoistureVaporatorRange",
			"OmegaTelescopeBreakthroughsCount",
			"RCRoverMaxRadius",
			"ResearchQueueSize",
		},
	},
	-- Stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,
	-- For text dumping (yep .pc means windows desktop, I guess .linux/.osx aren't personal computers)
	newline = Platform.pc and "\r\n" or Platform.linux and "\n" or "\r",
	-- Pre Abstraction Games (Before Tourism update rev 1,001,514)
	is_gp = LuaRevision < 1001000,
	-- temporary... stuff
	Temp = {
		-- Collect error msgs to be displayed in console after game is loaded
		StartupMsgs = {},
		-- A list of menuitems and shortcut keys for Msg("ShortcutsReloaded")
		Actions = {},
		-- Rememeber transparency for some of my dialogs (ex and console log)
		Dlg_transp_mode = false,
		-- Stores a table of my dialogs
		Dialogs = {},
		-- They changed it once, they can change it again (tranlation func returns this for fail)
		missing_text = "Missing text",
	},
	-- Settings that are saved to settings_file
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
		-- Saved Consts settings
		Consts = {},
	},
}
--
local ChoGGi = ChoGGi

ChoGGi_Funcs = {
	_LICENSE = LICENSE,

	-- CommonFunctions.lua/ECM_Functions.lua
	Common = {
		DebugGetInfo = format_value,
	},
	-- store orig funcs that get replaced
	Original = {},
	-- /Menus/*
	Menus = {},
	-- InfoPaneCheats.lua
	InfoPane = {},
	-- Settings.lua
	Settings = {},
	-- ConsoleFuncs.lua
	Console = {},
}
-- Backwards compat for my mods till I update them all
local ChoGGi_Funcs = ChoGGi_Funcs
ChoGGi.ComFuncs = ChoGGi_Funcs.Common
ChoGGi.OrigFuncs = ChoGGi_Funcs.Original
ChoGGi.MenuFuncs = ChoGGi_Funcs.Menus
ChoGGi.InfoFuncs = ChoGGi_Funcs.InfoPane
ChoGGi.SettingFuncs = ChoGGi_Funcs.Settings
ChoGGi.ConsoleFuncs = ChoGGi_Funcs.Console

-- What game are we playing?
local c = const
if c.HaeraldProjectName and c.HaeraldProjectName == "Mars" then
	-- Surviving Mars
	ChoGGi.what_game = "Mars"
elseif c.HaeraldProjectName and c.HaeraldProjectName == "FVH" then
	-- Victor Vran
	ChoGGi.what_game = "VV"
elseif c.ProjectName and c.ProjectName == "Zulu" then
	-- Jagged Alliance 3
	ChoGGi.what_game = "JA3"
elseif c.ProjectName and c.ProjectName == "Bacon" then
	-- Stranded: Alien Dawn
	ChoGGi.what_game = "SAD"
else
	ChoGGi.what_game = "Unknown"
end
-- It's called Sol Engine (used to be called HGEngine till SM came out and someone decided it needed a name)

do -- Translate (todo update code to not need this, maybe use T() for menus)
	local locale_path = ChoGGi.library_path .. "Locales/"
	-- Load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path .. ChoGGi.lang .. ".csv") then
		LoadTranslationTableFile(locale_path .. "English.csv")
	end

	Msg("TranslationChanged")
end -- do

-- Fake mod used to tell if it's my comp, if you want some extra msgs and .testing funcs have at it (Testing.lua)
if Mods.ChoGGi_testing or Mods.TESTING then
	local print = print
	local FlushLogFile = FlushLogFile

	ChoGGi.testing = {}
	printC = function(...)
		print(...)
		FlushLogFile()
	end
else
	printC = empty_func
end

-- Maybe they'll update the game again?
--~ -- Is ECM shanghaied by the blacklist?
--~ if def.no_blacklist then
--~ 	ChoGGi.blacklist = false
--~ 	local env = def.env
--~ 	Msg("ChoGGi_UpdateBlacklistFuncs", env)
--~ 	-- make lib mod have access as well
--~ 	local lib_env = ChoGGi.def_lib.env
--~ 	lib_env._G = env._G
--~ 	lib_env.rawget = env.rawget
--~ 	lib_env.getmetatable = env.getmetatable
--~ 	lib_env.os = env.os
--~ end

-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!]]}

-- Used to bypass blacklist
local ChoOrig_cmdline = Platform.cmdline
Platform.cmdline = true

-- Wait for g_ConsoleFENV
CreateRealTimeThread(function()
	if not g_ConsoleFENV then
		WaitMsg("Autorun")
	end
	while not g_ConsoleFENV do
		Sleep(250)
	end
	-- Might as well reset it?
	Platform.cmdline = ChoOrig_cmdline
	--
	local env = g_ConsoleFENV._G
--~ 	env.ModEnvBlacklist = {--[[Harumph!]]}
	ChoGGi.blacklist = false
	Msg("ChoGGi_UpdateBlacklistFuncs", env)

	-- Make my mods have access
	local lib_env = ChoGGi.def_lib.env
	lib_env._G = env
	lib_env.rawget = env.rawget
	lib_env.getmetatable = env.getmetatable
	lib_env.os = env.os
	--
	if ChoGGi.def then
		lib_env = ChoGGi.def.env
		lib_env._G = env
		lib_env.rawget = env.rawget
		lib_env.getmetatable = env.getmetatable
		lib_env.os = env.os
	end

	ChoGGi_Funcs.Common.FileExists = env.io.exists
	if ChoGGi.testing then
		ChoGGi.env = env
	end

end)
