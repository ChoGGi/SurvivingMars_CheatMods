-- TESTING123
local luarev = LuaRevision > 1001586
if luarev then
	assert = empty_func
end

-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2021] [ChoGGi]

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

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
	-- anyone examining ChoGGi will see this first
	_LICENSE = LICENSE,
	-- easy access to them
	id_lib = CurrentModId,
	def_lib = CurrentModDef,
	-- Is ECM shanghaied by the blacklist?
	blacklist = true,
	-- constants
	Consts = {InvalidPos = InvalidPos()},
	-- default ECM settings
	Defaults = false,
	-- means of communication
	email = "SM_Mods@choggi.org",
	-- font used for various UI stuff
	font = "droid",
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- path to this mods' folder
	library_path = CurrentModPath,
	-- stores my strings, and edited sm ones
	Strings = {},
	-- easier access to some data
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
	-- stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,
	-- for text dumping (yep .pc means windows desktop, i guess .linux/.osx aren't personal computers)
	newline = Platform.pc and "\r\n" or "\n",
	-- CommonFunctions.lua/ECM_Functions.lua
	ComFuncs = {
		-- thanks for replacing concat... what's wrong with using table.concat2?
		TableConcat = rawget(_G, "oldTableConcat") or table.concat,
		DebugGetInfo = format_value,
	},
	-- orig funcs that get replaced
	OrigFuncs = {},
	-- /Menus/*
	MenuFuncs = {},
	-- InfoPaneCheats.lua
	InfoFuncs = {},
	-- Defaults.lua
	SettingFuncs = {},
	-- ConsoleFuncs.lua
	ConsoleFuncs = {},
	-- temporary... stuff
	Temp = {
		-- collect error msgs to be displayed in console after game is loaded
		StartupMsgs = {},
		-- a list of menuitems and shortcut keys for Msg("ShortcutsReloaded")
		Actions = {},
		-- rememeber transparency for some of my dialogs (ex and console log)
		transp_mode = false,
		-- stores a table of my dialogs
		Dialogs = {},
		-- they changed it once, they can change it again (trans func returns this for fail)
		missing_text = "Missing text",
	},
	-- settings that are saved to settings_file
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
		-- saved Consts settings
		Consts = {},
	},
}

do -- translate (todo update code to not need this, maybe use T() for menus)
	local locale_path = ChoGGi.library_path .. "Locales/"
	-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path .. ChoGGi.lang .. ".csv") then
		LoadTranslationTableFile(locale_path .. "English.csv")
	end

	Msg("TranslationChanged")
end -- do

-- fake mod used to tell if it's my comp, if you want some extra msgs and .testing funcs have at it
if Mods.ChoGGi_testing then
	ChoGGi.testing = {}
	local print = print
	function printC(...)
		print(...)
	end
else
	printC = empty_func
end

-- TESTING123
if luarev then
	return
end

-- get rid of log spam from RCTransport:Automation_Gather()
-- how long are they going to leave in it? (tito was 2021-03-24)
-- DefineClass("SurfaceDepositPreciousMinerals", etc)		< ends in a ctd and I can't be bothered to dig into it
printC"RCTransport:Automation_Gather() override is still in place..."
local orig_MapFindNearest = MapFindNearest
local function fake_MapFindNearest(rover, realm, metals, concrete, polymers, minerals, func, ...)
	-- if the mineral class doesn't exist then return map func minus the log spam
	if minerals == "SurfaceDepositPreciousMinerals" then
		-- I moved polymers in front of concrete because...
		return orig_MapFindNearest(rover, realm, metals, polymers, concrete, func)
	end
	--
	return orig_MapFindNearest(rover, realm, metals, polymers, concrete, minerals, func, ...)
end

local orig_RCTransport_Automation_Gather = RCTransport.Automation_Gather
function RCTransport.Automation_Gather(...)
	MapFindNearest = fake_MapFindNearest
	orig_RCTransport_Automation_Gather(...)
	MapFindNearest = orig_MapFindNearest
end
