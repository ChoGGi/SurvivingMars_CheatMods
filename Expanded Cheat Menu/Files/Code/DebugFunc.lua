function ChoGGi.MsgFuncs.DebugFunc_ClassesGenerate()
  --simplest entity object as possible for hexgrids (it went from being laggy with 100 to usable, also some local vars)
  DefineClass.ChoGGi_CursorBuilding = {
    __parents = {"CObject"},
    entity = "GridTile"
  }
end

function ChoGGi.MenuFuncs.ReloadLua()
  ReloadLua()
  WaitDelayedLoadEntities()
  ReloadClassEntities()
  print("ReloadLua done")
end

function ChoGGi.MenuFuncs.DeleteAllSelectedObjects(s)
  local ChoGGi = ChoGGi
  --the menu item sends itself
  if s and not s.class then
    s = ChoGGi.CodeFuncs.SelObject()
  end
  local name = (s.display_name and ChoGGi.CodeFuncs.Trans(s.display_name)) or s.encyclopedia_id or s.class
  if not name then
    ChoGGi.ComFuncs.MsgPopup("Error: " .. tostring(s) .. "isn't an object?\nSounds like a broked save; send me the file and I'll take a look: " .. ChoGGi.email,
      "Error",nil,true
    )
    return
  end

  local objs = GetObjects({class=s.class})
  local CallBackFunc = function()
    CreateRealTimeThread(function()
      for i = 1, #objs do
        ChoGGi.CodeFuncs.DeleteObject(objs[i])
      end
    end)
  end
  ChoGGi.ComFuncs.QuestionBox(
    "Warning!\nThis will delete all " .. #objs .. " of " .. name .. "\n\nTakes about thirty seconds for 12 000 objects.",
    CallBackFunc,
    "Warning: Last chance before deletion!",
    "Yes, I want to delete all " .. name,
    "No, I need to backup my save (like I should've done before clicking something called delete all)."
  )
end

function ChoGGi.MenuFuncs.ObjectCloner(sel)
  --the menu item sends itself
  if sel and not sel.class then
    sel = ChoGGi.CodeFuncs.SelObject()
  end

  local NewObj = g_Classes[sel.class]:new()
  NewObj:CopyProperties(sel)
  --[[find out which ones we shouldn't copy
  for Key,Value in pairs(sel or empty_table) do
    NewObj[Key] = Value
  end
  --]]
  NewObj:SetPos(ChoGGi.CodeFuncs.CursorNearestHex())
  --if it's a deposit then make max_amount random and add
  --local ObjName = ValueToLuaCode(sel):match("^PlaceObj%('(%a+).+$")
  --if ObjName:find("SubsurfaceDeposit") then
  --NewObj.max_amount = UICity:Random(1000 * ChoGGi.Consts.ResourceScale,5000 * ChoGGi.Consts.ResourceScale)
  if NewObj.max_amount then
    NewObj.amount = NewObj.max_amount
  elseif NewObj:IsKindOf("Colonist") then
    --it seems CopyProperties is only some properties
    NewObj.traits = {}
    NewObj.race = sel.race
    NewObj.fx_actor_class = sel.fx_actor_class
    NewObj.entity = sel.entity
    NewObj.infopanel_icon = sel.infopanel_icon
    NewObj.inner_entity = sel.inner_entity
    NewObj.pin_icon = sel.pin_icon
    ChoGGi.CodeFuncs.ColonistUpdateGender(NewObj,sel.gender,sel.entity_gender)
    ChoGGi.CodeFuncs.ColonistUpdateAge(NewObj,sel.age_trait)
    NewObj:SetSpecialization(sel.specialist,"init")
    NewObj.age = sel.age
    NewObj:ChooseEntity()
  end
end

local function AnimDebug_Show(Class)
  local CreateGameTimeThread = CreateGameTimeThread
  local GetObjects = GetObjects
  local IsValid = IsValid
  local PlaceObject = PlaceObject
  local WaitNextFrame = WaitNextFrame
  local objs = GetObjects({class = Class}) or empty_table
  for i = 1, #objs do
    local text = PlaceObject("Text")
    text:SetDepthTest(true)
    text:SetColor(ChoGGi.CodeFuncs.RandomColour())
    text:SetFontId(UIL.GetFontID("droid, 14, bold"))

    text.ChoGGi_AnimDebug = true
    objs[i]:Attach(text)
    text:SetAttachOffset(point(0,0,objs[i]:GetObjectBBox():sizez() + 100))
    CreateGameTimeThread(function()
      while IsValid(text) do
        text:SetText(string.format("%d. %s\n", 1, objs[i]:GetAnimDebug(1)))
        WaitNextFrame()
      end
    end)
  end
