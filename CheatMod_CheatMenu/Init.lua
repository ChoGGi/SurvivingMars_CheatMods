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
ChoGGi._VERSION = _G.Mods[ChoGGi.id].version
ChoGGi.ModPath = _G.Mods[ChoGGi.id].path

--used to let me know if we're on my computer
local file_error, _ = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.Testing = true
end

if ChoGGi.Testing then
  --get saved settings for this mod
  dofile(ChoGGi.ModPath .. "Files/Defaults.lua")
  --functions needed for before Code/ is loaded
  dofile(ChoGGi.ModPath .. "Files/CommonFunctions.lua")
  --load all the other files
  dofolder_files(ChoGGi.ModPath .. "Files/Code")
else
  --if file exists then we'll ignore Files.hpk (user likely unpacked the files)
  local file_error, _ = AsyncFileToString(ChoGGi.ModPath .. "/Defaults.lua")
  if not file_error then
    --get saved settings for this mod
    dofile(ChoGGi.ModPath .. "/Defaults.lua")
    --functions needed for before Code/ is loaded
    dofile(ChoGGi.ModPath .. "/CommonFunctions.lua")
    --load all the other files
    dofolder_files(ChoGGi.ModPath .. "/Code")
  else
    local MountName = "ChoGGi_Mount"
    --load up the hpk
    AsyncMountPack(MountName,ChoGGi.ModPath .. "/Files.hpk")
    dofile(MountName .. "/Defaults.lua")
    dofile(MountName .. "/CommonFunctions.lua")
    dofolder_files(MountName .. "/Code")
  end
end

--read settings from AppData/CheatMenuModSettings.lua
ChoGGi.SettingFuncs.ReadSettings()

if ChoGGi.Testing then
  ChoGGi.UserSettings.WriteLogs = true
end

local msgs = ChoGGi.Temp.StartupMsgs

--if writelogs option
if ChoGGi.UserSettings.WriteLogs == true then
  msgs[#msgs+1] = "<color 255 255 255>ECM</color><color 0 0 0>: </color><color 128 255 128>Writing debug/console logs to AppData/logs</color>"
  ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
end

--first time run info
if ChoGGi.UserSettings.FirstRun ~= false then
  msgs[#msgs+1] = "<color 255 255 255>\nECM Active<color 0 0 0>:</color></color><color 128 255 128>\nF2 to toggle cheats menu\nDebug>Console Toggle History to toggle this console history.</color>\n\n\n"
  ChoGGi.UserSettings.FirstRun = false
  ChoGGi.Temp.WriteSettings = true
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
