--keep everything stored in
ChoGGi = {
  id = "ChoGGi_CheatMenu",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --funcs used by *Menu.lua / *Func.lua
  MenuFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {StartupMsgs = {}},
  --settings that are saved to SettingsFile
  UserSettings = {BuildingSettings = {},Transparency = {}},
}
local ChoGGi = ChoGGi
ChoGGi._VERSION = _G.Mods[ChoGGi.id].version
ChoGGi.ModPath = _G.Mods[ChoGGi.id].path
local CTemp = ChoGGi.Temp
local CModPath = ChoGGi.ModPath
local COrigFuncs = ChoGGi.OrigFuncs

--used to let me know if we're on my computer
local file_error, _ = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.Testing = true
end
local CTesting = ChoGGi.Testing

if CTesting then
  --get saved settings for this mod
  dofile(CModPath .. "Files/Defaults.lua")
  --functions needed for before Code/ is loaded
  dofile(CModPath .. "Files/CommonFunctions.lua")
  --load all the other files
  dofolder_files(CModPath .. "Files/Code")
else
  --if file exists then we'll ignore Files.hpk (user likely unpacked the files)
  local file_error, _ = AsyncFileToString(CModPath .. "/Defaults.lua")
  if not file_error then
    --get saved settings for this mod
    dofile(CModPath .. "/Defaults.lua")
    --functions needed for before Code/ is loaded
    dofile(CModPath .. "/CommonFunctions.lua")
    --load all the other files
    dofolder_files(CModPath .. "/Code")
  else
    local MountName = "ChoGGi_Mount"
    --load up the hpk
    AsyncMountPack(MountName,CModPath .. "/Files.hpk")
    dofile(MountName .. "/Defaults.lua")
    dofile(MountName .. "/CommonFunctions.lua")
    dofolder_files(MountName .. "/Code")
  end
end

--read settings from AppData/CheatMenuModSettings.lua
ChoGGi.SettingFuncs.ReadSettings()
local CUserSettings = ChoGGi.UserSettings

if CTesting then
  CUserSettings.WriteLogs = true
end

--if writelogs option
if CUserSettings.WriteLogs == true then
  CTemp.StartupMsgs[#CTemp.StartupMsgs+1] = "<color 200 200 200>ECM</color><color 0 0 0>: </color><color 128 255 128>Writing debug/console logs to AppData/logs</color>"
  ChoGGi.ComFuncs.WriteLogs_Toggle(CUserSettings.WriteLogs)
end

--first time run info
if CUserSettings.FirstRun ~= false then
  CTemp.StartupMsgs[#CTemp.StartupMsgs+1] = "<color 200 200 200>\nECM Active<color 0 0 0>:</color></color><color 128 255 128>\nF2 to toggle cheats menu\nDebug>Console Toggle History to toggle this console history.</color>\n\n\n"
  CUserSettings.FirstRun = false
  CTemp.WriteSettings = true
end

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
--fixes UpdateInterface nil value in editor mode
Platform.developer = true
editor.LoadPlaceObjConfig()
Platform.developer = false
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

if CTesting then
  config.TraceEnable = true
  Platform.editor = true
  config.LuaDebugger = true
  GlobalVar("outputSocket", false)
  dofile("CommonLua/Core/luasocket.lua")
  dofile("CommonLua/Core/luadebugger.lua")
  dofile("CommonLua/Core/luaDebuggerOutput.lua")
  dofile("CommonLua/Core/ProjectSync.lua")
end
