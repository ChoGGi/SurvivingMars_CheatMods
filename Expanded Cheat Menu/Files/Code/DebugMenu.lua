--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.DebugMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Attach Spots Toggle",
    ChoGGi.MenuFuncs.AttachSpots_Toggle,
    nil,
    "Toggle showing attachment spots on selected object.",
    "ShowAll.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Measure Tool",
    function()
      ChoGGi.MenuFuncs.MeasureTool_Toggle(true)
    end,
    "Ctrl-M",
    "Measures stuff (Use Ctrl-Shift-M to remove the lines).",
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
    "[102]Debug/Reload Lua",
    ChoGGi.MenuFuncs.ReloadLua,
    nil,
    "Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).",
    "EV_OpenFirst.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Object Cloner",
    ChoGGi.MenuFuncs.ObjectCloner,
    "Shift-Q",
    "Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).",
    "EnrichTerrainEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Anim State Set",
    ChoGGi.MenuFuncs.SetAnimState,
    nil,
    "Make object dance on command.",
    "UnlockCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Anim Debug Toggle",
    ChoGGi.MenuFuncs.ShowAnimDebug_Toggle,
    nil,
    "Attaches text to each object showing animation info (or just to selected object).",
    "CameraEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Path Markers Real Time/lines",
    function()
      ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,true,true)
    end,
    "Ctrl-Numpad .",
    "Maps paths in realtime (just lines).",
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Path Markers Real Time/lines & flags",
    function()
      ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,nil,true)
    end,
    "Ctrl-Numpad 3",
    "Maps paths in realtime (doesn't show label).",
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Path Markers Real Time/lines & flags & label",
    ChoGGi.MenuFuncs.SetPathMarkersGameTime,
    "Ctrl-Numpad 2",
    "Maps paths in realtime (shows all).",
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Path Markers Visible",
    ChoGGi.MenuFuncs.SetPathMarkersVisible,
    "Ctrl-Numpad 0",
    "Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.",
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Close Dialogs",
    ChoGGi.CodeFuncs.CloseDialogsECM,
    nil,
    "Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)",
    "remove_water.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Object Manipulator",
    ChoGGi.ComFuncs.OpenInObjectManipulator,
    "F5",
    "Manipulate objects (selected or under mouse cursor)",
    "SaveMapEntityList.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Selection Editor",
    ChoGGi.MenuFuncs.ShowSelectionEditor,
    nil,
    "Lets you manipulate objects.\n\nIf you leave it opened during a game load/save, then click this menu item to make it closeable).",
    "AreaProperties.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Object Spawner",
    ChoGGi.MenuFuncs.ObjectSpawner,
    "Ctrl-Shift-S",
    "Shows list of objects, and spawns at mouse cursor.\n\nWarning: Unable to mouse select items after spawn\nhover mouse over and use Delete Selected Object ",
    "add_water.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Console Clear Display",
    cls,
    "F9",
    "Clears console history display.",
    "Voice.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Toggle Editor",
    ChoGGi.MenuFuncs.Editor_Toggle,
    "Ctrl-Shift-E",
    "Select object(s) then hold ctrl/shift/alt and drag mouse.\nclick+drag for multiple selection.\n\nIt's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look).",
    "SelectionEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Open In Ged Editor",
    function()
      OpenGedGameObjectEditor(ChoGGi.CodeFuncs.SelObject())
    end,
    nil,
    "It edits stuff?",
    "SelectionEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Write Logs",
    ChoGGi.MenuFuncs.SetWriteLogs_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.WriteLogs and "(Enabled)" or "(Disabled)"
      return des .. " Write debug/console logs to AppData/logs."
    end,
    "save_city.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Console Toggle History",
    ChoGGi.MenuFuncs.ConsoleHistory_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ConsoleToggleHistory and "(Enabled)" or "(Disabled)"
      return des .. " Show console history on screen."
    end,
    "Voice.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Delete All Of Selected Object",
    ChoGGi.MenuFuncs.DeleteAllSelectedObjects,
    nil,
    "Will ask for confirmation beforehand (will not delete domes).",
    "delete_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Delete Object(s)",
    ChoGGi.CodeFuncs.DeleteObject,
    "Ctrl-Alt-Shift-D",
    "Deletes selected object or object under mouse cursor (most objs, not all).\n\nUse Editor Mode and mouse drag to select multiple objects for deletion.",
    "delete_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Examine Current Obj",
    ChoGGi.MenuFuncs.ObjExaminer,
    "F4",
    "Opens the object examiner",
    "PlayerInfo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Change Map",
    ChoGGi.MenuFuncs.ChangeMap,
    nil,
    "Change map (options to pick commander, sponsor, etc...\n\nAttention: The first change usually screws up with some yellow ground (ideas?).\nThe map disaster settings don't do jack.",
    "load_city.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/Particles Reload",
    function()
      LoadStreamParticlesFromDir("Data/Particles")
      ParticlesReload("", true)
    end,
    nil,
    "Reloads particles from \"Data/Particles\"...",
    "place_particles.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/[08]Toggle Terrain Deposit Grid",
    ToggleTerrainDepositGrid,
    "Ctrl-F4",
    "Shows a grid around concrete.",
    "ToggleBlockPass.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/[09]Toggle Hex Build + Passability Grid Visibility",
    function()
      ChoGGi.MenuFuncs.debug_build_grid(1)
    end,
    "Shift-F1",
    "Shows a hex grid with green for buildable/walkable.",
    "ToggleOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/[10]Toggle Hex Passability Grid Visibility",
    function()
      ChoGGi.MenuFuncs.debug_build_grid(2)
    end,
    "Shift-F2",
    "Shows a hex grid with green for walkable terrain.",
    "CollisionGeometry.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[102]Debug/[11]Toggle Hex Build Grid Visibility",
    function()
      ChoGGi.MenuFuncs.debug_build_grid(3)
    end,
    "Shift-F3",
    "Shows a hex grid with green for buildable (ignores uneven terrain).",
    "ToggleCollisions.tga"
  )

end
