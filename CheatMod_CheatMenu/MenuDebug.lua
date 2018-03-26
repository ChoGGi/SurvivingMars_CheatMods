UserActions.AddActions({

  ChoGGi_HexBuildGridToggle = {
    icon = "CollisionGeometry.tga",
    key = "Ctrl-F3",
    description = "Toggle Hex Build Grid Visibility",
    menu = "[102]Debug/[09]Toggle Hex Build Grid Visibility",
    action = debug_build_grid
  },

  ChoGGi_ConsoleClearDisplay = {
    icon = "Voice.tga",
    key = "F9",
    description = "Clears console history display.",
    menu = "[102]Debug/Console Clear Display",
    action = cls
  },

  ChoGGi_WriteDebugLogs = {
    icon = "save_city.tga",
    menu = "[102]Debug/Write Debug Logs",
    description = function()
      local action = ChoGGi.CheatMenuSettings["WriteDebugLogs"] and "(Enabled)" or "(Disabled)"
      return action .. " Writing debug logs to AppData/DebugPrint and AppData/printf (immediately instead of only after quiting, restart for disable)."
    end,
    action = ChoGGi.WriteDebugLogs
  },

  ChoGGi_ConsoleToggleHistory = {
    icon = "Voice.tga",
    menu = "[102]Debug/Console Toggle History",
    description = function()
      local action = ChoGGi.CheatMenuSettings["ConsoleToggleHistory"] and "(Enabled)" or "(Disabled)"
      return action .. " Show console history on screen."
    end,
    action = ChoGGi.ConsoleToggleHistory
  },

  ChoGGi_ToggleTerrainDepositGrid = {
    icon = "CollisionGeometry.tga",
    key = "Ctrl-F4",
    description = "Toggle Terrain Deposit Grid",
    menu = "[102]Debug/[09]Toggle Terrain Deposit Grid",
    action = ToggleTerrainDepositGrid
  },

  ChoGGi_DestroySelectedObject = {
    icon = "DeleteArea.tga",
    description = "(Some, not all).",
    menu = "[102]Debug/Destroy Selected Object",
    action = ChoGGi.DestroySelectedObject
  },

  ChoGGi_BombardmentAtCursor = {
    icon = "ToggleEnvMap.tga",
    key = "Ctrl-Numpad 1",
    menu = "[102]Debug/Asteroid At Cursor",
    description = "May have trouble aiming when an object is selected.",
    action = ChoGGi.BombardmentAtCursor
  },
  ChoGGi_BombardmentAtCursorMass = {
    icon = "ToggleEnvMap.tga",
    description = "Zoom out",
    key = "Ctrl-Numpad 2",
    menu = "[102]Debug/Asteroid Bombardment",
    action = ChoGGi.BombardmentAtCursorMass
  },

  ChoGGi_ExamineCurrentObj = {
    icon = "SelectByClassName.tga",
    description = "Opens the object examiner",
    menu = "[102]Debug/Examine Current Obj",
    key = "F4",
    action = ChoGGi.ExamineCurrentObj
  },

  ChoGGi_DumpCurrentObj = {
    icon = "SaveMapEntityList.tga",
    description = "Dumps info for current object to AppData/DumpText.txt",
    menu = "[102]Debug/Dump Current Obj",
    key = "F5",
    action = function()
      ChoGGi.DumpObject(SelectedObj)
    end
  },

  ChoGGi_ChangeMap = {
    key = "F12",
    description = "Change Map",
    toolbar = "01_File/01_ChangeMap",
    icon = "load_city.tga",
    menu = "[102]Map/[01]Change Map",
    action = ChoGGi.ChangeMap
  },

--[[
  ChoGGi_ReloadStaticClasses = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadStaticClasses()",
    action = ReloadStaticClasses
  },

  ChoGGi_ReloadTexture = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadTexture()",
    action = ReloadTexture
  },

  ChoGGi_ReloadEntity = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadEntity()",
    action = ReloadEntity
  },

  ChoGGi_InitSourceController = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/InitSourceController()",
    action = InitSourceController
  },

  ChoGGi_CNSProcess = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/CNSProcess()",
    action = CNSProcess
  },

  ChoGGi_ParticlesReload = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ParticlesReload()",
    action = ParticlesReload
  },

  ChoGGi_ReloadShaders = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadShaders()",
    action = hr.ReloadShaders
  },

dofolder_files("Lua/Dev")

  ChoGGi_DbgToggleBuildableGrid = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[2]Toggle Buildable Grid",
    action = DbgToggleBuildableGrid
  },
  ChoGGi_PrefabDbgDrawMinCircles = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[3]Draw Min Circles",
    action = PrefabDbgDrawMinCircles
  },
  ChoGGi_PrefabDbgDrawMaxCircles = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[4]Draw Max Circles",
    action = PrefabDbgDrawMaxCircles
  },
  ChoGGi_PrefabDbgDrawDecorCircles = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[5]Draw Decor Circles",
    action = PrefabDbgDrawDecorCircles
  },
  ChoGGi_PrefabDbgDrawPos = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[6]Draw Prefab Pos",
    action = PrefabDbgDrawPos
  },
  ChoGGi_PrefabEditorDrawClusters = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[7]Draw Resource Clusters",
    action = PrefabDbgDrawResourceClusters
  },
  ChoGGi_PrefabDbgDrawFeatures = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[8]Draw Features",
    action = PrefabDbgDrawFeatures
  },
  ChoGGi_PrefabEditorObjectsToggle = {
    menu = "[203]Editors/[02]Random Map/[2]Debug/[9]Editor Objects Toggle",
    action = PrefabEditorObjectsToggle
  },
  ChoGGi_ResaveAllPrefabs = {
    menu = "[203]Editors/[02]Random Map/Resave All Prefabs",
    action = ResaveAllPrefabs
  },
  ChoGGi_ResaveAllBlankMaps = {
    menu = "[203]Editors/[02]Random Map/Resave All Blank Maps",
    action = ResaveAllBlankMaps
  },
  ChoGGi_CheckGameRevision = {
    menu = "[203]Editors/[02]Random Map/Recover Game Revision",
    mode = "Editor",
    action = function()
      local gen = GetRandomMapGenerator() or GetRandomMapGeneratorHolder()
      if gen then
        CreateRealTimeThread(function(gen)
          gen:RecoverRevision()
        end, gen)
      end
    end
  },
--]]

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuDebug.lua",true)
end
