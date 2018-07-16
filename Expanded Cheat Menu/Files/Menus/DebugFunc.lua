--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local T = ChoGGi.ComFuncs.Trans

local pairs,pcall,print,type,tonumber,tostring,table = pairs,pcall,print,type,tonumber,tostring,table

local Clamp = Clamp
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local DoneObject = DoneObject
local EditorState = EditorState
local GetCamera = GetCamera
local GetEditorInterface = GetEditorInterface
local GetObjects = GetObjects
local GetTerrainCursor = GetTerrainCursor
local HexGridGetObject = HexGridGetObject
local HexToWorld = HexToWorld
local IsEditorActive = IsEditorActive
local IsValid = IsValid
local LoadStreamParticlesFromDir = LoadStreamParticlesFromDir
local ObjModified = ObjModified
local OpenExamine = OpenExamine
local ParticlesReload = ParticlesReload
local PlaceObj = PlaceObj
local PlaceObject = PlaceObject
local point = point
local ReloadClassEntities = ReloadClassEntities
local ReloadLua = ReloadLua
local SaveCSV = SaveCSV
local SelectionArrowAdd = SelectionArrowAdd
local Sleep = Sleep
local WaitDelayedLoadEntities = WaitDelayedLoadEntities
local WaitNextFrame = WaitNextFrame
local WorldToHex = WorldToHex
local XShortcutsSetMode = XShortcutsSetMode

local white = white
--~ local TerrainTextures = TerrainTextures

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

local function DeleteAllRocks(rock_cls)
  local objs = GetObjects{class = rock_cls} or empty_table
  for i = 1, #objs do
    objs[i]:delete()
  end
end

function ChoGGi.MenuFuncs.DeleteAllRocks()
  local function CallBackFunc(answer)
    if answer then
      DeleteAllRocks("Deposition")
      DeleteAllRocks("WasteRockObstructorSmall")
      DeleteAllRocks("WasteRockObstructor")
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(6779--[[Warning--]]),"!\n",T(302535920001238--[[Removes any rocks for that smooth map feel (will take about 30 seconds).--]])),
    CallBackFunc,
    Concat(T(6779--[[Warning--]]),": ",T(302535920000855--[[Last chance before deletion!--]]))
  )
end

