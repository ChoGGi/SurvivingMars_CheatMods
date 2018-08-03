--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local S = ChoGGi.Strings
--~ local default_icon = "UI/Icons/Anomaly_Event.tga"

local next,type,table = next,type,table

local ChangeGameSpeedState = ChangeGameSpeedState
--~ local CreateRealTimeThread = CreateRealTimeThread
local GetObjects = GetObjects
local PlayFX = PlayFX
local Random = Random
local RebuildFXRules = RebuildFXRules
local RemoveFromRules = RemoveFromRules
local ReopenSelectionXInfopanel = ReopenSelectionXInfopanel
--~ local Sleep = Sleep

local pf_SetStepLen = pf.SetStepLen

function ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials()
  local function ChangeEntity(cls,entity,random)
    local objs = GetObjects{class = cls}
    for i = 1, #objs do
      if random then
        objs[i]:ChangeEntity(Concat(entity,Random(1,random)))
      else
        objs[i]:ChangeEntity(entity)
      end
    end
  end

  local ItemList = {
    {text = S[302535920001079--[[Enable--]]],value = 1,hint = 302535920001081--[[Changes signs to materials.--]]},
    {text = S[302535920000142--[[Disable--]]],value = 0,hint = 302535920001082--[[Changes materials to signs.--]]},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if value == 1 then
      ChangeEntity("SubsurfaceDepositWater","DecSpider_01")
      ChangeEntity("SubsurfaceDepositMetals","DecDebris_01")
      ChangeEntity("SubsurfaceDepositPreciousMetals","DecSurfaceDepositConcrete_01")
      ChangeEntity("TerrainDepositConcrete","DecDustDevils_0",5)
      ChangeEntity("SubsurfaceAnomaly","DebrisConcrete")
      ChangeEntity("SubsurfaceAnomaly_unlock","DebrisMetal")
      ChangeEntity("SubsurfaceAnomaly_breakthrough","DebrisPolymer")
    else
      ChangeEntity("SubsurfaceDepositWater","SignWaterDeposit")
      ChangeEntity("SubsurfaceDepositMetals","SignMetalsDeposit")
      ChangeEntity("SubsurfaceDepositPreciousMetals","SignPreciousMetalsDeposit")
      ChangeEntity("TerrainDepositConcrete","SignConcreteDeposit")
      ChangeEntity("SubsurfaceAnomaly","Anomaly_01")
      ChangeEntity("SubsurfaceAnomaly_unlock","Anomaly_04")
      ChangeEntity("SubsurfaceAnomaly_breakthrough","Anomaly_02")
      ChangeEntity("SubsurfaceAnomaly_aliens","Anomaly_03")
      ChangeEntity("SubsurfaceAnomaly_complete","Anomaly_05")
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001083--[[Change Surface Signs--]],
  }
end

--AnnoyingSounds_Toggles
local function MirrorSphere_Toggle()
  local tab = UICity.labels.MirrorSpheres or ""
  for i = 1, #tab do
    PlayFX("Freeze", "end", tab[i])
    PlayFX("Freeze", "start", tab[i])
  end
end
local function SensorTower_Toggle()
  local ChoGGi = ChoGGi
  local tab = UICity.labels.SensorTower or ""
  for i = 1, #tab do
    ChoGGi.CodeFuncs.ToggleWorking(tab[i])
  end
end
local function RCRoverDeploy_Toggle()
  local tab = UICity.labels.RCRover or ""
  for i = 1, #tab do
    PlayFX("RoverDeploy", "end", tab[i])
    PlayFX("RoverDeploy", "start", tab[i])
  end
end
local function RCRoverEmergencyPower_Toggle()
  local tab = UICity.labels.RCRover or ""
  for i = 1, #tab do
    PlayFX("EmergencyPower", "end", tab[i])
    PlayFX("EmergencyPower", "start", tab[i])
  end
end

--Data\Sound.lua, and Lua\Config\__SoundTypes.lua
--test sounds:
--~ local function TestSound(snd)
--~   StopSound(ChoGGi.Temp.Sound)
--~   ChoGGi.Temp.Sound = PlaySound(snd,"UI")
--~ end
--~ TestSound("Object MOXIE Loop")

