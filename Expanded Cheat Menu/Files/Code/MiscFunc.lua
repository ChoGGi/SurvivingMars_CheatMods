--See LICENSE for terms

local UsualIcon = "UI/Icons/Anomaly_Event.tga"

function ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials()
  local GetObjects = GetObjects
  local function ChangeEntity(Class,Entity,random)
    local objs = GetObjects({class = Class}) or empty_table
    for i = 1, #objs do
      if random then
        objs[i]:ChangeEntity(Entity .. Random(1,random))
      else
        objs[i]:ChangeEntity(Entity)
      end
    end
  end

  local ItemList = {
    {text = ChoGGi.ComFuncs.Trans(302535920001079,"Enable"),value = "Enable",hint = ChoGGi.ComFuncs.Trans(302535920001081,"Changes signs to materials.")},
    {text = ChoGGi.ComFuncs.Trans(302535920000142,"Disable"),value = "Disable",hint = ChoGGi.ComFuncs.Trans(302535920001082,"Changes materials to signs.")},
  }

  local CallBackFunc = function(choice)
    if choice[1].value == ChoGGi.ComFuncs.Trans(302535920001079,"Enable") then
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
    title = ChoGGi.ComFuncs.Trans(302535920001083,"Change Surface Signs"),
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
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset"),value = "Reset"},
    {text = ChoGGi.ComFuncs.Trans(302535920001085,"Sensor Tower Beeping"),value = "SensorTowerWorking"},
    {text = ChoGGi.ComFuncs.Trans(302535920001086,"RC Rover Drones Deployed"),value = "RCRoverAntenna"},
    {text = ChoGGi.ComFuncs.Trans(302535920001087,"Mirror Sphere Crackling"),value = "MirrorSphereFreeze"},
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

    ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ChoGGi.ComFuncs.Trans(302535920001088,": Stop that bloody bouzouki!"),
      ChoGGi.ComFuncs.Trans(3581,"Sounds")
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000680,"Annoying Sounds"),
    hint = ChoGGi.ComFuncs.Trans(302535920001090,"You can only reset all sounds at once."),
  })
end

function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
  local ItemList = {
    {text = ChoGGi.ComFuncs.Trans(1682,"RC Rover"),value = "RCRover"},
    {text = ChoGGi.ComFuncs.Trans(1684,"RC Explorer"),value = "RCExplorer"},
    {text = ChoGGi.ComFuncs.Trans(1683,"RC Transport"),value = "RCTransport"},
    {text = ChoGGi.ComFuncs.Trans(3518,"Drone Hub"),value = "DroneHub"},
    {text = ChoGGi.ComFuncs.Trans(547,"Colonists"),value = "Colonist"},
    {text = ChoGGi.ComFuncs.Trans(1685,"Rocket"),value = "SupplyRocket"},
    {text = ChoGGi.ComFuncs.Trans(1120,"Space Elevator"),value = "SpaceElevator"},
    {text = ChoGGi.ComFuncs.Trans(5017,"Basic Dome"),value = "DomeBasic"},
    {text = ChoGGi.ComFuncs.Trans(5146,"Medium Dome"),value = "DomeMedium"},
    {text = ChoGGi.ComFuncs.Trans(5152,"Mega Dome"),value = "DomeMega"},
    {text = ChoGGi.ComFuncs.Trans(5188,"Oval Dome"),value = "DomeOval"},
    {text = ChoGGi.ComFuncs.Trans(5093,"Geoscape Dome"),value = "GeoscapeDome"},
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001091,"Pick a checkbox next time..."),ChoGGi.ComFuncs.Trans(302535920001092,"Pins"))
      return
    elseif check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000039,"Don't pick both checkboxes next time..."),ChoGGi.ComFuncs.Trans(302535920001092,"Pins"))
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
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001093,"Toggled") .. ": " .. #choice .. " " .. ChoGGi.ComFuncs.Trans(302535920001094,"pinnable objects."),ChoGGi.ComFuncs.Trans(302535920001092,"Pins"))
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001095,"Auto Remove Items From Pin List"),
    hint = ChoGGi.ComFuncs.Trans(302535920001096,"Auto Unpinned") .. ":" .. EnabledList .. "\n" .. ChoGGi.ComFuncs.Trans(302535920001097,"Enter a class name (s.class) to add a custom entry."),
    multisel = true,
    check1 = ChoGGi.ComFuncs.Trans(302535920001098,"Add to list"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920001099,"Add these items to the unpin list."),
    check2 = ChoGGi.ComFuncs.Trans(302535920001100,"Remove from list"),
    check2_hint = ChoGGi.ComFuncs.Trans(302535920001101,"Remove these items from the unpin list."),
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

  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001102,"Cleaned all"),ChoGGi.ComFuncs.Trans(302535920001103,"Objects"))
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

  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001104,"Fixed all"),ChoGGi.ComFuncs.Trans(302535920001103,"Objects"))
