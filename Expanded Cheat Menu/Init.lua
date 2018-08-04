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
local dofile,select,tostring,type,table = dofile,select,tostring,type,table
local AsyncGetFileAttribute,Mods,dofolder_files = AsyncGetFileAttribute,Mods,dofolder_files

local TableConcat
-- just in case they remove oldTableConcat
pcall(function()
  TableConcat = oldTableConcat
end)
-- thanks for replacing concat... what's wrong with using table.concat2?
TableConcat = TableConcat or table.concat

local function FileExists(file)
  -- AsyncFileOpen may not work that well under linux?
  local err,_ = AsyncGetFileAttribute(file,"size")
  if not err then
    return true
  end
end

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)
-- this is also used instead of "str .. str"; anytime you do that lua will check for the hashed string, if not then hash the new string, and store it till exit (which means this is faster, and uses less memory)
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

--~ ChoGGi.CodeFuncs.TestConcat()

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
  _LICENSE = LICENSE,
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_CheatMenu",
  scripts = "AppData/ECM Scripts",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  _VERSION = Mods.ChoGGi_CheatMenu.version,
  ModPath = Mods.ChoGGi_CheatMenu.path,
  Lang = GetLanguage(),

  -- CommonFunctions.lua
  ComFuncs = {
    FileExists = FileExists,
    TableConcat = TableConcat,
    Concat = Concat,
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
    -- collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  -- settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
}
local ChoGGi = ChoGGi

do -- load script files
  -- used to let the mod know if we're on my computer
  if FileExists("AppData/ChoGGi") then
    --mostly just more logs msgs
    ChoGGi.Testing = true

    ChoGGi.MountPath = Concat(ChoGGi.ModPath,"Files/")
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
end

do -- translate
  --load up translation strings
  local function LoadLocale(file)
    if not pcall(function()
      LoadTranslationTableFile(file)
    end) then
      DebugPrintNL(string.format([[Problem loading locale: %s

Please send me latest log file: %s]],file,ChoGGi.email))
    end
  end

  -- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
  local locale_file = Concat(ChoGGi.ModPath,"Locales/",ChoGGi.Lang,".csv")
  if FileExists(locale_file) then
    LoadLocale(locale_file)
  else
    LoadLocale(Concat(ChoGGi.ModPath,"Locales/","English.csv"))
  end
  Msg("TranslationChanged")
end

do -- ECM settings
  -- translate all the strings before anything else
  dofile(Concat(ChoGGi.MountPath,"Strings.lua"))
  -- functions that need to be loaded before they get called...
  dofile(Concat(ChoGGi.MountPath,"CommonFunctions.lua"))
  -- get saved settings for this mod
  dofile(Concat(ChoGGi.MountPath,"Defaults.lua"))
  -- new ui classes
  dofolder_files(Concat(ChoGGi.MountPath,"Dialogs"))
  -- OnMsgs and functions that don't need to be in CommonFunctions
  dofolder_files(Concat(ChoGGi.MountPath,"Code"))

  -- read settings from AppData/CheatMenuModSettings.lua
  ChoGGi.SettingFuncs.ReadSettings()

  if ChoGGi.Testing or ChoGGi.UserSettings.ShowStartupTicks then
    -- from here to the end of OnMsg.ChoGGi_Loaded()
    ChoGGi.Temp.StartupTicks = GetPreciseTicks()
  end

  --bloody hint popups
  if ChoGGi.UserSettings.DisableHints then
    mapdata.DisableHints = true
    HintsEnabled = false
  end

  -- why would anyone ever turn this off? console logging ftw, and why did the devs make their log print only after quitting...!? unless of course it crashes in certain ways, then fuck you no log for you... Thank the Gods for FlushLogFile() (or whichever dev added it; Thank YOU!)
  if ChoGGi.Testing then
    ChoGGi.UserSettings.WriteLogs = true
  end

  -- if writelogs option
  if ChoGGi.UserSettings.WriteLogs then
    ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
  end

  local Platform = Platform
  Platform.editor = true

  -- fixes UpdateInterface nil value in editor mode
  local d_before = Platform.developer
  Platform.developer = true
  editor.LoadPlaceObjConfig()
  Platform.developer = d_before

  -- editor wants a table
  GlobalVar("g_revision_map",{})
  -- needed for HashLogToTable(), SM was planning to have multiple cities (or from a past game from this engine)?
  GlobalVar("g_Cities",{})

--~   ClassesGenerate
--~   ClassesPreprocess
--~   ClassesPostprocess
--~   ClassesBuilt
--~   OptionsApply
--~   Autorun
--~   ModsLoaded
--~   EntitiesLoaded
--~   BinAssetsLoaded

--~   -- be nice to get a remote debugger working
--~   Platform.editor = true
--~   config.LuaDebugger = true
--~   GlobalVar("outputSocket", false)
--~   dofile("CommonLua/Core/luasocket.lua")
--~   dofile("CommonLua/Core/luadebugger.lua")
--~   outputSocket = LuaSocket:new()
--~   outputThread = false
--~   dofile("CommonLua/Core/luaDebuggerOutput.lua")
--~   dofile("CommonLua/Core/ProjectSync.lua")
--~   config.LuaDebugger = false
end