function ChoGGi.MenuFuncs.AnnoyingSounds_Toggle()
  local ChoGGi = ChoGGi
  --make a list
  local ItemList = {
    {text = Concat(" ",S[302535920001084--[[Reset--]]]),value = "Reset"},
    {text = S[302535920001085--[[Sensor Tower Beeping--]]],value = "SensorTowerWorking"},
    {text = S[302535920001086--[[RC Rover Drones Deployed--]]],value = "RCRoverAntenna"},
    {text = S[302535920001087--[[Mirror Sphere Crackling--]]],value = "MirrorSphereFreeze"},
    {text = S[302535920000220--[[RC Rover Emergency Power--]]],value = "RCRoverEmergencyPower"},
  }

  --callback
  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local FXRules = FXRules
    if value == "SensorTowerWorking" then
      table.remove(FXRules.Working.start.SensorTower.any,3)
      RemoveFromRules("Object SensorTower Loop")
      SensorTower_Toggle()

    elseif value == "MirrorSphereFreeze" then
      table.remove(FXRules.Freeze.start.MirrorSphere.any,2)
      FXRules.Freeze.start.any = nil
      RemoveFromRules("Freeze")
      MirrorSphere_Toggle()

    elseif value == "RCRoverAntenna" then
      table.remove(FXRules.RoverDeploy.start.RCRover.any,2)
      table.remove(FXRules.RoverDeploy.start.RCRover.any,3)
      RemoveFromRules("Unit Rover DeployWork")
      RemoveFromRules("Unit Rover DeployAntennaON")
      RCRoverDeploy_Toggle()

    elseif value == "RCRoverEmergencyPower" then
      table.remove(FXRules.EmergencyPower.start.RCRover.any,2)
      table.remove(FXRules.EmergencyPower.start.RCRover.any,3)
      RemoveFromRules("Unit Rover EmergencyPower")
      RemoveFromRules("Unit Rover EmergencyPower")
      RCRoverEmergencyPower_Toggle()

    elseif value == "Reset" then
      RebuildFXRules()
      MirrorSphere_Toggle()
      SensorTower_Toggle()
      RCRoverDeploy_Toggle()
      RCRoverEmergencyPower_Toggle()
    end

    MsgPopup(
      S[302535920001088--[[%s: Stop that bloody bouzouki!--]]]:format(choice[1].text),
      3581--[[Sounds--]]
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000680--[[Annoying Sounds--]],
    hint = 302535920001090--[[You can only reset all sounds at once.--]],
  }
end

