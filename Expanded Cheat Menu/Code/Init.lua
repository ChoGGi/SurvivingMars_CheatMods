-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) 2018-2022 ChoGGi

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

ChoGGi._LICENSE = LICENSE

local ChoGGi = ChoGGi
local def = CurrentModDef

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
local orig_cmdline = Platform.cmdline
Platform.cmdline = true

-- Wait for g_ConsoleFENV
local Sleep = Sleep
CreateRealTimeThread(function()
	if not g_ConsoleFENV then
		WaitMsg("Autorun")
	end
	while not g_ConsoleFENV do
		Sleep(250)
	end

	-- Might as well reset it
	Platform.cmdline = orig_cmdline

	local env = g_ConsoleFENV._G
	ChoGGi.blacklist = false
	Msg("ChoGGi_UpdateBlacklistFuncs", env)

	-- Make my mods have access
	local lib_env = ChoGGi.def_lib.env
	lib_env._G = env
	lib_env.rawget = env.rawget
	lib_env.getmetatable = env.getmetatable
	lib_env.os = env.os
	--
	lib_env = ChoGGi.def.env
	lib_env._G = env
	lib_env.rawget = env.rawget
	lib_env.getmetatable = env.getmetatable
	lib_env.os = env.os

	ChoGGi.ComFuncs.FileExists = env.io.exists
end)

-- I should really split ChoGGi into funcs and settings... one of these days
ChoGGi.id = CurrentModId
ChoGGi.def = def
ChoGGi._VERSION = "v" .. def.version_major .. "." .. def.version_minor
-- Path to this mods' folder
ChoGGi.mod_path = def.env.CurrentModPath or def.content_path or def.path
-- Console>Scripts folder
ChoGGi.scripts = "AppData/ECM Scripts"
-- You can pry my settings FILE from my cold dead (and not modding SM anymore) hands.
ChoGGi.settings_file = "AppData/CheatMenuModSettings.lua"

if ChoGGi.blacklist then
	ChoGGi.ComFuncs.FileExists = empty_func
else
	ChoGGi.ComFuncs.FileExists = io.exists
end
