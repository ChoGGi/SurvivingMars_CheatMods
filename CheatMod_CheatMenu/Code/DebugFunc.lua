
--no sense in building the list more then once?
local ObjectSpawner_ItemList = {}
function ChoGGi.MenuFuncs.ObjectSpawner()
  --if #ObjectSpawner_ItemList == 0 then
  if not next(ObjectSpawner_ItemList) then
    for Key,_ in pairs(g_Classes) do
      ObjectSpawner_ItemList[#ObjectSpawner_ItemList+1] = {
        text = Key,
        value = Key
      }
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if g_Classes[value] then
      PlaceObj(value,{"Pos",ChoGGi.Funcs.CursorNearestHex()})

      --[[
      --local NewObj = PlaceObj(value,{"Pos",GetTerrainCursor()})
      for _, prop in iXpairs(NewObj:GetProperties()) do
        NewObj:SetProperty(prop.id, NewObj:GetDefaultPropertyValue(prop.id, prop))
      end
      --]]

      ChoGGi.Funcs.MsgPopup("Spawned: " .. choice[1].text,"Object")
    end
  end

  local hint = "Warning: Objects are unselectable with mouse cursor (hover mouse over and use Delete Selected Object)."
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ObjectSpawner_ItemList,"Object Spawner",hint)
end

function ChoGGi.MenuFuncs.ShowSelectionEditor()
  --check for any opened windows and kill them
  for i = 1, #terminal.desktop do
    if IsKindOf(terminal.desktop[i],"ObjectsStatsDlg") then
      terminal.desktop[i]:delete()
    end
  end
  --open a new copy
  local dlg = ObjectsStatsDlg:new()
  if not dlg then
    return
  end
  dlg:SetPos(terminal.GetMousePos())

  --OpenDialog("ObjectsStatsDlg",nil,terminal.desktop)
end

function ChoGGi.MenuFuncs.SetWriteLogs_Toggle()
  ChoGGi.UserSettings.WriteLogs = not ChoGGi.UserSettings.WriteLogs
  ChoGGi.Funcs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup("Write debug/console logs: " .. tostring(ChoGGi.UserSettings.WriteLogs),
    "Logging","UI/Icons/Anomaly_Breakthrough.tga"
  )
end

function ChoGGi.MenuFuncs.ObjExaminer()
  local obj = SelectedObj or SelectionMouseObj() or ChoGGi.Funcs.CursorNearestObject()
  --OpenExamine(SelectedObj)
  if obj == nil then
    return ClearShowMe()
  end
  local ex = Examine:new()
  ex:SetPos(terminal.GetMousePos())
  ex:SetObj(obj)
end

function ChoGGi.MenuFuncs.Editor_Toggle()
  --keep menu opened if visible
  local showmenu
  if dlgUAMenu then
    showmenu = true
  end

  if IsEditorActive() then
    EditorState(0)
    table.restore(hr, "Editor")
    editor.SavedDynRes = false
    XShortcutsSetMode("Game")
  else
    table.change(hr, "Editor", {
      ResolutionPercent = 100,
      SceneWidth = 0,
      SceneHeight = 0,
      DynResTargetFps = 0
    })
    XShortcutsSetMode("Editor", function()
      EditorDeactivate()
    end)
    EditorState(1,1)
    GetEditorInterface():Show(true)

    --GetToolbar():SetVisible(true)
    editor.OldCameraType = {
      GetCamera()
    }
    editor.CameraWasLocked = camera.IsLocked(1)
    camera.Unlock(1)

    GetEditorInterface():SetVisible(true)
    GetEditorInterface():ShowSidebar(true)
    GetEditorInterface().dlgEditorStatusbar:SetVisible(true)
    --GetEditorInterface():SetMinimapVisible(true)
    --CreateEditorPlaceObjectsDlg()
    if showmenu then
      UAMenu.ToggleOpen()
    end
  end
end

