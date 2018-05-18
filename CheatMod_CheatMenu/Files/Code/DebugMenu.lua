local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.DebugMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  --object cloner
  cComFuncs.AddAction(
    "[102]Debug/Object Cloner",
    cMenuFuncs.ObjectCloner,
    "Shift-Q",
    "Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item)."
  )

  cComFuncs.AddAction(
    "[102]Debug/Toggle Showing Anim Debug",
    cMenuFuncs.ShowAnimDebug_Toggle,
    nil,
    "Attaches text to each object showing animation info.",
    "CameraEditor.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Visible Path Markers",
    cMenuFuncs.SetVisiblePathMarkers,
    "Ctrl-Numpad 0",
    "Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.",
    "ViewCamPath.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Close Dialogs",
    cCodeFuncs.CloseDialogsECM,
    nil,
    "Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)",
    "remove_water.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Object Manipulator",
    cCodeFuncs.OpenInObjectManipulator,
    "F5",
    "Manipulate objects (selected or under mouse cursor)",
    "SaveMapEntityList.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Selection Editor",
    cMenuFuncs.ShowSelectionEditor,
    nil,
    "Lets you manipulate objects.\n\nIf you leave it opened during a game load/save, then click this menu item to make it closeable).",
    "AreaProperties.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Object Spawner",
    cMenuFuncs.ObjectSpawner,
    "Ctrl-Shift-S",
    "Shows list of objects, and spawns at mouse cursor.\n\nWarning: Unable to mouse select items after spawn\nhover mouse over and use Delete Selected Object ",
    "add_water.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Console Clear Display",
    cls,
    "F9",
    "Clears console history display.",
    "Voice.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Toggle Editor",
    cMenuFuncs.Editor_Toggle,
    "Ctrl-Shift-E",
    "Select object(s) then hold ctrl/shift/alt and drag mouse.\nclick+drag for multiple selection.\n\nIt's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look).",
    "SelectionEditor.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Open In Ged Editor",
    function()
      OpenGedGameObjectEditor(cCodeFuncs.SelObject())
    end,
    nil,
    "It edits stuff?",
    "SelectionEditor.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Write Logs",
    cMenuFuncs.SetWriteLogs_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.WriteLogs and "(Enabled)" or "(Disabled)"
      return des .. " Write debug/console logs to AppData/logs."
    end,
    "save_city.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Console Toggle History",
    cMenuFuncs.ConsoleHistory_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ConsoleToggleHistory and "(Enabled)" or "(Disabled)"
      return des .. " Show console history on screen."
    end,
    "Voice.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/[09]Toggle Terrain Deposit Grid",
    ToggleTerrainDepositGrid,
    "Ctrl-F4",
    "Shows a grid around concrete.",
    "CollisionGeometry.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/[09]Toggle Hex Build + Passability Grid Visibility",
    function()
      cMenuFuncs.debug_build_grid(1)
    end,
    "Shift-F1",
    "Shows a hex grid with green for buildable/walkable.",
    "CollisionGeometry.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/[10]Toggle Hex Passability Grid Visibility",
    function()
      cMenuFuncs.debug_build_grid(2)
    end,
    "Shift-F2",
    "Shows a hex grid with green for walkable terrain.",
    "CollisionGeometry.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/[11]Toggle Hex Build Grid Visibility",
    function()
      cMenuFuncs.debug_build_grid(3)
    end,
    "Shift-F3",
    "Shows a hex grid with green for buildable (ignores uneven terrain).",
    "CollisionGeometry.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Delete Object(s)",
    cCodeFuncs.DeleteObjects,
    "Ctrl-Alt-Shift-D",
    "Deletes selected object or object under mouse cursor (most objs, not all).\n\nUse Editor Mode and mouse drag to select multiple objects for deletion.",
    "delete_objects.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Examine Current Obj",
    cMenuFuncs.ObjExaminer,
    "F4",
    "Opens the object examiner",
    "PlayerInfo.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/Change Map",
    cMenuFuncs.ChangeMap,
    nil,
    "Change map (options to pick commander, sponsor, etc...\n\nAttention: The first change usually screws up with some yellow ground (ideas?).\nThe map disaster settings don't do jack.",
    "load_city.tga"
  )

  cComFuncs.AddAction(
    "[102]Debug/ParticlesReload",
    function()
      LoadStreamParticlesFromDir("Data/Particles")
      ParticlesReload("", true)
    end,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

end