function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = S[1682--[[RC Rover--]]],value = "RCRover"},
    {text = S[1684--[[RC Explorer--]]],value = "RCExplorer"},
    {text = S[1683--[[RC Transport--]]],value = "RCTransport"},
    {text = S[3518--[[Drone Hub--]]],value = "DroneHub"},
    {text = S[547--[[Colonists--]]],value = "Colonist"},
    {text = S[1685--[[Rocket--]]],value = "SupplyRocket"},
    {text = S[1120--[[Space Elevator--]]],value = "SpaceElevator"},
    {text = S[5017--[[Basic Dome--]]],value = "DomeBasic"},
    {text = S[5146--[[Medium Dome--]]],value = "DomeMedium"},
    {text = S[5152--[[Mega Dome--]]],value = "DomeMega"},
    {text = S[5188--[[Oval Dome--]]],value = "DomeOval"},
    {text = S[5093--[[Geoscape Dome--]]],value = "GeoscapeDome"},
    {text = S[9000--[[Micro Dome--]]],value = "DomeMicro"},
    {text = S[9003--[[Trigon Dome--]]],value = "DomeTrigon"},
    {text = S[9009--[[Mega Trigon Dome--]]],value = "DomeMegaTrigon"},
    {text = S[9012--[[Diamond Dome--]]],value = "DomeDiamond"},
    {text = S[302535920000347--[[Star Dome--]]],value = "DomeStar"},
    {text = S[302535920000351--[[Hexa Dome--]]],value = "DomeHexa"},
  }

  if not ChoGGi.UserSettings.UnpinObjects then
    ChoGGi.UserSettings.UnpinObjects = {}
  end

  --other hint type
  local EnabledList = {S[302535920001096--[[Auto Unpinned--]]],":"}
  local list = ChoGGi.UserSettings.UnpinObjects
  if next(list) then
    local tab = list or ""
    for i = 1, #tab do
      EnabledList[#EnabledList+1] = " "
      EnabledList[#EnabledList+1] = tab[i]
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      MsgPopup(
        302535920000038--[[Pick a checkbox next time...--]],
        302535920001092--[[Pins--]]
      )
      return
    elseif check1 and check2 then
      MsgPopup(
        302535920000039--[[Don't pick both checkboxes next time...--]],
        302535920001092--[[Pins--]]
      )
      return
    end

    local pins = ChoGGi.UserSettings.UnpinObjects
    for i = 1, #choice do
      local value = choice[i].value
      if check2 then
        for j = 1, #pins do
          if pins[j] == value then
            pins[j] = false
          end
        end
      elseif check1 then
        pins[#pins+1] = value
      end
    end

    --remove dupes
    ChoGGi.UserSettings.UnpinObjects = ChoGGi.ComFuncs.RetTableNoDupes(ChoGGi.UserSettings.UnpinObjects)

    local found = true
    while found do
      found = nil
      for i = 1, #ChoGGi.UserSettings.UnpinObjects do
        if ChoGGi.UserSettings.UnpinObjects[i] == false then
          ChoGGi.UserSettings.UnpinObjects[i] = nil
          found = true
          break
        end
      end
    end

    --if it's empty then remove setting
    if not next(ChoGGi.UserSettings.UnpinObjects) then
      ChoGGi.UserSettings.UnpinObjects = nil
    end
    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      S[302535920001093--[[Toggled: %s pinnable objects.--]]]:format(#choice),
      302535920001092--[[Pins--]]
    )
  end

  EnabledList[#EnabledList+1] = "\n"
  EnabledList[#EnabledList+1] = S[302535920001097--[[Enter a class name (SelectedObj.class) to add a custom entry.--]]]
  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001095--[[Auto Remove Items From Pin List--]],
    hint = Concat(EnabledList),
    multisel = true,
    check1 = 302535920001098--[[Add to list--]],
    check1_hint = 302535920001099--[[Add these items to the unpin list.--]],
    check2 = 302535920001100--[[Remove from list--]],
    check2_hint = 302535920001101--[[Remove these items from the unpin list.--]],
  }
end

function ChoGGi.MenuFuncs.CleanAllObjects()
  local const = const
  local objs = GetObjects{}
  for i = 1, #objs do
    if type(objs[i].SetDust) == "function" then
      objs[i]:SetDust(0,const.DustMaterialExterior)
    end
  end

  MsgPopup(
    302535920001102--[[Cleaned all--]],
    302535920001103--[[Objects--]]
  )
end

function ChoGGi.MenuFuncs.FixAllObjects()
  local objs = GetObjects{}
  for i = 1, #objs do
    if type(objs[i].Repair) == "function" then
      objs[i]:Repair()
      objs[i].accumulated_maintenance_points = 0
    end
  end

  objs = UICity.labels.Drone or ""
  for i = 1, #objs do
    objs[i]:SetCommand("RepairDrone")
  end

  MsgPopup(
    302535920001104--[[Fixed all--]],
    302535920001103--[[Objects--]]
  )
end

--build and show a list of attachments for changing their colours
function ChoGGi.MenuFuncs.CreateObjectListAndAttaches(obj)
  local ChoGGi = ChoGGi
  obj = obj or ChoGGi.CodeFuncs.SelObject()

  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    MsgPopup(
      302535920001105--[[Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).--]],
      302535920000016--[[Colour--]]
    )
    return
  end
  local ItemList = {}

  --has no Attaches so just open as is
  if obj:GetNumAttaches() == 0 then
    ChoGGi.CodeFuncs.ChangeObjectColour(obj)
    return
  else
    ItemList[#ItemList+1] = {
      text = Concat(" ",obj.class),
      value = obj.class,
      obj = obj,
      hint = 302535920001106--[[Change main object colours.--]],
    }
    local Attaches = obj:GetAttaches() or ""
    for i = 1, #Attaches do
      ItemList[#ItemList+1] = {
        text = Attaches[i].class,
        value = Attaches[i].class,
        parentobj = obj,
        obj = Attaches[i],
        hint = 302535920001107--[[Change colours of an attached object.--]],
      }
    end
  end

  local function CallBackFunc()end

  local function FiredOnMenuClick(sel)
    ChoGGi.CodeFuncs.ChangeObjectColour(sel.obj,sel.parentobj)
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000021--[[Change Colour--]]],": ",RetName(obj)),
    hint = 302535920001108--[[Double click to open object/attachment to edit.--]],
    custom_type = 1,
    custom_func = FiredOnMenuClick,
  }
end

function ChoGGi.MenuFuncs.SetObjectOpacity()
  local ChoGGi = ChoGGi
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end
  local hint_loop = Concat(S[302535920001109--[[Loops though and makes all--]]]," ")
  local ItemList = {
    {text = Concat(" ",S[302535920001084--[[Reset--]]],": ",S[3984--[[Anomalies--]]]),value = "Anomaly",hint = Concat(hint_loop,S[302535920001110--[[anomalies visible.--]]])},
    {text = Concat(" ",S[302535920001084--[[Reset--]]],": ",S[3980--[[Buildings--]]]),value = "Building",hint = Concat(hint_loop,S[302535920001111--[[buildings visible.--]]])},
    {text = Concat(" ",S[302535920001084--[[Reset--]]],": ",S[302535920000157--[[Cables & Pipes--]]]),value = "GridElements",hint = Concat(hint_loop,S[302535920001113--[[pipes and cables visible.--]]])},
    {text = Concat(" ",S[302535920001084--[[Reset--]]],": ",S[547--[[Colonists--]]]),value = "Colonists",hint = Concat(hint_loop,S[302535920001114--[[colonists visible.--]]])},
    {text = Concat(" ",S[302535920001084--[[Reset--]]],": ",S[3981--[[Units--]]]),value = "Unit",hint = Concat(hint_loop,S[302535920001115--[[rovers and drones visible.--]]])},
    {text = Concat(" ",S[302535920001084--[[Reset--]]]": ",S[3982--[[Deposits--]]]),value = "SurfaceDeposit",hint = Concat(hint_loop,S[302535920000138--[["surface, subsurface, and terrain deposits visible."--]]])},
    {text = 0,value = 0},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
  }
  --callback
  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      sel:SetOpacity(value)
    elseif type(value) == "string" then
      local function SettingOpacity(label)
        local tab = UICity.labels[label] or ""
        for i = 1, #tab do
          tab[i]:SetOpacity(100)
        end
      end
      SettingOpacity(value)
      --extra ones
      if value == "Building" then
        SettingOpacity("AllRockets")
      elseif value == "Anomaly" then
        SettingOpacity("SubsurfaceAnomalyMarker")
      elseif value == "SurfaceDeposit" then
        SettingOpacity("SubsurfaceDeposit")
        SettingOpacity("TerrainDeposit")
      end
    end
    MsgPopup(
      ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
      302535920001117--[[Opacity--]],
      "UI/Icons/Sections/attention.tga"
    )
  end
  local hint = S[302535920001118--[[You can still select items after making them invisible (0), but it may take some effort :).--]]]
  if sel then
    hint = Concat(S[302535920000106--[[Current--]]],": ",sel:GetOpacity(),"\n\n",hint)
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000694--[[Set Opacity--]]],": ",RetName(sel)),
    hint = hint,
  }
