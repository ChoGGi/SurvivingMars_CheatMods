--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
--~ local icon = "new_city.tga"

local cls = cls
local OpenGedGameObjectEditor = OpenGedGameObjectEditor
local ToggleTerrainDepositGrid = ToggleTerrainDepositGrid
--~ local OpenGedApp = OpenGedApp
--~ OpenGedApp("XWindowInspector", dialog_object)

function ChoGGi.MsgFuncs.DebugMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000449--[[Attach Spots Toggle--]])),
    ChoGGi.MenuFuncs.AttachSpots_Toggle,
    nil,
    T(302535920000450--[[Toggle showing attachment spots on selected object.--]]),
    "ShowAll.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000451--[[Measure Tool--]])),
    function()
      ChoGGi.MenuFuncs.MeasureTool_Toggle(true)
    end,
    "Ctrl-M",
    T(302535920000452--[[Measures stuff (Use Ctrl-Shift-M to remove the lines).--]]),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    nil,
    function()
      ChoGGi.MenuFuncs.MeasureTool_Toggle()
    end,
    "Ctrl-Shift-M"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000453--[[Reload Lua--]])),
    ChoGGi.MenuFuncs.ReloadLua,
    nil,
    T(302535920000454--[[Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).--]]),
    "EV_OpenFirst.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000455--[[Object Cloner--]])),
    ChoGGi.MenuFuncs.ObjectCloner,
    "Shift-Q",
    T(302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).--]]),
    "EnrichTerrainEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000457--[[Anim State Set--]])),
    ChoGGi.MenuFuncs.SetAnimState,
    nil,
    T(302535920000458--[[Make object dance on command.--]]),
    "UnlockCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000459--[[Anim Debug Toggle--]])),
    ChoGGi.MenuFuncs.ShowAnimDebug_Toggle,
    nil,
    T(302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]),
    "CameraEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/Path Markers Real Time/",T(302535920000461--[[Lines--]])),
    function()
      ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,true,true)
    end,
    "Ctrl-Numpad .",
    T(302535920000462--[[Maps paths in realtime (just lines).--]]),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/Path Markers Real Time/",T(302535920000463--[[Lines & Flags--]])),
    function()
      ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,nil,true)
    end,
    "Ctrl-Numpad 3",
    T(302535920000464--[[Maps paths in realtime (doesn't show label).--]]),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/Path Markers Real Time/",T(302535920000465--[[Lines & Flags & Label--]])),
    ChoGGi.MenuFuncs.SetPathMarkersGameTime,
    "Ctrl-Numpad 2",
    T(302535920000466--[[Maps paths in realtime (shows all).--]]),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000467--[[Path Markers Toggle--]])),
    ChoGGi.MenuFuncs.SetPathMarkersVisible,
    "Ctrl-Numpad 0",
    T(302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.--]]),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000471--[[Object Manipulator--]])),
    ChoGGi.ComFuncs.OpenInObjectManipulator,
    "F5",
    T(302535920000472--[[Manipulate objects (selected or under mouse cursor)--]]),
    "SaveMapEntityList.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000473--[[Selection Editor--]])),
    ChoGGi.MenuFuncs.ShowSelectionEditor,
    nil,
    T(302535920000474--[[Lets you manipulate objects.\n\nIf you leave it opened during a game load/save, then click this menu item to make it closeable).--]]),
    "AreaProperties.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000475--[[Object Spawner--]])),
    ChoGGi.MenuFuncs.ObjectSpawner,
    "Ctrl-Shift-S",
    T(302535920000476--[[Shows list of objects, and spawns at mouse cursor.\n\nWarning: Unable to mouse select items after spawn\nhover mouse over and use Delete Selected Object--]]),
    "add_water.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000477--[[Console: Clear Log--]])),
    cls,
    "F9",
    T(302535920000478--[[Clears console history display.--]]),
    "Voice.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000479--[[Toggle Editor--]])),
    ChoGGi.MenuFuncs.Editor_Toggle,
    "Ctrl-Shift-E",
    T(302535920000480--[[Select object(s) then hold ctrl/shift/alt and drag mouse.\nclick+drag for multiple selection.\n\nIt's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look).--]]),
    "SelectionEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000481--[[Open In Ged Object Editor--]])),
    function()
      OpenGedGameObjectEditor(ChoGGi.CodeFuncs.SelObject())
    end,
    nil,
    T(302535920000482--[[It edits stuff?--]]),
    "SelectionEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000483--[[Write Logs--]])),
    ChoGGi.MenuFuncs.SetWriteLogs_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.WriteLogs,
        302535920000484 --,"Write debug/console logs to AppData/logs."
      )
    end,
    "save_city.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000485--[[Console: Toggle On-Screen Log--]])),
    ChoGGi.MenuFuncs.ConsoleHistory_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ConsoleToggleHistory,
        302535920000486 --,"Show console history on screen."
      )
    end,
    "Voice.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000487--[[Delete All Of Selected Object--]])),
    ChoGGi.MenuFuncs.DeleteAllSelectedObjects,
    nil,
    T(302535920000488--[[Will ask for confirmation beforehand (will not delete domes).--]]),
    "delete_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000489--[[Delete Object(s)--]])),
    ChoGGi.CodeFuncs.DeleteObject,
    "Ctrl-Alt-Shift-D",
    T(302535920000490--[[Deletes selected object or object under mouse cursor (most objs, not all).\n\nUse Editor Mode and mouse drag to select multiple objects for deletion.--]]),
    "delete_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000491--[[Examine Current Obj--]])),
    ChoGGi.MenuFuncs.ObjExaminer,
    "F4",
    T(302535920000492--[[Opens the object examiner--]]),
    "PlayerInfo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000493--[[Change Map--]])),
    ChoGGi.MenuFuncs.ChangeMap,
    nil,
    T(302535920000494--[[Change map (options to pick commander, sponsor, etc...\n\nAttention: If you get yellow ground areas; just load it again.\nThe map disaster settings don't do jack.--]]),
    "load_city.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000495--[[Particles Reload--]])),
    ChoGGi.MenuFuncs.ParticlesReload,
    nil,
    T(302535920000496--[[Reloads particles from \"Data/Particles\"...--]]),
    "place_particles.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/[08]",T(302535920000497--[[Toggle Terrain Deposit Grid--]])),
    ToggleTerrainDepositGrid,
    "Ctrl-F4",
    T(302535920000498--[[Shows a grid around concrete.--]]),
    "ToggleBlockPass.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/[09]",T(302535920000499--[[Toggle Hex Build + Passability Grid Visibility--]])),
    function()
      ChoGGi.MenuFuncs.debug_build_grid(1)
    end,
    "Shift-F1",
    T(302535920000500--[[Shows a hex grid with green for buildable/walkable.--]]),
    "ToggleOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/[10]",T(302535920000501--[[Toggle Hex Passability Grid Visibility--]])),
    function()
      ChoGGi.MenuFuncs.debug_build_grid(2)
    end,
    "Shift-F2",
    T(302535920000502--[[Shows a hex grid with green for walkable terrain.--]]),
    "CollisionGeometry.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[102]Debug/[11]",T(302535920000503--[[Toggle Hex Build Grid Visibility--]])),
    function()
      ChoGGi.MenuFuncs.debug_build_grid(3)
    end,
    "Shift-F3",
    T(302535920000504--[[Shows a hex grid with green for buildable (ignores uneven terrain).--]]),
    "ToggleCollisions.tga"
  )

end
