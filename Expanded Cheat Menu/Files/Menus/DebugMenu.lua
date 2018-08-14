--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

local OpenGedGameObjectEditor = OpenGedGameObjectEditor
local ToggleTerrainDepositGrid = ToggleTerrainDepositGrid

--~ local icon = "new_city.tga"

--~ AddAction(Entry,Menu,Action,Key,Des,Icon)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001208--[[Export Colonist Data To CSV--]]]),
  ChoGGi.MenuFuncs.ExportColonistDataToCSV,
  nil,
  302535920001219--[[Exports data about colonists to AppData/Colonists.csv--]],
  "SelectByClassName.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000449--[[Attach Spots Toggle--]]]),
  ChoGGi.MenuFuncs.AttachSpots_Toggle,
  nil,
  302535920000450--[[Toggle showing attachment spots on selected object.--]],
  "ShowAll.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000451--[[Measure Tool--]]]),
  function()
    ChoGGi.MenuFuncs.MeasureTool_Toggle(true)
  end,
  ChoGGi.UserSettings.KeyBindings.MeasureTool_Toggle,
  302535920000452--[[Measures stuff (Use Ctrl-Shift-M to remove the lines).--]],
  "MeasureTool.tga"
)

AddAction(
  nil,
  nil,
  function()
    ChoGGi.MenuFuncs.MeasureTool_Toggle()
  end,
  ChoGGi.UserSettings.KeyBindings.MeasureTool_Clear
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000453--[[Reload Lua--]]]),
  ChoGGi.MenuFuncs.ReloadLua,
  nil,
  302535920000454--[[Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).--]],
  "EV_OpenFirst.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000455--[[Object Cloner--]]]),
  function()
    ChoGGi.MenuFuncs.ObjectCloner()
  end,
  ChoGGi.UserSettings.KeyBindings.ObjectCloner,
  302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).--]],
  "EnrichTerrainEditor.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000457--[[Anim State Set--]]]),
  ChoGGi.MenuFuncs.SetAnimState,
  nil,
  302535920000458--[[Make object dance on command.--]],
  "UnlockCamera.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000459--[[Anim Debug Toggle--]]]),
  ChoGGi.MenuFuncs.ShowAnimDebug_Toggle,
  nil,
  302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]],
  "CameraEditor.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000467--[[Path Markers--]]]," ",S[4099--[[Game Time--]]]),
  function()
    ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,true)
  end,
  ChoGGi.UserSettings.KeyBindings.SetPathMarkersGameTime,
  Concat(S[302535920000462--[[Maps paths in real time--]]]," ",S[302535920000874--[[(see "Path Markers" to mark more than one at a time).--]]]),
  "ViewCamPath.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000467--[[Path Markers--]]]),
  function()
    ChoGGi.MenuFuncs.SetPathMarkersVisible()
  end,
  ChoGGi.UserSettings.KeyBindings.SetPathMarkersVisible,
  302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.--]],
  "ViewCamPath.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000471--[[Object Manipulator--]]]),
  function()
    ChoGGi.ComFuncs.OpenInObjectManipulator()
  end,
  ChoGGi.UserSettings.KeyBindings.OpenInObjectManipulator,
  302535920000472--[[Manipulate objects (selected or under mouse cursor)--]],
  "SaveMapEntityList.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000473--[[Selection Editor--]]]),
  ChoGGi.MenuFuncs.ShowSelectionEditor,
  nil,
  302535920000474--[["Lets you manipulate objects.

If you leave it opened during a game load/save, then click this menu item to make it closeable)."--]],
  "AreaProperties.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000475--[[Object Spawner--]]]),
  ChoGGi.MenuFuncs.ObjectSpawner,
  ChoGGi.UserSettings.KeyBindings.ObjectSpawner,
  302535920000476--[["Shows list of objects, and spawns at mouse cursor.

Warning: Unable to mouse select items after spawn
hover mouse over and use Delete Selected Object"--]],
  "add_water.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000479--[[Toggle Editor--]]]),
  ChoGGi.MenuFuncs.Editor_Toggle,
  ChoGGi.UserSettings.KeyBindings.Editor_Toggle,
  302535920000480--[["Select object(s) then hold ctrl/shift/alt and drag mouse.
click+drag for multiple selection.

It's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look)."--]],
  "SelectionEditor.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000481--[[Open In Ged Object Editor--]]]),
  function()
    OpenGedGameObjectEditor(ChoGGi.CodeFuncs.SelObject())
  end,
  nil,
  302535920000482--[[It edits stuff?--]],
  "SelectionEditor.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000491--[[Examine Object--]]]),
  function()
    ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.CodeFuncs.SelObject())
  end,
  ChoGGi.UserSettings.KeyBindings.ObjExaminer,
  302535920000492--[[Opens the object examiner for the selected or moused-over obj.--]],
  "PlayerInfo.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920000495--[[Particles Reload--]]]),
  ChoGGi.MenuFuncs.ParticlesReload,
  nil,
  302535920000496--[[Reloads particles from "Data/Particles"...--]],
  "place_particles.tga"
)

-------------------------------toggle grids
AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[08]",S[302535920000497--[[Toggle Terrain Deposit Grid--]]]),
  ToggleTerrainDepositGrid,
  ChoGGi.UserSettings.KeyBindings.ToggleTerrainDepositGrid,
  302535920000498--[[Shows a grid around concrete.--]],
  "ToggleBlockPass.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[09]",S[302535920000499--[[Toggle Hex Build + Passability Grid Visibility--]]]),
  function()
    ChoGGi.MenuFuncs.debug_build_grid(1)
  end,
  ChoGGi.UserSettings.KeyBindings.debug_build_grid_both,
  302535920000500--[[Shows a hex grid with green for buildable/walkable.--]],
  "ToggleOcclusion.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[10]",S[302535920000501--[[Toggle Hex Passability Grid Visibility--]]]),
  function()
    ChoGGi.MenuFuncs.debug_build_grid(2)
  end,
  ChoGGi.UserSettings.KeyBindings.debug_build_grid_pass,
  302535920000502--[[Shows a hex grid with green for walkable terrain.--]],
  "CollisionGeometry.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[11]",S[302535920000503--[[Toggle Hex Build Grid Visibility--]]]),
  function()
    ChoGGi.MenuFuncs.debug_build_grid(3)
  end,
  ChoGGi.UserSettings.KeyBindings.debug_build_grid_build,
  302535920000504--[[Shows a hex grid with green for buildable (ignores uneven terrain).--]],
  "ToggleCollisions.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[12]",S[302535920001297--[[Toggle Flight Grid--]]]),
  function()
    ChoGGi.CodeFuncs.FlightGrid_Toggle()
  end,
  ChoGGi.UserSettings.KeyBindings.debug_grid_squares,
  302535920001298--[[Shows a square grid with terrain/objects shape.--]],
  "ToggleCollisions.tga"
)
-------------------------------toggle grids

