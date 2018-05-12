--keep everything stored in
ChoGGi = {
  id = "ChoGGi_CheatMenu",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  --store msgs till game is loaded
  StartupMsgs = {},
  --orig funcs that we replace
  OrigFuncs = {},
  --common funcs
  Funcs = {},
  --funcs used by menu items
  MenuFuncs = {},
  --funcs passed to OnMsgs.lua
  MsgFuncs = {},
  --settings that aren't saved
  Temp = {},
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

--get saved settings for this mod
dofile(ChoGGi.ModPath .. "Settings.lua")
--read settings from AppData/CheatMenuModSettings.lua
ChoGGi.Funcs.ReadSettings()

--functions needed for before Code/ is loaded
dofile(ChoGGi.ModPath .. "Functions.lua")
--load all my other files
dofolder_files(ChoGGi.ModPath .. "Code")

if ChoGGi.Testing then
  ChoGGi.UserSettings.WriteLogs = true
end

local msgs = ChoGGi.StartupMsgs

--if writelogs option
if ChoGGi.UserSettings.WriteLogs == true then
  msgs[#msgs+1] = "<color 255 255 255>ECM</color><color 0 0 0>: </color><color 128 255 128>Writing debug/console logs to AppData/logs</color>"
  ChoGGi.Funcs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
end

--first time run info
if ChoGGi.UserSettings.FirstRun ~= false then
  msgs[#msgs+1] = "<color 255 255 255>\nECM Active<color 0 0 0>:</color></color><color 128 255 128>\nF2 to toggle menu\nDebug>Console History to toggle console history.</color>\n\n\n"
  ChoGGi.UserSettings.FirstRun = false
  ChoGGi.Init_WriteSettings = 1
end

--make sure to save anything we changed above
if ChoGGi.Init_WriteSettings then
  ChoGGi.Funcs.WriteSettings()
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
