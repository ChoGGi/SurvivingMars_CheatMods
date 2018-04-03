--easier access to SelectedObj from console
GlobalVar("s", false)
--stops log errors in editor mode
GlobalVar("g_revision_map", false)
--add some global vars setup later in Replaced Functions
GlobalVar("console")
GlobalVar("sm")
GlobalVar("st")
GlobalVar("cur")
GlobalVar("sp")
GlobalVar("sc")
GlobalVar("dumplua")
GlobalVar("restart")
GlobalVar("ex")
GlobalVar("examine")
GlobalVar("dump")
GlobalVar("dumpobject")
GlobalVar("dumpo")
GlobalVar("dumptable")
GlobalVar("dumpt")
GlobalVar("alert")
GlobalVar("exit")
GlobalVar("reboot")
GlobalVar("trans")

-- This must return true for most cheats to function (built-in ones)
function CheatsEnabled()
  return true
end

--keep my mod contained in
ChoGGi = {
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  FilesCount = {},
  ReplacedFunc = {},
  OrigFunc = {},
  CheatMenuSettings = {},
}

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
PlaceObjectConfig = {}
dlgEditorPlaceObjectsDlg = false
editor.PlaceObjectInited = false
l_SortCache = setmetatable({}, weak_keys_meta)
ObjectPaletteFilters = {
  {text = "all", item = nil}
}
ObjectPaletteTempCategories = false
ObjectPaletteFilterCategoryData = false
ObjectPaletteLastSearchString = false
dofile("CommonLua/UI/uiEditorInterface.designer.lua")
dofile("CommonLua/UI/uiEditorInterface.lua")
dofile("CommonLua/UI/uiEditorPlaceObjectsDlg.designer.lua")
dofile("CommonLua/UI/uiEditorPlaceObjectsDlg.lua")
dofile("CommonLua/UI/uiEditorStatusbar.designer.lua")
dofile("CommonLua/UI/uiEditorStatusbar.lua")
Platform.developer = false

function OnMsg.ModsLoaded()
  ChoGGi._VERSION = _G.Mods.ChoGGi_CheatMenu.version
  ChoGGi.ModPath = _G.Mods.ChoGGi_CheatMenu.content_path
  --ChoGGi.ModPath = "AppData/Mods/CheatMod_CheatMenu/",

  --used to let me know if any files didn't load
  local file_error, code = AsyncFileToString("AppData/ChoGGi.lua")
  if not file_error then
    ChoGGi.ChoGGiTest = true
  end

  --get saved settings for this mod
  dofile(ChoGGi.ModPath .. "Settings.lua")
  --reading settings from AppData/CheatMenuModSettings.lua
  ChoGGi.ReadSettings()

  --if you want it...
  if ChoGGi.CheatMenuSettings.developer then
    Platform.developer = true
  end

  --my functions
  dofile(ChoGGi.ModPath .. "FuncDebug.lua")
  dofile(ChoGGi.ModPath .. "FuncGame.lua")
  --load up function overrides
  dofile(ChoGGi.ModPath .. "ReplacedFunctions.lua")
  --load all my other files
  dofolder_files(ChoGGi.ModPath .. "Code")

  --people will likely just copy new mod over old, and I moved stuff around
  if ChoGGi._VERSION ~= ChoGGi.CheatMenuSettings._VERSION then
    --clean up
    ChoGGi.RemoveOldFiles()
    --update saved version
    ChoGGi.CheatMenuSettings._VERSION = ChoGGi._VERSION
    ChoGGi.Init_WriteSettings = 1
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

  --tell me if all files loaded
  if ChoGGi.ChoGGiTest and #ChoGGi.FilesCount < 4+19 then
    for _,Value in ipairs(ChoGGi.FilesCount) do
      AddConsoleLog(Value,true)
    end
  end
end -- OnMsg.ModsLoaded
