--See LICENSE for terms

local UsualIcon = "UI/Icons/Anomaly_Event.tga"

function ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials()
  local GetObjects = GetObjects
  local function ChangeEntity(Class,Entity,Random)
    local objs = GetObjects({class = Class}) or empty_table
    for i = 1, #objs do
      if Random then
        objs[i]:ChangeEntity(Entity .. UICity:Random(1,Random))
      else
        objs[i]:ChangeEntity(Entity)
      end
    end
  end

  local ItemList = {
    {text = "Enable",value = "Enable",hint = "Changes signs to materials."},
    {text = "Disable",value = "Disable",hint = "Changes materials to signs."},
  }

  local CallBackFunc = function(choice)
    if choice[1].value == "Enable" then
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

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Change Surface Signs",
  })
end

--AnnoyingSounds_Toggle
local function MirrorSphere_Toggle()
  local tab = UICity.labels.MirrorSpheres or empty_table
  for i = 1, #tab do
    PlayFX("Freeze", "end", tab[i])
    PlayFX("Freeze", "start", tab[i])
  end
end
local function SensorTower_Toggle()
  local ChoGGi = ChoGGi
  local tab = UICity.labels.SensorTower or empty_table
  for i = 1, #tab do
    ChoGGi.CodeFuncs.ToggleWorking(tab[i])
  end
end
local function RCRover_Toggle()
  local ChoGGi = ChoGGi
  local tab = UICity.labels.RCRover or empty_table
  for i = 1, #tab do
    PlayFX("RoverDeploy", "end", tab[i])
    PlayFX("RoverDeploy", "start", tab[i])
  end
end

function ChoGGi.MenuFuncs.AnnoyingSounds_Toggle()
  --make a list
  local ItemList = {
    {text = " Reset",value = "Reset"},
    {text = "Sensor Tower Beeping",value = "SensorTowerWorking"},
    {text = "RC Rover Drones Deployed",value = "RCRoverAntenna"},
    {text = "Mirror Sphere Crackling",value = "MirrorSphereFreeze"},
  }

  --callback
  local CallBackFunc = function(choice)
    local RemoveFromRules = RemoveFromRules
    local value = choice[1].value
    if value == "SensorTowerWorking" then
      --FXRules.Working.start.SensorTower.any[3] = nil
      table.remove(FXRules.Working.start.SensorTower.any,3)
      RemoveFromRules("Object SensorTower Loop")
      SensorTower_Toggle()

    elseif value == "MirrorSphereFreeze" then
      --FXRules.Freeze.start.MirrorSphere.any[2] = nil
      table.remove(FXRules.Freeze.start.MirrorSphere.any,2)
      FXRules.Freeze.start.any = nil
      RemoveFromRules("Freeze")
      MirrorSphere_Toggle()

    elseif value == "RCRoverAntenna" then
      --FXRules.RoverDeploy.start.RCRover.any[3] = nil
      --FXRules.RoverDeploy.start.RCRover.any[2] = nil
      table.remove(FXRules.RoverDeploy.start.RCRover.any,2)
      table.remove(FXRules.RoverDeploy.start.RCRover.any,3)
      RemoveFromRules("Unit Rover DeployWork")
      RemoveFromRules("Unit Rover DeployAntennaON")
      RCRover_Toggle()

    elseif value == "Reset" then
      RebuildFXRules()
      MirrorSphere_Toggle()
      SensorTower_Toggle()
      RCRover_Toggle()
    end

    ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": Stop that bloody bouzouki!",
      "Sounds"
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Annoying Sounds",
    hint = "You can only reset all sounds at once.",
  })
end