do --export colonist data
  local ChoGGi_Tables = ChoGGi.Tables
  --build list of traits to skip (added as columns, we don't want dupes)
  local skipped_traits = {}
  local function AddSkipped(traits,list)
    for i = 1, #traits do
      list[traits[i]] = true
    end
    return list
  end
  skipped_traits = AddSkipped(ChoGGi_Tables.ColonistAges,skipped_traits)
  skipped_traits = AddSkipped(ChoGGi_Tables.ColonistGenders,skipped_traits)
  skipped_traits = AddSkipped(ChoGGi_Tables.ColonistSpecializations,skipped_traits)

  local ColonistsCSVColumns = {
    {"name",T(1000037--[[Name--]])},
    {"age",T(302535920001222--[[Age--]])},
    {"age_trait",Concat(T(302535920001222--[[Age--]])," ",T(3720--[[Trait--]]))},
    {"death_age",T(4284--[[Age of death--]])},
    {"birthplace",T(302535920000739--[[Birthplace--]])},
    {"gender",T(302535920000740--[[Gender--]])},
    {"race",T(302535920000741--[[Race--]])},
    {"specialist",T(240--[[Specialization--]])},
    {"performance",T(4283--[[Worker performance--]])},
    {"health",T(4291--[[Health--]])},
    {"comfort",T(4295--[[Comfort--]])},
    {"morale",T(4297--[[Morale--]])},
    {"sanity",T(4293--[[Sanity--]])},
    {"handle",T(302535920000955--[[Handle--]])},
    {"last_meal",T(302535920001229--[[Last Meal--]])},
    {"last_rest",T(302535920001235--[[Last Rest--]])},
    {"dome_name",Concat(T(1234--[[Dome--]])," ",T(1000037--[[Name--]]))},
    {"dome_pos",Concat(T(1234--[[Dome--]])," ",T(302535920001237--[[Position--]]))},
    {"dome_handle",Concat(T(1234--[[Dome--]])," ",T(302535920000955--[[Handle--]]))},
    {"residence_name",Concat(T(4809--[[Residence--]])," ",T(1000037--[[Name--]]))},
    {"residence_pos",Concat(T(4809--[[Residence--]])," ",T(302535920001237--[[Position--]]))},
    {"residence_dome",Concat(T(4809--[[Residence--]])," ",T(1234--[[Dome--]]))},
    {"workplace_name",Concat(T(4801--[[Workplace--]])," ",T(1000037--[[Name--]]))},
    {"workplace_pos",Concat(T(4801--[[Workplace--]])," ",T(302535920001237--[[Position--]]))},
    {"workplace_dome",Concat(T(4801--[[Workplace--]])," ",T(1234--[[Dome--]]))},
  }
  local function AddTraits(traits,list)
    for i = 1, #traits do
      list[#list+1] = {
        Concat("trait_",traits[i]),
        Concat("Trait ",traits[i]),
      }
    end
    return list
  end
  ColonistsCSVColumns = AddTraits(ChoGGi_Tables.NegativeTraits,ColonistsCSVColumns)
  ColonistsCSVColumns = AddTraits(ChoGGi_Tables.PositiveTraits,ColonistsCSVColumns)

  function ChoGGi.MenuFuncs.ExportColonistDataToCSV()
    local export_data = {}
    local colonists = UICity.labels.Colonist

    for i = 1, #colonists do
      local c = colonists[i]

      export_data[i] = {
        name = Concat(T(c.name[1])," ",T(c.name[3])),
        age = c.age,
        age_trait = c.age_trait,
        birthplace = c.birthplace,
        gender = c.gender,
        death_age = c.death_age,
        race = c.race,
        health = c.stat_health,
        comfort = c.stat_comfort,
        morale = c.stat_morale,
        sanity = c.stat_sanity,
        performance = c.performance,
        handle = c.handle,
        specialist = c.specialist,
        last_meal = c.last_meal,
        last_rest = c.last_rest,
      }
      --dome
      if c.dome then
        export_data[i].dome_name = RetName(c.dome)
        export_data[i].dome_pos = c.dome:GetVisualPos()
        export_data[i].dome_handle = c.dome.handle
      end
      --residence
      if c.residence then
        export_data[i].residence_name = RetName(c.residence)
        export_data[i].residence_pos = c.residence:GetVisualPos()
        export_data[i].residence_dome = RetName(c.residence.parent_dome)
      end
      --workplace
      if c.workplace then
        export_data[i].workplace_name = RetName(c.workplace)
        export_data[i].workplace_pos = c.workplace:GetVisualPos()
        export_data[i].workplace_dome = RetName(c.workplace.parent_dome)
      end
      --traits
      for trait_id, _ in pairs(c.traits) do
        if trait_id and trait_id ~= "" and not skipped_traits[trait_id] then
          export_data[i][Concat("trait_",trait_id)] = true
        end
      end
    end
    --and now we can save it to disk
    SaveCSV("AppData/Colonists.csv", export_data, table.map(ColonistsCSVColumns, 1), table.map(ColonistsCSVColumns, 2))
  end
end

function ChoGGi.MenuFuncs.DebugFX_Toggle(name,trans_id)
  _G[name] = not _G[name]

  MsgPopup(
    Concat(tostring(_G[name]),": ",T(trans_id)),
    T(1000113--[[Debug--]])
  )
end

function ChoGGi.MenuFuncs.ParticlesReload()
  LoadStreamParticlesFromDir("Data/Particles")
  ParticlesReload("", true)
end

function ChoGGi.MenuFuncs.AttachSpots_Toggle()
  local sel = ChoGGi.CodeFuncs.SelObject()
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

function ChoGGi.MenuFuncs.DeleteAllSelectedObjects(obj)
  local ChoGGi = ChoGGi
  obj = obj or ChoGGi.CodeFuncs.SelObject()

  local objs = GetObjects{class = obj.class} or empty_table
  local function CallBackFunc(answer)
    if answer then
      CreateRealTimeThread(function()
        for i = 1, #objs do
          ChoGGi.CodeFuncs.DeleteObject(objs[i])
        end
      end)
    end
  end

  local name = RetName(obj)
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(6779--[[Warning--]]),"!\n",T(302535920000852--[[This will delete all %s of %s--]]):format(#objs,name),"\n\n",T(302535920000854--[[Takes about thirty seconds for 12 000 objects.--]])),
    CallBackFunc,
    Concat(T(6779--[[Warning--]]),": ",T(302535920000855--[[Last chance before deletion!--]])),
    T(302535920000856--[[Yes, I want to delete all: %s--]]):format(name),
    T(302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."--]])
  )
end

function ChoGGi.MenuFuncs.ObjectCloner(obj)
  obj = obj or ChoGGi.CodeFuncs.SelObject()
  --clone dome = crashy
  local new
  if obj:IsKindOf("Dome") then
    new = g_Classes[obj.class]:new()
    new:CopyProperties(obj)
  else
    new = obj:Clone()
  end
  new:SetPos(ChoGGi.CodeFuncs.CursorNearestHex())
  if type(new.CheatRefill) == "function" then
    new:CheatRefill()
  end
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
      local str = "%d. %s\n"
      text:SetText(str:format(1,Obj:GetAnimDebug(1)))
      WaitNextFrame()
    end
  end)
end

local function AnimDebug_ShowAll(Class)
  local objs = GetObjects{class = Class} or empty_table
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
  local objs = GetObjects{class = Class} or empty_table
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
    local ChoGGi = ChoGGi
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
  local ChoGGi = ChoGGi
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
    MsgPopup(
      Concat(choice[1].text,": ",T(3722--[[State--]])),
      T(302535920000859--[[Anim State--]])
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000860--[[Set Anim State--]]),
    hint = Concat(T(302535920000861--[[Current State--]]),": ",sel:GetState()),
  }
