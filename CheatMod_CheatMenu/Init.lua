--easier access to SelectedObj from console
GlobalVar("s", false)
--stops log errors in editor mode
GlobalVar("g_revision_map", false)
--fucking pre-orders
if not g_TrailblazerSkins then
  g_TrailblazerSkins = {}
end

-- This must return true for most cheats to function (built-in ones)
function CheatsEnabled()
  return true
end
--needed to make the console appear when not in ged mod editor more
ConsoleEnabled = true

--keep my mod contained in
ChoGGi = {
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  _VERSION = _G.Mods.ChoGGi_CheatMenu.version,
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
  FilesCount = {},
  FilesCountAuto = {},
  ReplacedFunc = {},
  StartupMsgs = {},
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
--ConsoleExec --re-added back in with Spirit update
--dofile("CommonLua/console.lua")
--console log
--dofolder("CommonLua/UI/Dev")
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


--used to let me know if we're on my computer for extra StartupMsgs
local file_error, code = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.Testing = true
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

--if writelogs option
if ChoGGi.CheatMenuSettings.WriteLogs then
  table.insert(ChoGGi.StartupMsgs,"ChoGGi: Writing Debug/Console Logs to AppData/logs")
  ChoGGi.WriteLogsEnable()
end

--first time run info
if not ChoGGi.CheatMenuSettings.FirstRun then
  table.insert(ChoGGi.StartupMsgs,"\nCheatMenu Active:\nF2 to toggle menu\nDebug>Console History to toggle console history.\n\n\n")
  ChoGGi.CheatMenuSettings.FirstRun = false
  ChoGGi.Init_WriteSettings = 1
end

--make sure to save anything we changed above
if ChoGGi.Init_WriteSettings then
  ChoGGi.WriteSettings()
end

--check if all files loaded
if ChoGGi.Testing then
  table.insert(ChoGGi.FilesCountAuto,"Settings")
  table.insert(ChoGGi.FilesCountAuto,"FuncDebug")
  table.insert(ChoGGi.FilesCountAuto,"FuncGame")
  table.insert(ChoGGi.FilesCountAuto,"ReplacedFunctions")
  --add files in Code to list
  local err, files = AsyncListFiles(ChoGGi.ModPath .. "Code", "*.lua")
  if err then
    table.insert(ChoGGi.StartupMsgs,"Error reading " .. ChoGGi.ModPath .. "Code")
    return
  end
  --we just want the file names
  for i = 1, #files do
    local dir, file, ext = SplitPath(files[i])
    table.insert(ChoGGi.FilesCountAuto,file)
  end
  --remove file if name is matched
  local listedfile
  local rem = false
  for i = 1, #ChoGGi.FilesCountAuto do
    listedfile = ChoGGi.FilesCountAuto[i]
    for j = 1, #ChoGGi.FilesCount do
      if listedfile == ChoGGi.FilesCount[j] then
        rem = true
        break
      end
    end
    if rem then
      ChoGGi.FilesCountAuto[i] = nil
      rem = false
    end
  end
  --send missing names to console
  for _,v in pairs(ChoGGi.FilesCountAuto) do
    table.insert(ChoGGi.StartupMsgs,"LUA ERROR: " .. v)
  end

end --Testing
