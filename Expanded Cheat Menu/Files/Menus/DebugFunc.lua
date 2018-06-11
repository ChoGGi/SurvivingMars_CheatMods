--See LICENSE for terms

--simplest entity object as possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local)
DefineClass.ChoGGi_CursorBuilding = {
  __parents = {"CObject"},
  entity = "GridTile"
}

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans

local pairs,pcall,print,type,tonumber,tostring,string,table = pairs,pcall,print,type,tonumber,tostring,string,table

local ClassDescendantsList = ClassDescendantsList
local CloseMenuDialogs = CloseMenuDialogs
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local DoneObject = DoneObject
local EditorState = EditorState
local FillRandomMapProps = FillRandomMapProps
local GenerateRandomMapParams = GenerateRandomMapParams
local GenerateRocketCargo = GenerateRocketCargo
local GetCamera = GetCamera
local GetEditorInterface = GetEditorInterface
local GetMapName = GetMapName
local GetModifiedProperties = GetModifiedProperties
local GetObjects = GetObjects
local GetTerrainCursor = GetTerrainCursor
local HexGridGetObject = HexGridGetObject
local HexToWorld = HexToWorld
local InitNewGameMissionParams = InitNewGameMissionParams
local IsEditorActive = IsEditorActive
local IsValid = IsValid
local ListMaps = ListMaps
local LoadStreamParticlesFromDir = LoadStreamParticlesFromDir
local ObjModified = ObjModified
local OpenExamine = OpenExamine
local ParticlesReload = ParticlesReload
local PlaceObj = PlaceObj
local PlaceObject = PlaceObject
local PlaceTerrainLine = PlaceTerrainLine
local PlaceText = PlaceText
local point = point
local Random = Random
local ReloadClassEntities = ReloadClassEntities
local ReloadLua = ReloadLua
local SaveLocalStorage = SaveLocalStorage
local SelectionArrowAdd = SelectionArrowAdd
local ShowConsoleLog = ShowConsoleLog
local Sleep = Sleep
local WaitDelayedLoadEntities = WaitDelayedLoadEntities
local WaitMapSettingsDialog = WaitMapSettingsDialog
local WaitNextFrame = WaitNextFrame
local WorldToHex = WorldToHex
local XShortcutsSetMode = XShortcutsSetMode
local MulDivRound = MulDivRound
local Max = Max
local Clamp = Clamp

local guim = guim
local guic = guic
local white = white

local camera_IsLocked = camera.IsLocked
local camera_Unlock = camera.Unlock
local terminal_GetMousePos = terminal.GetMousePos
local terrain_HeightTileSize = terrain.HeightTileSize() --intentional
local terrain_IsSCell = terrain.IsSCell
local terrain_IsPassable = terrain.IsPassable
local terrain_GetHeight = terrain.GetHeight
local terrain_GetMapSize = terrain.GetMapSize
local UIL_GetFontID = UIL.GetFontID

local g_Classes = g_Classes

function ChoGGi.MenuFuncs.ParticlesReload()
  LoadStreamParticlesFromDir("Data/Particles")
  ParticlesReload("", true)
end

function ChoGGi.MenuFuncs.AttachSpots_Toggle()
  local sel = SelectedObj
  if not sel then
    return
  end
  if sel.ChoGGi_ShowAttachSpots then
    sel:HideSpots()
    sel.ChoGGi_ShowAttachSpots = nil
  else
    sel:ShowSpots()
    sel.ChoGGi_ShowAttachSpots = true
  end
end

function ChoGGi.MenuFuncs.MeasureTool_Toggle(which)
  if which then
    MeasureTool.enabled = true
    g_Classes.MeasureTool.OnLButtonDown(GetTerrainCursor())
  else
    DoneObject(MeasureTool.object)
    MeasureTool.enabled = false
  end
end

