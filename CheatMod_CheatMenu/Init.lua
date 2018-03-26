-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

--keep my mod contained in
ChoGGi = {
  SettingsFileLoaded = false,
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
}
--used to let me know if any files didn't load
local file_error, code = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.ChoGGiComp = true
end

--msgs file (OnMsg.DataLoaded, GameLoaded, etc)
dofile(ChoGGi.ModPath .. "OnMsgs.lua")
--my functions
dofile(ChoGGi.ModPath .. "Functions.lua")
--saved settings from this mod
dofile(ChoGGi.ModPath .. "Settings.lua")
--reading settings from AppData/CheatMenuModSettings.lua
ChoGGi.ReadSettings()

--Platform.ged = true
--Platform.cmdline = true
--config.Network = true
--config.LuaDebugger = true
--upsampled screenshot
-- Turn on editor mode (this is required for cheats to work) and then add the editor commands
Platform.editor = true
Platform.developer = true
Platform.cmdline = true
--add built-in cheat menu items
AddCheatsUA()

--buildings menu (kinda useless, but what the haeh)
dofile("Lua/Buildings/Building.lua")
--dbg_DrainAllDrones(),dbg_TestForDetached(),dbg_TestRockets(),dbg_GetDetachedDrone()
dofile("Lua/Units/Drone.lua")
--Toggle Hex Build Grid Visibility
dofile("Lua/hex.lua")
--add ConsoleExec
--[[
dlgConsole.autoCompleteList = true
dlgConsole.cursorPosOnTabPress = true
dlgConsole.autoCompleteListPos = true
dlgConsole.autoCompleteCursorPosOnLastUpdate = true
dlgConsole.autoCompleteTextOnLastUpdate = true
--]]
dofile("CommonLua/console.lua")
dofile("CommonLua/UI/Dev/uiConsole.lua")
dofile("CommonLua/UI/Dev/uiConsoleLog.lua")

--we want dev mode left on?
if not ChoGGi.CheatMenuSettings.developer then
  Platform.developer = false
end

--block CheatEmpty from working?
if ChoGGi.CheatMenuSettings.BlockCheatEmpty then
  ChoGGi.SetBlockCheatEmpty()
end

--output results to console
ConsolePrint = ChoGGi.AddConsoleLog
ChoGGi.print = print
print = ChoGGi.AddConsoleLog

--if we toggled debuglog option
if ChoGGi.WriteDebugLogs then
  AddConsoleLog("ChoGGi: WriteDebugLogs",true)
  ChoGGi.WriteDebugLogsEnable()
end

--load up custom actions (menus/keys)
dofile(ChoGGi.ModPath .. "FuncsCheats.lua")
dofile(ChoGGi.ModPath .. "FuncsDebug.lua")
dofile(ChoGGi.ModPath .. "FuncsGameplayBuildings.lua")
dofile(ChoGGi.ModPath .. "FuncsGameplayColonists.lua")
dofile(ChoGGi.ModPath .. "FuncsGameplayDronesAndRC.lua")
dofile(ChoGGi.ModPath .. "FuncsGameplayMisc.lua")
dofile(ChoGGi.ModPath .. "FuncsResources.lua")
dofile(ChoGGi.ModPath .. "FuncsToggles.lua")
dofile(ChoGGi.ModPath .. "Keys.lua")
dofile(ChoGGi.ModPath .. "MenuCheats.lua")
dofile(ChoGGi.ModPath .. "MenuDebug.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayBuildings.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayColonists.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayDronesAndRC.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayMisc.lua")
dofile(ChoGGi.ModPath .. "MenuResources.lua")
dofile(ChoGGi.ModPath .. "MenuToggles.lua")

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: Init.lua",true)
end
