--~ -- be nice to get a remote debugger working
--~ Platform.editor = true
--~ config.LuaDebugger = true
--~ GlobalVar("outputSocket", false)
--~ dofile("CommonLua/Core/luasocket.lua")
--~ dofile("CommonLua/Core/luadebugger.lua")
--~ outputSocket = LuaSocket:new()
--~ outputThread = false
--~ dofile("CommonLua/Core/luaDebuggerOutput.lua")
--~ dofile("CommonLua/Core/ProjectSync.lua")
--~ config.LuaDebugger = false

-- hello
ChoGGi = {
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
  id = "ChoGGi_CheatMenu",
  scripts = "AppData/ECM Scripts",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  -- orig funcs that we replace
  OrigFuncs = {},
  -- CommonFunctions.lua
  ComFuncs = {
    FileExists = function(file)
      return select(2,AsyncFileOpen(file))
--~       return not AsyncFileToString(file)
    end,
  },
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
-- thanks for replacing concat...
ChoGGi.ComFuncs.TableConcat = oldTableConcat or table.concat
local TConcat = ChoGGi.ComFuncs.TableConcat

local AsyncFileOpen = AsyncFileOpen
local dofolder_files = dofolder_files

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)

-- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
-- which means this is faster, and uses less memory
local concat_table = {}
local concat_value
function ChoGGi.ComFuncs.Concat(...)
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

local ChoGGi = ChoGGi
local Mods = Mods
ChoGGi._VERSION = Mods[ChoGGi.id].version
ChoGGi.ModPath = Mods[ChoGGi.id].path
local Concat = ChoGGi.ComFuncs.Concat
local FileExists = ChoGGi.ComFuncs.FileExists

-- used to let me know if we're on my computer
if FileExists("AppData/ChoGGi") then
  ChoGGi.Temp.Testing = true

  ChoGGi.MountPath = Concat(ChoGGi.ModPath,"Files/")
  -- from here to the end of OnMsg.ChoGGi_Loaded()
  ChoGGi.Temp.StartupTicks = GetPreciseTicks()
else
  if FileExists(Concat(ChoGGi.ModPath,"Defaults.lua")) then
    -- if file exists then user likely unpacked the files, and moved them up a dir
    ChoGGi.MountPath = ChoGGi.ModPath
  else
    -- load up the hpk
    AsyncMountPack("ChoGGi_Mount",Concat(ChoGGi.ModPath,"Files.hpk"))
    ChoGGi.MountPath = "ChoGGi_Mount/"
  end
end

-- functions that need to be loaded before they get called...
dofile(Concat(ChoGGi.MountPath,"CommonFunctions.lua"))
-- get saved settings for this mod
dofile(Concat(ChoGGi.MountPath,"Defaults.lua"))
-- new ui classes
dofolder_files(Concat(ChoGGi.MountPath,"Dialogs"))
-- OnMsgs and functions that don't need to be in CommonFunctions
dofolder_files(Concat(ChoGGi.MountPath,"Code"))
-- menus... (ok and keys)
dofolder_files(Concat(ChoGGi.MountPath,"Menus"))

local T = ChoGGi.ComFuncs.Trans

local function LoadLocale(file)
  if not pcall(function()
    LoadTranslationTableFile(file)
  end) then
    DebugPrintNL(Concat("Problem loading locale: ",file,"\n\nPlease send me this log file ",ChoGGi.email))
  end
end

-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = Concat(ChoGGi.ModPath,"Locales/",GetLanguage(),".csv")
if FileExists(locale_file) then
  LoadLocale(locale_file)
else
  LoadLocale(Concat(ChoGGi.ModPath,"Locales/","English.csv"))
end
Msg("TranslationChanged")

-- read settings from AppData/CheatMenuModSettings.lua
ChoGGi.SettingFuncs.ReadSettings()

--bloody hint popups
if ChoGGi.UserSettings.DisableHints then
  mapdata.DisableHints = true
  HintsEnabled = false
end

-- why would anyone ever turn this off? console logging ftw, and why did the devs make their log print only after quitting...!? unless of course it crashes in certain ways, then fuck you no log for you...
if ChoGGi.Temp.Testing then
  ChoGGi.UserSettings.WriteLogs = true
end

-- if writelogs option
if ChoGGi.UserSettings.WriteLogs then
--~   ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = "<color 200 200 200>ECM</color><color 0 0 0>: </color><color 128 255 128>Writing debug/console logs to AppData/logs</color>"
  ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
end

-- first time run info
if ChoGGi.UserSettings.FirstRun ~= false then
  ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat("<color 200 200 200>",T(302535920000000--[[Expanded Cheat Menu--]]),"</color> ",T(302535920000201--[[Active--]]),"<color 0 0 0>:</color>\n<color 128 255 128>",T(302535920000001--[[F2 to toggle cheats menu\"Debug>Console: Toggle On-Screen Log\" to toggle this console history.--]]),"</color>")
  ChoGGi.UserSettings.FirstRun = false
  ChoGGi.Temp.WriteSettings = true
end

local Platform = Platform

Platform.editor = true

local d_before = Platform.developer
Platform.developer = true
-- fixes UpdateInterface nil value in editor mode
editor.LoadPlaceObjConfig()
-- some error it gives about missing table
GlobalVar("g_revision_map",{})
Platform.developer = d_before

--~ ClassesGenerate
--~ ClassesPreprocess
--~ ClassesPostprocess
--~ ClassesBuilt
--~ OptionsApply
--~ Autorun
--~ ModsLoaded
--~ EntitiesLoaded
--~ BinAssetsLoaded