function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
  local ItemList = {
    {text = "RC Rover",value = "RCRover"},
    {text = "RC Explorer",value = "RCExplorer"},
    {text = "RC Transport",value = "RCTransport"},
    {text = "Drone Hub",value = "DroneHub"},
    {text = "Colonist",value = "Colonist"},
    {text = "Supply Rocket",value = "SupplyRocket"},
    {text = "Space Elevator",value = "SpaceElevator"},
    {text = "Dome Basic",value = "DomeBasic"},
    {text = "Dome Medium",value = "DomeMedium"},
    {text = "Dome Mega",value = "DomeMega"},
    {text = "Dome Oval",value = "DomeOval"},
    {text = "Dome Geoscape",value = "GeoscapeDome"},
  }

  if not ChoGGi.UserSettings.UnpinObjects then
    ChoGGi.UserSettings.UnpinObjects = {}
  end

  --other hint type
  local EnabledList = ""
  local list = ChoGGi.UserSettings.UnpinObjects
  if next(list) then
    local tab = list or empty_table
    for i = 1, #tab do
      EnabledList = EnabledList .. " " .. tab[i]
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      ChoGGi.ComFuncs.MsgPopup("Pick a checkbox next time...","Pins")
      return
    elseif check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Pins")
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
    ChoGGi.ComFuncs.MsgPopup("Toggled: " .. #choice .. " pinnable objects.","Pins")
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Auto Remove Items From Pin List",
    hint = "Auto Unpinned:" .. EnabledList .. "\nEnter a class name (s.class) to add a custom entry.",
    multisel = true,
    check1 = "Add to list",
    check1_hint = "Add these items to the unpin list.",
    check2 = "Remove from list",
    check2_hint = "Remove these items from the unpin list.",
  })
end

function ChoGGi.MenuFuncs.CleanAllObjects()
  local tab = UICity.labels.Building or empty_table
  for i = 1, #tab do
    tab[i]:SetDust(0,const.DustMaterialExterior)
  end
  tab = UICity.labels.Unit or empty_table
  for i = 1, #tab do
    tab[i]:SetDust(0,const.DustMaterialExterior)
  end

  ChoGGi.ComFuncs.MsgPopup("Cleaned all","Objects")
end

function ChoGGi.MenuFuncs.FixAllObjects()
  local function Repair(Label)
    local tab = UICity.labels[Label] or empty_table
    for i = 1, #tab do
      tab[i]:Repair()
      tab[i].accumulated_maintenance_points = 0
    end
  end
  Repair("Building")
  Repair("Rover")
  local tab = UICity.labels.Drone or empty_table
  for i = 1, #tab do
    tab[i]:SetCommand("RepairDrone")
  end

  ChoGGi.ComFuncs.MsgPopup("Fixed all","Objects")
end

--build and show a list of attachments for changing their colours
function ChoGGi.MenuFuncs.CreateObjectListAndAttaches()
  local obj = ChoGGi.CodeFuncs.SelObject()
  if not obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.ComFuncs.MsgPopup("Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).","Colour")
    return
  end
  local ItemList = {}

  --has no Attaches so just open as is
  if obj:GetNumAttaches() == 0 then
    ChoGGi.CodeFuncs.ChangeObjectColour(obj)
    return
  else
    ItemList[#ItemList+1] = {
      text = " " .. obj.class,
      value = obj.class,
      obj = obj,
      hint = "Change main object colours."
    }
    local Attaches = obj:GetAttaches()
    for i = 1, #Attaches do
      ItemList[#ItemList+1] = {
        text = Attaches[i].class,
        value = Attaches[i].class,
        parentobj = obj,
        obj = Attaches[i],
        hint = "Change colours of a part of an object."
      }
    end
  end

  local CallBackFunc = function()
    --we're ignoring the ok button
    return
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Change Colour: " .. ChoGGi.CodeFuncs.RetName(obj),
    hint = "Double click to open object/attachment to edit.",
    custom_type = 1,
  })
end

function ChoGGi.MenuFuncs.SetObjectOpacity()
  local sel = ChoGGi.CodeFuncs.SelObject()
  local ItemList = {
    {text = " Reset: Anomalies",value = "Anomaly",hint = "Loops though and makes all anomalies visible."},
    {text = " Reset: Buildings",value = "Building",hint = "Loops though and makes all buildings visible."},
    {text = " Reset: Cables & Pipes",value = "ChoGGi_GridElements",hint = "Loops though and makes all pipes and cables visible."},
    {text = " Reset: Colonists",value = "Colonists",hint = "Loops though and makes all colonists visible."},
    {text = " Reset: Units",value = "Unit",hint = "Loops though and makes all rovers and drones visible."},
    {text = " Reset: Deposits",value = "SurfaceDeposit",hint = "Loops though and makes all surface, subsurface, and terrain deposits visible."},
    {text = 0,value = 0},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
  }
  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      sel:SetOpacity(value)
    elseif type(value) == "string" then
      local function SettingOpacity(label)
        local tab = UICity.labels[label] or empty_table
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
    ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
      "Opacity","UI/Icons/Sections/attention.tga"
    )
  end
  local hint = "You can still select items after making them invisible (0), but it may take some effort :)."
  if sel then
    hint = "Current: " .. sel:GetOpacity() .. "\n\n" .. hint
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Opacity: " .. ChoGGi.CodeFuncs.RetName(sel),
    hint = hint,
  })