function ChoGGi.MenuFuncs.ReloadLua()
  ReloadLua()
  WaitDelayedLoadEntities()
  ReloadClassEntities()
  print(T(302535920000850--[[Reload lua done--]]))
end

function ChoGGi.MenuFuncs.DeleteAllSelectedObjects(s)
  local ChoGGi = ChoGGi
  --the menu item sends itself
  if s and not s.class then
    s = ChoGGi.CodeFuncs.SelObject()
  end
  local name = ChoGGi.ComFuncs.RetName(s)
  if not name then
    ChoGGi.ComFuncs.MsgPopup(Concat(T(6774--[[Error--]]),": ",tostring(s),T(302535920000851--[[isn't an object?\nSounds like a broked save; send me the file and I'll take a look--]]),": ",ChoGGi.email),
      T(6774--[[Error--]]),nil,true
    )
    return
  end

  local objs = GetObjects({class=s.class})
  local function CallBackFunc(answer)
    if answer then
      CreateRealTimeThread(function()
        for i = 1, #objs do
          ChoGGi.CodeFuncs.DeleteObject(objs[i])
        end
      end)
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(6779--[[Warning--]]),"!\n",T(302535920000852--[[This will delete all--]])," ",#objs," ",T(302535920000853--[[of--]])," ",name,"\n\n",T(302535920000854--[[Takes about thirty seconds for 12 000 objects.--]])),
    CallBackFunc,
    Concat(T(6779--[[Warning--]]),": ",T(302535920000855--[[Last chance before deletion!--]])),
    Concat(T(302535920000856--[[Yes, I want to delete all--]]),": ",name),
    T(302535920000857--[[No, I need to backup my save first (like I should've done before clicking something called 'Delete All').--]])
  )
end

function ChoGGi.MenuFuncs.ObjectCloner(sel)
  --the menu item sends itself
  if sel and not sel.class then
    sel = ChoGGi.CodeFuncs.SelObject()
  end
  --clone dome = crashy
  local new
  if sel:IsKindOf("Dome") then
    new = g_Classes[sel.class]:new()
    new:CopyProperties(sel)
  else
    new = sel:Clone()
  end
  new:SetPos(ChoGGi.CodeFuncs.CursorNearestHex())
end

local function AnimDebug_Show(Obj,Colour)
  local text = PlaceObject("Text")
  text:SetDepthTest(true)
  text:SetColor(Colour or ChoGGi.CodeFuncs.RandomColour())
  text:SetFontId(UIL_GetFontID("droid, 14, bold"))

  text.ChoGGi_AnimDebug = true
  Obj:Attach(text)
  text:SetAttachOffset(point(0,0,Obj:GetObjectBBox():sizez() + 100))
  CreateGameTimeThread(function()
    while IsValid(text) do
      text:SetText(string.format("%d. %s\n", 1, Obj:GetAnimDebug(1)))
      WaitNextFrame()
    end
  end)
end

local function AnimDebug_ShowAll(Class)
  local objs = GetObjects({class = Class}) or empty_table
  for i = 1, #objs do
    AnimDebug_Show(objs[i])
  end
end

local function AnimDebug_Hide(Obj)
  local att = Obj:GetAttaches() or empty_table
  for i = 1, #att do
    if att[i].ChoGGi_AnimDebug then
      DoneObject(att[i]) --:delete()
    end
  end
end

local function AnimDebug_HideAll(Class)
  local empty_table = empty_table
  local objs = GetObjects({class = Class}) or empty_table
  for i = 1, #objs do
    AnimDebug_Hide(objs[i])
  end
end

function ChoGGi.MenuFuncs.ShowAnimDebug_Toggle()
  if SelectedObj then
    local sel = SelectedObj
    if sel.ChoGGi_ShowAnimDebug then
      sel.ChoGGi_ShowAnimDebug = nil
      AnimDebug_Hide(sel)
    else
      sel.ChoGGi_ShowAnimDebug = true
      AnimDebug_Show(sel,white)
    end
  else
    ChoGGi.Temp.ShowAnimDebug = not ChoGGi.Temp.ShowAnimDebug
    if ChoGGi.Temp.ShowAnimDebug then
      AnimDebug_ShowAll("Building")
      AnimDebug_ShowAll("Unit")
      AnimDebug_ShowAll("CargoShuttle")
    else
      AnimDebug_HideAll("Building")
      AnimDebug_HideAll("Unit")
      AnimDebug_HideAll("CargoShuttle")
    end
  end
end

function ChoGGi.MenuFuncs.SetAnimState()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end
  local ItemList = {}
  local Table = sel:GetStates()

  for Key,State in pairs(Table) do
    ItemList[#ItemList+1] = {
      text = Concat(T(1000037--[[Name--]]),": ",State," ",T(302535920000858--[[Idx--]]),": ",Key),
      value = State,
    }
  end

  local CallBackFunc = function(choice)
    sel:SetStateText(choice[1].value)
    ChoGGi.ComFuncs.MsgPopup(Concat(T(3722--[[State--]]),": ",choice[1].text),
      T(302535920000859--[[Anim State--]])
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000860--[[Set Anim State--]]),
    hint = Concat(T(302535920000861--[[Current State--]]),": ",sel:GetState()),
  })
end

--no sense in building the list more then once (it's a big list)
local ObjectSpawner_ItemList = {}
function ChoGGi.MenuFuncs.ObjectSpawner()
  local EntityData = EntityData
  if #ObjectSpawner_ItemList == 0 then
    for Key,_ in pairs(EntityData) do
      ObjectSpawner_ItemList[#ObjectSpawner_ItemList+1] = {
        text = Key,
        value = Key
      }
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if g_Classes[value] then

      local NewObj = PlaceObj(value,{"Pos",ChoGGi.CodeFuncs.CursorNearestHex()})
      --NewObj.__parents[#NewObj.__parents] = "Building"
      NewObj.__parents[#NewObj.__parents] = "InfopanelObj"
      NewObj.ip_template = "ipEverything"
      NewObj.ChoGGi_Spawned = true
      NewObj:GetEnumFlags(const.efSelectable)

      --so we know something is selected
      NewObj.OnSelected = function()
        SelectionArrowAdd(NewObj)
      end

      ObjModified(NewObj)
      --[[
      be nice to populate with default values, but causes issues
      --local NewObj = PlaceObj(value,{"Pos",GetTerrainCursor()})
      for _, prop in iXpairs(NewObj:GetProperties()) do
        NewObj:SetProperty(prop.id, NewObj:GetDefaultPropertyValue(prop.id, prop))
      end
      --]]

      ChoGGi.ComFuncs.MsgPopup(Concat(T(302535920000014--[[Spawned--]]),": ",choice[1].text,T(298035641454--[[Object--]])),
        T(302535920000014--[[Spawned--]])
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ObjectSpawner_ItemList,
    title = T(302535920000862--[[Object Spawner (EntityData list)--]]),
    hint = Concat(T(6779--[[Warning--]]),": ",T(302535920000863--[[Objects are unselectable with mouse cursor (hover mouse over and use Delete Object).--]])),
  })
end

function ChoGGi.MenuFuncs.ShowSelectionEditor()
  local DoneObject = DoneObject
  local terminal = terminal
  --check for any opened windows and kill them
  for i = 1, #terminal.desktop do
    if terminal.desktop[i]:IsKindOf("ObjectsStatsDlg") then
      DoneObject(terminal.desktop[i]) --:delete()
    end
  end
  --open a new copy
  local dlg = g_Classes.ObjectsStatsDlg:new()
  if not dlg then
    return
  end
  dlg:SetPos(terminal_GetMousePos())

  --OpenDialog("ObjectsStatsDlg",nil,terminal.desktop)
end

function ChoGGi.MenuFuncs.SetWriteLogs_Toggle()
  ChoGGi.UserSettings.WriteLogs = not ChoGGi.UserSettings.WriteLogs
  ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(T(302535920000864--[[Write debug/console logs--]]),": ",tostring(ChoGGi.UserSettings.WriteLogs)),
    T(1000113--[[Debug--]]),"UI/Icons/Anomaly_Breakthrough.tga"
  )
end

function ChoGGi.MenuFuncs.ObjExaminer()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end
  --open examine at the object
  OpenExamine(sel,sel)
end

function ChoGGi.MenuFuncs.Editor_Toggle()

  if type(UpdateMapRevision) ~= "function" then
    function UpdateMapRevision() end
  end
  local Platform = Platform
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
    editor.CameraWasLocked = camera_IsLocked(1)
    camera_Unlock(1)

    GetEditorInterface():SetVisible(true)
    GetEditorInterface():ShowSidebar(true)
    GetEditorInterface().dlgEditorStatusbar:SetVisible(true)
    --GetEditorInterface():SetMinimapVisible(true)
    --CreateEditorPlaceObjectsDlg()
    if showmenu then
      g_Classes.UAMenu.ToggleOpen()
    end
  end

end

function ChoGGi.MenuFuncs.ConsoleHistory_Toggle()
  ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.ConsoleToggleHistory),T(302535920000865--[[: Those who cannot remember the past are condemned to repeat it.--]])),
    T(1000113--[[Debug--]]),"UI/Icons/Sections/workshifts.tga"
  )
