local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables
local CMenuFuncs = ChoGGi.MenuFuncs

--default height of waypoints
local flag_height = 50
--store all objects for easy removal
local stored_waypoints = {}

--check stored_waypoints length and see if we can find out how many = flickering
local function ShowWaypoints(waypoints, color, obj, single, skipflags)

  color = color or RandColor()
  --also used for line height
  flag_height = flag_height + 4
  local height = flag_height
  local objpos = obj:GetVisualPos()
  local objterr = terrain.GetHeight(objpos)
  local objheight = obj:GetObjectBBox():sizez() / 2
  local shuttle
  if obj.class == "CargoShuttle" then
    shuttle = obj:GetPos():z()
  end
  --some objects don't have pos as waypoint
  if waypoints[#waypoints] ~= objpos then
    waypoints[#waypoints+1] = objpos
  end

  --make sure there's always a line from the obj to first WayPoint
  --local work_step = const.PrefabWorkRatio * terrain.TypeTileSize()
  local spawnline = PlaceTerrainLine(
    objpos,
    waypoints[#waypoints],
    color,
    nil, --work_step
    shuttle and shuttle - objterr or objheight --shuttle z always puts it too high?
  )
  stored_waypoints[#stored_waypoints+1] = spawnline
  spawnline:SetDepthTest(true)
  local sphereheight = 266 + height - 50
  --line:SetPrimType(4)
  if not single then
    --spawn a sphere at the obj pos
    local spherestart = PlaceObject("Sphere")
    stored_waypoints[#stored_waypoints+1] = spherestart
    spherestart:SetPos(point(objpos:x(),objpos:y(),(shuttle and shuttle + 500) or objterr + sphereheight))
    spherestart:SetDepthTest(true)
    spherestart:SetColor(color)
    spherestart:SetRadius(35)
  end
  --and another at the end
  --[[
  local sphereend = PlaceObject("Sphere")
  stored_waypoints[#stored_waypoints+1] = sphereend
  local w = waypoints[1]
  sphereend:SetPos(w)
  sphereend:SetZ(((w:z() or terrain.GetHeight(w)) + 10 * guic) + sphereheight)
  sphereend:SetDepthTest(true)
  sphereend:SetColor(color)
  sphereend:SetRadius(25)
  --]]

  --list is sent dest>pos order
  for i = 1, #waypoints do
    local w = waypoints[i]
    local pos = w:SetZ((w:z() or terrain.GetHeight(w)) + 10 * guic)
    pos = point(pos:x(),pos:y(),shuttle or pos:z())

    if skipflags ~= true then
      local p
      if single and i == #waypoints then
        p = PlaceObject("GreenMan")
        p:SetScale(200)
      else
        p = PlaceObject("WayPoint")
      end
      stored_waypoints[#stored_waypoints+1] = p
      p:SetColorModifier(color)
      p:SetPos(pos)
    end

    --add text to last wp
    if i == 1 then
      local endp = PlaceText(obj.class .. ": " .. obj.handle, pos)
      stored_waypoints[#stored_waypoints+1] = endp
      endp:SetColor(color)
      endp:SetZ(endp:GetZ() + 250 + height)
      --endp:SetFontId("Editor32Bold")
    end

    local wn = waypoints[i+1]
    if wn then
      local l = PlaceTerrainLine(
        pos,
        wn,
        color,
        nil,
        shuttle and shuttle - objterr or height
      )
      stored_waypoints[#stored_waypoints+1] = l
      l:SetDepthTest(true)
    end
  end
end

local randcolors = {}
local function RemoveWPDupePos(Class)
  local wppos = {}
  for i = 1, #stored_waypoints do
    local wp = stored_waypoints[i]
    if wp.class == Class then
      local pos = type(wp.GetPos) == "function" and wp:GetPos()
      if pos then
        pos = tostring(pos)
        if wppos[pos] then
          local Table = wp:GetAttaches() or empty_table
          for i = 1, #Table do
            Table[i]:delete()
          end
          wp:delete()
        else
          wppos[pos] = true
        end
      end
    end
  end
end
local function SetWaypoint(obj,single,skipflags)
  --need to add a Sleep for RandColor as there's a delay on how quickly it updates
  CreateRealTimeThread(function()
    local path
    --we need to build a path for shuttles (and figure out a way to get their dest properly...)
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
      path = type(obj.GetPath) == "function" and obj:GetPath()
    end
    if path then
      --used to reset the colour later on
      if not obj.ChoGGi_WaypointPathAdded then
        obj.ChoGGi_WaypointPathAdded = obj:GetColorModifier()
      end
      --we want to make sure all waypoints are a different colour (or at least slightly diff), do i want to round them for more slightly?
      local color = RandColor()
      if randcolors[color] then
        while true do
          color = RandColor()
          if not randcolors[color] then
            randcolors[color] = color
            ShowWaypoints(path,CCodeFuncs.ObjectColourRandom(obj,randcolors[color]),obj,single,skipflags)
            break
          end
          Sleep(50)
        end
      else
        randcolors[color] = color
        ShowWaypoints(path,CCodeFuncs.ObjectColourRandom(obj,randcolors[color]),obj,single,skipflags)
      end
    end
  end)
end
function CMenuFuncs.SetVisiblePathMarkers()
  local sel = SelectedObj
  if sel then
    SetWaypoint(sel,true)
    return
  end
  local ItemList = {
    {text = "All",value = "All"},
    {text = "Colonists",value = "Colonist"},
    {text = "Drones",value = "Drone"},
    {text = "Rovers",value = "BaseRover"},
    {text = "Shuttles",value = "CargoShuttle",hint = "Doesn't work that well; if it isn't a colonist dest."},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    --remove wp/lines and reset colours
    if choice[1].check1 then

      --remove all the waypoints
      for i = 1, #stored_waypoints do
        stored_waypoints[i]:delete()
      end
      stored_waypoints = {}
      --reset the random colors table
      randcolors = {}
      --reset all the base colours
      local function ClearColour(Class)
        ForEach({
          class = Class,
          exec = function(Obj)
            if Obj.ChoGGi_WaypointPathAdded then
              Obj:SetColorModifier(Obj.ChoGGi_WaypointPathAdded)
              Obj.ChoGGi_WaypointPathAdded = nil
            end
          end
        })
      end
      ClearColour("CargoShuttle")
      ClearColour("Unit")

      flag_height = 50
    else
      local function swp(Class)
        ForEach({
          class = Class,
          exec = function(Obj)
            SetWaypoint(Obj,nil,choice[1].check2)
          end
        })
      end
      if value == "All" then
        swp("Unit")
        swp("CargoShuttle")
      else
        swp(value)
      end

      --remove any waypoints in the same pos
      RemoveWPDupePos("WayPoint")
      RemoveWPDupePos("Sphere")
    end
  end

  local hint = "Use HandleToObject[handle] to get object handle"
  local Check1 = "Remove Waypoints"
  local Check1Hint = "Remove waypoints from the map and reset colours (You need to select any object)."
  local Check2 = "Skip Flags"
  local Check2Hint = "Doesn't add the little flags, just lines and spheres (good for larger maps)."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Visible Path Markers",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
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
    if Table[i].ChoGGi_AnimDebug then
      Table[i]:delete()
    end
  end
end
local function LoopObjects(Class,Which)
  ForEach({
    class = Class,
    exec = function(Obj)
      if Which then
        ShowAnimDebug(Obj)
      else
        HideAnimDebug(Obj)
      end
    end
  })
end

function CMenuFuncs.ShowAnimDebug_Toggle()
  ChoGGi.Temp.ShowAnimDebug = not ChoGGi.Temp.ShowAnimDebug
  LoopObjects("Building",ChoGGi.Temp.ShowAnimDebug)
  LoopObjects("Unit",ChoGGi.Temp.ShowAnimDebug)
end

--no sense in building the list more then once
local ObjectSpawner_ItemList = {}
function CMenuFuncs.ObjectSpawner()
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

function CMenuFuncs.ShowSelectionEditor()
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

function CMenuFuncs.SetWriteLogs_Toggle()
  ChoGGi.UserSettings.WriteLogs = not ChoGGi.UserSettings.WriteLogs
  CComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup("Write debug/console logs: " .. tostring(ChoGGi.UserSettings.WriteLogs),
    "Logging","UI/Icons/Anomaly_Breakthrough.tga"
  )
end

function CMenuFuncs.ObjExaminer()
  local obj = CCodeFuncs.SelObject()
  --OpenExamine(SelectedObj)
  if not obj then
    return ClearShowMe()
  end
  local ex = Examine:new()
  ex:SetPos(terminal.GetMousePos())
  ex:SetObj(obj)
end

function CMenuFuncs.Editor_Toggle()
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

function CMenuFuncs.DeleteObjects(obj)
  if not obj or (obj.key and obj.action and obj.idx) then
    --multiple selection from editor mode
    local objs = editor:GetSel()
    if next(objs) then
      for i = 1, #objs do
        CMenuFuncs.DeleteObject(objs[i])
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
          CMenuFuncs.DeleteObject(attach[i])
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

function CMenuFuncs.ConsoleHistory_Toggle()
  ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ConsoleToggleHistory) .. ": Those who cannot remember the past are condemned to repeat it.",
    "Console","UI/Icons/Sections/workshifts.tga"
  )
end

function CMenuFuncs.ChangeMap()
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
function CMenuFuncs.debug_build_grid(Type)
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
                  if Type == 1 then
                    if (terrain.IsSCell(HexToWorld(q_i, r_i)) or terrain.IsPassable(HexToWorld(q_i, r_i))) and not HexGridGetObject(ObjectGrid, q_i, r_i) then
                      --green
                      c:SetColorModifier(-16711936)
                    else
                      --red
                      c:SetColorModifier(-65536)
                    end
                  elseif Type == 2 then
                    if terrain.IsSCell(HexToWorld(q_i, r_i)) or terrain.IsPassable(HexToWorld(q_i, r_i)) then
                      --green
                      c:SetColorModifier(-16711936)
                    else
                      --red
                      c:SetColorModifier(-65536)
                    end
                  elseif Type == 3 then
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