function ChoGGi.MenuFuncs.DeleteObject(obj)
  if not obj or (obj.key and obj.action and obj.idx) then
    obj = SelectedObj or SelectionMouseObj() or ChoGGi.Funcs.CursorNearestObject()
  end

  --deleting domes will freeze game if they have anything in them.
  if IsKindOf(obj,"Dome") and obj.air then
    return
  end

  --not sure if i need to delete the attachments (safety first)
  if obj.GetAttaches then
    local attach = obj:GetAttaches()
    if type(attach) == "table" then
      for i = 1, #attach do
        ChoGGi.MenuFuncs.DeleteObject(attach[i])
      end
    end
  end

  --some stuff will leave holes in the world if they're still working
  if obj.working then
    obj:ToggleWorking()
  end

  --try nicely first
  pcall(function()
    obj.can_demolish = true
    obj.indestructible = false
    DestroyBuildingImmediate(obj)
    obj:Destroy()
  end)

  --clean up
  pcall(function()
    obj:SetDome(false)
  end)
  pcall(function()
    obj:RemoveFromLabels()
  end)
  pcall(function()
    obj:Done()
  end)
  pcall(function()
    obj:Gossip("done")
  end)
  pcall(function()
    obj:StopFX()
    PlayFX("Spawn", "end", obj)
    obj:SetHolder(false)
  end)
  if obj.sphere then
    obj.sphere:delete()
  end
  if obj.decal then
    obj.decal:delete()
  end

  --fuck it, I asked nicely
  if obj then
    pcall(function()
      obj:delete()
    end)
  end

    --so we don't get an error from UseLastOrientation
  ChoGGi.LastPlacedObject = nil
end

function ChoGGi.MenuFuncs.ConsoleHistory_Toggle()
  ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.ConsoleToggleHistory) .. ": Those who cannot remember the past are condemned to repeat it.",
    "Console","UI/Icons/Sections/workshifts.tga"
  )
end

function ChoGGi.MenuFuncs.ChangeMap()
  CreateRealTimeThread(function()
    local caption = Untranslated("Choose map with settings presets:")
    local maps = ListMaps()
    local items = {}
    for i = 1, #maps do
      if not string.find(string.lower(maps[i]), "^prefab") and not string.find(maps[i], "^__") then
        items[#items+1] = {
          text = Untranslated(maps[i]),
          map = maps[i]
        }
      end
    end
    local default_selection = table.find(maps, GetMapName())
    local map_settings = {}
    local class_names = ClassDescendantsList("MapSettings")
    for i = 1, #class_names do
      local class = class_names[i]
      map_settings[class] = mapdata[class]
    end
    local sel_idx
    sel_idx, map_settings = WaitMapSettingsDialog(items, caption, nil, default_selection, map_settings)
    if sel_idx ~= "idCancel" then
      local map = sel_idx and items[sel_idx].map
      if not map or map == "" then
        return
      end
      CloseMenuDialogs()
      StartGame(map, map_settings)
      LocalStorage.last_map = map
      SaveLocalStorage()
    end
  end)
end

--hex rings
local build_grid_debug_range = 10
GlobalVar("build_grid_debug_objs", false)
GlobalVar("build_grid_debug_thread", false)
function ChoGGi.MenuFuncs.debug_build_grid(Pass)
  if type(ChoGGi.UserSettings.DebugGridSize) == "number" then
    build_grid_debug_range = ChoGGi.UserSettings.DebugGridSize
  end
  if build_grid_debug_thread then
    DeleteThread(build_grid_debug_thread)
    build_grid_debug_thread = false
    if build_grid_debug_objs then
      for i = 1, #build_grid_debug_objs do
        DoneObject(build_grid_debug_objs[i])
      end
      build_grid_debug_objs = false
    end
  else
    build_grid_debug_objs = {}
    build_grid_debug_thread = CreateRealTimeThread(function()
      local last_q, last_r
      while build_grid_debug_objs do
        local q, r = WorldToHex(GetTerrainCursor())
        if last_q ~= q or last_r ~= r then
          local z = -q - r
          local idx = 1
          for q_i = q - build_grid_debug_range, q + build_grid_debug_range do
            for r_i = r - build_grid_debug_range, r + build_grid_debug_range do
              for z_i = z - build_grid_debug_range, z + build_grid_debug_range do
                if q_i + r_i + z_i == 0 then
                  --CursorBuilding is from construct controller, but it works nicely along with GridTile for filling each grid
                  local c = build_grid_debug_objs[idx] or CursorBuilding:new({
                    entity = "GridTile",
                    template = ClassTemplates.Building.FountainSmall,
                    auto_attach_at_init = false
                  })
                  if Pass == true then
                    if terrain.IsSCell(point(HexToWorld(q_i, r_i))) or terrain.IsPassable(point(HexToWorld(q_i, r_i))) then
                      --green
                      c:SetColorModifier(-16711936)
                    else
                      --red
                      c:SetColorModifier(-65536)
                    end
                  else
                    if HexGridGetObject(ObjectGrid, q_i, r_i) then
                      c:SetColorModifier(-65536)
                    else
                      c:SetColorModifier(-16711936)
                    end
                  end
                  c:SetOpacity(0)
                  c:SetPos(point(HexToWorld(q_i, r_i)))
                  c:SetOpacity(50)
                  build_grid_debug_objs[idx] = c
                  idx = idx + 1
                end
              end
            end
          end
          last_q = q
          last_r = r
        end
        Sleep(50)
      end
    end)
  end
end