end

function ChoGGi.MenuFuncs.InfopanelCheats_Toggle()
  local ChoGGi = ChoGGi
  local config = config
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.ComFuncs.SetSavedSetting("ToggleInfopanelCheats",config.BuildingInfopanelCheats)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920001122--[[%s: HAXOR--]]]:format(ChoGGi.UserSettings.ToggleInfopanelCheats),
    27--[[Cheats--]],
    "UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle()
  local ChoGGi = ChoGGi

  if ChoGGi.UserSettings.CleanupCheatsInfoPane then
    ChoGGi.UserSettings.CleanupCheatsInfoPane = nil
  else
    ChoGGi.UserSettings.CleanupCheatsInfoPane = true
    ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920001123--[[%s: Cleanup cheats infopane.--]]]:format(ChoGGi.UserSettings.CleanupCheatsInfoPane),
    27--[[Cheats--]],
    "UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
  local ChoGGi = ChoGGi
  const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
  ChoGGi.ComFuncs.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920001124--[[%s: scans at a time.--]]]:format(ChoGGi.UserSettings.ExplorationQueueMaxSize),
    302535920001125--[[Scanner--]],
    "UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.MenuFuncs.SetGameSpeed()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = 1},
    {text = Concat("1 ",S[302535920001126--[[Double--]]]),value = 2},
    {text = Concat("2 ",S[302535920001127--[[Triple--]]]),value = 3},
    {text = Concat("3 ",S[302535920001128--[[Quadruple--]]]),value = 4},
    {text = Concat("4 ",S[302535920001129--[[Octuple--]]]),value = 8},
    {text = Concat("5 ",S[302535920001130--[[Sexdecuple--]]]),value = 16},
    {text = Concat("6 ",S[302535920001131--[[Duotriguple--]]]),value = 32},
    {text = Concat("7 ",S[302535920001132--[[Quattuorsexaguple--]]]),value = 64},
  }

  local current = S[1000121--[[Default--]]]
  if const.mediumGameSpeed == 6 then
    current = S[302535920001126--[[Double--]]]
  elseif const.mediumGameSpeed == 9 then
    current = S[302535920001127--[[Triple--]]]
  elseif const.mediumGameSpeed == 12 then
    current = S[302535920001128--[[Quadruple--]]]
  elseif const.mediumGameSpeed == 24 then
    current = S[302535920001129--[[Octuple--]]]
  elseif const.mediumGameSpeed == 48 then
    current = S[302535920001130--[[Sexdecuple--]]]
  elseif const.mediumGameSpeed == 96 then
    current = S[302535920001131--[[Duotriguple--]]]
  elseif const.mediumGameSpeed == 192 then
    current = S[302535920001132--[[Quattuorsexaguple--]]]
  else
    current = S[302535920001134--[[Custom: %s < base number 3 multipled by custom amount.--]]]:format(const.mediumGameSpeed)
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local const = const
    if type(value) == "number" then
      const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * value
      const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * value
      --so it changes the speed
      ChangeGameSpeedState(-1)
      ChangeGameSpeedState(1)
      --update settings
      ChoGGi.UserSettings.mediumGameSpeed = const.mediumGameSpeed
      ChoGGi.UserSettings.fastGameSpeed = const.fastGameSpeed

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920001135--[[%s: Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono.--]]]:format(choice[1].text),
        302535920001136--[[Speed--]],
        "UI/Icons/Notifications/timer.tga",
        true
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001137--[[Set Game Speed--]],
    hint = S[302535920000933--[[Current speed: %s--]]]:format(current),
  }
