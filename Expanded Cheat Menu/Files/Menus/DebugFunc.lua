--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local local_T = T
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings

local pairs,pcall,print,type,tonumber,tostring,table = pairs,pcall,print,type,tonumber,tostring,table

local AsyncFileDelete = AsyncFileDelete
local Clamp = Clamp
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local EditorState = EditorState
local GetCamera = GetCamera
local GetEditorInterface = GetEditorInterface
local GetObjects = GetObjects
local GetPCSaveFolder = GetPCSaveFolder
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

function ChoGGi.MenuFuncs.DeleteSavedGames()
  local SavegamesList = SavegamesList
  local ItemList = {}
  for i = 1, #SavegamesList do
    local data = SavegamesList[i]

    -- build played time
    local playtime = local_T{77, "Unknown"}
    if data.playtime then
      local h, m, _ = FormatElapsedTime(data.playtime, "hms")
      local hours = string.format("%02d", h)
      local minutes = string.format("%02d", m)
      playtime = T(local_T{7549, "<hours>:<minutes>", hours = hours, minutes = minutes})
    end
    -- and last saved
    local save_date = 0
    if data.timestamp then
      save_date = os.date("%H:%M - %d / %m / %Y", data.timestamp)
    end

    ItemList[i] = {
      text = data.displayname,
      value = data.savename,
      hint = Concat(
        S[4274--[[Playtime : %s--]]]:format(playtime),
        "\n",
        S[4273--[[Saved on : %s--]]]:format(save_date),
        "\n\n",
        S[302535920001274--[[This is permanent!--]]]
      ),
    }
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end

    if not choice[1].check1 then
      MsgPopup(
        302535920000038--[[Pick a checkbox next time...--]],
        302535920000146--[[Delete Saved Games--]]
      )
      return
    end
    local save_folder = GetPCSaveFolder()

    for i = 1, #choice do
      value = choice[i].value
      if type(value) == "string" then
--~         print("delete ",Concat(save_folder,value))
        AsyncFileDelete(Concat(save_folder,value))
      end
    end

    -- remove any saves we deleted
    local games_amt = #SavegamesList
    for i = #SavegamesList, 1, -1 do
      if not ChoGGi.ComFuncs.FileExists(Concat(save_folder,SavegamesList[i].savename)) then
        SavegamesList[i] = nil
        table.remove(SavegamesList,i)
      end
    end

    games_amt = games_amt - #SavegamesList
    if games_amt > 0 then
      MsgPopup(
        S[302535920001275--[[Deleted %s saved games.--]]]:format(games_amt),
        302535920000146--[[Delete Saved Games--]]
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000146--[[Delete Saved Games--]]],": ",#ItemList),
    hint = Concat(S[302535920001167--[[Use Ctrl/Shift for multiple selection.--]]],"\n\n",S[6779--[[Warning--]]],": ",S[302535920001274--[[This is permanent!--]]]),
    multisel = true,
    skip_sort = true,
    check1 = 1000009--[[Confirmation--]],
    check1_hint = 302535920001276--[[Nothing is deleted unless you check this.--]],
  }
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
    {"name",S[1000037--[[Name--]]]},
    {"age",S[302535920001222--[[Age--]]]},
    {"age_trait",Concat(S[302535920001222--[[Age--]]]," ",S[3720--[[Trait--]]])},
    {"death_age",S[4284--[[Age of death--]]]},
    {"birthplace",S[4357--[[Birthplace--]]]},
    {"gender",S[4356--[[Sex--]]]},
    {"race",S[302535920000741--[[Race--]]]},
    {"specialist",S[240--[[Specialization--]]]},
    {"performance",S[4283--[[Worker performance--]]]},
    {"health",S[4291--[[Health--]]]},
    {"comfort",S[4295--[[Comfort--]]]},
    {"morale",S[4297--[[Morale--]]]},
    {"sanity",S[4293--[[Sanity--]]]},
    {"handle",S[302535920000955--[[Handle--]]]},
    {"last_meal",S[302535920001229--[[Last Meal--]]]},
    {"last_rest",S[302535920001235--[[Last Rest--]]]},
    {"dome_name",Concat(S[1234--[[Dome--]]]," ",S[1000037--[[Name--]]])},
    {"dome_pos",Concat(S[1234--[[Dome--]]]," ",S[302535920001237--[[Position--]]])},
    {"dome_handle",Concat(S[1234--[[Dome--]]]," ",S[302535920000955--[[Handle--]]])},
    {"residence_name",Concat(S[4809--[[Residence--]]]," ",S[1000037--[[Name--]]])},
    {"residence_pos",Concat(S[4809--[[Residence--]]]," ",S[302535920001237--[[Position--]]])},
    {"residence_dome",Concat(S[4809--[[Residence--]]]," ",S[1234--[[Dome--]]])},
    {"workplace_name",Concat(S[4801--[[Workplace--]]]," ",S[1000037--[[Name--]]])},
    {"workplace_pos",Concat(S[4801--[[Workplace--]]]," ",S[302535920001237--[[Position--]]])},
    {"workplace_dome",Concat(S[4801--[[Workplace--]]]," ",S[1234--[[Dome--]]])},
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
    local colonists = UICity.labels.Colonist or ""

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
    ChoGGi.ComFuncs.SettingState(tostring(_G[name]),trans_id),
    1000113--[[Debug--]]
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
    MeasureTool.OnLButtonDown(GetTerrainCursor())
  else
    MeasureTool.object:delete()
    MeasureTool.enabled = false
  end
