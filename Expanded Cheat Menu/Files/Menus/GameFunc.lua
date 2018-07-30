--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local S = ChoGGi.Strings
local default_icon = "UI/Icons/Anomaly_Event.tga"

local print,type,tostring = print,type,tostring

local cls = cls
local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local engineHideMouseCursor = engineHideMouseCursor
local engineShowMouseCursor = engineShowMouseCursor
local GetInGameInterface = GetInGameInterface
local GetObjects = GetObjects
local GetTerrainCursor = GetTerrainCursor
local HideMouseCursor = HideMouseCursor
local IsMouseCursorHidden = IsMouseCursorHidden
local point = point
local PropToLuaCode = PropToLuaCode
local RecalcBuildableGrid = RecalcBuildableGrid
local SaveLocalStorage = SaveLocalStorage
local SetLightmodel = SetLightmodel
local SetLightmodelOverride = SetLightmodelOverride
local SetMouseDeltaMode = SetMouseDeltaMode
local ShowMouseCursor = ShowMouseCursor
local Sleep = Sleep
--change map funcs
local ClassDescendantsList = ClassDescendantsList
local CloseMenuDialogs = CloseMenuDialogs
local CreateMapSettingsDialog = CreateMapSettingsDialog
local FillRandomMapProps = FillRandomMapProps
local GenerateRandomMapParams = GenerateRandomMapParams
local GenerateRocketCargo = GenerateRocketCargo
local GetMapName = GetMapName
local GetModifiedProperties = GetModifiedProperties
local InitNewGameMissionParams = InitNewGameMissionParams
local ListMaps = ListMaps
local OpenExamineRet = OpenExamineRet

local camera_GetFovX = camera.GetFovX
local camera_SetFovX = camera.SetFovX
local camera3p_Activate = camera3p.Activate
local camera3p_AttachObject = camera3p.AttachObject
local camera3p_DetachObject = camera3p.DetachObject
local camera3p_EnableMouseControl = camera3p.EnableMouseControl
local camera3p_IsActive = camera3p.IsActive
local camera3p_SetEyeOffset = camera3p.SetEyeOffset
local camera3p_SetLookAtOffset = camera3p.SetLookAtOffset
local cameraFly_Activate = cameraFly.Activate
local cameraFly_IsActive = cameraFly.IsActive
local cameraRTS_Activate = cameraRTS.Activate
local cameraRTS_SetZoom = cameraRTS.SetZoom
local terrain_GetHeight = terrain.GetHeight
local terrain_SetHeightCircle = terrain.SetHeightCircle
local terrain_SetTerrainType = terrain.SetTerrainType
local UAMenu_UpdateUAMenu = UAMenu.UpdateUAMenu
local UserActions_AddActions = UserActions.AddActions
local UserActions_GetActiveActions = UserActions.GetActiveActions

local white = white
local guic = guic

local function DeleteAllRocks(rock_cls)
  local objs = GetObjects{class = rock_cls}
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
    Concat(S[6779--[[Warning--]]],"!\n",S[302535920001238--[[Removes any rocks for that smooth map feel (will take about 30 seconds).--]]]),
    CallBackFunc,
    Concat(S[6779--[[Warning--]]],": ",S[302535920000855--[[Last chance before deletion!--]]])
  )
end

function ChoGGi.MenuFuncs.DisableTextureCompression_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DisableTextureCompression = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DisableTextureCompression)
  hr.TR_ToggleTextureCompression = 1

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisableTextureCompression,302535920000641--[[Texture Compression--]]),
    302535920001015--[[Video--]]
  )
end

do --FlattenGround

  -- we also save the height offset of all the rocks if user wants to change that as well (optionally as it takes awhile)

  -- some rocks are Deposition as well as WasteRockObstructor, and we don't want dupes
  -- rocks don't have handles, so we use their position to build a table of no dupes
  local positions = {}
  local function SaveRocks(rock_cls,rock_objects)
    local objs = GetObjects{class = rock_cls}
    for i = 1, #objs do
      local pos = objs[i]:GetVisualPos()
      if not positions[pos] then
        local terrain_height = terrain_GetHeight(pos)
        rock_objects[#rock_objects+1] = {
          obj = objs[i],
          pos = point(pos:x(),pos:y()),
          height_t = terrain_height,
          offset = terrain_height - pos:z(),
        }
        positions[pos] = true
      end
    end
  end
  local function UpdateRockList()
    rock_objects = {}
    SaveRocks("Deposition",rock_objects)
    SaveRocks("WasteRockObstructorSmall",rock_objects)
    SaveRocks("WasteRockObstructor",rock_objects)
    UICity.ChoGGi.map_rock_objects = rock_objects
  end

  function ChoGGi.MenuFuncs.SaveRockHeight()
    local rock_objects = UICity.ChoGGi.map_rock_objects
    -- make a list of rocks to henceforth be a reference
    if not rock_objects then
      UpdateRockList()
    end
  end

  function ChoGGi.MenuFuncs.MoveRocksToGround()
    local rock_objects = UICity.ChoGGi.map_rock_objects
    if not rock_objects then
      UpdateRockList()
    end
    for i = 1, #rock_objects do

