--[[
if you're curious when these msgs happen then uncomment and check the log
(it doesn't write till after quitting; use dump() and open AppData\DumpText.txt)
You can also create a Surviving Mars\BinAssets\AssetsRevision.lua
and run stuff from there (just make sure to add return 1 at the bottom of the file)

function OnMsg.Resume()
  DebugPrint("Mod_Resume\n\n")
end
function OnMsg.BinAssetsLoaded()
  DebugPrint("Mod_BinAssetsLoaded\n\n")
end
function OnMsg.PersistPostLoad()
  DebugPrint("Mod_PersistPostLoad\n\n")
end
function OnMsg.EntitiesLoaded()
  DebugPrint("Mod_EntitiesLoaded\n\n")
end
function OnMsg.DeveloperOptionsChanged()
  DebugPrint("Mod_DeveloperOptionsChanged\n\n")
end
function OnMsg.GameTimeStart()
  DebugPrint("Mod_GameTimeStart\n\n")
end
function OnMsg.AccountStorageChanged()
  DebugPrint("Mod_AccountStorageChanged\n\n")
end
function OnMsg.OptionsChanged()
  DebugPrint("Mod_OptionsChanged\n\n")
end
function OnMsg.DataLoaded()
  DebugPrint("Mod_DataLoaded\n\n")
end
function OnMsg.DataLoading()
  DebugPrint("Mod_DataLoading\n\n")
end
function OnMsg.ReloadSoundData()
  DebugPrint("Mod_ReloadSoundData\n\n")
end
function OnMsg.ChangeMap()
  DebugPrint("Mod_ChangeMap\n\n")
end
function OnMsg.NewMap()
  DebugPrint("Mod_NewMap\n\n")
end
function OnMsg.LoadGame()
  DebugPrint("Mod_LoadGame\n\n")
end
--]]

-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

--DebugPrint("Mod_Init\n\n")
--keep my mod contained in
ChoGGi = {
  SettingsFileLoaded = false,
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
}

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
Platform.publisher = true
Platform.cmdline = true
--add built-in cheat menu items
AddCheatsUA()

--dofolder_files("CommonLua/UI/Designer")
--dofolder_folders("CommonLua/UI/Designer")

--buildings menu (kinda useless, but what the haeh)
dofile("Lua/Buildings/Building.lua")
--dbg_DrainAllDrones(),dbg_TestForDetached(),dbg_TestRockets(),dbg_GetDetachedDrone()
dofile("Lua/Units/Drone.lua")
--Toggle Hex Build Grid Visibility
dofile("Lua/hex.lua")
--add ConsoleExec
dofile("CommonLua/console.lua")

--we want dev mode left on?
if not ChoGGi.CheatMenuSettings["developer"] then
  Platform.developer = false
end

--load up custom actions (menus/keys)
dofile(ChoGGi.ModPath .. "Keys.lua")
dofile(ChoGGi.ModPath .. "MenuCheats.lua")
dofile(ChoGGi.ModPath .. "MenuDebug.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayBuildings.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayColonists.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayDronesAndRC.lua")
dofile(ChoGGi.ModPath .. "MenuGameplayMisc.lua")
dofile(ChoGGi.ModPath .. "MenuResources.lua")
dofile(ChoGGi.ModPath .. "MenuToggles.lua")
