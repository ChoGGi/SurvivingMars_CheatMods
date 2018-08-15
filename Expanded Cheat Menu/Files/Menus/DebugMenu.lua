-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920001208--[[Export Colonist Data To CSV--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001208--[[Export Colonist Data To CSV--]]]),
  ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
  RolloverText = S[302535920001219--[[Exports data about colonists to AppData/Colonists.csv--]]],
  OnAction = ChoGGi.MenuFuncs.ExportColonistDataToCSV,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000449--[[Attach Spots Toggle--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000449--[[Attach Spots Toggle--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ShowAll.tga",
  RolloverText = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
  OnAction = ChoGGi.MenuFuncs.AttachSpots_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000451--[[Measure Tool--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000451--[[Measure Tool--]]]),
  ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
  RolloverText = S[302535920000452--[[Measures stuff (Use Ctrl-Shift-M to remove the lines).--]]],
  OnAction = function()
    ChoGGi.MenuFuncs.MeasureTool_Toggle(true)
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.MeasureTool_Toggle,
}

Actions[#Actions+1] = {
  ActionId = Concat("MeasureTool_Toggle",AsyncRand()),
  OnAction = function()
    ChoGGi.MenuFuncs.MeasureTool_Toggle()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.MeasureTool_Clear,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000453--[[Reload Lua--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000453--[[Reload Lua--]]]),
  ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
  RolloverText = S[302535920000454--[[Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).--]]],
  OnAction = ChoGGi.MenuFuncs.ReloadLua,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000455--[[Object Cloner--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000455--[[Object Cloner--]]]),
  ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
  RolloverText = S[302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).--]]],
  OnAction = function()
    ChoGGi.MenuFuncs.ObjectCloner()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ObjectCloner,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000457--[[Anim State Set--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000457--[[Anim State Set--]]]),
  ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
  RolloverText = S[302535920000458--[[Make object dance on command.--]]],
  OnAction = ChoGGi.MenuFuncs.SetAnimState,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000459--[[Anim Debug Toggle--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000459--[[Anim Debug Toggle--]]]),
  ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
  RolloverText = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
  OnAction = ChoGGi.MenuFuncs.ShowAnimDebug_Toggle,
}