end

function ChoGGi.MenuFuncs.ReloadLua()
  ReloadLua()
  WaitDelayedLoadEntities()
  ReloadClassEntities()
  MsgPopup(
    302535920000453--[[Reload Lua--]],
    1000113--[[Debug--]]
  )
end

function ChoGGi.MenuFuncs.DeleteAllSelectedObjects(obj)
  local ChoGGi = ChoGGi
  obj = obj or ChoGGi.CodeFuncs.SelObject()

  local function CallBackFunc(answer)
    if answer then
      CreateRealTimeThread(function()
        ForEach{
          class = obj.class,
          area = "realm",
          exec = function(o)
            ChoGGi.CodeFuncs.DeleteObject(o)
          end,
        }
      end)
    end
  end

  local count = CountObjects{class = obj.class,area = "realm"}
  local name = RetName(obj)
  ChoGGi.ComFuncs.QuestionBox(
    Concat(S[6779--[[Warning--]]],"!\n",S[302535920000852--[[This will delete all %s of %s--]]]:format(count,name),"\n\n",S[302535920000854--[[Takes about thirty seconds for 12 000 objects.--]]]),
    CallBackFunc,
    Concat(S[6779--[[Warning--]]],": ",S[302535920000855--[[Last chance before deletion!--]]]),
    S[302535920000856--[[Yes, I want to delete all: %s--]]]:format(name),
    302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."--]]
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

local function AnimDebug_Show(obj,colour)
  local text = PlaceObject("Text")
  text:SetColor(colour or ChoGGi.CodeFuncs.RandomColour())
  text:SetFontId(UIL_GetFontID(Concat(ChoGGi.font,", 14, bold, aa")))
  text:SetCenter(true)
  local orient = Orientation:new()

  text.ChoGGi_AnimDebug = true
  obj:Attach(text, 0)
  obj:Attach(orient, 0)
  text:SetAttachOffset(point(0,0,obj:GetObjectBBox():sizez() + 100))
  CreateGameTimeThread(function()
    while IsValid(text) do
      local str = "%d. %s\n"
      text:SetText(str:format(1,obj:GetAnimDebug(1)))
      WaitNextFrame()
    end
  end)
end

local function AnimDebug_ShowAll(cls)
  local objs = UICity.labels[cls] or ""
  for i = 1, #objs do
    AnimDebug_Show(objs[i])
  end
end

local function AnimDebug_Hide(obj)
  local att = obj:IsKindOf("ComponentAttach") and obj:GetAttaches() or ""
  for i = 1, #att do
    if att[i].ChoGGi_AnimDebug then
      att[i]:delete()
    end
  end
end

local function AnimDebug_HideAll(cls)
  local objs = UICity.labels[cls] or ""
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
  local Table = sel:GetStates() or empty_table

  for Key,State in pairs(Table) do
    ItemList[#ItemList+1] = {
      text = Concat(S[1000037--[[Name--]]],": ",State," ",S[302535920000858--[[Idx--]]],": ",Key),
      value = State,
    }
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    sel:SetStateText(value)
    MsgPopup(
      ChoGGi.ComFuncs.SettingState(choice[1].text,3722--[[State--]]),
      302535920000859--[[Anim State--]]
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000860--[[Set Anim State--]],
    hint = S[302535920000861--[[Current State: %s--]]]:format(sel:GetState()),
  }
end

--no sense in building the list more then once (it's a big list)
local ObjectSpawner_ItemList = {}
function ChoGGi.MenuFuncs.ObjectSpawner()
  local ChoGGi = ChoGGi
  local EntityData = EntityData or empty_table
  if #ObjectSpawner_ItemList == 0 then
    for Key,_ in pairs(EntityData) do
      ObjectSpawner_ItemList[#ObjectSpawner_ItemList+1] = {
        text = Key,
        value = Key
      }
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if g_Classes[value] then

      local NewObj = PlaceObj(value,{"Pos",ChoGGi.CodeFuncs.CursorNearestHex()})
--~       NewObj.__parents[#NewObj.__parents] = "Building"
      NewObj.__parents[#NewObj.__parents] = "InfopanelObj"
      NewObj.ip_template = "ipEverything"
      NewObj.ChoGGi_Spawned = true
      NewObj:GetEnumFlags(const.efSelectable)

      --so we know something is selected
      NewObj.OnSelected = function()
        SelectionArrowAdd(NewObj)
      end

      ObjModified(NewObj)
      -- be nice to populate with default values, but causes issues
      --[[
      local props = NewObj:GetProperties()
      for i = 1, #props do
        NewObj:SetProperty(props[i].id, NewObj:GetDefaultPropertyValue(props[i].id, props[i]))
      end
      --]]

      MsgPopup(
        Concat(choice[1].text,": ",S[302535920000014--[[Spawned--]]]," ",S[298035641454--[[Object--]]]),
        302535920000014--[[Spawned--]]
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ObjectSpawner_ItemList,
    title = 302535920000862--[[Object Spawner (EntityData list)--]],
    hint = Concat(S[6779--[[Warning--]]],": ",S[302535920000863--[[Objects are unselectable with mouse cursor (hover mouse over and use Delete Object).--]]]),
  }
end

function ChoGGi.MenuFuncs.ShowSelectionEditor()
  local terminal = terminal
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
  dlg:SetPos(terminal_GetMousePos())

  --OpenDialog("ObjectsStatsDlg",nil,terminal.desktop)
end

function ChoGGi.MenuFuncs.Editor_Toggle()
  local Platform = Platform

--~   if type(UpdateMapRevision) ~= "function" then
--~     function UpdateMapRevision() end
--~   end

  Platform.editor = true
  Platform.developer = true

  --keep menu opened if visible
--~   local showmenu
--~   if dlgUAMenu then
--~     showmenu = true
--~   end

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
--~     if showmenu then
--~       UAMenu.ToggleOpen()
--~     end
  end

end

do --hex rings
  local build_grid_debug_range = 10
  local opacity = 15
  local build_grid_debug_objs = false
  local build_grid_debug_thread = false

  function ChoGGi.MenuFuncs.debug_build_grid(iType)
    local g_Classes = g_Classes
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
          build_grid_debug_objs[i]:delete()
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
  local randcolours = {}
  local colourcount = 0
  local dupewppos = {}
  --default height of waypoints (maybe flag_height isn't the best name as no more flags)
  local flag_height = 50

  local function ShowWaypoints(waypoints, colour, obj, skipheight)
    colour = tonumber(colour) or ChoGGi.CodeFuncs.RandomColour()
    --also used for line height
    if not skipheight then
      flag_height = flag_height + 4
    end
    local height = flag_height
    local Objpos = obj:GetVisualPos()
    local Objterr = terrain_GetHeight(Objpos)
    local Objheight = obj:GetObjectBBox():sizez() / 2
    local shuttle
    if obj.class == "CargoShuttle" then
      shuttle = obj:GetPos():z()
    end
    --some objects don't have pos as waypoint
    if waypoints[#waypoints] ~= Objpos then
      waypoints[#waypoints+1] = Objpos
    end

    --build a list of points that aren't high in the sky
    local points = {}
    local mapw, maph = terrain_GetMapSize()
    for i = 1, #waypoints do
      local x, y, z = waypoints[i]:xy()
      x = Clamp(x, 0, mapw - terrain_HeightTileSize)
      y = Clamp(y, 0, maph - terrain_HeightTileSize)
      z = terrain_GetHeight(x, y) + (shuttle and shuttle - Objterr or Objheight) + height --shuttle z always puts it too high?
      points[#points + 1] = point(x, y, z)
    end
    local last_pos = points[#points]
    --and spawn the line
    local spawnline = Polyline:new{max_vertices = #waypoints}
    spawnline:SetMesh(points, colour)
    spawnline:SetPos(last_pos)
    spawnline.ChoGGi_WaypointPath = true

    obj.ChoGGi_Stored_Waypoints[#obj.ChoGGi_Stored_Waypoints+1] = spawnline
  end --end of ShowWaypoints

  function ChoGGi.MenuFuncs.SetWaypoint(obj,setcolour,skipheight)
    local path

    --we need to build a path for shuttles (and figure out a way to get their dest properly...)
    if obj.class == "CargoShuttle" then

      path = {}
      --going to pickup colonist
      if obj.command == "GoHome" then
        path[1] = obj.hub:GetPos()
      elseif obj.command == "Transport" then
        -- 2 is pickup loc, 3 is drop off
        path[1] = (obj.transport_task[2] and obj.transport_task[2]:GetBuilding():GetPos()) or (obj.transport_task[3] and obj.transport_task[3]:GetBuilding():GetPos())
      elseif obj.is_colonist_transport_task then
        path[1] = obj.transport_task.dest_pos or obj.transport_task.colonist:GetPos()
      else
        path[1] = obj:GetDestination()
      end

      --the next four points it's going to
      local Table = obj.next_spline
      if Table then
        -- :GetPath() has them backwards so we'll do the same
        for i = #Table, 1, -1 do
          path[#path+1] = Table[i]
        end
      end

      Table = obj.current_spline
      if Table then
        for i = #Table, 1, -1 do
          path[#path+1] = Table[i]
        end
      end
      path[#path+1] = obj:GetPos()

    else
      -- rovers/drones/colonists
      if not pcall(function()
        path = type(obj.GetPath) == "function" and obj:GetPath()
      end) then
        OpenExamine(obj)
        print(Concat(S[6779--[[Warning--]]],": ",S[302535920000869--[[This %s doesn't have GetPath function, something is probably borked.--]]]:format(RetName(obj))))
      end
    end

    -- we have a path so add some colours, and build the waypoints
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

      if type(obj.ChoGGi_Stored_Waypoints) ~= "table" then
        obj.ChoGGi_Stored_Waypoints = {}
      end

      if not obj.ChoGGi_WaypointPathAdded then
        --used to reset the colour later on
        obj.ChoGGi_WaypointPathAdded = obj:GetColorModifier()
      end
      --colour it up
      obj:SetColorModifier(colour)
      --send path off to make wp
      ShowWaypoints(
        path,
        colour,
        obj,
        skipheight
      )
    end
  end

  function ChoGGi.MenuFuncs.SetPathMarkersGameTime(obj,single)
    local ChoGGi = ChoGGi
    obj = obj or ChoGGi.CodeFuncs.SelObject()

    if obj and obj:IsKindOfClasses("Movable", "CargoShuttle") then
      if not ChoGGi.Temp.UnitPathingHandles then
        ChoGGi.Temp.UnitPathingHandles = {}
      end

      if ChoGGi.Temp.UnitPathingHandles[obj.handle] then
        --already exists so remove thread
        ChoGGi.Temp.UnitPathingHandles[obj.handle] = nil
      elseif IsValid(obj) and (type(obj.GetPath) == "function" or obj.class == "CargoShuttle") then

        --continous loooop of object for pathing it
        ChoGGi.Temp.UnitPathingHandles[obj.handle] = CreateGameTimeThread(function()
          local colour = ChoGGi.CodeFuncs.RandomColour()
          if type(obj.ChoGGi_Stored_Waypoints) ~= "table" then
            obj.ChoGGi_Stored_Waypoints = {}
          end

          local sleepidx = 0
          repeat
            --shuttles don't have paths
            if obj.class ~= "CargoShuttle" and not obj:GetPath() then
              Sleep(500)
              sleepidx = sleepidx + 1
              if sleepidx == 250 then
                DeleteThread(ChoGGi.Temp.UnitPathingHandles[obj.handle])
              end
            end
            sleepidx = 0

            ChoGGi.MenuFuncs.SetWaypoint(obj,colour,true)
            Sleep(750)

            --remove old wps
            if type(obj.ChoGGi_Stored_Waypoints) == "table" then
              for i = #obj.ChoGGi_Stored_Waypoints, 1, -1 do
                obj.ChoGGi_Stored_Waypoints[i]:delete()
              end
            end
            obj.ChoGGi_Stored_Waypoints = {}

            --break thread when obj isn't valid
            if not IsValid(obj) or not obj:IsValidPos() then
              ChoGGi.Temp.UnitPathingHandles[obj.handle] = nil
            end
          until not ChoGGi.Temp.UnitPathingHandles[obj.handle]
        end)

      end
    elseif single then
      MsgPopup(
        302535920000871--[[Doesn't seem to be an object that moves.--]],
        302535920000872--[[Pathing--]],
        nil,
        nil,
        obj
      )
    end
  end

  local function RemoveWPDupePos(Class,obj)
    --remove dupe pos
    if type(obj.ChoGGi_Stored_Waypoints) == "table" then
      for i = 1, #obj.ChoGGi_Stored_Waypoints do
        local wp = obj.ChoGGi_Stored_Waypoints[i]
        if wp.class == Class then
          local pos = tostring(wp:GetPos())
          if dupewppos[pos] then
            dupewppos[pos]:SetColorModifier(6579300)
            wp:delete()
          else
            dupewppos[pos] = obj.ChoGGi_Stored_Waypoints[i]
          end
        end
      end
      --remove removed
      for i = #obj.ChoGGi_Stored_Waypoints, 1, -1 do
        if not IsValid(obj.ChoGGi_Stored_Waypoints[i]) then
          table.remove(obj.ChoGGi_Stored_Waypoints,i)
        end
      end
    end
  end

  local function ClearColourAndWP(cls)
    local ChoGGi = ChoGGi
    --remove all thread refs so they stop
    ChoGGi.Temp.UnitPathingHandles = {}
    --and waypoints/colour
    local objs = UICity.labels[cls] or ""
    for i = 1, #objs do

      if objs[i].ChoGGi_WaypointPathAdded then
        objs[i]:SetColorModifier(objs[i].ChoGGi_WaypointPathAdded)
        objs[i].ChoGGi_WaypointPathAdded = nil
      end

      if type(objs[i].ChoGGi_Stored_Waypoints) == "table" then
        for j = #objs[i].ChoGGi_Stored_Waypoints, 1, -1 do
          objs[i].ChoGGi_Stored_Waypoints[j]:delete()
        end
        objs[i].ChoGGi_Stored_Waypoints = nil
      end

    end
  end

  function ChoGGi.MenuFuncs.SetPathMarkersVisible()
    local ChoGGi = ChoGGi
    local sel = SelectedObj
    if sel then
      randcolours = ChoGGi.CodeFuncs.RandomColour(#randcolours + 1)
      ChoGGi.MenuFuncs.SetWaypoint(sel)
      return
    end

    local ItemList = {
      {text = S[4493--[[All--]]],value = "All"},
      {text = S[547--[[Colonists--]]],value = "Colonist"},
      {text = S[517--[[Drones--]]],value = "Drone"},
      {text = S[5438--[[Rovers--]]],value = "BaseRover"},
      {text = S[745--[[Shuttles--]]],value = "CargoShuttle",hint = 302535920000873--[[Doesn't work that well.--]]},
    }

    local function CallBackFunc(choice)
      local value = choice[1].value
      if not value then
        return
      end
      local UICity = UICity
      -- remove wp/lines and reset colours
      if choice[1].check1 then
        print("check1_hint")

        -- reset all the base colours/waypoints
        ClearColourAndWP("CargoShuttle")
        ClearColourAndWP("Unit")
        ClearColourAndWP("Colonist")

        -- check for any extra lines
        ForEach{
          class = "Polyline",
          area = "realm",
          exec = function(o)
            if o.ChoGGi_WaypointPath then
              o:delete()
            end
          end,
        }

        -- reset stuff
        flag_height = 50
        randcolours = {}
        colourcount = 0
        dupewppos = {}

      elseif value then -- add waypoints

        local function swp(list)
          if choice[1].check2 then
            for i = 1, #list do
              ChoGGi.MenuFuncs.SetPathMarkersGameTime(list[i])
            end
          else
            for i = 1, #list do
              ChoGGi.MenuFuncs.SetWaypoint(list[i])
            end
          end
        end

        if value == "All" then
          local table1 = ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Unit or "","IsValid",nil,true)
          local table2 = ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.CargoShuttle or "","IsValid",nil,true)
          local table3 = ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Colonist or "","IsValid",nil,true)
          colourcount = colourcount + #table1
          colourcount = colourcount + #table2
          colourcount = colourcount + #table3
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(table1)
          swp(table2)
          swp(table3)
        else
          local table1 = GetObjects{
            area = "",
            class = value,
            filter = function(o)
              if IsValid(o) then
                return o
              end
            end,
          }
          colourcount = colourcount + #table1
          randcolours = ChoGGi.CodeFuncs.RandomColour(colourcount + 1)
          swp(table1)
        end

        --remove any waypoints in the same pos
        local function ClearAllDupeWP(cls)
          local objs = UICity.labels[cls] or ""
          for i = 1, #objs do
            if objs[i] and objs[i].ChoGGi_Stored_Waypoints then
              RemoveWPDupePos("WayPoint",objs[i])
              RemoveWPDupePos("Sphere",objs[i])
            end
          end
        end
        ClearAllDupeWP("CargoShuttle")
        ClearAllDupeWP("Unit")
        ClearAllDupeWP("Colonist")

      end
    end

    ChoGGi.ComFuncs.OpenInListChoice{
      callback = CallBackFunc,
      items = ItemList,
      title = 302535920000467--[[Path Markers--]],
      check1 = 302535920000876--[[Remove Waypoints--]],
      check1_hint = 302535920000877--[[Remove waypoints from the map and reset colours.--]],
      check2 = 4099--[[Game Time--]],
      check2_hint = Concat(S[302535920000462--[[Maps paths in real time--]]],"."),
      check2_checked = true,
    }
  end
end

--little bit of painting
--~ local terrain_type = "Grass_01"
--~ local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
--~ CreateRealTimeThread(function()
--~   while true do
--~     terrain.SetTypeCircle(GetTerrainCursor(), 2500, terrain_type_idx)
--~     Sleep(5)
--~   end
--~ end)