end

--no sense in building the list more then once (it's a big list)
local ObjectSpawner_ItemList = {}
function ChoGGi.MenuFuncs.ObjectSpawner()
  local ChoGGi = ChoGGi
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

      MsgPopup(
        Concat(choice[1].text,": ",T(302535920000014--[[Spawned--]])," ",T(298035641454--[[Object--]])),
        T(302535920000014--[[Spawned--]])
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ObjectSpawner_ItemList,
    title = T(302535920000862--[[Object Spawner (EntityData list)--]]),
    hint = Concat(T(6779--[[Warning--]]),": ",T(302535920000863--[[Objects are unselectable with mouse cursor (hover mouse over and use Delete Object).--]])),
  }
end

function ChoGGi.MenuFuncs.ShowSelectionEditor()
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

function ChoGGi.MenuFuncs.ObjExaminer()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end
  --open examine at the object
  OpenExamine(sel,sel)
end

function ChoGGi.MenuFuncs.Editor_Toggle()
  local Platform = Platform

--~   if type(UpdateMapRevision) ~= "function" then
--~     function UpdateMapRevision() end
--~   end

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
                    local c = build_grid_debug_objs[idx] or g_Classes.ChoGGi_HexSpot:new()
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
--~   local function PlaceTerrainLine(pt1, pt2, color, step, offset)
--~     step = step or guim
--~     offset = offset or guim
--~     local diff = pt2 - pt1
--~     local steps = Max(2, 1 + diff:Len2D() / step)
--~     local mapw, maph = terrain_GetMapSize()
--~     local points = {}
--~     for i = 1, steps do
--~       local pos = pt1 + MulDivRound(diff, i - 1, steps - 1)
--~       local x, y, z = pos:xy()
--~       x = Clamp(x, 0, mapw - terrain_HeightTileSize)
--~       y = Clamp(y, 0, maph - terrain_HeightTileSize)
--~       z = terrain_GetHeight(x, y) + offset
--~       points[#points + 1] = point(x, y, z)
--~     end
--~     local line = g_Classes.Polyline:new({
--~       max_vertices = #points
--~     })
--~     line:SetMesh(points, color)
--~     line:SetDepthTest(true)
--~     line:SetPos((pt1 + pt2) / 2)
--~     line:SetColor(color or white)
--~     return line
--~   end

  local randcolours = {}
  local colourcount = 0
  local dupewppos = {}
  --pick a random model for start of path if doing single object
  local SpawnModels = {}
  SpawnModels[1] = "GreenMan"
  SpawnModels[2] = "Lama"
  --default height of waypoints (maybe flag_height isn't the best name as no more flags)
  local flag_height = 50

  local function ShowWaypoints(waypoints, colour, Obj, skipheight)
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

    --build a list of points that aren't high in the sky
    local points = {}
    local mapw, maph = terrain_GetMapSize()
    for i = 1, #waypoints do
--~       local pos = pt1 + MulDivRound(diff, i - 1, steps - 1)
      local x, y, z = waypoints[i]:xy()
      x = Clamp(x, 0, mapw - terrain_HeightTileSize)
      y = Clamp(y, 0, maph - terrain_HeightTileSize)
      z = terrain_GetHeight(x, y) + (shuttle and shuttle - Objterr or Objheight) + height --shuttle z always puts it too high?
      points[#points + 1] = point(x, y, z)
    end
    local last_pos = points[#points]
    --and spawn the line
    local spawnline = g_Classes.Polyline:new{max_vertices = #waypoints}
    spawnline:SetMesh(points, colour)
    spawnline:SetPos(last_pos)
    spawnline.ChoGGi_WaypointPath = true

--~     --add text to last wp
--~     local endwp = PlaceText(Concat(RetName(Obj),": ",Obj.handle), last_pos)
--~     Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = endwp
--~     endwp:SetColor(colour)
--~     endwp:SetZ(endwp:GetZ() + 250)
--~     --endp:SetShadowOffset(3)
--~     endwp:SetFontId(UIL_GetFontID("droid, 14, bold"))

    Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = spawnline
--~     spawnline:SetDepthTest(true)

--~     local sphereheight = 266 + height - 50
    --spawn a sphere at the Obj pos
--~     if not single then
--~       local spherestart = PlaceObject("Sphere")
--~       Obj.ChoGGi_Stored_Waypoints[#Obj.ChoGGi_Stored_Waypoints+1] = spherestart
--~       spherestart:SetPos(point(Objpos:x(),Objpos:y(),(shuttle and shuttle + 500) or (Objterr + sphereheight)))
--~       spherestart:SetDepthTest(true)
--~       spherestart:SetColor(colour)
--~       spherestart:SetRadius(35)
--~     end
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

  end --end of ShowWaypoints

  function ChoGGi.MenuFuncs.SetWaypoint(Obj,setcolour,skipheight)
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
        -- :GetPath() has them backwards so we'll do the same
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
        print(Concat(T(6779--[[Warning--]]),": ",T(302535920000869--[[This %s doesn't have GetPath function, something is probably borked.--]]):format(RetName(Obj))))
      end
    end
    if path then
      local colour
      if setcolour then
        colour = setcolour
      else
        local randomcolour = ChoGGi.CodeFuncs.RandomColour()
        if #randcolours < 1 then
          colour = randomcolour
        else
          --we want to make sure all grouped waypoints are a different colour (or at least slightly diff)
          colour = table.remove(randcolours)
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
        skipheight
      )
    end
  end

  function ChoGGi.MenuFuncs.SetPathMarkersGameTime(Obj)
    local ChoGGi = ChoGGi
    Obj = Obj or ChoGGi.CodeFuncs.SelObject()

    if Obj and Obj:IsKindOfClasses("Movable", "Shuttle") then
      if not ChoGGi.Temp.UnitPathingHandles then
        ChoGGi.Temp.UnitPathingHandles = {}
      end

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

            ChoGGi.MenuFuncs.SetWaypoint(Obj,colour,true)
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
      MsgPopup(
        T(302535920000871--[[Doesn't seem to be an object that moves.--]]),
        T(302535920000872--[[Pathing--]]),
        nil,
        nil,
        Obj
      )
    end
  end

  local function RemoveWPDupePos(Class,Obj)
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
    --and waypoints/colour
    local Objs = GetObjects{class = Class} or empty_table
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
      ChoGGi.MenuFuncs.SetWaypoint(Obj)
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

        --check for any extra lines
        local lines = GetObjects{class = "Polyline"} or empty_table
        for i = 1, #lines do
          if lines[i].ChoGGi_WaypointPath then
            DoneObject(lines[i])
          end
        end

        --reset stuff
        flag_height = 50
        randcolours = {}
        colourcount = 0
        dupewppos = {}

      else --add waypoints

        local function swp(Table)
          if choice[1].check2 then
            for i = 1, #Table do
              ChoGGi.MenuFuncs.SetPathMarkersGameTime(Table[i])
            end
          else
            for i = 1, #Table do
              ChoGGi.MenuFuncs.SetWaypoint(Table[i])
            end
          end
        end

        if value == "All" then
          local Table1 = ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects{class = "Unit"} or empty_table,"IsValid",nil,true)
          local Table2 = ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects{class = "CargoShuttle"} or empty_table,"IsValid",nil,true)
          colourcount = colourcount + #Table1
          colourcount = colourcount + #Table2
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(Table1)
          swp(Table2)
        else
          local Table = ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects{class = value} or empty_table,"IsValid",nil,true)
          colourcount = colourcount + #Table
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(Table)
        end

        --remove any waypoints in the same pos
        local function ClearAllDupeWP(Class)
          local objs = GetObjects{class = Class} or empty_table
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

    ChoGGi.ComFuncs.OpenInListChoice{
      callback = CallBackFunc,
      items = ItemList,
      title = T(302535920000467--[[Path Markers--]]),
      check1 = T(302535920000876--[[Remove Waypoints--]]),
      check1_hint = T(302535920000877--[[Remove waypoints from the map and reset colours.--]]),
      check2 = T(4099--[[Game Time--]]),
      check2_hint = Concat(T(302535920000462--[[Maps paths in real time--]]),"."),
    }
  end
end

-- add realtime markers to all of class
--~ local classname = "Drone"
--~ local objs = GetObjects{class = classname} or empty_table
--~ for i = 1, #objs do
--~   ChoGGi.MenuFuncs.SetPathMarkersGameTime(objs[i])
--~ end

--little bit of painting
--~ local terrain_type = "Grass_01"
--~ local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
--~ CreateRealTimeThread(function()
--~   while true do
--~     terrain.SetTypeCircle(GetTerrainCursor(), 2500, terrain_type_idx)
--~     Sleep(5)
--~   end
--~ end)
