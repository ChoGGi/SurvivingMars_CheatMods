-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!--]]}
-- yeah i know it don't do jack shit your point?

-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

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

-- if we use global func more then once: make them local for that small bit o' speed
local select,tostring,type,table = select,tostring,type,table
local id,Mods,FileExists = "ChoGGi_CheatMenu",Mods
local blacklist = Mods[id].env

-- thanks for replacing concat... what's wrong with using table.concat2?
local TableConcat = oldTableConcat or table.concat

if not blacklist then
	local AsyncGetFileAttribute = AsyncGetFileAttribute

	FileExists = function(file)
		-- AsyncFileOpen may not work that well under linux?
		local err,_ = AsyncGetFileAttribute(file,"size")
		if not err then
			return true
		end
	end
end

-- this is used instead of "str .. str"; anytime you do that lua will check for the hashed string, if not then hash the new string, and store it till exit (which means this is faster, and uses less memory)
local concat_table = {}
local function Concat(...)
	-- sm devs added a c func to clear tables, which does seem to be faster than a lua loop
	table.iclear(concat_table)
	-- build table from args
	local concat_value
	local concat_type
	for i = 1, select("#",...) do
		concat_value = select(i,...)
		-- no sense in calling a func more then we need to
		concat_type = type(concat_value)
		if concat_type == "string" or concat_type == "number" then
			concat_table[i] = concat_value
		else
			concat_table[i] = tostring(concat_value)
		end
	end
	-- and done
	return TableConcat(concat_table)
end

--~ ChoGGi.CodeFuncs.TestConcatExamine()

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
	-- see above
	_LICENSE = LICENSE,
	-- get version of mod from metadata.lua
	_VERSION = Mods[id].version,
	-- is ECM shanghaied by the blacklist?
	blacklist = blacklist,
	-- constants
	Consts = false,
	-- default ECM settings
	Defaults = false,
	-- means of communication
	email = "SM_Mods@choggi.org",
	-- font used for various UI stuff
	font = "droid",
	-- used to access Mods[id]
	id = id,
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- path to this mods' folder
	ModPath = blacklist and CurrentModPath or Mods[id].content_path or Mods[id].path,
	-- Console>Scripts folder
	scripts = "AppData/ECM Scripts",
	-- you can pry my settings FILE from my cold dead (and not modding sm anymore) hands.
	SettingsFile = blacklist and nil or "AppData/CheatMenuModSettings.lua",
	-- i translate all my strings at startup (and a couple of the built-in ones
	Strings = false,
	-- easy access to some data (traits,cargo,mysteries,colonist data)
	Tables = false,
	-- stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,

	-- CommonFunctions.lua
	ComFuncs = {
		FileExists = FileExists,
		TableConcat = TableConcat,
		Concat = Concat,
		DebugGetInfo = format_value,
	},
	-- orig funcs that get replaced
	OrigFuncs = {},
	-- _Functions.lua
	CodeFuncs = {},
	-- /Menus/*
	MenuFuncs = {},
	-- OnMsgs.lua
	MsgFuncs = {},
	-- InfoPaneCheats.lua
	InfoFuncs = {},
	-- Defaults.lua
	SettingFuncs = {},
	-- ConsoleControls.lua
	Console = {},
	-- temporary... stuff
	Temp = {
		-- collect error msgs to be displayed in console after game is loaded
		StartupMsgs = {},
		-- a list of menuitems and shortcut keys for Msg("ShortcutsReloaded")
		Actions = {},
	},
	-- settings that are saved to SettingsFile
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
	},
}
local ChoGGi = ChoGGi

do -- translate
	local locale_path = Concat(ChoGGi.ModPath,"Locales/%s.csv")
	-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path:format(GetLanguage())) then
		LoadTranslationTableFile(locale_path:format("English"))
	end
	Msg("TranslationChanged")
end

if Mods.ChoGGi_testing then
	ChoGGi.testing = true
end

local Platform = Platform
Platform.editor = true

-- fixes UpdateInterface nil value in editor mode
local d_before = Platform.developer
Platform.developer = true
editor.LoadPlaceObjConfig()
Platform.developer = d_before

-- needed for HashLogToTable(), SM was planning to have multiple cities (or from a past game from this engine)?
GlobalVar("g_Cities",{})
-- editor wants a table
GlobalVar("g_revision_map",{})
-- stops some log spam in editor (function doesn't exist in SM)
function UpdateMapRevision()end
function AsyncGetSourceInfo()end
