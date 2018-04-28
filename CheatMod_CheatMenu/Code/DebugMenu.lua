function ChoGGi.DebugMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  if ChoGGi.Testing then
    ChoGGi.AddAction(
      "[102]Debug/Object Manipulator",
      function()
        ChoGGi.OpenInObjectManipulator(SelectedObj or SelectionMouseObj())
      end,
      "F5",
      "Manipulate objects (selected or under mouse cursor)",
      "SaveMapEntityList.tga"
    )
  end

  ChoGGi.AddAction(
    "[102]Debug/Objects Stats",
    ChoGGi.ObjectsStats_Toggle,
    nil,
    "Lets you manipulate objects.\n\nIf you leave it opened during a game load/save, then use this menu item to make it closeable).",
    "ToggleCutSmoothTrans.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Object Spawner",
    ChoGGi.ObjectSpawner,
    "Ctrl-Shift-S",
    "Shows list of objects, and spawns at mouse cursor.\n\nWarning: Unable to mouse select items after spawn\nhover mouse over and use Delete Selected Object ",
    "add_water.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/[09]Toggle Hex Build Grid Visibility",
    ChoGGi.debug_build_grid,
    "Ctrl-F3",
    "Toggle Hex Build Grid Visibility",
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Console Clear Display",
    cls,
    "F9",
    "Clears console history display.",
    "Voice.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Toggle Editor",
    ChoGGi.Editor_Toggle,
    "Ctrl-Shift-E",
    "You can move stuff around, but that's all that I know.",
    "SelectionEditor.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Open In Ged Editor",
    function()
      OpenGedGameObjectEditor(SelectedObj or SelectionMouseObj())
    end,
    nil,
    "It edits stuff?",
    "SelectionEditor.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Write Logs",
    ChoGGi.SetWriteLogs,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.WriteLogs and "(Enabled)" or "(Disabled)"
      return des .. " Write debug/console logs to AppData/logs."
    end,
    "save_city.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Console Toggle History",
    ChoGGi.ConsoleHistory_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.ConsoleToggleHistory and "(Enabled)" or "(Disabled)"
      return des .. " Show console history on screen."
    end,
    "Voice.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/[09]Toggle Terrain Deposit Grid",
    ToggleTerrainDepositGrid,
    "Ctrl-F4",
    "Toggle Terrain Deposit Grid",
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Delete Selected Object",
    ChoGGi.DeleteObject,
    "Ctrl-Alt-Shift-D",
    "Deletes selected object or object under mouse cursor (most obj, not all).",
    "DeleteArea.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Asteroids/Meteor At Cursor",
    function()
      ChoGGi.MeteorBombardment(true)
    end,
    "Ctrl-Numpad 9",
    "May have trouble aiming when an object is selected.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Asteroids/Meteor Bombardment",
    function()
      ChoGGi.MeteorBombardment()
    end,
    nil,
    "Zoom out",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Asteroids/Asteroid At Cursor",
    function()
      ChoGGi.AsteroidBombardment(1)
    end,
    "Ctrl-Numpad 8",
    "Single shot.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Asteroids/Asteroid Multi At Cursor",
    function()
      ChoGGi.AsteroidBombardment(2)
    end,
    "Ctrl-Numpad 7",
    "Over and over.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Asteroids/Asteroid Storm At Cursor",
    function()
      ChoGGi.AsteroidBombardment(3)
    end,
    "Ctrl-Numpad 6",
    "Over and over.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Examine Current Obj",
    ChoGGi.ObjExaminer,
    "F4",
    "Opens the object examiner",
    "SelectByClassName.tga"
  )

  ChoGGi.AddAction(
    "[102]Debug/Change Map",
    ChoGGi.ChangeMap,
    "F12",
    "Change Map",
    "load_city.tga"
    --toolbar = "01_File/01_ChangeMap",
  )

  --[[
  ChoGGi.AddAction(
    "[203]Editors/ReloadStaticClasses()",
    ReloadStaticClasses,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/ReloadTexture()",
    ReloadTexture,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/ReloadEntity()",
    ReloadEntity,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/InitSourceController()",
    InitSourceController,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/CNSProcess()",
    CNSProcess,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/ParticlesReload()",
    ParticlesReload,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/ReloadShaders()",
    hr.ReloadShaders,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[2]Toggle Buildable Grid",
    DbgToggleBuildableGrid,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[3]Draw Min Circles",
    PrefabDbgDrawMinCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[4]Draw Max Circles",
    PrefabDbgDrawMaxCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[5]Draw Decor Circles",
    PrefabDbgDrawDecorCircles,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[6]Draw Prefab Pos",
    PrefabDbgDrawPos,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[7]Draw Resource Clusters",
    PrefabDbgDrawResourceClusters,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[8]Draw Features",
    PrefabDbgDrawFeatures,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/[2]Debug/[9]Editor Objects",
    PrefabEditorObjectsToggle,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/Resave All Prefabs",
    ResaveAllPrefabs,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
    "[203]Editors/[02]Random Map/Resave All Blank Maps",
    ResaveAllBlankMaps,
    nil,
    nil,
    "CollisionGeometry.tga"
  )

  ChoGGi.AddAction(
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
