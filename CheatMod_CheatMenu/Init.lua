--[[
load game
Map changed to ""
new game
Map changed to "PreGame"
--]]
--easier access to SelectedObj from console
GlobalVar("s", false)

--keep my mod contained in
ChoGGi = {
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
  StartupMsgs = {},
  OrigFunc = {},
  CheatMenuSettings = {},
}

--used to let me know if we're on my computer
local file_error, _ = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.Testing = true
end

--get saved settings for this mod
dofile(ChoGGi.ModPath .. "Settings.lua")
--read settings from AppData/CheatMenuModSettings.lua
ChoGGi.ReadSettings()

--TEMP REMOVE ME AFTER NEXT UPDATE (or two)
if ChoGGi.CheatMenuSettings.NewColonistSex then
  ChoGGi.CheatMenuSettings.NewColonistGender = ChoGGi.CheatMenuSettings.NewColonistSex
  ChoGGi.CheatMenuSettings.NewColonistSex = nil
  ChoGGi.Init_WriteSettings = 1
end
if ChoGGi.CheatMenuSettings.ShuttleSpeed then
  ChoGGi.CheatMenuSettings.SpeedShuttle = ChoGGi.CheatMenuSettings.ShuttleSpeed
  ChoGGi.CheatMenuSettings.ShuttleSpeed = nil
  ChoGGi.Init_WriteSettings = 1
end
if ChoGGi.CheatMenuSettings.ShuttleStorage then
  ChoGGi.CheatMenuSettings.StorageShuttle = ChoGGi.CheatMenuSettings.ShuttleStorage
  ChoGGi.CheatMenuSettings.ShuttleStorage = nil
  ChoGGi.Init_WriteSettings = 1
end

--function overrides / shortened func names
dofile(ChoGGi.ModPath .. "ReplacedFunctions.lua")
--functions needed for before Code/ is loaded
dofile(ChoGGi.ModPath .. "Functions.lua")
--load all my other files
dofolder_files(ChoGGi.ModPath .. "Code")

--if writelogs option
if ChoGGi.CheatMenuSettings.WriteLogs then
  table.insert(ChoGGi.StartupMsgs,"ChoGGi: Writing debug/console logs to AppData/logs")
  ChoGGi.WriteLogsEnable()
end

--first time run info
if ChoGGi.CheatMenuSettings.FirstRun then
  table.insert(ChoGGi.StartupMsgs,"\nCheatMenu Active:\nF2 to toggle menu\nDebug>Console History to toggle console history.\n\n\n")
  ChoGGi.CheatMenuSettings.FirstRun = false
  ChoGGi.Init_WriteSettings = 1
end

--make sure to save anything we changed above
if ChoGGi.Init_WriteSettings then
  ChoGGi.WriteSettings()
end

--[[
--for loading from the main menu
Platform.editor = true
Platform.developer = true

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
dofile("CommonLua/UI/uiEditorPlaceObjectsDlg.designer.lua")
dofile("CommonLua/UI/uiEditorStatusbar.designer.lua")
dofile("CommonLua/UI/uiEditorInterface.lua")
dofile("CommonLua/UI/uiEditorPlaceObjectsDlg.lua")
dofile("CommonLua/UI/uiEditorStatusbar.lua")

--causes some labels to say stripped/keys are different
Platform.developer = false
--i don't think i need it on
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
  HexShapesRebuilt
EntitiesLoaded
  HexShapesRebuilt
BinAssetsLoaded
--]]

function OnMsg.ChangeMapDone()
  --stops log errors in editor mode
  --GlobalVar("g_revision_map", false)
end