end

--build and show a list of attachments for changing their colours
function ChoGGi.MenuFuncs.CreateObjectListAndAttaches()
  local obj = ChoGGi.CodeFuncs.SelObject()
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001105,"Select/mouse over an object (buildings, vehicles, signs, rocky outcrops)."),ChoGGi.ComFuncs.Trans(302535920000016,"Colour"))
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
      hint = ChoGGi.ComFuncs.Trans(302535920001106,"Change main object colours.")
    }
    local Attaches = obj:GetAttaches()
    for i = 1, #Attaches do
      ItemList[#ItemList+1] = {
        text = Attaches[i].class,
        value = Attaches[i].class,
        parentobj = obj,
        obj = Attaches[i],
        hint = ChoGGi.ComFuncs.Trans(302535920001107,"Change colours of an attached object.")
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
    title = ChoGGi.ComFuncs.Trans(302535920000692,"Change Colour") .. ": " .. ChoGGi.CodeFuncs.RetName(obj),
    hint = ChoGGi.ComFuncs.Trans(302535920001108,"Double click to open object/attachment to edit."),
    custom_type = 1,
  })
end

function ChoGGi.MenuFuncs.SetObjectOpacity()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end
  local hint_loop = ChoGGi.ComFuncs.Trans(302535920001109,"Loops though and makes all") .. " "
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset") .. ": " .. ChoGGi.ComFuncs.Trans(3984,"Anomalies"),value = "Anomaly",hint = hint_loop .. ChoGGi.ComFuncs.Trans(302535920001110,"anomalies visible.")},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset") .. ": " .. ChoGGi.ComFuncs.Trans(3980,"Buildings"),value = "Building",hint = hint_loop .. ChoGGi.ComFuncs.Trans(302535920001111,"buildings visible.")},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset") .. ": " .. ChoGGi.ComFuncs.Trans(302535920000157,"Cables & Pipes"),value = "ChoGGi_GridElements",hint = hint_loop .. ChoGGi.ComFuncs.Trans(302535920001113,"pipes and cables visible.")},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset") .. ": " .. ChoGGi.ComFuncs.Trans(547,"Colonists"),value = "Colonists",hint = hint_loop .. ChoGGi.ComFuncs.Trans(302535920001114,"colonists visible.")},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset") .. ": " .. ChoGGi.ComFuncs.Trans(3981,"Units"),value = "Unit",hint = hint_loop .. ChoGGi.ComFuncs.Trans(302535920001115,"rovers and drones visible.")},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920001084,"Reset") .. ": " .. ChoGGi.ComFuncs.Trans(3982,"Deposits"),value = "SurfaceDeposit",hint = hint_loop .. ChoGGi.ComFuncs.Trans("surface, subsurface, and terrain deposits visible.")},
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
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000769,"Selected") .. ": " .. choice[1].text,
      ChoGGi.ComFuncs.Trans(302535920001117,"Opacity"),"UI/Icons/Sections/attention.tga"
    )
  end
  local hint = ChoGGi.ComFuncs.Trans(302535920001118,"You can still select items after making them invisible (0), but it may take some effort :).")
  if sel then
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. sel:GetOpacity() .. "\n\n" .. hint
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001120,"Set Opacity") .. ": " .. ChoGGi.CodeFuncs.RetName(sel),
    hint = hint,
  })
end

function ChoGGi.MenuFuncs.DisableTextureCompression_Toggle()
  ChoGGi.UserSettings.DisableTextureCompression = not ChoGGi.UserSettings.DisableTextureCompression
  hr.TR_ToggleTextureCompression = 1

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001121,"Texture Compression") .. ": " .. tostring(ChoGGi.UserSettings.DisableTextureCompression),
    ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
  )
end

