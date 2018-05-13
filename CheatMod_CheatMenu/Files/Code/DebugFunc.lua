local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

local flag_height = 50
local function ShowWaypoints(waypoints,color,obj)
  flag_height = flag_height + 1
  color = color or RandColor()
  local work_step = const.PrefabWorkRatio * terrain.TypeTileSize()
  --connect the first line to the object
  local line = PlaceTerrainLine(obj:GetVisualPos(), waypoints[#waypoints], color, work_step, obj:GetObjectBBox():sizez() / 2)
  line.ChoGGi_TerrainLine = true
  line:SetDepthTest(true)
  --line:SetPrimType(4)

  for i = 1, #waypoints do
    local w = waypoints[i]
    local p = PlaceObject("WayPoint")

    pcall(function()
      local wn = waypoints[i+1]
      if wn then
        local l = PlaceTerrainLine(w, wn, color, work_step, flag_height)
        l.ChoGGi_TerrainLine = true
        l:SetDepthTest(true)
      end
    end)

    p:SetColorModifier(color)
    p:SetPos(w:SetZ((w:z() or terrain.GetHeight(w)) + 10 * guic))
  end
end

function ChoGGi.MenuFuncs.SetVisiblePathMarkers()
  local rand = CCodeFuncs.ObjectColourRandom
  local function SetWaypoint(obj)
    if not obj.ChoGGi_PathAdded then
      obj.ChoGGi_PathAdded = obj:GetColorModifier()
    end
    local path
    --need to build a path for shuttles
    if obj.class == "CargoShuttle" then
      path = {}
      if obj.dest_dome then
        path[1] = obj.dest_dome:GetPos()
      else
        path[1] = obj.hub:GetPos()
      end
      local Table = obj.current_spline
      if Table then
        for i = #Table, 1, -1 do
          path[#path+1] = Table[i]
        end
      end
      path[#path+1] = obj:GetPos()
    else
      path = obj:GetPath()
    end
    if path then
      CreateRealTimeThread(function()
        Sleep(25)
        ShowWaypoints(path,rand(obj,true),obj)
      end)
    end
  end
  local sel = SelectedObj
  if sel then
    SetWaypoint(sel)
    return
  end
  local ItemList = {
    {text = "All",value = "All"},
    {text = "Colonists",value = "Colonist"},
    {text = "Drones",value = "Drone"},
    {text = "Rovers",value = "BaseRover"},
    {text = "Shuttles",value = "CargoShuttle",hint = "Doesn't work that well, if it isn't a colonist dest."},
    {text = "Units",value = "Unit",hint = "Drones and Rovers"},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    --remove wp/lines and reset colours
    if choice[1].check1 then
      local function DeleteMarkers(Class,Test)
        local Table = GetObjects({class=Class}) or empty_table
        for i = 1, #Table do
          if Test then
            if Table[i][Test] then
              Table[i]:delete()
            end
          else
            Table[i]:delete()
          end
        end
      end
      DeleteMarkers("WayPoint")
      DeleteMarkers("Polyline","ChoGGi_TerrainLine")

      local function ClearColour(Class)
        local Table = GetObjects({class=Class}) or empty_table
        for i = 1, #Table do
          if Table[i].ChoGGi_PathAdded then
            Table[i]:SetColorModifier(Table[i].ChoGGi_PathAdded)
            Table[i].ChoGGi_PathAdded = nil
          end
        end
      end
      ClearColour("CargoShuttle")
      ClearColour("Unit")

      flag_height = 50
    else
      local function swp(Class)
        local Table = GetObjects({class=Class}) or empty_table
        for i = 1, #Table do
          SetWaypoint(Table[i])
        end
      end
      if value == "All" then
        swp("Unit")
        swp("CargoShuttle")
      else
        swp(value)
      end
    end
  end

  local Check1 = "Remove Waypoints"
  local Check1Hint = "Remove waypoints from the map and reset colours (You need to select any object)."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Visible Path Markers",nil,nil,Check1,Check1Hint)
end

local function ShowAnimDebug(obj, color1, color2)
  if not obj or (obj.action and obj.idx) then
    obj = CCodeFuncs.SelObject()
  end
  if not obj then
    return
  end
  local text = PlaceObject("Text")
  text:SetDepthTest(true)
  text:SetColor1(color1 or text.color1)
  text:SetColor2(color2 or text.color2)
  text.ChoGGi_AnimDebug = true
  obj:Attach(text)
  CreateRealTimeThread(function()
    while IsValid(text) do
      text:SetText(string.format("%d. %s\n", 1, obj:GetAnimDebug(1)))
      WaitNextFrame()
    end
  end)
end

local function HideAnimDebug(obj)
  local Table = obj:GetAttaches() or empty_table
  for i = 1, #Table do
    if Table[i].ChoGGi_AnimDebug == true then
      Table[i]:delete()
    end
  end
end
local function LoopObjects(Class,Which)
  local Table = GetObjects({class=Class}) or empty_table
  for i = 1, #Table do
    if Which then
      ShowAnimDebug(Table[i])
    else
      HideAnimDebug(Table[i])
    end
  end
end

function ChoGGi.MenuFuncs.ShowAnimDebug_Toggle()
  ChoGGi.Temp.ShowAnimDebug = not ChoGGi.Temp.ShowAnimDebug
  LoopObjects("Building",ChoGGi.Temp.ShowAnimDebug)
  LoopObjects("Unit",ChoGGi.Temp.ShowAnimDebug)
end

--no sense in building the list more then once
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
      PlaceObj(value,{"Pos",CCodeFuncs.CursorNearestHex()})

      --[[
      --local NewObj = PlaceObj(value,{"Pos",GetTerrainCursor()})
      for _, prop in iXpairs(NewObj:GetProperties()) do
        NewObj:SetProperty(prop.id, NewObj:GetDefaultPropertyValue(prop.id, prop))
      end
      --]]

      CComFuncs.MsgPopup("Spawned: " .. choice[1].text,"Object")
    end
  end

  local hint = "Warning: Objects are unselectable with mouse cursor (hover mouse over and use Delete Selected Object)."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ObjectSpawner_ItemList,"Object Spawner",hint)
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
  CComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup("Write debug/console logs: " .. tostring(ChoGGi.UserSettings.WriteLogs),
    "Logging","UI/Icons/Anomaly_Breakthrough.tga"
  )
end

function ChoGGi.MenuFuncs.ObjExaminer()
  local obj = CCodeFuncs.SelObject()
  --OpenExamine(SelectedObj)
  if not obj then
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

function ChoGGi.MenuFuncs.DeleteObjects(obj)
  if not obj or (obj.key and obj.action and obj.idx) then
    --multiple selection from editor mode
    local objs = editor:GetSel()
    if next(objs) then
      for i = 1, #objs do
        ChoGGi.MenuFuncs.DeleteObject(objs[i])
      end
    else
      obj = CCodeFuncs.SelObject()
    end
  end

  --deleting domes will freeze game if they have anything in them.
  if IsKindOf(obj,"Dome") and obj.air then
    return
  end

  --not sure if i need to delete the attachments (safety first)
  if not IsKindOf(obj,"Building") and obj.GetAttaches then
    local attach = obj:GetAttaches()
    if type(attach) == "table" then
      for i = 1, #attach do
        pcall(function()
          ChoGGi.MenuFuncs.DeleteObject(attach[i])
        end)
      end
    end
  end

  local function TryFunc(Name,Param)
    if obj[Name] then
      obj[Name](obj,Param)
    end
  end

  --some stuff will leave holes in the world if they're still working
  TryFunc("ToggleWorking")

  --try nicely first
  obj.can_demolish = true
  obj.indestructible = false

  if obj.DoDemolish then
    DestroyBuildingImmediate(obj)
  end

  TryFunc("Destroy")
  TryFunc("SetDome",false)
  TryFunc("RemoveFromLabels")
  TryFunc("Done")
  TryFunc("Gossip","done")
  TryFunc("SetHolder",false)
  local function TryFunc2(Name)
    if obj[Name] then
      obj[Name]:delete()
    end
  end
  TryFunc2("sphere")
  TryFunc2("decal")

  --fuck it, I asked nicely
  if obj then
    TryFunc("delete")
  end

    --so we don't get an error from UseLastOrientation
  ChoGGi.Temp.LastPlacedObject = nil
end

function ChoGGi.MenuFuncs.ConsoleHistory_Toggle()
  ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ConsoleToggleHistory) .. ": Those who cannot remember the past are condemned to repeat it.",
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
                  c:SetOpacity(10)
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