end

local function AnimDebug_Hide(Class)
  local objs = GetObjects({class = Class}) or empty_table
  for i = 1, #objs do
    local att = objs[i]:GetAttaches() or empty_table
    for j = 1, #att do
      if att[j].ChoGGi_AnimDebug then
        att[j]:delete()
      end
    end
  end
end

function ChoGGi.MenuFuncs.ShowAnimDebug_Toggle()
  ChoGGi.Temp.ShowAnimDebug = not ChoGGi.Temp.ShowAnimDebug
  if ChoGGi.Temp.ShowAnimDebug then
    AnimDebug_Show("Building")
    AnimDebug_Show("Unit")
    AnimDebug_Show("CargoShuttle")
  else
    AnimDebug_Hide("Building")
    AnimDebug_Hide("Unit")
    AnimDebug_Hide("CargoShuttle")
  end
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
      PlaceObj(value,{"Pos",ChoGGi.CodeFuncs.CursorNearestHex()})

      --[[
      --local NewObj = PlaceObj(value,{"Pos",GetTerrainCursor()})
      for _, prop in iXpairs(NewObj:GetProperties()) do
        NewObj:SetProperty(prop.id, NewObj:GetDefaultPropertyValue(prop.id, prop))
      end
      --]]

      ChoGGi.ComFuncs.MsgPopup("Spawned: " .. choice[1].text,"Object")
    end
  end

  local hint = "Warning: Objects are unselectable with mouse cursor (hover mouse over and use Delete Selected Object)."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ObjectSpawner_ItemList,"Object Spawner",hint)
end

function ChoGGi.MenuFuncs.ShowSelectionEditor()
  --check for any opened windows and kill them
  for i = 1, #terminal.desktop do
    if terminal.desktop[i]:IsKindOf("ObjectsStatsDlg") then
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
  ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup("Write debug/console logs: " .. tostring(ChoGGi.UserSettings.WriteLogs),
    "Logging","UI/Icons/Anomaly_Breakthrough.tga"
  )
end

function ChoGGi.MenuFuncs.ObjExaminer()
  local obj = ChoGGi.CodeFuncs.SelObject()
  if not obj then
    return
    --return ClearShowMe()
  end
  --OpenExamine(SelectedObj)
  --open and move to where the cursor is
  ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(obj)
end

function ChoGGi.MenuFuncs.Editor_Toggle()
  Platform.editor = true
  Platform.developer = true

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
    Platform.editor = false
    Platform.developer = false
  else
    table.change(hr, "Editor", {
      ResolutionPercent = 100,
      SceneWidth = 0,
      SceneHeight = 0,
      DynResTargetFps = 0
    })
    XShortcutsSetMode("Game")
    --XShortcutsSetMode("Editor", function()EditorDeactivate()end)
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

function ChoGGi.MenuFuncs.ConsoleHistory_Toggle()
  ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ConsoleToggleHistory) .. ": Those who cannot remember the past are condemned to repeat it.",
    "Console","UI/Icons/Sections/workshifts.tga"
  )
end