-------------------------------debugfx
AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001175--[[Debug FX--]]],"/",S[302535920001175--[[Debug FX--]]]),
  function()
    ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFX",302535920001175)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      DebugFX,
      302535920001176--[[Toggle showing FX debug info in console.--]]
    )
  end,
  "FXEditor.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001175--[[Debug FX--]]],"/",S[302535920001184--[[Particles--]]]),
  function()
    ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXParticles",302535920001184)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      DebugFXParticles,
      302535920001176--[[Toggle showing FX debug info in console.--]]
    )
  end,
  "place_particles.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/",S[302535920001175--[[Debug FX--]]],"/",S[4107--[[Sound FX--]]]),
  function()
    ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXSound",4107)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      DebugFXSound,
      302535920001176--[[Toggle showing FX debug info in console.--]]
    )
  end,
  "DisableEyeSpec.tga"
)
-------------------------------debugfx

------------------------------- DELETE
AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[98]",S[302535920000146--[[Delete Saved Games--]]]),
  ChoGGi.MenuFuncs.DeleteSavedGames,
  nil,
  Concat(S[302535920001273--[["Shows a list of saved games, and allows you to delete more than one at a time."--]]],"\n\n",S[302535920001274--[[This is permanent!--]]]),
  "DeleteArea.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[99]",S[302535920000487--[[Delete All Of Selected Object--]]]),
  function()
    ChoGGi.MenuFuncs.DeleteAllSelectedObjects()
  end,
  nil,
  302535920000488--[[Will ask for confirmation beforehand (will not delete domes).--]],
  "delete_objects.tga"
)

AddAction(
  {"/[50]",S[1000113--[[Debug--]]],"/"},
  Concat("/[50]",S[1000113--[[Debug--]]],"/[99]",S[302535920000489--[[Delete Object(s)--]]],"/",S[302535920000489--[[Delete Object(s)--]]]),
  function()
    ChoGGi.CodeFuncs.DeleteObject()
  end,
  ChoGGi.UserSettings.KeyBindings.DeleteObject,
  302535920000490--[["Deletes selected object or object under mouse cursor (most objs, not all).

Use Editor Mode and mouse drag to select multiple objects for deletion."--]],
  "delete_objects.tga"
)
------------------------------- DELETE
