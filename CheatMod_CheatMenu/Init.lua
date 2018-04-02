GlobalVar("s", false)
-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

--keep my mod contained in
ChoGGi = {
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
  _VERSION = _G.Mods.ChoGGi_CheatMenu.version,
  FilesCount = {},
  ReplacedFunc = {},
  OrigFunc = {},
  CheatMenuSettings = {},
}

--used to let me know if any files didn't load
local file_error, code = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.ChoGGiTest = true
end

--Platform.ged = true
--Platform.cmdline = true
--upsampled screenshot
-- Turn on editor mode (this is required for cheats to work) and then add the editor commands
Platform.editor = true
Platform.developer = true
Platform.cmdline = true
--add built-in cheat menu items
AddCheatsUA()

--buildings menu (pretty much useless, but what the haeh)
dofile("Lua/Buildings/Building.lua")
--Toggle Hex Build Grid Visibility
--dofile("Lua/hex.lua")
--ConsoleExec
dofile("CommonLua/console.lua")
--console log
dofolder("CommonLua/UI/Dev")

--[[
LGS = {}
--load up the editors
dofolder_files("CommonLua/Dev")
dofolder_files("Lua/Dev")
dofolder_files("CommonLua/UI/Designer")
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
--]]

--get saved settings for this mod
dofile(ChoGGi.ModPath .. "Settings.lua")
--reading settings from AppData/CheatMenuModSettings.lua
ChoGGi.ReadSettings()

--turn it back off, so we don't get "stripped" for most labels
if not ChoGGi.CheatMenuSettings.developer then
  Platform.developer = false
end

--my functions
dofile(ChoGGi.ModPath .. "FuncDebug.lua")
dofile(ChoGGi.ModPath .. "FuncGame.lua")
--load up function overrides
dofile(ChoGGi.ModPath .. "ReplacedFunctions.lua")

--people will likely just copy new mod over old, and I moved stuff around
if ChoGGi._VERSION ~= ChoGGi.CheatMenuSettings._VERSION then
  --clean up
  ChoGGi.RemoveOldFiles()
  --update saved version
  ChoGGi.CheatMenuSettings._VERSION = ChoGGi._VERSION
  ChoGGi.Init_WriteSettings = 1
end

--menus/menus funcs
dofolder_files(ChoGGi.ModPath .. "Code")

--do they do anything, or do they have to be set before modload?
if ChoGGi.CheatMenuSettings.HighQualitySettings then
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

--if writelogs option
if ChoGGi.CheatMenuSettings.WriteLogs then
  AddConsoleLog("ChoGGi: Writing Debug/Console Logs to AppData/logs",true)
  ChoGGi.WriteLogsEnable()
end
--first time run info
if not ChoGGi.CheatMenuSettings.FirstRun then
  AddConsoleLog("\nCheatMenu Active:\nF2 to toggle menu\nDebug>Console History to toggle console history.\n\n\n",true)
  ChoGGi.CheatMenuSettings.FirstRun = false
  ChoGGi.Init_WriteSettings = 1
end

--make sure to save anything we changed above
if ChoGGi.Init_WriteSettings then
  ChoGGi.WriteSettings()
end

--checking if all files loaded
if ChoGGi.ChoGGiTest and #ChoGGi.FilesCount < 4+18 then
  for _,Value in ipairs(ChoGGi.FilesCount) do
    AddConsoleLog(Value,true)
  end
end
