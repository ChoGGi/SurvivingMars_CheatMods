-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) 2018-2023 ChoGGi

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

local ChoGGi = ChoGGi
local def = CurrentModDef

ChoGGi._LICENSE = LICENSE

-- I should really split ChoGGi into funcs and settings... one of these days
ChoGGi.id = CurrentModId
ChoGGi.def = def
ChoGGi._VERSION = "v" .. def.version_major .. "." .. def.version_minor
-- Path to this mods' folder
ChoGGi.mod_path = def.env.CurrentModPath or def.content_path or def.path
-- Console>Scripts folder
ChoGGi.scripts = "AppData/ECM Scripts"
-- You can pry my settings FILE from my cold dead hands (yeah I can toss them in localsettings... :)
--~ ChoGGi.settings_file = "AppData/CheatMenuModSettings.lua"

--~ if ChoGGi.blacklist then
--~ 	ChoGGi.ComFuncs.FileExists = empty_func
--~ else
--~ 	ChoGGi.ComFuncs.FileExists = io.exists
--~ end