end

function ChoGGi.MenuFuncs.DisableTextureCompression_Toggle()
  ChoGGi.UserSettings.DisableTextureCompression = not ChoGGi.UserSettings.DisableTextureCompression
  hr.TR_ToggleTextureCompression = 1

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup("Texture Compression: " .. tostring(ChoGGi.UserSettings.DisableTextureCompression),
    "Video",UsualIcon
  )
end

function ChoGGi.MenuFuncs.InfopanelCheats_Toggle()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.ComFuncs.SetSavedSetting("ToggleInfopanelCheats",config.BuildingInfopanelCheats)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ToggleInfopanelCheats) .. ": HAXOR",
    "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle()
  ChoGGi.UserSettings.CleanupCheatsInfoPane = not ChoGGi.UserSettings.CleanupCheatsInfoPane

  if ChoGGi.UserSettings.CleanupCheatsInfoPane then
    ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.CleanupCheatsInfoPane) .. ": Cleanup",
    "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
  const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
  ChoGGi.ComFuncs.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ExplorationQueueMaxSize) .. ": scans at a time.",
    "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.MenuFuncs.SetGameSpeed()
  local ItemList = {
    {text = " Default",value = 1},
    {text = "1 Double",value = 2},
    {text = "2 Triple",value = 3},
    {text = "3 Quadruple",value = 4},
    {text = "4 Octuple",value = 8},
    {text = "5 Sexdecuple",value = 16},
    {text = "6 Duotriguple",value = 32},
    {text = "7 Quattuorsexaguple",value = 64},
  }

  local current = "Default"
  pcall(function()
    if const.mediumGameSpeed == 6 then
      current = "Double"
    elseif const.mediumGameSpeed == 9 then
      current = "Triple"
    elseif const.mediumGameSpeed == 12 then
      current = "Quadruple"
    elseif const.mediumGameSpeed == 24 then
      current = "Octuple"
    elseif const.mediumGameSpeed == 48 then
      current = "Sexdecuple"
    elseif const.mediumGameSpeed == 96 then
      current = "Duotriguple"
    elseif const.mediumGameSpeed == 192 then
      current = "Quattuorsexaguple"
    else
      current = "Custom: " .. const.mediumGameSpeed .. " < base number 3 multipled by custom amount"
    end
  end)

  local CallBackFunc = function(choice)
    local value = choice[1].value
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono.",
        "Speed","UI/Icons/Notifications/timer.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Game Speed",
    hint = "Current speed: " .. current,
  })
end

local entity_table = {}
local function SetEntity(Obj,Entity)
  --backup orig
  if not Obj.ChoGGi_OrigEntity then
    Obj.ChoGGi_OrigEntity = Obj.entity
  end
  if Entity == "Default" and Obj.ChoGGi_OrigEntity then
    Obj.entity = Obj.ChoGGi_OrigEntity
    Obj:ChangeEntity(Obj.ChoGGi_OrigEntity)
    Obj.ChoGGi_OrigEntity = nil
  else
    Obj.entity = Entity
    Obj:ChangeEntity(Entity)
  end
