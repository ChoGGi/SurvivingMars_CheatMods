--See LICENSE for terms

local oldTableConcat = oldTableConcat

--keep everything stored in
ChoGGi = {
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
ChoGGi._VERSION = Mods[ChoGGi.id].version
ChoGGi.ModPath = Mods[ChoGGi.id].path
ChoGGi.MountPath = ChoGGi.ModPath

--if we use global func more then once: make them local for that small bit o' speed
local AsyncFileToString = AsyncFileToString
local dofolder_files = dofolder_files

--used to let me know if we're on my computer
local _,test = AsyncFileToString("AppData/ChoGGi")
if test then
  ChoGGi.Temp.Testing = true
end

--if file exists then user likely unpacked the files, so we'll ignore Files.hpk
local err,_ = AsyncFileToString(oldTableConcat({ChoGGi.ModPath,"Defaults.lua"}))
if err then
  --load up the hpk
  AsyncMountPack("ChoGGi_Mount",oldTableConcat({ChoGGi.ModPath,"Files.hpk"}))
  ChoGGi.MountPath = "ChoGGi_Mount/"
end

if ChoGGi.Temp.Testing then
  ChoGGi.MountPath = oldTableConcat({ChoGGi.ModPath,"Files/"})
end

--get saved settings for this mod
dofile(oldTableConcat({ChoGGi.MountPath,"Defaults.lua"}))
--functions needed before Code/ is loaded
dofile(oldTableConcat({ChoGGi.MountPath,"CommonFunctions.lua"}))
--load all the other files
dofolder_files(oldTableConcat({ChoGGi.MountPath,"Code"}))

--load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = oldTableConcat({ChoGGi.ModPath,"Locales/",GetLanguage(),".csv"})
local _,locale = AsyncFileToString(locale_file)
if locale then
  LoadTranslationTableFile(locale_file)
else
  LoadTranslationTableFile(oldTableConcat({ChoGGi.ModPath,"Locales/","English.csv"}))
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
  ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = oldTableConcat({"<color 200 200 200>\n",ChoGGi.ComFuncs.Trans(302535920000000,"Expanded Cheat Menu")," ",ChoGGi.ComFuncs.Trans(302535920000201,"Active","<color 0 0 0>:</color></color><color 128 255 128>\n",ChoGGi.ComFuncs.Trans(302535920000001,"F2 to toggle cheats menu\nDebug>Console Toggle History to toggle this console history."),"</color>\n\n\n")})
  ChoGGi.UserSettings.FirstRun = false
  ChoGGi.Temp.WriteSettings = true
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

-- what does this do with examine?
--config.TraceEnabled = true

--be nice to get a remote debugger working
--[[
Platform.editor = true
config.LuaDebugger = true
GlobalVar("outputSocket", false)
dofile("CommonLua/Core/luasocket.lua")
dofile("CommonLua/Core/luadebugger.lua")
dofile("CommonLua/Core/luaDebuggerOutput.lua")
dofile("CommonLua/Core/ProjectSync.lua")
config.LuaDebugger = false
Platform.editor = false
--]]
--[[
ClassesGenerate
ClassesPreprocess
ClassesPostprocess
ClassesBuilt
OptionsApply
Autorun
ModsLoaded
EntitiesLoaded
BinAssetsLoaded
--]]