--~ Actions[#Actions+1] = {
--~   ActionMenubar = S[1000113--[[Debug--]]],
--~   ActionName = S[302535920000471--[[Object Manipulator--]]],
--~   ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000471--[[Object Manipulator--]]]),
--~   ActionIcon = "CommonAssets/UI/Menu/SaveMapEntityList.tga",
--~   RolloverText = S[302535920000472--[[Manipulate objects (selected or under mouse cursor)--]]],
--~   OnAction = function()
--~     ChoGGi.ComFuncs.OpenInObjectManipulator()
--~   end,
--~   ActionShortcut = ChoGGi.UserSettings.KeyBindings.OpenInObjectManipulator,
--~   ActionSortKey = "",
--~ }

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000473--[[Selection Editor--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000473--[[Selection Editor--]]]),
  ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
  RolloverText = S[302535920000474--[["Lets you manipulate objects.

If you leave it opened during a game load/save, then click this menu item to make it closeable)."--]]],
  OnAction = ChoGGi.MenuFuncs.ShowSelectionEditor,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000475--[[Object Spawner--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000475--[[Object Spawner--]]]),
  ActionIcon = "CommonAssets/UI/Menu/add_water.tga",
  RolloverText = S[302535920000476--[["Shows list of objects, and spawns at mouse cursor.

Warning: Unable to mouse select items after spawn
hover mouse over and use Delete Selected Object"--]]],
  OnAction = ChoGGi.MenuFuncs.ObjectSpawner,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ObjectSpawner,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000479--[[Toggle Editor--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000479--[[Toggle Editor--]]]),
  ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
  RolloverText = S[302535920000480--[["Select object(s) then hold ctrl/shift/alt and drag mouse.
click+drag for multiple selection.

It's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look)."--]]],
  OnAction = ChoGGi.MenuFuncs.Editor_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.Editor_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000481--[[Open In Ged Object Editor--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000481--[[Open In Ged Object Editor--]]]),
  ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
  RolloverText = S[302535920000482--[[It edits stuff?--]]],
  OnAction = function()
    OpenGedGameObjectEditor(ChoGGi.CodeFuncs.SelObject())
  end,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000491--[[Examine Object--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000491--[[Examine Object--]]]),
  ActionIcon = "CommonAssets/UI/Menu/PlayerInfo.tga",
  RolloverText = S[302535920000492--[[Opens the object examiner for the selected or moused-over obj.--]]],
  OnAction = function()
    ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.CodeFuncs.SelObject())
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ObjExaminer,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000495--[[Particles Reload--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000495--[[Particles Reload--]]]),
  ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
  RolloverText = S[302535920000496--[[Reloads particles from "Data/Particles"...--]]],
  OnAction = ChoGGi.MenuFuncs.ParticlesReload,
}

local str_Debug_Grids = Concat(S[487939677892--[[Help--]]],".",S[302535920000035--[[Grids--]]])
Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000035--[[Grids--]]],
  ActionId = str_Debug_Grids,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_Grids,
  ActionName = S[302535920000497--[[Toggle Terrain Deposit Grid--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000497--[[Toggle Terrain Deposit Grid--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ToggleBlockPass.tga",
  RolloverText = S[302535920000498--[[Shows a grid around concrete.--]]],
  OnAction = ToggleTerrainDepositGrid,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ToggleTerrainDepositGrid,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_Grids,
  ActionName = S[302535920000499--[[Toggle Hex Build + Passability Grid Visibility--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000499--[[Toggle Hex Build + Passability Grid Visibility--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
  RolloverText = S[302535920000500--[[Shows a hex grid with green for buildable/walkable.--]]],
  OnAction = ChoGGi.MenuFuncs.debug_build_grid,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.debug_grid_build,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_Grids,
  ActionName = S[302535920001297--[[Toggle Flight Grid--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001297--[[Toggle Flight Grid--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ToggleCollisions.tga",
  RolloverText = S[302535920001298--[[Shows a square grid with terrain/objects shape.--]]],
  OnAction = function()
    ChoGGi.CodeFuncs.FlightGrid_Toggle()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.debug_grid_squares,
}

local str_Debug_DebugFX = Concat(S[487939677892--[[Help--]]],".",S[302535920001175--[[Debug FX--]]])
Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920001175--[[Debug FX--]]],
  ActionId = str_Debug_DebugFX,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_DebugFX,
  ActionName = S[302535920001175--[[Debug FX--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001175--[[Debug FX--]]],"/",S[302535920001175--[[Debug FX--]]]),
  ActionIcon = "CommonAssets/UI/Menu/FXEditor.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      DebugFX,
      302535920001176--[[Toggle showing FX debug info in console.--]]
    )
  end,
  OnAction = function()
    ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFX",302535920001175)
  end,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_DebugFX,
  ActionName = S[302535920001184--[[Particles--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001175--[[Debug FX--]]],"/",S[302535920001184--[[Particles--]]]),
  ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      DebugFXParticles,
      302535920001176--[[Toggle showing FX debug info in console.--]]
    )
  end,
  OnAction = function()
    ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXParticles",302535920001184)
  end,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_DebugFX,
  ActionName = S[4107--[[Sound FX--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001175--[[Debug FX--]]],"/",S[4107--[[Sound FX--]]]),
  ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      DebugFXSound,
      302535920001176--[[Toggle showing FX debug info in console.--]]
    )
  end,
  OnAction = function()
    ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXSound",4107)
  end,
}

local str_Debug_PathMarkers = Concat(S[487939677892--[[Help--]]],".",S[302535920000467--[[Path Markers--]]])
Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000467--[[Path Markers--]]],
  ActionId = str_Debug_PathMarkers,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_PathMarkers,
  ActionName = Concat(S[302535920000467--[[Path Markers--]]]," ",S[4099--[[Game Time--]]]),
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000467--[[Path Markers--]]]," ",S[4099--[[Game Time--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
  RolloverText = Concat(S[302535920000462--[[Maps paths in real time--]]]," ",S[302535920000874--[[(see "Path Markers" to mark more than one at a time).--]]]),
  OnAction = function()
    ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,true)
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetPathMarkersGameTime,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_PathMarkers,
  ActionName = S[302535920000467--[[Path Markers--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000467--[[Path Markers--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
  RolloverText = S[302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.--]]],
  OnAction = function()
    ChoGGi.MenuFuncs.SetPathMarkersVisible()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetPathMarkersVisible,
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000146--[[Delete Saved Games--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/[98]",S[302535920000146--[[Delete Saved Games--]]]),
  ActionIcon = "CommonAssets/UI/Menu/DeleteArea.tga",
  RolloverText = Concat(S[302535920001273--[["Shows a list of saved games, and allows you to delete more than one at a time."--]]],"\n\n",S[302535920001274--[[This is permanent!--]]]),
  OnAction = ChoGGi.MenuFuncs.DeleteSavedGames,
  ActionSortKey = "98",
}

Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000487--[[Delete All Of Selected Object--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/[99]",S[302535920000487--[[Delete All Of Selected Object--]]]),
  ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
  RolloverText = S[302535920000488--[[Will ask for confirmation beforehand (will not delete domes).--]]],
  OnAction = function()
    ChoGGi.MenuFuncs.DeleteAllSelectedObjects()
  end,
  ActionSortKey = "99",
}

local str_Debug_DeleteObjects = Concat(S[487939677892--[[Help--]]],".",S[302535920000489--[[Delete Object(s)--]]])
Actions[#Actions+1] = {
  ActionMenubar = S[1000113--[[Debug--]]],
  ActionName = S[302535920000489--[[Delete Object(s)--]]],
  ActionId = str_Debug_DeleteObjects,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Debug_DeleteObjects,
  ActionName = S[302535920000489--[[Delete Object(s)--]]],
  ActionId = Concat("/[50]",S[1000113--[[Debug--]]],"/[99]",S[302535920000489--[[Delete Object(s)--]]],"/",S[302535920000489--[[Delete Object(s)--]]]),
  ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
  RolloverText = S[302535920000490--[["Deletes selected object or object under mouse cursor (most objs, not all).

Use Editor Mode and mouse drag to select multiple objects for deletion."--]]],
  OnAction = function()
    ChoGGi.CodeFuncs.DeleteObject()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.DeleteObject,
  ActionSortKey = "99",
}