if i == 500 then
  break
end

      local r = rock_objects[i]
      r.obj:SetPos(r.pos:SetZ(terrain_GetHeight(r.pos) + r.offset))
    end
  end


  local are_we_flattening
  local visual_circle
  local flatten_height
  local size
  local radius

  local remove_actions = {
    "FlattenGround_RaiseHeight",
    "FlattenGround_LowerHeight",
    "FlattenGround_WidenRadius",
    "FlattenGround_ShrinkRadius",
  }

  local temp_height
  local function ToggleHotkeys(bool)
    if bool then
      local us = ChoGGi.UserSettings
      UserActions_AddActions({
        FlattenGround_RaiseHeight = {
          key = "Shift-Up",
          action = function()
            temp_height = flatten_height + us.FlattenGround_HeightDiff or 100
            --guess i found the ceiling limit
            if temp_height > 65535 then
              temp_height = 65535
            end
            flatten_height = temp_height
          end
        },
        FlattenGround_LowerHeight = {
          key = "Shift-Down",
          action = function()
            temp_height = flatten_height - (us.FlattenGround_HeightDiff or 100)
            --and the floor limit (oh look 0 go figure)
            if temp_height < 0 then
              temp_height = 0
            end
            flatten_height = temp_height
          end
        },
        FlattenGround_WidenRadius = {
          key = "Shift-Right",
          action = function()
            us.FlattenGround_Radius = (us.FlattenGround_Radius or 2500) + (us.FlattenGround_RadiusDiff or 100)
            size = us.FlattenGround_Radius
            visual_circle:SetRadius(size)
            radius = size * guic
          end
        },
        FlattenGround_ShrinkRadius = {
          key = "Shift-Left",
          action = function()
            us.FlattenGround_Radius = (us.FlattenGround_Radius or 2500) - (us.FlattenGround_RadiusDiff or 100)
            size = us.FlattenGround_Radius
            visual_circle:SetRadius(size)
            radius = size * guic
          end
        },
      })
    else
      local UserActions = UserActions
      for i = 1, #remove_actions do
        UserActions.Actions[remove_actions[i]] = nil
      end
    end

    UAMenu_UpdateUAMenu(UserActions_GetActiveActions())
  end

  local function ToggleCollisions(objs)
    local ChoGGi = ChoGGi
    for i = 1, #objs do
      ChoGGi.CodeFuncs.CollisionsObject_Toggle(objs[i],true)
    end
  end

  function ChoGGi.MenuFuncs.FlattenTerrain_Toggle(square)

if ChoGGi.Test then
    -- make a list of rocks to henceforth be a reference
    if not UICity.ChoGGi.map_rock_objects then
      UpdateRockList()
    end
end

    if are_we_flattening then
      -- disable shift-arrow keys
      ToggleHotkeys()
      DeleteThread(are_we_flattening)
      are_we_flattening = false
      visual_circle:delete()
      -- update saved settings
      ChoGGi.SettingFuncs.WriteSettings()

      MsgPopup(
        302535920001164--[[Flattening has been stopped, now updating buildable.--]],
        904--[[Terrain--]],
        "UI/Icons/Sections/WasteRock_1.tga"
      )
      -- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
      local objs = GetObjects{class = "LifeSupportGridElement"}
      ToggleCollisions(objs)
      -- update uneven terrain checker thingy
      RecalcBuildableGrid()
      -- and back on when we're done
      ToggleCollisions(objs)

    else
      -- have to set it here after settings are loaded or it'll be default radius till user adjusts it
      size = ChoGGi.UserSettings.FlattenGround_Radius or 2500
      radius = size * guic

      ToggleHotkeys(true)
      flatten_height = terrain_GetHeight(GetTerrainCursor())
      MsgPopup(
        S[302535920001163--[[Flatten height has been choosen %s, press shortcut again to update buildable.--]]]:format(flatten_height),
        904--[[Terrain--]],
        "UI/Icons/Sections/warning.tga"
      )