end

local entity_table = {}
local function SetEntity(obj,entity)
  --backup orig
  if not obj.ChoGGi_OrigEntity then
    obj.ChoGGi_OrigEntity = obj.entity
  end
  if entity == "Default" then
    local orig = obj.ChoGGi_OrigEntity or obj:GetDefaultPropertyValue("entity")
    obj.entity = orig
    obj:ChangeEntity(orig)
    obj.ChoGGi_OrigEntity = nil
  else
    obj.entity = entity
    obj:ChangeEntity(entity)
  end
end
function ChoGGi.MenuFuncs.SetEntity()
  local ChoGGi = ChoGGi
  local sel = ChoGGi.CodeFuncs.SelObject()
  local entity_str = 155--[[Entity--]]
  if not sel then
    MsgPopup(
      302535920001139--[[You need to select an object.--]],
      entity_str
    )
    return
  end

  local hint_noanim = S[302535920001140--[[No animation.--]]]
  if #entity_table == 0 then
    entity_table = {
      {text = Concat("  ",S[302535920001141--[[Default Entity--]]]),value = "Default"},
      {text = Concat(" ",S[302535920001142--[[Kosmonavt--]]]),value = "Kosmonavt"},
      {text = Concat(" ",S[302535920001143--[[Jama--]]]),value = "Lama"},
      {text = Concat(" ",S[302535920001144--[[Green Man--]]]),value = "GreenMan"},
      {text = Concat(" ",S[302535920001145--[[Planet Mars--]]]),value = "PlanetMars",hint = hint_noanim},
      {text = Concat(" ",S[302535920001146--[[Planet Earth--]]]),value = "PlanetEarth",hint = hint_noanim},
      {text = Concat(" ",S[302535920001147--[[Rocket Small--]]]),value = "RocketUI",hint = hint_noanim},
      {text = Concat(" ",S[302535920001148--[[Rocket Regular--]]]),value = "Rocket",hint = hint_noanim},
      {text = Concat(" ",S[302535920001149--[[Combat Rover--]]]),value = "CombatRover",hint = hint_noanim},
      {text = Concat(" ",S[302535920001150--[[PumpStation Demo--]]]),value = "PumpStationDemo",hint = hint_noanim},
    }
    --EntityData
    local Table = DataInstances.BuildingTemplate
    for i = 1, #Table do
      entity_table[#entity_table+1] = {
        text = Table[i].entity,
        value = Table[i].entity,
        hint = hint_noanim
      }
    end
  end
  local ItemList = entity_table

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if check1 and check2 then
      MsgPopup(
        302535920000039--[[Don't pick both checkboxes next time...--]],
        entity_str
      )
      return
    end

    local dome
    if sel.dome and check1 then
      dome = sel.dome
    end
    if EntityData[value] or value == "Default" then

      if check2 then
        SetEntity(sel,value)
      else
        local objs = GetObjects{class = sel.class}
        for i = 1, #objs do
          if dome then
            if objs[i].dome and objs[i].dome.handle == dome.handle then
              SetEntity(objs[i],value)
            end
          else
            SetEntity(objs[i],value)
          end
        end
      end
      MsgPopup(
        Concat(choice[1].text,": ",RetName(sel)),
        entity_str
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = S[302535920001151--[[Set Entity For %s--]]]:format(RetName(sel)),
    hint = Concat(S[302535920000106--[[Current--]]],": ",(sel.ChoGGi_OrigEntity or sel.entity),"\n",S[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]],"\n\n",S[302535920001153--[[Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).

Not permanent for colonists after they exit buildings (for now).--]]]),
    check1 = 302535920000750--[[Dome Only--]],
    check1_hint = 302535920001255--[[Will only apply to objects in the same dome as selected object.--]],
    check2 = 302535920000752--[[Selected Only--]],
    check2_hint = 302535920001256--[[Will only apply to selected object.--]],
  }
