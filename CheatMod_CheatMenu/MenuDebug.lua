UserActions.AddActions({

  ChoGGi_HexBuildGridToggle = {
    icon = "CollisionGeometry.tga",
    key = "Ctrl-F3",
    description = "Toggle Hex Build Grid Visibility",
    menu = "[102]Debug/[09]Toggle Hex Build Grid Visibility",
    action = function()
      debug_build_grid()
    end
  },

  ChoGGi_ConsoleClearDisplay = {
    icon = "Voice.tga",
    key = "F9",
    menu = "[102]Debug/Console Clear Display",
    action = function()
      cls()
    end
  },

  ChoGGi_ConsoleToggleHistory = {
    icon = "Voice.tga",
    menu = "[102]Debug/Console Toggle History",
    description = function()
      local action = ChoGGi.CheatMenuSettings["ConsoleToggleHistory"] and "Disable" or "Enable"
      return action .. " showing console history on screen."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["ConsoleToggleHistory"] = not ChoGGi.CheatMenuSettings["ConsoleToggleHistory"]
      ShowConsoleLog(ChoGGi.CheatMenuSettings["ConsoleToggleHistory"])
      ChoGGi.WriteSettings()
    end
  },

  ChoGGi_ToggleTerrainDepositGrid = {
    icon = "CollisionGeometry.tga",
    key = "Ctrl-F4",
    description = "Toggle Terrain Deposit Grid",
    menu = "[102]Debug/[09]Toggle Terrain Deposit Grid",
    action = function()
      ToggleTerrainDepositGrid()
    end
  },

  ChoGGi_DestroySelectedObject = {
    icon = "DeleteArea.tga",
    description = "(Some, not all).",
    menu = "[102]Debug/Destroy Selected Object",
    action = function()
      pcall(function()
        SelectedObj.can_demolish = true
        SelectedObj.indestructible = false
        DestroyBuildingImmediate(SelectedObj)
        SelectedObj:Destroy()
      end)
    end
  },

  ChoGGi_BombardmentAtCursor = {
    icon = "ToggleEnvMap.tga",
    key = "Ctrl-Numpad 1",
    menu = "[102]Debug/Asteroid At Cursor",
    action = function()
      StartBombard(GetTerrainCursor(),0,1,0,0)
      --function WaitBombard(obj, radius, count, delay_min, delay_max)
    end
  },
  ChoGGi_BombardmentAtCursorMass = {
    icon = "ToggleEnvMap.tga",
    description = "Zoom out",
    key = "Ctrl-Numpad 2",
    menu = "[102]Debug/Asteroid Bombardment",
    action = function()
      StartBombard(GetTerrainCursor(),0,100,0,0)
    end
  },

--[[
  ChoGGi_DumpCurrentObj = {
    menu = "[102]Debug/Dump Current Obj",
    key = "F5",
    action = function()
      Examine.onclick_handles = {}
      Examine.obj = SelectedObj
      local tempTable = Examine:totextex(SelectedObj)
      ChoGGi.Dump(tempTable .. "\n\n","a","DumpedHtml","html")
    end
  },
--]]

  ChoGGi_ExamineCurrentObj = {
    icon = "SelectByClassName.tga",
    description = "Opens the object examiner",
    menu = "[102]Debug/Examine Current Obj",
    key = "F4",
    action = function()
      OpenExamine(SelectedObj)
    end
  },

  ChoGGi_DumpCurrentObj = {
    icon = "SaveMapEntityList.tga",
    description = "Dumps info for current object to AppData/DumpText.txt",
    menu = "[102]Debug/Dump Current Obj",
    key = "F5",
    action = function()
      local objInfo = "\n"
      for key,value in pairs(SelectedObj) do
        objInfo = objInfo .. tostring(key) .. " = " .. tostring(value) .. "\n"
      end
      ChoGGi.Dump(objInfo,"a")
    end
  },

  ChoGGi_ChangeMap = {
    key = "F12",
    description = "Change Map",
    toolbar = "01_File/01_ChangeMap",
    icon = "load_city.tga",
    menu = "[102]Map/[01]Change Map",
    action = function()
      local ineditor = Platform.editor and IsEditorActive()
      if ineditor then
        s_OldChangeMapAction()
      else
        CreateRealTimeThread(function()
          local caption = Untranslated("Choose map with settings presets:")
          local maps = ListMaps()
          local items = {}
          for i = 1, #maps do
            if not string.find(string.lower(maps[i]), "^prefab") and not string.find(maps[i], "^__") then
              table.insert(items, {
                text = Untranslated(maps[i]),
                map = maps[i]
              })
            end
          end
          local default_selection = table.find(maps, GetMapName())
          local map_settings = {}
          local class_names = ClassDescendantsList("MapSettings")
          for i = 1, #class_names do
            local class = class_names[i]
            map_settings[class] = mapdata[class]
          end
          local sel_idx, map_settings = WaitMapSettingsDialog(items, caption, nil, default_selection, map_settings)
          if sel_idx ~= "idCancel" then
            local map = sel_idx and items[sel_idx].map
            if not map or map == "" then
              return
            end
            CloseMenuWizards()
            StartGame(map, map_settings)
            LocalStorage.last_map = map
            SaveLocalStorage()
          end
        end)
      end
    end
  },

--[[
  ChoGGi_ReloadStaticClasses = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadStaticClasses()",
    action = function()
      ReloadStaticClasses()
    end
  },

  ChoGGi_ReloadTexture = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadTexture()",
    action = function()
      ReloadTexture()
    end
  },

  ChoGGi_ReloadEntity = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadEntity()",
    action = function()
      ReloadEntity()
    end
  },

  ChoGGi_InitSourceController = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/InitSourceController()",
    action = function()
      InitSourceController()
    end
  },

  ChoGGi_CNSProcess = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/CNSProcess()",
    action = function()
      CNSProcess()
    end
  },

  ChoGGi_ParticlesReload = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ParticlesReload()",
    action = function()
      ParticlesReload()
    end
  },

  ChoGGi_ReloadShaders = {
    icon = "CollisionGeometry.tga",
    menu = "[102]Debug/ReloadShaders()",
    action = function()
      hr.ReloadShaders()
    end
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