--~ local terrain_type_idx = table.find(TerrainTextures, "name", "Grass_01")
      visual_circle = Circle:new()
      visual_circle:SetRadius(size)
      visual_circle:SetColor(white)

      are_we_flattening = CreateRealTimeThread(function()
        -- thread gets deleted, but just in case
        while are_we_flattening do
          local cursor = GetTerrainCursor()
          visual_circle:SetPos(cursor)
          local outer
          if square == true then
            outer = radius / 2
          end
          terrain_SetHeightCircle(cursor, radius, outer or radius, flatten_height)
--~ terrain.SetTypeCircle(cursor, radius, terrain_type_idx)
          --used to set terrain type (see above)
          Sleep(10)
        end
      end)
    end
  end

end

-- we'll get more concrete one of these days
local terrain_type = "Regolith"		-- applied terrain type
local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
terrain.SetTypeCircle(c(), 5000, terrain_type_idx)

function ChoGGi.MenuFuncs.ChangeMap()
  local g_Classes = g_Classes
  local str_hint_rules = S[302535920000803--[[For rules separate with spaces: Hunger ColonyPrefab (or leave blank for none).--]]]
  local NewMissionParams = {}

  --open a list dialog to set g_CurrentMissionParams
  local ItemList = {
    {text = S[3474--[[Mission Sponsor--]]],value = "IMM"},
    {text = S[3478--[[Commander Profile--]]],value = "rocketscientist"},
    {text = S[3486--[[Mystery--]]],value = "random"},
    {text = S[8800--[[Game Rules--]]],value = "",hint = str_hint_rules},
  }

  local CallBackFunc = function(choice)
    if type(choice) ~= "table" then
      return
    end
    for i = 1, #choice do
      local text = choice[i].text
      local value = choice[i].value

      if text == S[3474--[[Mission Sponsor--]]] then
        NewMissionParams.idMissionSponsor = value
      elseif text == S[3478--[[Commander Profile--]]] then
        NewMissionParams.idCommanderProfile = value
      elseif text == S[3486--[[Mystery--]]] then
        NewMissionParams.idMystery = value
      elseif text == S[8800--[[Game Rules--]]] then
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

  local dlg_list = ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000866--[[Set MissionParams NewMap--]],
    hint = Concat(S[302535920000867--[["Attention: You must press ""OK"" for these settings to take effect before choosing a map!

See the examine list on the left for ids."--]]],"\n\n",str_hint_rules),
    custom_type = 4,
  }

  --shows the mission params for people to look at
  local ex = OpenExamineRet(MissionParams)

  --map list dialog
  CreateRealTimeThread(function()
    local caption = S[302535920000868--[[Choose map with settings presets:--]]]
    local maps = ListMaps()
    local items = {}
    for i = 1, #maps do
      if not maps[i]:lower():find("^prefab") and not maps[i]:find("^__") then
        items[#items+1] = {
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

    -- close dialogs we opened
    dlg_list:delete()
    ex:delete()

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

function ChoGGi.MenuFuncs.AutosavePeriod()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.AutosavePeriod
  local UserSettings = ChoGGi.UserSettings
  local title = Concat(S[3591--[[Autosave--]]]," ",S[302535920001201--[[Interval--]]])
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 1,value = 1},
    {text = 3,value = 3},
    {text = 10,value = 10},
    {text = 15,value = 15},
  }

  --other hint type
  local hint = DefaultSetting
  if UserSettings.AutosavePeriod then
    hint = UserSettings.AutosavePeriod
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then

      --update const it checks
      const.AutosavePeriod = value
      --and update current countdown
      g_NextAutosaveSol = UICity.day + value

      if value == DefaultSetting then
        UserSettings.AutosavePeriod = nil
      else
        UserSettings.AutosavePeriod = value
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
        title
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = title,
    hint = Concat("Current: ",hint),
  }
end

function ChoGGi.MenuFuncs.PulsatingPins_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DisablePulsatingPinsMotion = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DisablePulsatingPinsMotion)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisablePulsatingPinsMotion,302535920000265--[[Pulsating Pins--]]),
    302535920001092--[[Pins--]]
  )
end