end

function ChoGGi.MenuFuncs.ChangeMap()
  local NewMissionParams = {}

  --open a list dialog to set g_CurrentMissionParams
  local ItemList = {
    {text = T(3474--[[Mission Sponsor--]]),value = "IMM"},
    {text = T(3478--[[Commander Profile--]]),value = "rocketscientist"},
    {text = T(3486--[[Mystery--]]),value = "random"},
    {text = T(8800--[[Game Rules--]]),value = ""},
  }

  local CallBackFunc = function(choice)
    if type(choice) ~= "table" then
      return
    end
    for i = 1, #choice do
      local text = choice[i].text
      local value = choice[i].value

      if text == T(3474--[[Mission Sponsor--]]) then
        NewMissionParams.idMissionSponsor = value
      elseif text == T(3478--[[Commander Profile--]]) then
        NewMissionParams.idCommanderProfile = value
      elseif text == T(3486--[[Mystery--]]) then
        NewMissionParams.idMystery = value
      elseif text == T(8800--[[Game Rules--]]) then
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

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000866--[[Set MissionParams NewMap--]]),
    hint = T(302535920000867--[[Attention: You must close this dialog for these settings to take effect on new map!\n\nSee the list on the left for ids.\n\nFor rules separate with spaces: Hunger Twister (or leave blank for none).--]]),
    custom_type = 4,
  })

  --shows the mission params for people to look at
  OpenExamine(MissionParams)

  --map list dialog
  CreateRealTimeThread(function()
    local caption = T(302535920000868--[[Choose map with settings presets:--]])
    local maps = ListMaps()
    local items = {}
    for i = 1, #maps do
      if not string.find(string.lower(maps[i]), "^prefab") and not string.find(maps[i], "^__") then
        items[#items+1] = {
--~           text = Untranslated(maps[i]),
          text = maps[i],
          map = maps[i]
        }
      end
    end

    local default_selection = table.find(maps, GetMapName())
    local map_settings = {}
    local mapdata = mapdata
    local class_names = ClassDescendantsList("MapSettings")
    for i = 1, #class_names do
      map_settings[class_names[i]] = mapdata[class_names[i]]
    end

    local sel_idx
    local dlg = CreateMapSettingsDialog(items, caption, nil, map_settings)
    if default_selection then
      dlg.idList:SetSelection(default_selection, true)
    end
    --QoL
    dlg.idCaption.HandleMouse = false
    dlg:SetMovable(true)
    Sleep(1)
    dlg.move:SetZOrder(10)

    sel_idx, map_settings = dlg:Wait()

    if sel_idx ~= "idCancel" then
      local g_CurrentMissionParams = g_CurrentMissionParams
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
      g_CurrentMissionParams.idGameRules = NewMissionParams.idGameRules or empty_table
      g_CurrentMissionParams.GameSessionID = g_Classes.srp.random_encode64(96)

      --items in spawn rocket
      GenerateRocketCargo()

      --landing spot/rocket name / resource amounts?, see g_CurrentMapParams
      GenerateRandomMapParams()

      --and change the map
      local props = GetModifiedProperties(DataInstances.RandomMapPreset.MAIN)
      local gen = g_Classes.RandomMapGenerator:new()
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
    local ObjectGrid = ObjectGrid
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
                    local c = build_grid_debug_objs[idx] or g_Classes.ChoGGi_CursorBuilding:new()
                    --both
                    if iType == 1 then
                      if (terrain_IsSCell(HexToWorld(q_i, r_i)) or terrain_IsPassable(HexToWorld(q_i, r_i))) and not HexGridGetObject(ObjectGrid, q_i, r_i) then
                        --green
                        c:SetColorModifier(-16711936)
                      else
                        --red
                        c:SetColorModifier(-65536)
                      end
                    --passable
                    elseif iType == 2 then
                      if terrain_IsSCell(HexToWorld(q_i, r_i)) or terrain_IsPassable(HexToWorld(q_i, r_i)) then
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
  --from CommonLua\Classes\CodeRenderableObject.lua
  local function PlaceTerrainLine(pt1, pt2, color, step, offset)
    step = step or guim
    offset = offset or guim
    local diff = pt2 - pt1
    local steps = Max(2, 1 + diff:Len2D() / step)
    local mapw, maph = terrain_GetMapSize()
    local points = {}
    for i = 1, steps do
      local pos = pt1 + MulDivRound(diff, i - 1, steps - 1)
      local x, y, z = pos:xy()
      x = Clamp(x, 0, mapw - terrain_HeightTileSize)
      y = Clamp(y, 0, maph - terrain_HeightTileSize)
      z = terrain_GetHeight(x, y) + offset
      points[#points + 1] = point(x, y, z)
    end
    local line = g_Classes.Polyline:new({
      max_vertices = #points
    })
    line:SetMesh(points, color)
    line:SetDepthTest(true)
    line:SetPos((pt1 + pt2) / 2)
--~     line:SetColor(color or white)
    return line
  end

  local randcolours = {}
  local colourcount = 0
  local dupewppos = {}
  --pick a random model for start of path if doing single object
  local SpawnModels = {}
  SpawnModels[1] = "GreenMan"
  SpawnModels[2] = "Lama"
  --default height of waypoints
  local flag_height = 50

  local function ShowWaypoints(waypoints, colour, Obj, single, skipflags, skipheight, skiptext, skipstart)
    colour = tonumber(colour) or ChoGGi.CodeFuncs.RandomColour()
    --also used for line height
    if not skipheight then
      flag_height = flag_height + 4
    end
    local height = flag_height
    local Objpos = Obj:GetVisualPos()
    local Objterr = terrain_GetHeight(Objpos)
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
--~     local spawnline = PlaceTerrainLine(
--~       Objpos,
--~       waypoints[#waypoints],
--~       colour,
--~       nil, --work_step
--~       shuttle and shuttle - Objterr or Objheight --shuttle z always puts it too high?
--~     )
    local spawnline = PlaceTerrainLine(
      Objpos,
      waypoints[#waypoints],
      colour,
      nil, --work_step
      shuttle and shuttle - Objterr or Objheight --shuttle z always puts it too high?
    )
    Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = spawnline
    spawnline:SetDepthTest(true)
    local sphereheight = 266 + height - 50
    --line:SetPrimType(4)
    if not single then
      --spawn a sphere at the Obj pos
      local spherestart = PlaceObject("Sphere")
      Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = spherestart
      spherestart:SetPos(point(Objpos:x(),Objpos:y(),(shuttle and shuttle + 500) or Objterr + sphereheight))
      spherestart:SetDepthTest(true)
      spherestart:SetColor(colour)
      spherestart:SetRadius(35)
    end
    --and another at the end
    --[[
    local sphereend = PlaceObject("Sphere")
    Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = sphereend
    local w = waypoints[1]
    sphereend:SetPos(w)
    sphereend:SetZ(((w:z() or terrain_GetHeight(w)) + 10 * guic) + sphereheight)
    sphereend:SetDepthTest(true)
    sphereend:SetColor(colour)
    sphereend:SetRadius(25)
    --]]

    --list is sent dest>pos order
    for i = 1, #waypoints do
      local w = waypoints[i]
      local wpn = waypoints[i+1]
      local pos = w:SetZ((w:z() or terrain_GetHeight(w)) + 10 * guic)
      pos = point(pos:x(),pos:y(),shuttle or pos:z())

      if skipflags ~= true then
        local p
        if single and i == #waypoints and not skipstart then
          p = PlaceObject(SpawnModels[Random(1,2)])
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
        Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = p
        p:SetColorModifier(colour)
        p:SetPos(pos)
      end

      --add text to last wp
      if i == 1 and not skiptext then
        local endwp = PlaceText(Concat(Obj.class,": ",Obj.handle), pos)
        Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = endwp
        endwp:SetColor(colour)
        --endp:SetColor2()
        endwp:SetZ(endwp:GetZ() + 250 + height)
        --endp:SetShadowOffset(3)
        endwp:SetFontId(UIL_GetFontID("droid, 14, bold"))
      end

      if wpn then
--~         local l = PlaceTerrainLine(
        local l = PlaceTerrainLine(
          pos,
          wpn,
          colour,
          nil,
          shuttle and shuttle - Objterr or height
        )
        Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = l
        l:SetDepthTest(true)
      end
    end

    --if #Obj.ChoGGi_Stored_Waypoints > 150 then
    --  print(Concat(ChoGGi.ComFuncs.RetName(Obj)," (handle: ",Obj.handle,") has over 150 waypoints."))
    --end
  end --end of ShowWaypoints

  function ChoGGi.MenuFuncs.SetWaypoint(Obj,single,skipflags,setcolour,skipheight,skiptext, skipstart)
    local path
    --we need to build a path for shuttles (and figure out a way to get their dest properly...)
    if Obj.class == "CargoShuttle" then

      path = {}
      --going to pickup colonist
      if Obj.dest_dome then
        path[1] = Obj.dest_dome:GetPos()
      else
        path[1] = Obj:GetDestination()
      end
      --the next four points it's going to
      local Table = Obj.next_spline
      if Table then
        for i = #Table, 1, -1 do
          path[#path+1] = Table[i]
        end
      end
      Table = Obj.current_spline
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
        OpenExamine(Obj)
        print(Concat(T(6779--[[Warning--]]),": ",T(302535920000869--[[This--]])," ",Obj and ChoGGi.ComFuncs.RetName(Obj)," ",T(302535920000870--[[doesn't have GetPath function, something is probably borked.--]])))
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

      if type(Obj.ChoGGi_Stored_Waypoints) ~= "table" then
        Obj.ChoGGi_Stored_Waypoints = {}
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
        skipheight,
        skiptext,
        skipstart
      )
    end
  end

  function ChoGGi.MenuFuncs.SetPathMarkersGameTime(Obj,skipflags,skiptext)
    local ChoGGi = ChoGGi
    local IsValid = IsValid
    local Sleep = Sleep
    local DoneObject = DoneObject
    --the menu item sends itself
    if Obj and not Obj.class then
      Obj = ChoGGi.CodeFuncs.SelObject()
    else
      Obj = ChoGGi.CodeFuncs.SelObject()
    end
    if not ChoGGi.Temp.UnitPathingHandles then
      ChoGGi.Temp.UnitPathingHandles = {}
    end

    if Obj and Obj.handle then
      if ChoGGi.Temp.UnitPathingHandles[Obj.handle] then
        --already exists so remove thread
        --DeleteThread(ChoGGi.Temp.UnitPathingHandles[Obj.handle])
        ChoGGi.Temp.UnitPathingHandles[Obj.handle] = nil
      elseif IsValid(Obj) and (type(Obj.GetPath) == "function" or Obj.class == "CargoShuttle") then

        --continous loooop of object for pathing it
        ChoGGi.Temp.UnitPathingHandles[Obj.handle] = CreateGameTimeThread(function()
          local colour = ChoGGi.CodeFuncs.RandomColour()
          if type(Obj.ChoGGi_Stored_Waypoints) ~= "table" then
            Obj.ChoGGi_Stored_Waypoints = {}
          end
          local sleepidx = 0
          --stick a flag over the follower
          --local endwp = PlaceText(Concat(Obj.class,": ",Obj.handle), Obj:GetPos())
          --endwp:SetColor(colour)
          --endwp:Attach(Obj)
          --endwp:SetAttachOffset(point(0,0,500))
          --endwp:SetFontId(UIL_GetFontID("droid, 14, bold"))
          repeat
            --shuttles don't have paths
            if Obj.class ~= "CargoShuttle" and not Obj:GetPath() then
              Sleep(500)
              sleepidx = sleepidx + 1
              if sleepidx == 250 then
                DeleteThread(ChoGGi.Temp.UnitPathingHandles[Obj.handle])
              end
            end
            sleepidx = 0

            ChoGGi.MenuFuncs.SetWaypoint(Obj,true,skipflags,colour,true,skiptext,true)
            Sleep(750)

            --remove old wps
            if type(Obj.ChoGGi_Stored_Waypoints) == "table" then
              for i = #Obj.ChoGGi_Stored_Waypoints, 1, -1 do
                DoneObject(Obj.ChoGGi_Stored_Waypoints[i])--:delete()
              end
            end
            Obj.ChoGGi_Stored_Waypoints = {}

            --break thread when obj isn't valid
            if not IsValid(Obj) then
              ChoGGi.Temp.UnitPathingHandles[Obj.handle] = nil
            end
          until not ChoGGi.Temp.UnitPathingHandles[Obj.handle]
        end)

      end
    else
      ChoGGi.ComFuncs.MsgPopup(T(302535920000871--[[Select a moving object to see path.--]]),T(302535920000872--[[Pathing--]]))
    end
  end

  local function RemoveWPDupePos(Class,Obj)
    local IsValid = IsValid
    local DoneObject = DoneObject
    --remove dupe pos
    if type(Obj.ChoGGi_Stored_Waypoints) == "table" then
      for i = 1, #Obj.ChoGGi_Stored_Waypoints do
        local wp = Obj.ChoGGi_Stored_Waypoints[i]
        if wp.class == Class then
          local pos = tostring(wp:GetPos())
          if dupewppos[pos] then
            dupewppos[pos]:SetColorModifier(6579300)
            DoneObject(wp) --:delete()
          else
            dupewppos[pos] = Obj.ChoGGi_Stored_Waypoints[i]
          end
        end
      end
      --remove removed
      for i = #Obj.ChoGGi_Stored_Waypoints, 1, -1 do
        if not IsValid(Obj.ChoGGi_Stored_Waypoints[i]) then
          table.remove(Obj.ChoGGi_Stored_Waypoints,i)
        end
      end
    end
  end

  local function ClearColourAndWP(Class)
    local ChoGGi = ChoGGi
    --remove all thread refs so they stop
    ChoGGi.Temp.UnitPathingHandles = {}
    --ChoGGi.Temp.UnitPathingHandles = {}
    --and waypoints/colour
    local Objs = GetObjects({class = Class}) or empty_table
    for i = 1, #Objs do

      if Objs[i].ChoGGi_WaypointPathAdded then
        Objs[i]:SetColorModifier(Objs[i].ChoGGi_WaypointPathAdded)
        Objs[i].ChoGGi_WaypointPathAdded = nil
      end

      if type(Objs[i].ChoGGi_Stored_Waypoints) == "table" then
        for j = #Objs[i].ChoGGi_Stored_Waypoints, 1, -1 do
          DoneObject(Objs[i].ChoGGi_Stored_Waypoints[j])
        end
        Objs[i].ChoGGi_Stored_Waypoints = nil
      end

    end
  end

  function ChoGGi.MenuFuncs.SetPathMarkersVisible()
    local ChoGGi = ChoGGi
    local Obj = SelectedObj
    if Obj then
      randcolours = ChoGGi.CodeFuncs.RandomColour(#randcolours + 1)
      ChoGGi.MenuFuncs.SetWaypoint(Obj,true)
      return
    end

    local ItemList = {
      {text = T(4493--[[All--]]),value = "All"},
      {text = T(547--[[Colonists--]]),value = "Colonist"},
      {text = T(517--[[Drones--]]),value = "Drone"},
      {text = T(5438--[[Rovers--]]),value = "BaseRover"},
      {text = T(745--[[Shuttles--]]),value = "CargoShuttle",hint = T(302535920000873--[[Doesn't work that well.--]])},
    }

    local CallBackFunc = function(choice)
      local value = choice[1].value
      --remove wp/lines and reset colours
      if choice[1].check1 then

        --reset all the base colours/waypoints
        ClearColourAndWP("CargoShuttle")
        ClearColourAndWP("Unit")

        --reset stuff
        flag_height = 50
        randcolours = {}
        colourcount = 0
        dupewppos = {}

      else --add waypoints

        local function swp(Table)
          for i = 1, #Table do
            ChoGGi.MenuFuncs.SetWaypoint(Table[i],nil,choice[1].check2)
          end
        end
        if value == "All" then
          local Table1 = ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects({class="Unit"}),"IsValid",nil,true)
          local Table2 = ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects({class="CargoShuttle"}),"IsValid",nil,true)
          colourcount = colourcount + #Table1
          colourcount = colourcount + #Table2
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(Table1)
          swp(Table2)
        else
          local Table = ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects({class=value}),"IsValid",nil,true)
          colourcount = colourcount + #Table
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(Table)
        end

        --remove any waypoints in the same pos
        local function ClearAllDupeWP(Class)
          local objs = GetObjects({class = Class}) or empty_table
          for i = 1, #objs do
            if objs[i] and objs[i].ChoGGi_Stored_Waypoints then
              RemoveWPDupePos("WayPoint",objs[i])
              RemoveWPDupePos("Sphere",objs[i])
            end
          end
        end
        ClearAllDupeWP("CargoShuttle")
        ClearAllDupeWP("Unit")

      end
    end

    ChoGGi.ComFuncs.OpenInListChoice({
      callback = CallBackFunc,
      items = ItemList,
      title = T(302535920000874--[[Set Visible Path Markers--]]),
      hint = T(302535920000875--[[Use HandleToObject[handle] to get object handle--]]),
      check1 = T(302535920000876--[[Remove Waypoints--]]),
      check1_hint = T(302535920000877--[[Remove waypoints from the map and reset colours (You need to select any object).--]]),
      check2 = T(302535920000878--[[Skip Flags--]]),
      check2_hint = T(302535920000879--[[Doesn't add the little flags, just lines and spheres (good for larger maps).--]]),
    })
  end
end