function ChoGGi.MenuFuncs.InfopanelCheats_Toggle()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.ComFuncs.SetSavedSetting("ToggleInfopanelCheats",config.BuildingInfopanelCheats)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ToggleInfopanelCheats) .. ChoGGi.ComFuncs.Trans(302535920001122,": HAXOR"),
    ChoGGi.ComFuncs.Trans(27,"Cheats"),"UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle()
  ChoGGi.UserSettings.CleanupCheatsInfoPane = not ChoGGi.UserSettings.CleanupCheatsInfoPane

  if ChoGGi.UserSettings.CleanupCheatsInfoPane then
    ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.CleanupCheatsInfoPane) .. ": " .. ChoGGi.ComFuncs.Trans(302535920001123,"Cleanup"),
    ChoGGi.ComFuncs.Trans(27,"Cheats"),"UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
  const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
  ChoGGi.ComFuncs.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ExplorationQueueMaxSize) .. ChoGGi.ComFuncs.Trans(302535920001124,": scans at a time."),
    ChoGGi.ComFuncs.Trans(302535920001125,"Scanner"),"UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.MenuFuncs.SetGameSpeed()
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = 1},
    {text = "1 " .. ChoGGi.ComFuncs.Trans(302535920001126,"Double"),value = 2},
    {text = "2 " .. ChoGGi.ComFuncs.Trans(302535920001127,"Triple"),value = 3},
    {text = "3 " .. ChoGGi.ComFuncs.Trans(302535920001128,"Quadruple"),value = 4},
    {text = "4 " .. ChoGGi.ComFuncs.Trans(302535920001129,"Octuple"),value = 8},
    {text = "5 " .. ChoGGi.ComFuncs.Trans(302535920001130,"Sexdecuple"),value = 16},
    {text = "6 " .. ChoGGi.ComFuncs.Trans(302535920001131,"Duotriguple"),value = 32},
    {text = "7 " .. ChoGGi.ComFuncs.Trans(302535920001132,"Quattuorsexaguple"),value = 64},
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
      current = ChoGGi.ComFuncs.Trans(302535920000982,"Custom") .. ": " .. const.mediumGameSpeed .. " < " .. ChoGGi.ComFuncs.Trans(302535920001134,"base number 3 multipled by custom amount")
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ChoGGi.ComFuncs.Trans(302535920001135,": Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono."),
        ChoGGi.ComFuncs.Trans(302535920001136,"Speed"),"UI/Icons/Notifications/timer.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001137,"Set Game Speed"),
    hint = ChoGGi.ComFuncs.Trans(302535920000933,"Current speed") .. ": " .. current,
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
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001139,"You need to select an object."),ChoGGi.ComFuncs.Trans(155,"Entity"))
    return
  end

  local hint_noanim = ChoGGi.ComFuncs.Trans(302535920001140,"No animation.")
  if #entity_table == 0 then
    entity_table = {
      {text = "  " .. ChoGGi.ComFuncs.Trans(302535920001141,"Default Entity"),value = "Default"},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001142,"Kosmonavt"),value = "Kosmonavt"},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001143,"Jama"),value = "Lama"},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001144,"Green Man"),value = "GreenMan"},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001145,"Planet Mars"),value = "PlanetMars",hint = hint_noanim},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001146,"Planet Earth"),value = "PlanetEarth",hint = hint_noanim},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001147,"Rocket Small"),value = "RocketUI",hint = hint_noanim},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001148,"Rocket Regular"),value = "Rocket",hint = hint_noanim},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001149,"Combat Rover"),value = "CombatRover",hint = hint_noanim},
      {text = " " .. ChoGGi.ComFuncs.Trans(302535920001150,"PumpStation Demo"),value = "PumpStationDemo",hint = hint_noanim},
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000039,"Don't pick both checkboxes next time..."),ChoGGi.ComFuncs.Trans(155,"Entity"))
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. sel.class,ChoGGi.ComFuncs.Trans(155,"Entity"))
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001151,"Set Entity For") .. " " .. ChoGGi.CodeFuncs.RetName(sel),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. (sel.ChoGGi_OrigEntity or sel.entity) .. "\n" .. ChoGGi.ComFuncs.Trans(302535920001157,"If you don't pick a checkbox it will change all of selected type.") .. "\n\n" .. ChoGGi.ComFuncs.Trans(302535920001153,"Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).\n\nNot permanent for colonists after they exit buildings (for now)."),
    check1 = ChoGGi.ComFuncs.Trans(302535920000750,"Dome Only"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920000751,"Will only apply to colonists in the same dome as selected colonist."),
    check2 = ChoGGi.ComFuncs.Trans(302535920000752,"Selected Only"),
    check2_hint = ChoGGi.ComFuncs.Trans(302535920000753,"Will only apply to selected colonist."),
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
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001154,"You need to select an object."),ChoGGi.ComFuncs.Trans(1000081,"Scale"))
    return
  end

  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = 100},
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000039,"Don't pick both checkboxes next time..."),ChoGGi.ComFuncs.Trans(1000081,"Scale"))
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. sel.class,ChoGGi.ComFuncs.Trans(1000081,"Scale"))
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001155,"Set Entity Scale For") .. " " .. ChoGGi.CodeFuncs.RetName(sel),
    hint = ChoGGi.ComFuncs.Trans(302535920001156,"Current object") .. ": " .. sel:GetScale() .. "\n" .. ChoGGi.ComFuncs.Trans(302535920001157,"If you don't pick a checkbox it will change all of selected type."),
    check1 = ChoGGi.ComFuncs.Trans(302535920000750,"Dome Only"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920000751,"Will only apply to colonists in the same dome as selected colonist."),
    check2 = ChoGGi.ComFuncs.Trans(302535920000752,"Selected Only"),
    check2_hint = ChoGGi.ComFuncs.Trans(302535920000753,"Will only apply to selected colonist."),
  })
end
