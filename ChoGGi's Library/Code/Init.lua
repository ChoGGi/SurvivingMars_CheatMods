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

-- thanks for replacing concat... what's wrong with using table.concat2?
local TableConcat = oldTableConcat or table.concat

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
	-- see above
	_LICENSE = LICENSE,
	-- ECM
	id = "ChoGGi_CheatMenu",
	-- constants
	Consts = false,
	-- default ECM settings
	Defaults = false,
	-- means of communication
	email = "SM_Mods@choggi.org",
	-- font used for various UI stuff
	font = "droid",
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- path to this mods' folder
	LibraryPath = CurrentModPath,
	-- i translate all my strings at startup (and a couple of the built-in ones)
	Strings = false,
	-- easier access to some data (traits,cargo,mysteries,colonist data)
	Tables = false,
	-- stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,

	-- CommonFunctions.lua
	ComFuncs = {
		TableConcat = TableConcat,
		DebugGetInfo = format_value,
	},
	-- orig funcs that get replaced
	OrigFuncs = {},
	-- /Menus/*
	MenuFuncs = {},
	-- OnMsgs.lua
	MsgFuncs = {},
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
	},
	-- settings that are saved to SettingsFile
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
	},
}
local ChoGGi = ChoGGi

do -- translate
	local locale_path = string.format("%sLocales/%s.csv",ChoGGi.LibraryPath,"%s")
	-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path:format(GetLanguage())) then
		LoadTranslationTableFile(locale_path:format("English"))
	end
	Msg("TranslationChanged")
end

if Mods.ChoGGi_testing then
	ChoGGi.testing = {}
end

function printC(...)
	if ChoGGi.testing then
		print(...)
	end
end