function ChoGGi.MenuFuncs.ChangeMap()
  local NewMissionParams = {}

  --open a list dialog to set g_CurrentMissionParams
  local ItemList = {
    {text = "idMissionSponsor",value = "IMM"},
    {text = "idCommanderProfile",value = "rocketscientist"},
    {text = "idMystery",value = "random"},
    {text = "idGameRules",value = ""},
  }

  local CallBackFunc = function(choice)
    if type(choice) ~= "table" then
      return
    end
    for i = 1, #choice do
      local text = choice[i].text
      local value = choice[i].value

      if text == "idMissionSponsor" then
        NewMissionParams.idMissionSponsor = value
      elseif text == "idCommanderProfile" then
        NewMissionParams.idCommanderProfile = value
      elseif text == "idMystery" then
        NewMissionParams.idMystery = value
      elseif text == "idGameRules" then
        NewMissionParams.idGameRules = {}
        if value:find(" ") then
          for i in value:gmatch("%S+") do
            NewMissionParams.idGameRules[i] = true
          end
        elseif value ~= "" then
          NewMissionParams.idGameRules[value] = true
        end
      end
    end

  end

  local hint = "Attention: You must close this dialog for these settings to take effect on new map!\n\nSee the list on the left for ids.\n\nFor rules separate with spaces: Hunger Twister (or leave blank for none)."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set MissionParams NewMap",hint,nil,nil,nil,nil,nil,4)

  --shows the mission params for people to look at
  OpenExamine(MissionParams)

  --map list dialog
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

      --cleans out missions params
      InitNewGameMissionParams()

      --select new MissionParams
      g_CurrentMissionParams.idMissionSponsor = NewMissionParams.idMissionSponsor or "IMM"
      g_CurrentMissionParams.idCommanderProfile = NewMissionParams.idCommanderProfile or "rocketscientist"
      g_CurrentMissionParams.idMystery = NewMissionParams.idMystery or "random"
      g_CurrentMissionParams.idGameRules = NewMissionParams.idGameRules or {}
      g_CurrentMissionParams.GameSessionID = srp.random_encode64(96)

      --items in spawn rocket
      GenerateRocketCargo()

      --landing spot/rocket name / resource amounts?, see g_CurrentMapParams
      GenerateRandomMapParams()

      --and change the map
      local props = GetModifiedProperties(DataInstances.RandomMapPreset.MAIN)
      local gen = RandomMapGenerator:new()
      gen:SetProperties(props)
      FillRandomMapProps(gen)
      gen.BlankMap = map

      --generates/loads map
      gen:Generate(nil, nil, nil, nil, map_settings)

      --update local store
      LocalStorage.last_map = map
      SaveLocalStorage()
    end
  end)
end

do --hex rings
  local build_grid_debug_range = 10
  local opacity = 15
  local build_grid_debug_objs = false
  local build_grid_debug_thread = false

  function ChoGGi.MenuFuncs.debug_build_grid(iType)
    --local everything for speed
    local CreateRealTimeThread = CreateRealTimeThread
    local Sleep = Sleep
    local HexGridGetObject = HexGridGetObject
    local HexToWorld = HexToWorld
    local ObjectGrid = ObjectGrid
    local GetTerrainCursor = GetTerrainCursor
    local terrain = terrain
    local DoneObject = DoneObject
    local DeleteThread = DeleteThread

    local ChoGGi_CursorBuilding = ChoGGi_CursorBuilding
    local UserSettings = ChoGGi.UserSettings
    if type(UserSettings.DebugGridSize) == "number" then
      build_grid_debug_range = UserSettings.DebugGridSize
    end
    if type(UserSettings.DebugGridOpacity) == "number" then
      opacity = UserSettings.DebugGridOpacity
    end
    --might as well make it smoother (and suck up some cpu), i doubt anyone is going to leave it on
    local sleep = 10
    -- 150 = 67951 objects (had a crash at 250, and not like you need one this big)
    if build_grid_debug_range > 150 then
      build_grid_debug_range = 150
    end
    if build_grid_debug_range > 50 and build_grid_debug_range < 99 then
      sleep = 50
    elseif build_grid_debug_range > 99 then
      sleep = 75
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
                    local c = build_grid_debug_objs[idx] or ChoGGi_CursorBuilding:new()
                    --both
                    if iType == 1 then
                      if (terrain.IsSCell(HexToWorld(q_i, r_i)) or terrain.IsPassable(HexToWorld(q_i, r_i))) and not HexGridGetObject(ObjectGrid, q_i, r_i) then
                        --green
                        c:SetColorModifier(-16711936)
                      else
                        --red
                        c:SetColorModifier(-65536)
                      end
                    --passable
                    elseif iType == 2 then
                      if terrain.IsSCell(HexToWorld(q_i, r_i)) or terrain.IsPassable(HexToWorld(q_i, r_i)) then
                        --green
                        c:SetColorModifier(-16711936)
                      else
                        --red
                        c:SetColorModifier(-65536)
                      end
                    --buildable
                    elseif iType == 3 then
                      if HexGridGetObject(ObjectGrid, q_i, r_i) then
                        c:SetColorModifier(-65536)
                      else
                        c:SetColorModifier(-16711936)
                      end
                    end
                    --c:SetOpacity(0)
                    c:SetPos(point(HexToWorld(q_i, r_i)))
                    c:SetOpacity(opacity)
                    build_grid_debug_objs[idx] = c
                    idx = idx + 1
                  end
                end
              end
            end
            last_q = q
            last_r = r
          else
            Sleep(5)
          end
          Sleep(sleep)
        end
      end)
    end
  end
