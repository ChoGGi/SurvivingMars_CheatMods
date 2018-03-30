-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

--keep my mod contained in
ChoGGi = {
  SettingsFileLoaded = false,
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
  FilesCount = {},
  ReplacedFunc = {},
  OrigFunc = {},
}

--used to let me know if any files didn't load
local file_error, code = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.ChoGGiTest = true
end

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
--Toggle Hex Build Grid Visibility
dofile("Lua/hex.lua")
--ConsoleExec
dofile("CommonLua/console.lua")
--console log
dofolder("CommonLua/UI/Dev")

--[[
--load up the editors
LGS = {}
Platform.editor = false
Platform.developer = true
dofolder_files("CommonLua/Dev")
dofolder_files("Lua/Dev")
--dofolder_files("Lua/UIDesignerData/")
dofolder_files("CommonLua/UI/UIDesignerData")
dofolder_files("Lua/UIDesignerData")
  pcall(function()
    dofolder_folders("CommonLua/Classes")
  end)
dofile("CommonLua/Classes/CodeRenderableObject.lua")
dofile("CommonLua/Classes/Decal.lua")
dofile("CommonLua/Classes/DeveloperOptions.lua")
dofile("CommonLua/Classes/DumbAI.lua")
dofile("CommonLua/Classes/Dummies.lua")
dofile("CommonLua/Classes/EditorBase.lua")
dofile("CommonLua/Classes/ModifierObject.lua")
--------something blocking rockets
dofile("CommonLua/Classes/Modifiers.lua")
dofile("CommonLua/Classes/OcclusionMarker.lua")
dofile("CommonLua/Classes/particles.lua")
dofile("CommonLua/Classes/PerlinNoise.lua")
dofile("CommonLua/Classes/Preset.lua")
dofile("CommonLua/Classes/PropEditor.lua")
dofile("CommonLua/Classes/PropertyPresets.lua")
dofile("CommonLua/Classes/ReverbParams.lua")
dofile("CommonLua/Classes/Shapeshifter.lua")
dofile("CommonLua/Classes/SoundDummy.lua")
dofile("CommonLua/Classes/Stats.lua")
dofile("CommonLua/Classes/TerrainConfig.lua")
dofile("CommonLua/Classes/TerrainHolder.lua")
dofile("CommonLua/Classes/trail.lua")
dofile("CommonLua/Classes/ZBrushEditor.lua")
---------
dofile("CommonLua/GedGameObjectEditor.lua")
dofolder_files("CommonLua/Editor")
dofolder_files("Lua/editor")
dofolder_folders("Lua/editor")

Platform.editor = true
--]]

--turn it back off, so we don't get "stripped" for most labels
Platform.developer = false

--my functions
dofile(ChoGGi.ModPath .. "FuncDebug.lua")
dofile(ChoGGi.ModPath .. "FuncGame.lua")
--load up custom actions/overrides (menus/keys)
dofolder_files(ChoGGi.ModPath .. "libs")
dofile(ChoGGi.ModPath .. "Keys.lua")
--saved settings from this mod
dofile(ChoGGi.ModPath .. "Settings.lua")
--msgs file (OnMsg.DataLoaded, GameLoaded, etc)
dofile(ChoGGi.ModPath .. "OnMsgs.lua")
--people will just copy new mod over old, and I renamed some stuff
local file_error, code = AsyncFileToString(ChoGGi.ModPath .. "/Script.lua")
if not file_error then
  ChoGGi.RemoveOldFiles()
end

--reading settings from AppData/CheatMenuModSettings.lua
ChoGGi.ReadSettings()
--menus/menus funcs
dofile(ChoGGi.ModPath .. "MenuBuildingsFunc.lua")
dofile(ChoGGi.ModPath .. "MenuBuildings.lua")
dofile(ChoGGi.ModPath .. "MenuCheatsFunc.lua")
dofile(ChoGGi.ModPath .. "MenuCheats.lua")
dofile(ChoGGi.ModPath .. "MenuColonistsFunc.lua")
dofile(ChoGGi.ModPath .. "MenuColonists.lua")
dofile(ChoGGi.ModPath .. "MenuDebugFunc.lua")
dofile(ChoGGi.ModPath .. "MenuDebug.lua")
dofile(ChoGGi.ModPath .. "MenuDronesAndRCFunc.lua")
dofile(ChoGGi.ModPath .. "MenuDronesAndRC.lua")
dofile(ChoGGi.ModPath .. "MenuHelp.lua")
dofile(ChoGGi.ModPath .. "MenuMiscFunc.lua")
dofile(ChoGGi.ModPath .. "MenuMisc.lua")
dofile(ChoGGi.ModPath .. "MenuResourcesFunc.lua")
dofile(ChoGGi.ModPath .. "MenuResources.lua")

--move to onmsgs
--block CheatEmpty from working?
if ChoGGi.CheatMenuSettings.BlockCheatEmpty then
  ChoGGi.SetBlockCheatEmpty()
end

--do they do anything, or do they have to be set before mods load?
if ChoGGi.ChoGGiTest then
  hr.EnableScreenSpaceReflection = 1
  hr.AutoFadeDistanceScale = 10000
  hr.FadeCullRadius = 5000
  hr.D3D11ParallelCompilation = 1
  config.MapSlotChunksMem = 16384
  config.ObjectPoolMem = 256000
  config.ParticlesMaxBaseColorMapSize = 4096
  config.ParticlesMaxNormalMapSize = 1024
  config.MinimapScreenshotSize = 4096
end

--if we toggled debuglog option
if ChoGGi.CheatMenuSettings.WriteLogs then
  AddConsoleLog("ChoGGi: Writing Debug/Console Logs to AppData/logs",true)
  ChoGGi.WriteLogsEnable()
end

if ChoGGi.CheatMenuSettings.FirstRun then
  AddConsoleLog("CheatMenu Active:\nF2 to toggle menu\nDebug>Console History to toggle console history.\n\n\n",true)
  ChoGGi.CheatMenuSettings.FirstRun = nil
  ChoGGi.WriteSettings()
end

--checking if all files loaded
if ChoGGi.ChoGGiTest and #ChoGGi.FilesCount < 22 then
  for _,Value in ipairs(ChoGGi.FilesCount) do
    AddConsoleLog(Value,true)
  end
end