end
function ChoGGi.MenuFuncs.SetEntity()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    ChoGGi.ComFuncs.MsgPopup("You need to select an object.","Entity")
    return
  end

  local hint_noanim = "No animation."
  if #entity_table == 0 then
    entity_table = {
      {text = "  Default Entity",value = "Default"},
      {text = " Kosmonavt",value = "Kosmonavt"},
      {text = " Lama",value = "Lama",hint = hint_noanim},
      {text = " GreenMan",value = "GreenMan",hint = hint_noanim},
      {text = " PlanetMars",value = "PlanetMars",hint = hint_noanim},
      {text = " PlanetEarth",value = "PlanetEarth",hint = hint_noanim},
      {text = " Rocket Small",value = "RocketUI",hint = hint_noanim},
      {text = " Rocket Regular",value = "Rocket",hint = hint_noanim},
      {text = " CombatRover",value = "CombatRover",hint = hint_noanim},
      {text = " PumpStationDemo",value = "PumpStationDemo",hint = hint_noanim},
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

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Entity")
      return
    end

    local dome
    if sel.dome and check1 then
      dome = sel.dome
    end
    local value = choice[1].value
    if EntityData[value] or value == "Default" then

      if check2 then
        SetEntity(sel,value)
      else
        local objs = GetObjects({class = sel.class}) or empty_table
        for i = 1, #objs do
          if dome then
            if objs[i].dome and objs[i].dome == dome then
              SetEntity(objs[i],value)
            end
          else
            SetEntity(objs[i],value)
          end
        end
      end
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. sel.class,"Entity")
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Entity For " .. ChoGGi.CodeFuncs.RetName(sel),
    hint = "Current: " .. (sel.ChoGGi_OrigEntity or sel.entity) .. "\nIf you don't pick a checkbox it will change all of selected type.\n\nPost a request if you want me to add more entities from EntityData (use ex(EntityData) to list).\n\nNot permanent for colonists after they exit buildings (for now).",
    check1 = "Dome Only",
    check1_hint = "Will only apply to objects in the same dome as selected object.",
    check2 = "Selected Only",
    check2_hint = "Will only apply to selected object.",
  })
end

local function SetScale(Obj,Scale)
  local cUserSettings = ChoGGi.UserSettings
  Obj:SetScale(Scale)
  --changing entity to a static one and changing scale can make things not move so re-apply speeds.
  CreateRealTimeThread(function()
    --and it needs a slight delay
    Sleep(500)
    if Obj.class == "Drone" then
      if cUserSettings.SpeedDrone then
        pf.SetStepLen(Obj,cUserSettings.SpeedDrone)
      else
        Obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedDrone())
      end
    elseif Obj.class == "CargoShuttle" then
      if cUserSettings.SpeedShuttle then
        Obj.max_speed = ChoGGi.Consts.SpeedShuttle
      else
        Obj.max_speed = ChoGGi.Consts.SpeedShuttle
      end
    elseif Obj.class == "Colonist" then
      if cUserSettings.SpeedColonist then
        pf.SetStepLen(Obj,cUserSettings.SpeedColonist)
      else
        Obj:SetMoveSpeed(ChoGGi.Consts.SpeedColonist)
      end
    elseif s:IsKindOf("BaseRover") then
      if cUserSettings.SpeedRC then
        pf.SetStepLen(Obj,cUserSettings.SpeedRC)
      else
        Obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedRC())
      end
    end
  end)
end

function ChoGGi.MenuFuncs.SetEntityScale()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    ChoGGi.ComFuncs.MsgPopup("You need to select an object.","Scale")
    return
  end

  local ItemList = {
    {text = " Default",value = 100},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Scale")
      return
    end

    local dome
    if sel.dome and check1 then
      dome = sel.dome
    end
    local value = choice[1].value
    if type(value) == "number" then

      if check2 then
        SetScale(sel,value)
      else
        local objs = GetObjects({class = sel.class}) or empty_table
        for i = 1, #objs do
          if dome then
            if objs[i].dome and objs[i].dome == dome then
              SetScale(objs[i],value)
            end
          else
            SetScale(objs[i],value)
          end
        end
      end
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. sel.class,"Scale")
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Entity Scale For " .. ChoGGi.CodeFuncs.RetName(sel),
    hint = "Current object: " .. sel:GetScale() .. "\nIf you don't pick a checkbox it will change all of selected type.",
    check1 = "Dome Only",
    check1_hint = "Will only apply to objects in the same dome as selected object.",
    check2 = "Selected Only",
    check2_hint = "Will only apply to selected object.",
  })
end