end

do --path markers
  --pick a random model for start of path if doing single object
  local SpawnModels = {}
  SpawnModels[1] = "GreenMan"
  SpawnModels[2] = "Lama"
  --default height of waypoints
  local flag_height = 50
  local function ShowWaypoints(waypoints, colour, Obj, single, skipflags, skipheight)
    local PlaceTerrainLine = PlaceTerrainLine
    local PlaceText = PlaceText
    local PlaceObject = PlaceObject
    local UICity = UICity
    local terrain = terrain

    colour = tonumber(colour) or ChoGGi.CodeFuncs.RandomColour()
    --also used for line height
    if not skipheight then
      flag_height = flag_height + 4
    end
    local height = flag_height
    local Objpos = Obj:GetVisualPos()
    local Objterr = terrain.GetHeight(Objpos)
    local Objheight = Obj:GetObjectBBox():sizez() / 2
    local shuttle
    if Obj.class == "CargoShuttle" then
      shuttle = Obj:GetPos():z()
    end
    --some objects don't have pos as waypoint
    if waypoints[#waypoints] ~= Objpos then
      waypoints[#waypoints+1] = Objpos
    end

    --make sure there's always a line from the obj to first WayPoint
    --local work_step = const.PrefabWorkRatio * terrain.TypeTileSize()
    local spawnline = PlaceTerrainLine(
      Objpos,
      waypoints[#waypoints],
      colour,
      nil, --work_step
      shuttle and shuttle - Objterr or Objheight --shuttle z always puts it too high?
    )
    Obj.stored_waypoints[#Obj.stored_waypoints+1] = spawnline
    spawnline:SetDepthTest(true)
    local sphereheight = 266 + height - 50
    --line:SetPrimType(4)
    if not single then
      --spawn a sphere at the Obj pos
      local spherestart = PlaceObject("Sphere")
      Obj.stored_waypoints[#Obj.stored_waypoints+1] = spherestart
      spherestart:SetPos(point(Objpos:x(),Objpos:y(),(shuttle and shuttle + 500) or Objterr + sphereheight))
      spherestart:SetDepthTest(true)
      spherestart:SetColor(colour)
      spherestart:SetRadius(35)
    end
    --and another at the end
    --[[
    local sphereend = PlaceObject("Sphere")
    Obj.stored_waypoints[#Obj.stored_waypoints+1] = sphereend
    local w = waypoints[1]
    sphereend:SetPos(w)
    sphereend:SetZ(((w:z() or terrain.GetHeight(w)) + 10 * guic) + sphereheight)
    sphereend:SetDepthTest(true)
    sphereend:SetColor(colour)
    sphereend:SetRadius(25)
    --]]

    --list is sent dest>pos order
    for i = 1, #waypoints do
      local w = waypoints[i]
      local wpn = waypoints[i+1]
      local pos = w:SetZ((w:z() or terrain.GetHeight(w)) + 10 * guic)
      pos = point(pos:x(),pos:y(),shuttle or pos:z())

      if skipflags ~= true then
        local p
        if single and i == #waypoints then
          p = PlaceObject(SpawnModels[UICity:Random(1,2)])
          p:SetScale(50)
          --p:SetAngle(Obj:GetAngle())
        else
          -- 1 == start #wp = dist
          p = PlaceObject("WayPoint")
          if i > 1 then
            p:SetAngle(p:AngleToPoint(waypoints[#waypoints-1]))
          else
            p:SetAngle(Obj:GetAngle())
          end
        end
        Obj.stored_waypoints[#Obj.stored_waypoints+1] = p
        p:SetColorModifier(colour)
        p:SetPos(pos)
      end

      --add text to last wp
      if i == 1 then
        local endwp = PlaceText(Obj.class .. ": " .. Obj.handle, pos)
        Obj.stored_waypoints[#Obj.stored_waypoints+1] = endwp
        endwp:SetColor(colour)
        --endp:SetColor2()
        endwp:SetZ(endwp:GetZ() + 250 + height)
        --endp:SetShadowOffset(3)
        endwp:SetFontId(UIL.GetFontID("droid, 14, bold"))
      end

      if wpn then
        local l = PlaceTerrainLine(
          pos,
          wpn,
          colour,
          nil,
          shuttle and shuttle - Objterr or height
        )
        Obj.stored_waypoints[#Obj.stored_waypoints+1] = l
        l:SetDepthTest(true)
      end

    end
  end

  local randcolours = {}
  local colourcount = 0
  function ChoGGi.MenuFuncs.ClearColourAndWP(Class)
    local IsValid = IsValid
    local Objs = GetObjects({class = Class}) or empty_table
    for i = 1, #Objs do
      if IsValid(Objs[i]) then
        for i = #Objs[i].stored_waypoints, 1, -1 do
          Objs[i].stored_waypoints[i]:delete()
        end
        Objs[i].stored_waypoints = {}
        if Objs[i].ChoGGi_WaypointPathAdded then
          pcall(function()
            Objs[i]:SetColorModifier(Objs[i].ChoGGi_WaypointPathAdded)
            Objs[i].ChoGGi_WaypointPathAdded = nil
          end)
        end
      end
    end
  end

  function ChoGGi.MenuFuncs.SetWaypoint(Obj,single,skipflags,setcolour,skipheight)
    local path
    --we need to build a path for shuttles (and figure out a way to get their dest properly...)
    if Obj.class == "CargoShuttle" then
      path = {}
      if Obj.dest_dome then
        path[1] = Obj.dest_dome:GetPos()
      else
        path[1] = Obj:GetDestination()
      end
      local Table = Obj.current_spline
      if Table then
        for i = #Table, 1, -1 do
          path[#path+1] = Table[i]
        end
      end
      path[#path+1] = Obj:GetPos()
    else
      if not pcall(function()
        path = type(Obj.GetPath) == "function" and Obj:GetPath()
      end) then
        ex(Obj)
        print("Warning: This " .. Obj and (Obj.class or Obj.entity or "\"No class/entity\"") .. " doesn't have GetPath function, something is probably borked.")
      end
    end
    if path then
      local colour
      if setcolour then
        colour = setcolour
      else
        local randomcolour = ChoGGi.CodeFuncs.RandomColour()
        if single then
          colour = randomcolour
        else
          if #randcolours < 1 then
            colour = randomcolour
          else
            --we want to make sure all grouped waypoints are a different colour (or at least slightly diff)
            colour = table.remove(randcolours)
          end
        end
      end

      if not Obj.stored_waypoints then
        Obj.stored_waypoints = {}
      end

      if not Obj.ChoGGi_WaypointPathAdded then
        --used to reset the colour later on
        Obj.ChoGGi_WaypointPathAdded = Obj:GetColorModifier()
      end
      --colour it up
      Obj:SetColorModifier(colour)
      --send path off to make wp
      ShowWaypoints(
        path,
        colour,
        Obj,
        single,
        skipflags,
        skipheight
      )
    end
  end

  --continous loooop of object for pathing it
  function ChoGGi.MenuFuncs.MapPath(Obj,ChoGGi)
    local ChoGGi = ChoGGi
    local IsValid = IsValid
    local Sleep = Sleep
    local colour = ChoGGi.CodeFuncs.RandomColour()

    --stick a flag over the follower
    local endwp = PlaceText(Obj.class .. ": " .. Obj.handle, Obj:GetPos())
    endwp:SetColor(colour)
    endwp:Attach(Obj)
    endwp:SetAttachOffset(point(0,0,500))

    endwp:SetFontId(UIL.GetFontID("droid, 14, bold"))

    repeat
      if not Obj:GetPath() then
        Sleep(500)
      end
      ChoGGi.MenuFuncs.SetWaypoint(Obj,true,true,colour,true)
      Sleep(750)
      local count = #Obj.stored_waypoints
      for i = count, 1, -1 do
        Obj.stored_waypoints[i]:delete()
      end
      Obj.stored_waypoints = {}
    until ChoGGi.Temp.UnitPathingHandles[Obj.handle] == false
    ChoGGi.MenuFuncs.ClearColourAndWP(Obj.class)
  end

  function ChoGGi.MenuFuncs.SetPathMarkersGameTime(Obj)
    local ChoGGi = ChoGGi
    --the menu item sends itself
    if Obj and not Obj.class then
      Obj = ChoGGi.CodeFuncs.SelObject()
    elseif not Obj then
      ChoGGi.Temp.UnitPathingHandles = {}
    end

    if Obj.handle then
      if ChoGGi.Temp.UnitPathingHandles[Obj.handle] then
        --already exists so remove thread
        DeleteThread(ChoGGi.Temp.UnitPathingHandles[Obj.handle])
        ChoGGi.Temp.UnitPathingHandles[Obj.handle] = nil
      elseif IsValid(Obj) and type(Obj.GetPath) == "function" then
        ChoGGi.Temp.UnitPathingHandles[Obj.handle] = CreateGameTimeThread(function()
          ChoGGi.MenuFuncs.MapPath(Obj,ChoGGi)
        end)
      end
    end
  end

  function ChoGGi.MenuFuncs.RemoveWPDupePos(Class,Obj)
    local IsValid = IsValid
    --remove dupe pos
    local wppos = {}
    for i = 1, #Obj.stored_waypoints do
      local wp = Obj.stored_waypoints[i]
      if wp.class == Class then
        local pos = tostring(wp:GetPos())
        if wppos[pos] then
          wppos[pos]:SetColorModifier(6579300)
          wp:delete()
        else
          wppos[pos] = Obj.stored_waypoints[i]
        end
      end
    end
    --remove removed
    local found = true
    while found do
      found = nil
      for i = 1, #Obj.stored_waypoints do
        if not IsValid(Obj.stored_waypoints[i]) then
          table.remove(Obj.stored_waypoints,i)
          found = true
          break
        end
      end
    end
  end

  function ChoGGi.MenuFuncs.SetPathMarkersVisible()
    local ChoGGi = ChoGGi
    local GetObjects = GetObjects
    local empty_table = empty_table
    local Obj = SelectedObj
    if Obj then
      randcolours = ChoGGi.CodeFuncs.RandomColour(#randcolours + 1)
      ChoGGi.MenuFuncs.SetWaypoint(Obj,true)
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

        --reset all the base colours/waypoints
        ChoGGi.MenuFuncs.ClearColourAndWP("CargoShuttle")
        ChoGGi.MenuFuncs.ClearColourAndWP("Unit")

        --reset stuff
        flag_height = 50
        randcolours = {}
        colourcount = 0

      else --add waypoints

        local function swp(Table)
          for i = 1, #Table do
            ChoGGi.MenuFuncs.SetWaypoint(Table[i],nil,choice[1].check2)
          end
        end
        if value == "All" then
          local Table1 = GetObjects({class = "Unit"}) or empty_table
          local Table2 = GetObjects({class = "CargoShuttle"}) or empty_table
          colourcount = colourcount + #Table1
          colourcount = colourcount + #Table2
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(Table1)
          swp(Table2)
        else
          local Table = GetObjects({class = value}) or empty_table
          colourcount = colourcount + #Table
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(Table)
        end

        --remove any waypoints in the same pos
       local function ClearAllDupeWP(Class)
          local objs = GetObjects({class = Class}) or empty_table
          for i = 1, #objs do
            if objs[i] and objs[i].ChoGGi_WaypointPathAdded then
              ChoGGi.MenuFuncs.RemoveWPDupePos("WayPoint",objs[i])
              ChoGGi.MenuFuncs.RemoveWPDupePos("Sphere",objs[i])
            end
          end
        end
        ClearAllDupeWP("CargoShuttle")
        ClearAllDupeWP("Unit")

      end
    end

    local hint = "Use HandleToObject[handle] to get object handle"
    local Check1 = "Remove Waypoints"
    local Check1Hint = "Remove waypoints from the map and reset colours (You need to select any object)."
    local Check2 = "Skip Flags"
    local Check2Hint = "Doesn't add the little flags, just lines and spheres (good for larger maps)."
    ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Visible Path Markers",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
  end
end
