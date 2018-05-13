local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.DebugMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  CComFuncs.AddAction(
    "[102]Debug/Toggle Showing Anim Debug",
    CMenuFuncs.ShowAnimDebug_Toggle,
    nil,
    "Attaches text to each object showing animation info.",
    "CameraEditor.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Visible Path Markers",
    CMenuFuncs.SetVisiblePathMarkers,
    "Ctrl-Numpad 0",
    "Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.",
    "ViewCamPath.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Close Dialogs",
    CCodeFuncs.CloseDialogsECM,
    nil,
    "Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)",
    "remove_water.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Object Manipulator",
    CCodeFuncs.OpenInObjectManipulator,
    "F5",
    "Manipulate objects (selected or under mouse cursor)",
    "SaveMapEntityList.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Selection Editor",
    CMenuFuncs.ShowSelectionEditor,
    nil,
    "Lets you manipulate objects.\n\nIf you leave it opened during a game load/save, then click this menu item to make it closeable).",
    "AreaProperties.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Object Spawner",
    CMenuFuncs.ObjectSpawner,
    "Ctrl-Shift-S",
    "Shows list of objects, and spawns at mouse cursor.\n\nWarning: Unable to mouse select items after spawn\nhover mouse over and use Delete Selected Object ",
    "add_water.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Console Clear Display",
    cls,
    "F9",
    "Clears console history display.",
    "Voice.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Toggle Editor",
    CMenuFuncs.Editor_Toggle,
    "Ctrl-Shift-E",
    "Select object(s) then hold ctrl/shift/alt and drag mouse.\nclick+drag for multiple selection.\n\nIt's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look).",
    "SelectionEditor.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Open In Ged Editor",
    function()
      OpenGedGameObjectEditor(CCodeFuncs.SelObject())
    end,
    nil,
    "It edits stuff?",
    "SelectionEditor.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Write Logs",
    CMenuFuncs.SetWriteLogs_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.WriteLogs and "(Enabled)" or "(Disabled)"
      return des .. " Write debug/console logs to AppData/logs."
    end,
    "save_city.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Console Toggle History",
    CMenuFuncs.ConsoleHistory_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ConsoleToggleHistory and "(Enabled)" or "(Disabled)"
      return des .. " Show console history on screen."
    end,
    "Voice.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/[09]Toggle Terrain Deposit Grid",
    ToggleTerrainDepositGrid,
    "Ctrl-F4",
    "Shows a grid around concrete.",
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/[09]Toggle Hex Build Grid Visibility",
    CMenuFuncs.debug_build_grid,
    "Ctrl-F3",
    "Shows a hex grid with green for buildable (ignores uneven terrain).",
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/[09]Toggle Hex Passability Grid Visibility",
    function()
      CMenuFuncs.debug_build_grid(true)
    end,
    "Ctrl-F2",
    "Shows a hex grid with green for walkable terrain.",
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Delete Object(s)",
    CMenuFuncs.DeleteObjects,
    "Ctrl-Alt-Shift-D",
    "Deletes selected object or object under mouse cursor (most objs, not all).\n\nUse Editor Mode and mouse drag to select multiple objects for deletion.",
    "delete_objects.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Examine Current Obj",
    CMenuFuncs.ObjExaminer,
    "F4",
    "Opens the object examiner",
    "PlayerInfo.tga"
  )

  CComFuncs.AddAction(
    "[102]Debug/Change Map",
    CMenuFuncs.ChangeMap,
    nil,
    "Change Map",
    "load_city.tga"
    --toolbar = "01_File/01_ChangeMap",
  )

  --[[
  CComFuncs.AddAction(
    "[203]Editors/ReloadStaticClasses()",
    ReloadStaticClasses,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/ReloadTexture()",
    ReloadTexture,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/ReloadEntity()",
    ReloadEntity,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/InitSourceController()",
    InitSourceController,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/CNSProcess()",
    CNSProcess,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/ParticlesReload()",
    ParticlesReload,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/ReloadShaders()",
    hr.ReloadShaders,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[2]Toggle Buildable Grid",
    DbgToggleBuildableGrid,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[3]Draw Min Circles",
    PrefabDbgDrawMinCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[4]Draw Max Circles",
    PrefabDbgDrawMaxCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[5]Draw Decor Circles",
    PrefabDbgDrawDecorCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[6]Draw Prefab Pos",
    PrefabDbgDrawPos,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[7]Draw Resource Clusters",
    PrefabDbgDrawResourceClusters,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[8]Draw Features",
    PrefabDbgDrawFeatures,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[9]Editor Objects",
    PrefabEditorObjectsToggle,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/Resave All Prefabs",
    ResaveAllPrefabs,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/Resave All Blank Maps",
    ResaveAllBlankMaps,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  CComFuncs.AddAction(
    "[203]Editors/[02]Random Map/Recover Game Revision",
    function()
      local gen = GetRandomMapGenerator() or GetRandomMapGeneratorHolder()
      if gen then
        CreateRealTimeThread(function(gen)
          gen:RecoverRevision()
        end, gen)
      end
    end,
    nil,
    nil,
    "CollisionGeometry.tga"
    --mode = "Editor",
  )
  --]]
end
