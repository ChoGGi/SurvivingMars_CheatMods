-- See LICENSE for terms

-- hello
SolariaTelepresence = {
  _LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

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
SOFTWARE.]],
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_SolariaTelepresence",
  -- orig funcs that we replace
  OrigFuncs = {},
  -- CommonFunctions.lua
  ComFuncs = {},
  -- /Code/_Functions.lua
  CodeFuncs = {},
  -- /Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  -- OnMsgs.lua
  MsgFuncs = {},
  -- InfoPaneCheats.lua
  InfoFuncs = {},
  -- Defaults.lua
  SettingFuncs = {},
  -- temporary settings that aren't saved to SettingsFile
  Temp = {
    -- collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  -- settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
}

-- if we use global func more then once: make them local for that small bit o' speed
local dofile,select,tostring,table = dofile,select,tostring,table

local SolariaTelepresence = SolariaTelepresence
local Mods = Mods
SolariaTelepresence._VERSION = Mods[SolariaTelepresence.id].version
SolariaTelepresence.ModPath = Mods[SolariaTelepresence.id].path
SolariaTelepresence.MountPath = SolariaTelepresence.ModPath

-- thanks for replacing concat...
SolariaTelepresence.ComFuncs.TableConcat = oldTableConcat or table.concat
local TConcat = SolariaTelepresence.ComFuncs.TableConcat

local AsyncFileOpen = AsyncFileOpen
function SolariaTelepresence.ComFuncs.FileExists(file)
  return select(2,AsyncFileOpen(file))
end

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)

-- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
-- which means this is faster, and uses less memory
local concat_table = {}
local concat_value
function SolariaTelepresence.ComFuncs.Concat(...)
  -- reuse old table if it's not that big, else it's quicker to make new one
  if #concat_table > 1000 then
    concat_table = {}
  else
    table.iclear(concat_table) -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
  end
  -- build table from args
  for i = 1, select("#",...) do
    concat_value = select(i,...)
      if type(concat_value) == "string" or type(concat_value) == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TConcat(concat_table)
end
local Concat = SolariaTelepresence.ComFuncs.Concat

local function LoadLocale(file)
  if not pcall(function()
    LoadTranslationTableFile(file)
  end) then
    DebugPrintNL(Concat("Problem loading locale: ",file,"\n\nPlease send me this log file ",SolariaTelepresence.email))
  end
end

-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = Concat(SolariaTelepresence.ModPath,"Locales/",GetLanguage(),".csv")
if SolariaTelepresence.ComFuncs.FileExists(locale_file) then
  LoadLocale(locale_file)
else
  LoadLocale(Concat(SolariaTelepresence.ModPath,"Locales/","English.csv"))
end
Msg("TranslationChanged")

dofolder_files(Concat(SolariaTelepresence.ModPath,"Code/"))