function ChoGGi.MenuFuncs.ChangeTerrainType()
  local ItemList = {}
  local Table = DepositionTypes
  for i = 1, #Table do
    ItemList[#ItemList+1] = {
      text = Table[i]:gsub("_mesh.mtl",""):gsub("Terrain",""),
      value = i,
    }
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      terrain_SetTerrainType({type = value})

      MsgPopup(
        ChoGGi.ComFuncs.SettingState(choice[1].text,904--[[Terrain--]]),
        904--[[Terrain--]]
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000973--[[Change Terrain Texture--]],
    hint = S[302535920000974--[[Map default: %s--]]]:format(mapdata.BaseLayer),
  }
end

--add button to import model
function ChoGGi.MenuFuncs.ChangeLightmodelCustom(Name)
  local ItemList = {}

  --always load defaults, then override with custom settings so list is always full
  local def = Lightmodel:GetProperties()
  local help_str = S[487939677892--[[Help--]]]
  local default_str = S[1000121--[[Default--]]]
  local min_str = S[302535920000110--[[Min--]]]
  local max_str = S[302535920000941--[[Max--]]]
  local scale_str = S[1000081--[[Scale--]]]
  for i = 1, #def do
    if def[i].editor ~= "image" and def[i].editor ~= "dropdownlist" and def[i].editor ~= "combo" and type(def[i].value) ~= "userdata" then
      ItemList[#ItemList+1] = {
        text = Concat(def[i].editor == "color" and "<color 175 175 255>",def[i].id,"</color>" or def[i].id),
        sort = def[i].id,
        value = def[i].default,
        default = def[i].default,
        editor = def[i].editor,
        hint = Concat("",(def[i].name or ""),"\n",help_str,": ",(def[i].help or ""),"\n\n",default_str,": ",(tostring(def[i].default) or "")," ",min_str,": ",(def[i].min or "")," ",max_str,": ",(def[i].max or "")," ",scale_str,": ",(def[i].scale or "")),
      }
    end
  end

  --custom settings
  local cus = ChoGGi.Temp.LightmodelCustom
  --or loading style from presets
  if type(Name) == "string" then
    cus = DataInstances.Lightmodel[Name]
  end
  for i = 1, #ItemList do
    if cus[ItemList[i].sort] then
      ItemList[i].value = cus[ItemList[i].sort]
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local model_table = {}
    for i = 1, #choice do
      local value = choice[i].value
      if value ~= choice[i].default then
        model_table[#model_table+1] = {
          id = choice[i].sort,
          value = value,
        }
      end
    end

    --save the custom lightmodel
    local lm = ChoGGi.CodeFuncs.LightmodelBuild(model_table)
    lm.name = "ChoGGi_Custom"
    ChoGGi.UserSettings.LightmodelCustom = PropToLuaCode(lm)
    if choice[1].check1 then
      SetLightmodelOverride(1,"ChoGGi_Custom")
    else
      SetLightmodel(1,"ChoGGi_Custom")
    end

    ChoGGi.SettingFuncs.WriteSettings()
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    sortby = "sort",
    title = 302535920000975--[[Custom Lightmodel--]],
    hint = 302535920000976--[[Use double right click to test without closing dialog\n\nSome settings can't be changed in the editor, but you can manually add them in the settings file (type ex(DataInstances.Lightmodel) and use dump obj).--]],
    check1 = 302535920000977--[[Semi-Permanent--]],
    check1_hint = 302535920000978--[[Make it stay at selected light model till reboot (use Misc>Change Light Model for Permanent).--]],
    check2 = 302535920000979--[[Presets--]],
    check2_hint = 302535920000980--[[Opens up the list of premade styles so you can start with the settings from one.--]],
    custom_type = 5,
  }
end

function ChoGGi.MenuFuncs.ChangeLightmodel(Mode)
  --if it gets opened by menu then has object so easy way to do this
  local Browse
  if Mode == true then
    Browse = Mode
  end

  local ItemList = {}
  if not Browse then
    ItemList[#ItemList+1] = {
      text = Concat(" ",S[1000121--[[Default--]]]),
      value = "ChoGGi_Default",
      hint = 302535920000981--[[Choose to this remove Permanent setting.--]],
    }
    ItemList[#ItemList+1] = {
      text = Concat(" ",S[302535920000982--[[Custom--]]]),
      value = "ChoGGi_Custom",
      hint = 302535920000983--[["Custom Lightmodel made with ""Change Light Model Custom""."--]],
    }
  end
  local Table = DataInstances.Lightmodel
  for i = 1, #Table do
    ItemList[#ItemList+1] = {
      text = Table[i].name,
      value = Table[i].name,
      func = Table[i].name,
    }
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "string" then
      if Browse or choice[1].check2 then
        ChoGGi.MenuFuncs.ChangeLightmodelCustom(value)
      else
        if value == "ChoGGi_Default" then
          ChoGGi.UserSettings.Lightmodel = nil
          SetLightmodelOverride(1)
        else
          if choice[1].check1 then
            ChoGGi.UserSettings.Lightmodel = value
            SetLightmodelOverride(1,value)
          else
            SetLightmodelOverride(1)
            SetLightmodel(1,value)
          end
        end

        ChoGGi.SettingFuncs.WriteSettings()
        MsgPopup(
          ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
          302535920000984--[[Lighting--]]
        )
      end
    end
  end

  local hint = {}
  local check1
  local check1_hint
  local check2
  local check2_hint
  local title = 302535920000985--[[Select Lightmodel Preset--]]
  if not Browse then
    title = 302535920000986--[[Change Lightmodel--]]
    hint[#hint+1] = S[302535920000987--[[If you used Permanent; you must choose default to remove the setting (or it'll set the lightmodel next time you start the game).--]]]
    local lightmodel = ChoGGi.UserSettings.Lightmodel
    if lightmodel then
      hint[#hint+1] = "\n\n"
      hint[#hint+1] = S[302535920000988--[[Permanent--]]]
      hint[#hint+1] = ": "
      hint[#hint+1] = lightmodel
    end
    check1 = 302535920000988--[[Permanent--]]
    check1_hint = 302535920000989--[[Make it stay at selected light model all the time (including reboots).--]]
    check2 = 327465361219--[[Edit--]]
    check2_hint = 302535920000990--[[Open this style in "Change Light Model Custom".--]]
  end

  hint[#hint+1] = "\n\n"
  hint[#hint+1] = S[302535920000991--[[Double right-click to preview lightmodel without closing dialog.--]]]
  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = title,
    hint = Concat(hint),
    check1 = check1,
    check1_hint = check1_hint,
    check2 = check2,
    check2_hint = check2_hint,
    custom_type = 6,
    custom_func = function(value)
      SetLightmodel(1,value)
    end,
  }
end

function ChoGGi.MenuFuncs.TransparencyUI_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.TransparencyToggle = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.TransparencyToggle)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.TransparencyToggle,302535920000629--[[UI Transparency--]]),
    1608--[[Transparency--]]
  )
end

function ChoGGi.MenuFuncs.SetTransparencyUI()
  local desk = terminal.desktop
  local igi = GetInGameInterface()
  --sets or gets transparency based on iWhich
  local function trans(iType,sName,iWhich)
    local name = ChoGGi.UserSettings.Transparency[sName]
    if not iWhich and name then
      return name
    end

    local uilist
    if iType == 1 then
      uilist = desk
    else
      if not igi or not igi:GetVisible() then
        return 0
      end
      uilist = igi
    end
    for i = 1, #uilist do
      local ui = uilist[i]
      if ui.class == sName then
        if iWhich then
          ui:SetTransparency(iWhich)
        else
          return ui:GetTransparency()
        end
      end
    end
    if not iWhich then
      --didn't find window so return 0 (fully vis)
      return 0
    end
  end

  local ItemList = {
    {text = "ConsoleLog",value = trans(1,"ConsoleLog"),hint = 302535920000994--[[Console logging text--]]},
    {text = "Console",value = trans(1,"Console"),hint = 302535920000996--[[Console text input--]]},
    {text = "UAMenu",value = trans(1,"UAMenu"),hint = 302535920000998--[[Cheat Menu: This uses 255 as visible and 0 as invisible.--]]},

    {text = "HUD",value = trans(2,"HUD"),hint = 302535920001000--[[Buttons at bottom--]]},
    {text = "XBuildMenu",value = trans(2,"XBuildMenu"),hint = 302535920000993--[[Build menu--]]},
    {text = "InfopanelDlg",value = trans(2,"InfopanelDlg"),hint = 302535920000995--[[Infopanel (selection)--]]},
    {text = "PinsDlg",value = trans(2,"PinsDlg"),hint = 302535920000997--[[Pins menu--]]},
  }
  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    for i = 1, #choice do
      local value = choice[i].value
      local text = choice[i].text

      if type(value) == "number" then

        if text == "UAMenu" or text == "Console" or text == "ConsoleLog" then
          trans(1,text,value)
        else
          trans(2,text,value)
        end

        --everything but UAMenu uses 255-0 in the opposite manner
        if value == 0 or (value == 255 and text == "UAMenu") then
          ChoGGi.UserSettings.Transparency[text] = nil
        else
          ChoGGi.UserSettings.Transparency[text] = value
        end

      end
    end

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      302535920000999--[[Transparency has been updated.--]],
      1608--[[Transparency--]]
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000629--[[Set UI Transparency--]],
    hint = 302535920001002--[[For some reason they went opposite day with this one: 255 is invisible and 0 is visible.--]],
    custom_type = 4,
  }
end

function ChoGGi.MenuFuncs.SetLightsRadius()
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = false,hint = 302535920001003--[[restart to enable--]]},
    {text = S[302535920001004--[[01 Lowest (25)--]]],value = 25},
    {text = S[302535920001005--[[02 Lower (50)--]]],value = 50},
    {text = Concat(S[302535920001006--[[03 Low (90)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 90},
    {text = Concat(S[302535920001007--[[04 Medium (95)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 95},
    {text = Concat(S[302535920001008--[[05 High (100)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 100},
    {text = S[302535920001009--[[06 Ultra (200)--]]],value = 200},
    {text = S[302535920001010--[[07 Ultra-er (400)--]]],value = 400},
    {text = S[302535920001011--[[08 Ultra-er (600)--]]],value = 600},
    {text = S[302535920001012--[[09 Ultra-er (1000)--]]],value = 1000},
    {text = S[302535920001013--[[10 Laggy (10000)--]]],value = 10000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      if value > 100000 then
        value = 100000
      end
      hr.LightsRadiusModifier = value
      ChoGGi.ComFuncs.SetSavedSetting("LightsRadius",value)
    else
      ChoGGi.UserSettings.LightsRadius = nil
    end

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000633--[[Lights Radius--]]),
      302535920001015--[[Video--]],
      default_icon
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001016--[[Set Lights Radius--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hr.LightsRadiusModifier,"\n\n",S[302535920001017--[[Turns up the radius for light bleedout, doesn't seem to hurt FPS much.--]]]),
  }
end

function ChoGGi.MenuFuncs.SetTerrainDetail()
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = false,hint = 302535920001003--[[restart to enable--]]},
    {text = S[302535920001004--[[01 Lowest (25)--]]],value = 25},
    {text = S[302535920001005--[[02 Lower (50)--]]],value = 50},
    {text = Concat(S[302535920001021--[[03 Low (100)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 100},
    {text = Concat(S[302535920001022--[[04 Medium (150)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 150},
    {text = Concat(S[302535920001008--[[05 High (100)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 100},
    {text = Concat(S[302535920001024--[[06 Ultra (200)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 200},
    {text = S[302535920001010--[[07 Ultra-er (400)--]]],value = 400},
    {text = S[302535920001011--[[08 Ultra-er (600)--]]],value = 600},
    {text = S[302535920001012--[[09 Ultraist (1000)--]]],value = 1000,hint = Concat("\n",S[302535920001018--[[Above 1000 will add a long delay to loading (and might crash).--]]])},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      if value > 1000 then
        value = 1000
      end
      hr.TR_MaxChunks = value
      ChoGGi.ComFuncs.SetSavedSetting("TerrainDetail",value)
    else
      ChoGGi.UserSettings.TerrainDetail = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000635--[[Terrain Detail--]]),
        302535920001015--[[Video--]],
        default_icon
      )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",S[302535920000635--[[Terrain Detail--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",hr.TR_MaxChunks,"\n",S[302535920001030--[["Doesn't seem to use much CPU, but load times will probably increase. I've limited max to 1000, if you've got a Nvidia Volta and want to use more memory then do it through the settings file.

And yes Medium is using a higher setting than High..."--]]]),
  }
end

function ChoGGi.MenuFuncs.SetVideoMemory()
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = false,hint = 302535920001003--[[restart to enable--]]},
    {text = S[302535920001031--[[1 Crap (32)--]]],value = 32},
    {text = S[302535920001032--[[2 Crap (64)--]]],value = 64},
    {text = S[302535920001033--[[3 Crap (128)--]]],value = 128},
    {text = Concat(S[302535920001034--[[4 Low (256)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 256},
    {text = Concat(S[302535920001035--[[5 Medium (512)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 512},
    {text = Concat(S[302535920001036--[[6 High (1024)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 1024},
    {text = Concat(S[302535920001037--[[7 Ultra (2048)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 2048},
    {text = S[302535920001038--[[8 Ultra-er (4096)--]]],value = 4096},
    {text = S[302535920001039--[[9 Ultra-er-er (8192)--]]],value = 8192},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      hr.DTM_VideoMemory = value
      ChoGGi.ComFuncs.SetSavedSetting("VideoMemory",value)
    else
      ChoGGi.UserSettings.VideoMemory = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000637--[[Video Memory--]]),
        302535920001015--[[Video--]],
        default_icon
      )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001041--[[Set Video Memory Use--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hr.DTM_VideoMemory),
  }
end

function ChoGGi.MenuFuncs.SetShadowmapSize()
  local hint_highest = Concat(S[6779--[[Warning--]]],": ",S[302535920001042--[[Highest uses vram (one gig for starter base, a couple for large base).--]]])
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = false,hint = 302535920001003--[[restart to enable--]]},
    {text = S[302535920001043--[[1 Crap (256)--]]],value = 256},
    {text = S[302535920001044--[[2 Lower (512)--]]],value = 512},
    {text = Concat(S[302535920001045--[[3 Low (1536)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 1536},
    {text = Concat(S[302535920001046--[[4 Medium (2048)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 2048},
    {text = Concat(S[302535920001047--[[5 High (4096)--]]]," < ",S[302535920001065--[[Menu Option--]]]),value = 4096},
    {text = S[302535920001048--[[6 Higher (8192)--]]],value = 8192},
    {text = S[302535920001049--[[7 Highest (16384)--]]],value = 16384,hint = hint_highest},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      if value > 16384 then
        value = 16384
      end
      hr.ShadowmapSize = value
      ChoGGi.ComFuncs.SetSavedSetting("ShadowmapSize",value)
    else
      ChoGGi.UserSettings.ShadowmapSize = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000639--[[Shadow Map--]]),
        302535920001015--[[Video--]],
        default_icon
      )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001051--[[Set Shadowmap Size--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hr.ShadowmapSize,"\n\n",hint_highest,"\n\n",S[302535920001052--[[Max limited to 16384 (or crashing).--]]]),
  }
end

function ChoGGi.MenuFuncs.HigherShadowDist_Toggle()
  ChoGGi.UserSettings.HigherShadowDist = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.HigherShadowDist)

  hr.ShadowRangeOverride = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowRangeOverride,0,1000000)
  hr.ShadowFadeOutRangePercent = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowFadeOutRangePercent,30,0)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.HigherShadowDist,302535920000645--[[Higher Shadow Distance--]]),
    302535920001015--[[Video--]],
    default_icon
  )
end

function ChoGGi.MenuFuncs.HigherRenderDist_Toggle()
  local DefaultSetting = ChoGGi.Consts.HigherRenderDist
  local hint_min = S[302535920001054--[[Minimal FPS hit on large base--]]]
  local hint_small = S[302535920001055--[[Small FPS hit on large base--]]]
  local hint_fps = S[302535920001056--[[FPS hit--]]]
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 240,value = 240,hint = hint_min},
    {text = 360,value = 360,hint = hint_min},
    {text = 480,value = 480,hint = hint_min},
    {text = 600,value = 600,hint = hint_small},
    {text = 720,value = 720,hint = hint_small},
    {text = 840,value = 840,hint = hint_fps},
    {text = 960,value = 960,hint = hint_fps},
    {text = 1080,value = 1080,hint = hint_fps},
    {text = 1200,value = 1200,hint = hint_fps},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.HigherRenderDist then
    hint = tostring(ChoGGi.UserSettings.HigherRenderDist)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      hr.LODDistanceModifier = value
      ChoGGi.ComFuncs.SetSavedSetting("HigherRenderDist",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.HigherRenderDist,302535920000643--[[Higher Render Distance--]]),
        302535920001015--[[Video--]],
        default_icon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000643--[[Higher Render Distance--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
  }
end

--CameraObj

--use hr.FarZ = 7000000 for viewing full map with 128K zoom
function ChoGGi.MenuFuncs.CameraFree_Toggle()
  --if not mapdata.GameLogic then
  --  return
  --end
  if cameraFly_IsActive() then
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS_Activate(1)
    engineShowMouseCursor()
    print(Concat(S[302535920001058--[[Camera--]]]," ",S[302535920001059--[[RTS--]]]))
  else
    cameraFly_Activate(1)
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
    --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
    engineHideMouseCursor()
    print(Concat(S[302535920001058--[[Camera--]]]," ",S[302535920001060--[[Fly--]]]))
  end
  --resets zoom so...
  ChoGGi.CodeFuncs.SetCameraSettings()
end

function ChoGGi.MenuFuncs.CameraFollow_Toggle()
  --it was on the free camera so
  if not mapdata.GameLogic then
    return
  end
  local obj = ChoGGi.CodeFuncs.SelObject()

  --turn it off?
  if camera3p_IsActive() then
    engineShowMouseCursor()
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS_Activate(1)
    --reset camera fov settings
    if ChoGGi.cameraFovX then
      camera_SetFovX(ChoGGi.cameraFovX)
    end
    --show log again if it was hidden
    if ChoGGi.UserSettings.ConsoleToggleHistory then
      cls() --if it's going to spam the log, might as well clear it
      ChoGGi.CodeFuncs.ToggleConsoleLog()
    end
    --reset camera zoom settings
    ChoGGi.CodeFuncs.SetCameraSettings()
    return
  --crashes game if we attach to "false"
  elseif not obj then
    return
  end
  --let user know the camera mode
  print(Concat(S[302535920001058--[[Camera--]]]," ",S[302535920001061--[[Follow--]]]))
  --we only want to follow one object
  if ChoGGi.LastFollowedObject then
    camera3p_DetachObject(ChoGGi.LastFollowedObject)
  end
  --save for DetachObject
  ChoGGi.LastFollowedObject = obj
  --save for fovX reset
  ChoGGi.cameraFovX = camera_GetFovX()
  --zoom further out unless it's a colonist
  if not obj.base_death_age then
    --up the horizontal fov so we're further away from object
    camera_SetFovX(8400)
  end
  --consistent zoom level
  cameraRTS_SetZoom(8000)
  --Activate it
  camera3p_Activate(1)
  camera3p_AttachObject(obj)
  camera3p_SetLookAtOffset(point(0,0,-1500))
  camera3p_SetEyeOffset(point(0,0,-1000))
  --moving mouse moves camera
  camera3p_EnableMouseControl(true)
  --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
  engineHideMouseCursor()

  --toggle showing console history as console spams transparent something (and it'd be annoying to replace that function)
  if ChoGGi.UserSettings.ConsoleToggleHistory then
    ChoGGi.CodeFuncs.ToggleConsoleLog()
  end

  --if it's a rover then stop the ctrl control mode from being active (from pressing ctrl-shift-f)
  if type(obj.SetControlMode) == "function" then
    obj:SetControlMode(false)
  end
end

--LogCameraPos(print)
function ChoGGi.MenuFuncs.CursorVisible_Toggle()
  if IsMouseCursorHidden() then
    engineShowMouseCursor()
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
  else
    engineHideMouseCursor()
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
  end
end

function ChoGGi.MenuFuncs.SetBorderScrolling()
  local DefaultSetting = 5
  local hint_down = S[302535920001062--[[Down scrolling may not work (dependant on aspect ratio?).--]]]
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = DefaultSetting},
    {text = 0,value = 0,hint = 302535920001063--[[disable mouse border scrolling, WASD still works fine.--]]},
    {text = 1,value = 1,hint = hint_down},
    {text = 2,value = 2,hint = hint_down},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 10,value = 10},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.BorderScrollingArea then
    hint = tostring(ChoGGi.UserSettings.BorderScrollingArea)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetSavedSetting("BorderScrollingArea",value)
      ChoGGi.CodeFuncs.SetCameraSettings()

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        Concat(choice[1].value,": ",S[302535920001064--[[Mouse--]]]," ",S[302535920000647--[[Border Scrolling--]]]),
        302535920000647--[[Border Scrolling--]],
        "UI/Icons/IPButtons/status_effects.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",S[302535920000647--[[Border Scrolling--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
  }
end

function ChoGGi.MenuFuncs.CameraZoom_Toggle()
  local DefaultSetting = ChoGGi.Consts.CameraZoomToggle
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 16000,value = 16000},
    {text = 20000,value = 20000},
    {text = 24000,value = 24000, hint = 302535920001066--[[What used to be the default for this ECM setting--]]},
    {text = 32000,value = 32000},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.CameraZoomToggle then
    hint = tostring(ChoGGi.UserSettings.CameraZoomToggle)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetSavedSetting("CameraZoomToggle",value)
      ChoGGi.CodeFuncs.SetCameraSettings()

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        Concat(choice[1].text,": ",S[302535920001058--[[Camera--]]]," ",S[302535920001067--[[Zoom--]]]),
        302535920001058--[[Camera--]],
        "UI/Icons/IPButtons/status_effects.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920001058--[[Camera--]]]," ",S[302535920001067--[[Zoom--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
  }
end
