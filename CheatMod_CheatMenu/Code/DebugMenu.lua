function ChoGGi.MsgFuncs.DebugMenu_LoadingScreenPreClose()
  --ChoGGi.Funcs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Close Dialogs",
    ChoGGi.Funcs.CloseDialogsECM,
    nil,
    "Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)",
    "remove_water.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Object Manipulator",
    ChoGGi.Funcs.OpenInObjectManipulator,
    "F5",
    "Manipulate objects (selected or under mouse cursor)",
    "SaveMapEntityList.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Selection Editor",
    ChoGGi.MenuFuncs.ShowSelectionEditor,
    nil,
    "Lets you manipulate objects.\n\nIf you leave it opened during a game load/save, then click this menu item to make it closeable).",
    "AreaProperties.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Object Spawner",
    ChoGGi.MenuFuncs.ObjectSpawner,
    "Ctrl-Shift-S",
    "Shows list of objects, and spawns at mouse cursor.\n\nWarning: Unable to mouse select items after spawn\nhover mouse over and use Delete Selected Object ",
    "add_water.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Console Clear Display",
    cls,
    "F9",
    "Clears console history display.",
    "Voice.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Toggle Editor",
    ChoGGi.MenuFuncs.Editor_Toggle,
    "Ctrl-Shift-E",
    "Select object(s) then hold ctrl/shift/alt and drag mouse.\nclick+drag for multiple selection.\n\nIt's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look).",
    "SelectionEditor.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Open In Ged Editor",
    function()
      OpenGedGameObjectEditor(SelectedObj or SelectionMouseObj() or ChoGGi.Funcs.CursorNearestObject())
    end,
    nil,
    "It edits stuff?",
    "SelectionEditor.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Write Logs",
    ChoGGi.MenuFuncs.SetWriteLogs_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.WriteLogs and "(Enabled)" or "(Disabled)"
      return des .. " Write debug/console logs to AppData/logs."
    end,
    "save_city.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Console Toggle History",
    ChoGGi.MenuFuncs.ConsoleHistory_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ConsoleToggleHistory and "(Enabled)" or "(Disabled)"
      return des .. " Show console history on screen."
    end,
    "Voice.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/[09]Toggle Terrain Deposit Grid",
    ToggleTerrainDepositGrid,
    "Ctrl-F4",
    "Shows a grid around concrete.",
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/[09]Toggle Hex Build Grid Visibility",
    ChoGGi.MenuFuncs.debug_build_grid,
    "Ctrl-F3",
    "Shows a hex grid with green for buildable (ignores uneven terrain).",
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/[09]Toggle Hex Passability Grid Visibility",
    function()
      ChoGGi.MenuFuncs.debug_build_grid(true)
    end,
    "Ctrl-F2",
    "Shows a hex grid with green for walkable terrain.",
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Delete Object",
    ChoGGi.MenuFuncs.DeleteObject,
    "Ctrl-Alt-Shift-D",
    "Deletes selected object or object under mouse cursor (most obj, not all).",
    "delete_objects.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Examine Current Obj",
    ChoGGi.MenuFuncs.ObjExaminer,
    "F4",
    "Opens the object examiner",
    "PlayerInfo.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[102]Debug/Change Map",
    ChoGGi.MenuFuncs.ChangeMap,
    nil,
    "Change Map",
    "load_city.tga"
    --toolbar = "01_File/01_ChangeMap",
  )

  --[[
  ChoGGi.Funcs.AddAction(
    "[203]Editors/ReloadStaticClasses()",
    ReloadStaticClasses,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/ReloadTexture()",
    ReloadTexture,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/ReloadEntity()",
    ReloadEntity,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/InitSourceController()",
    InitSourceController,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/CNSProcess()",
    CNSProcess,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/ParticlesReload()",
    ParticlesReload,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/ReloadShaders()",
    hr.ReloadShaders,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[2]Toggle Buildable Grid",
    DbgToggleBuildableGrid,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[3]Draw Min Circles",
    PrefabDbgDrawMinCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[4]Draw Max Circles",
    PrefabDbgDrawMaxCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[5]Draw Decor Circles",
    PrefabDbgDrawDecorCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[6]Draw Prefab Pos",
    PrefabDbgDrawPos,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[7]Draw Resource Clusters",
    PrefabDbgDrawResourceClusters,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[8]Draw Features",
    PrefabDbgDrawFeatures,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[9]Editor Objects",
    PrefabEditorObjectsToggle,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/Resave All Prefabs",
    ResaveAllPrefabs,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
    "[203]Editors/[02]Random Map/Resave All Blank Maps",
    ResaveAllBlankMaps,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.Funcs.AddAction(
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
