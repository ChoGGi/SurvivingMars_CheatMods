--~ --be nice to get a remote debugger working
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
--~ Platform.editor = false

--hello
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
  email = "ECM@choggi.org",
  id = "ChoGGi_CheatMenu",
  scripts = "AppData/ECM Scripts",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --/Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {
    --collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  --settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
}
local ChoGGi = ChoGGi
local Mods = Mods

--if we use global func more then once: make them local for that small bit o' speed
local dofile,select,tostring,table = dofile,select,tostring,table
--thanks for replacing concat...
local TConcat = oldTableConcat or table.concat
ChoGGi.ComFuncs.TableConcat = TConcat

local AsyncFileOpen = AsyncFileOpen
local dofolder_files = dofolder_files

local concat_table = {}
local concat_value
--instead of a whole bunch of TConcat({}) making new tables we just use one
local lookup = {string=true,number=true}
function ChoGGi.ComFuncs.Concat(...)
  --reuse old table
  table.iclear(concat_table)
  --build table from args
  for i = 1, select("#",...) do
    concat_value = select(i,...)
    if lookup[type(concat_value)] then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  --and done
  return TConcat(concat_table)
--~   honestly there isn't much of a difference to replacing the above with:
--~   return TConcat({...})
--~   but now if i try to concat something that i can't it will :)
end

ChoGGi._VERSION = Mods[ChoGGi.id].version
ChoGGi._TITLE = Mods[ChoGGi.id].title
ChoGGi.ModPath = Mods[ChoGGi.id].path
local Concat = ChoGGi.ComFuncs.Concat

--used to let me know if we're on my computer
local _,test = AsyncFileOpen("AppData/ChoGGi")
if test then
  ChoGGi.Temp.Testing = true
end

if ChoGGi.Temp.Testing then
  ChoGGi.MountPath = Concat(ChoGGi.ModPath,"Files/")
  --from here to the end of OnMsg.ChoGGi_Loaded()
  ChoGGi.Temp.StartupTicks = GetPreciseTicks()
else
  local _,extracted = AsyncFileOpen(Concat(ChoGGi.ModPath,"Defaults.lua"))
  if extracted then
    --if file exists then user likely unpacked the files, and moved them up a dir
    ChoGGi.MountPath = ChoGGi.ModPath
  else
    --load up the hpk
    AsyncMountPack("ChoGGi_Mount",Concat(ChoGGi.ModPath,"Files.hpk"))
    ChoGGi.MountPath = "ChoGGi_Mount/"
  end
end

--functions that need to be loaded before they get called...
dofile(Concat(ChoGGi.MountPath,"CommonFunctions.lua"))
--get saved settings for this mod
dofile(Concat(ChoGGi.MountPath,"Defaults.lua"))
--new ui classes
dofolder_files(Concat(ChoGGi.MountPath,"Dialogs"))
--OnMsgs and functions that don't need to be in CommonFunctions
dofolder_files(Concat(ChoGGi.MountPath,"Code"))
--menus... (ok and keys)
dofolder_files(Concat(ChoGGi.MountPath,"Menus"))

local T = ChoGGi.ComFuncs.Trans

--load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = Concat(ChoGGi.ModPath,"Locales/",GetLanguage(),".csv")
local _,locale = AsyncFileOpen(locale_file)
if locale then
  LoadTranslationTableFile(locale_file)
else
  LoadTranslationTableFile(Concat(ChoGGi.ModPath,"Locales/","English.csv"))
end
Msg("TranslationChanged")

--read settings from AppData/CheatMenuModSettings.lua
ChoGGi.SettingFuncs.ReadSettings()

--bloody hint popups
if ChoGGi.UserSettings.DisableHints then
  mapdata.DisableHints = true
  HintsEnabled = false
end

--why would anyone ever turn this off? console logging ftw, and why did the devs make their log print only after quitting...!? unless of course it crashes in certain ways, then fuck you no log for you...
if ChoGGi.Temp.Testing then
  ChoGGi.UserSettings.WriteLogs = true
end

--if writelogs option
if ChoGGi.UserSettings.WriteLogs then
  --ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = "<color 200 200 200>ECM</color><color 0 0 0>: </color><color 128 255 128>Writing debug/console logs to AppData/logs</color>"
  ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
end

--first time run info
if ChoGGi.UserSettings.FirstRun ~= false then
  ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat("<color 200 200 200>",T(302535920000000--[[Expanded Cheat Menu--]]),"</color> ",T(302535920000201--[[Active--]]),"<color 0 0 0>:</color>\n<color 128 255 128>",T(302535920000001--[[F2 to toggle cheats menu\"Debug>Console: Toggle On-Screen Log\" to toggle this console history.--]]),"</color>")
  ChoGGi.UserSettings.FirstRun = false
  ChoGGi.Temp.WriteSettings = true
end

--if we're in fake editor mode (probably should fix that large font/ui scale issue)
if ChoGGi.UserSettings.GedFilesLoaded then
  function OnMsg.ClassesGenerate()
    Platform.editor = true
    Platform.ged = true
    dofile("CommonLua/Core/Terrain.lua")
    --dofile("CommonLua/Ged/stubs.lua")
    dofolder("CommonLua/Ged")
    dofolder("CommonLua/Editor")
    --dofolder_files("CommonLua/Ged/XTemplates")
    --dofolder_files("CommonLua/Ged/Apps")
  end
end

local Platform = Platform
local d_before = Platform.developer
local e_before = Platform.editor
Platform.developer = true
Platform.editor = true
--fixes UpdateInterface nil value in editor mode
editor.LoadPlaceObjConfig()
--some error it gives about missing table
GlobalVar("g_revision_map",{})
Platform.developer = d_before
Platform.editor = e_before

--~ ClassesGenerate
--~ ClassesPreprocess
--~ ClassesPostprocess
--~ ClassesBuilt
--~ OptionsApply
--~ Autorun
--~ ModsLoaded
--~ EntitiesLoaded
--~ BinAssetsLoaded