end

local function SetScale(obj,Scale)
  local ChoGGi = ChoGGi
  local cUserSettings = ChoGGi.UserSettings
  obj:SetScale(Scale)

  --changing entity to a static one and changing scale can make things not move so re-apply speeds.
  --and it needs a slight delay
	DelayedCall(500, function()
--~   CreateRealTimeThread(function()
--~     Sleep(500)
    if obj.class == "Drone" then
      if cUserSettings.SpeedDrone then
        pf_SetStepLen(obj,cUserSettings.SpeedDrone)
      else
        obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedDrone())
      end
    elseif obj.class == "CargoShuttle" then
      if cUserSettings.SpeedShuttle then
        obj.max_speed = ChoGGi.Consts.SpeedShuttle
      else
        obj.max_speed = ChoGGi.Consts.SpeedShuttle
      end
    elseif obj.class == "Colonist" then
      if cUserSettings.SpeedColonist then
        pf_SetStepLen(obj,cUserSettings.SpeedColonist)
      else
        obj:SetMoveSpeed(ChoGGi.Consts.SpeedColonist)
      end
    elseif obj:IsKindOf("BaseRover") then
      if cUserSettings.SpeedRC then
        pf_SetStepLen(obj,cUserSettings.SpeedRC)
      else
        obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedRC())
      end
    end
  end)
end

function ChoGGi.MenuFuncs.SetEntityScale()
  local ChoGGi = ChoGGi
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    MsgPopup(
      302535920001139--[[You need to select an object.--]],
      1000081--[[Scale--]]
    )
    return
  end

  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]]),value = 100},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if check1 and check2 then
      MsgPopup(
        302535920000039--[[Don't pick both checkboxes next time...--]],
        1000081--[[Scale--]]
      )
      return
    end

    local dome
    if sel.dome and check1 then
      dome = sel.dome
    end
    if type(value) == "number" then

      if check2 then
        SetScale(sel,value)
      else
        local objs = GetObjects{class = sel.class}
        for i = 1, #objs do
          if dome then
            if objs[i].dome and objs[i].dome.handle == dome.handle then
              SetScale(objs[i],value)
            end
          else
            SetScale(objs[i],value)
          end
        end
      end
      MsgPopup(
        Concat(choice[1].text,": ",RetName(sel)),
        1000081--[[Scale--]],
        nil,
        nil,
        sel
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = S[302535920001155--[[Set Entity Scale For %s--]]]:format(RetName(sel)),
    hint = Concat(S[302535920001156--[[Current object--]]],": ",sel:GetScale(),"\n",S[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]]),
    check1 = 302535920000750--[[Dome Only--]],
    check1_hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
    check2 = 302535920000752--[[Selected Only--]],
    check2_hint = 302535920000753--[[Will only apply to selected colonist.--]],
  }
end
