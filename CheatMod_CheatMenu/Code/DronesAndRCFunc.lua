
function ChoGGi.DismantleAllDronesOfSelectedHub()
  local sel = SelectedObj or SelectionMouseObj()
  while #sel.drones ~= 0 do
    for _,Value in ipairs(sel.drones or empty_table) do
      sel:ConvertDroneToPrefab()
    end
  end
end

function ChoGGi.FillSelectedDroneHubWithDrones()
  local sel = SelectedObj or SelectionMouseObj()
  for i = 1, Consts.CommandCenterMaxDrones do
    sel:UseDronePrefab()
  end
end

function ChoGGi.SetDroneFactoryBuildSpeed()
  local DefaultSetting
  for _,Prop in ipairs(DroneFactory:GetProperties()) do
    if Prop.id == "performance" then
      DefaultSetting = Prop.default
    end
  end
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed then
    hint = ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed
  end
  local CallBackFunc = function(choice)
    local amount = choice[1].value

    if type(amount) == "number" then
      for _,Object in ipairs(UICity.labels.DroneFactory or empty_table) do
        Object.performance = amount
      end
      ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed = amount
    else
      for _,Object in ipairs(UICity.labels.DroneFactory or empty_table) do
        Object.performance = nil
      end
      ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed = false
    end


    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Build Speed: " .. choice[1].text,
      "Drones","UI/Icons/IPButtons/drone.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Factory Build Speed","Currently: " .. hint)
end

function ChoGGi.DroneBatteryInfinite_Toggle()
  Consts.DroneMoveBatteryUse = ChoGGi.NumRetBool(Consts.DroneMoveBatteryUse,0,ChoGGi.Consts.DroneMoveBatteryUse)
  Consts.DroneCarryBatteryUse = ChoGGi.NumRetBool(Consts.DroneCarryBatteryUse,0,ChoGGi.Consts.DroneCarryBatteryUse)
  Consts.DroneConstructBatteryUse = ChoGGi.NumRetBool(Consts.DroneConstructBatteryUse,0,ChoGGi.Consts.DroneConstructBatteryUse)
  Consts.DroneBuildingRepairBatteryUse = ChoGGi.NumRetBool(Consts.DroneBuildingRepairBatteryUse,0,ChoGGi.Consts.DroneBuildingRepairBatteryUse)
  Consts.DroneDeconstructBatteryUse = ChoGGi.NumRetBool(Consts.DroneDeconstructBatteryUse,0,ChoGGi.Consts.DroneDeconstructBatteryUse)
  Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = ChoGGi.NumRetBool(Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse,0,ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse)
  ChoGGi.CheatMenuSettings.DroneMoveBatteryUse = Consts.DroneMoveBatteryUse
  ChoGGi.CheatMenuSettings.DroneCarryBatteryUse = Consts.DroneCarryBatteryUse
  ChoGGi.CheatMenuSettings.DroneConstructBatteryUse = Consts.DroneConstructBatteryUse
  ChoGGi.CheatMenuSettings.DroneBuildingRepairBatteryUse = Consts.DroneBuildingRepairBatteryUse
  ChoGGi.CheatMenuSettings.DroneDeconstructBatteryUse = Consts.DroneDeconstructBatteryUse
  ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileBatteryUse = Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneMoveBatteryUse .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DroneBuildSpeed_Toggle()
  if Consts.DroneConstructAmount == 999900 then
    Consts.DroneConstructAmount = ChoGGi.Consts.DroneConstructAmount
    Consts.DroneBuildingRepairAmount = ChoGGi.Consts.DroneBuildingRepairAmount
  else
    Consts.DroneConstructAmount = 999900
    Consts.DroneBuildingRepairAmount = 999900
  end
  ChoGGi.CheatMenuSettings.DroneConstructAmount = Consts.DroneConstructAmount
  ChoGGi.CheatMenuSettings.DroneBuildingRepairAmount = Consts.DroneBuildingRepairAmount
  ChoGGi.WriteSettings()
  --Consts.DroneConstrutionTime = 0
  --Consts.AndroidConstrutionTime = 0
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneConstructAmount .. ": What happens when the drones get into your Jolt Cola supply... and drink it",
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCRoverDroneRechargeFree_Toggle()
  Consts.RCRoverDroneRechargeCost = ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,0,ChoGGi.Consts.RCRoverDroneRechargeCost)
  ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost = Consts.RCRoverDroneRechargeCost
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost .. ": More where that came from",
    "RC","UI/Icons/IPButtons/transport_route.tga"
  )
end

function ChoGGi.RCTransportInstantTransfer_Toggle()
  Consts.RCRoverTransferResourceWorkTime = ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime)
  Consts.RCTransportGatherResourceWorkTime = ChoGGi.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.GetRCTransportGatherResourceWorkTime())
  ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime = Consts.RCRoverTransferResourceWorkTime
  ChoGGi.CheatMenuSettings.RCTransportGatherResourceWorkTime = Consts.RCTransportGatherResourceWorkTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime .. ": Slight of hand",
    "RC","UI/Icons/IPButtons/resources_section.tga"
  )
end

function ChoGGi.DroneMeteorMalfunction_Toggle()
  Consts.DroneMeteorMalfunctionChance = ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,ChoGGi.Consts.DroneMeteorMalfunctionChance)
  ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance = Consts.DroneMeteorMalfunctionChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance .. ": I'm singing in the rain. Just singin' in the rain. What a glorious feeling",
    "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.DroneRechargeTime_Toggle()
  Consts.DroneRechargeTime = ChoGGi.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime)
  ChoGGi.CheatMenuSettings.DroneRechargeTime = Consts.DroneRechargeTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneRechargeTime .. ": Well, if jacking on'll make strangers think I'm cool, I'll do it!",
    "Drones","UI/Icons/Notifications/low_battery.tga"
  )
end

function ChoGGi.DroneRepairSupplyLeak_Toggle()

  if Consts.DroneRepairSupplyLeak == 1 then
    Consts.DroneRepairSupplyLeak = ChoGGi.Consts.DroneRepairSupplyLeak
  else
    Consts.DroneRepairSupplyLeak = 1
  end
  ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak = Consts.DroneRepairSupplyLeak

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak .. ": You know what they say about leaky pipes",
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.SetDroneCarryAmount()
  --retrieve default
  local DefaultSetting = ChoGGi.GetDroneResourceCarryAmount()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DroneResourceCarryAmount then
    hint = ChoGGi.CheatMenuSettings.DroneResourceCarryAmount
  end

  local CallBackFunc = function(choice)
    local amount = choice[1].value

    if type(amount) == "number" then
      --somewhere above 1000 fucks the save
      if amount > 1000 then
        amount = 1000
      end
      Consts.DroneResourceCarryAmount = amount
      g_Consts.DroneResourceCarryAmount = amount
      UpdateDroneResourceUnits()
      ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = amount
    else
      Consts.DroneResourceCarryAmount = DefaultSetting
      g_Consts.DroneResourceCarryAmount = DefaultSetting
      UpdateDroneResourceUnits()
      ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = DefaultSetting
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Drones can carry: " .. choice[1].text .. " items.",
      "Drones","UI/Icons/IPButtons/drone.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Carry Capacity","Current capacity: " .. hint .. "\n\nWarning: If you set this amount larger then a building's \"Stored\" amount drones will NOT empty those buildings.\n\nMax locked to 1000.")
end

function ChoGGi.SetDronesPerDroneHub()
  local DefaultSetting = ChoGGi.GetCommandCenterMaxDrones()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.CommandCenterMaxDrones then
    hint = ChoGGi.CheatMenuSettings.CommandCenterMaxDrones
  end

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      Consts.CommandCenterMaxDrones = amount
      ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = amount
    else
      Consts.CommandCenterMaxDrones = DefaultSetting
      ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = DefaultSetting
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("DroneHubs can control: " .. choice[1].text .. " drones.",
      "RC","UI/Icons/IPButtons/drone.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Drone Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetDronesPerRCRover()
  local DefaultSetting = ChoGGi.GetRCRoverMaxDrones()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.RCRoverMaxDrones then
    hint = ChoGGi.CheatMenuSettings.RCRoverMaxDrones
  end

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      Consts.RCRoverMaxDrones = amount
      ChoGGi.CheatMenuSettings.RCRoverMaxDrones = amount
    else
      Consts.RCRoverMaxDrones = DefaultSetting
      ChoGGi.CheatMenuSettings.RCRoverMaxDrones = DefaultSetting
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC Rovers can control: " .. choice[1].text .. " drones.",
      "RC","UI/Icons/IPButtons/transport_route.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Rover Drone Capacity","Current capacity: " .. hint)
end

--somewhere above 2000 it will fuck the save
function ChoGGi.SetRCTransportStorageCapacity()
  --retrieve default
  local DefaultSetting = ChoGGi.GetRCTransportStorageCapacity()
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
    {text = 1000,value = 1000 * r},
    {text = 2000,value = 2000 * r},
  }

  local hint = DefaultSetting / r
  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity then
    hint = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity / r
  end

  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      --somewhere above 2000 fucks the save
      if amount > 2000 * r then
        amount = 2000 * r
      end
      --loop through and set all
      for _,Object in ipairs(UICity.labels.RCTransport or empty_table) do
        Object.max_shared_storage = amount
      end
      ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = amount
    else
      for _,Object in ipairs(UICity.labels.RCTransport or empty_table) do
        Object.max_shared_storage = DefaultSetting
      end
      ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC Transport capacity is now: " .. choice[1].text,
      "RC","UI/Icons/bmc_building_storages_shine.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Transport Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetShuttleCapacity()
  --retrieve default
  local DefaultSetting
  for _,Value in ipairs(CargoShuttle:GetProperties()) do
    if Value.id == "max_shared_storage" then
      DefaultSetting = Value.default
    end
  end

  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
    {text = 1000,value = 1000 * r},
  }

  local hint = DefaultSetting / r
  if ChoGGi.CheatMenuSettings.StorageShuttle then
    hint = ChoGGi.CheatMenuSettings.StorageShuttle / r
  end

  local CallBackFunc = function(choice)
    local amount = choice[1].value

    if type(amount) == "number" then
      --not tested but I assume too much = dead save as well
      if amount > 1000 * r then
        amount = 1000 * r
      end
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
        object.max_shared_storage = amount
      end
      ChoGGi.CheatMenuSettings.StorageShuttle = amount
    else
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
        object.max_shared_storage = DefaultSetting
      end
      ChoGGi.CheatMenuSettings.StorageShuttle = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Shuttle storage is now: " .. choice[1].text,
      "Shuttle","UI/Icons/IPButtons/shuttle.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetShuttleSpeed()
  --retrieve default
  local DefaultSetting
  for _,Value in ipairs(CargoShuttle:GetProperties()) do
    if Value.id == "max_speed" then
      DefaultSetting = Value.default
    end
  end
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
    {text = 1000,value = 1000 * r},
    {text = 5000,value = 5000 * r},
    {text = 10000,value = 10000 * r},
    {text = 25000,value = 25000 * r},
    {text = 50000,value = 50000 * r},
    {text = 100000,value = 100000 * r},
  }

  local hint = DefaultSetting / r
  if ChoGGi.CheatMenuSettings.SpeedShuttle then
    hint = ChoGGi.CheatMenuSettings.SpeedShuttle / r
  end

  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
        object.max_speed = amount
      end
      ChoGGi.CheatMenuSettings.SpeedShuttle = amount
    else
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
        object.max_speed = DefaultSetting
      end
      ChoGGi.CheatMenuSettings.SpeedShuttle = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Shuttle speed is now: " .. choice[1].text,
      "Shuttle","UI/Icons/IPButtons/shuttle.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Speed","Current speed: " .. hint)
end

function ChoGGi.SetShuttleHubCapacity()
  --retrieve default
  local DefaultSetting
  for _,Value in ipairs(ShuttleHub:GetProperties()) do
    if Value.id == "max_shuttles" then
      DefaultSetting = Value.default
    end
  end
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.BuildingsCapacity.ShuttleHub then
    hint = ChoGGi.CheatMenuSettings.BuildingsCapacity.ShuttleHub
  end

  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.ShuttleHub or empty_table) do
        object.max_shuttles = amount
      end
      ChoGGi.CheatMenuSettings.BuildingsCapacity.ShuttleHub = amount
    else
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.ShuttleHub or empty_table) do
        object.max_shuttles = DefaultSetting
      end
      ChoGGi.CheatMenuSettings.BuildingsCapacity.ShuttleHub = nil
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("ShuttleHub shuttle capacity is now: " .. choice[1].text,
      "Shuttle","UI/Icons/IPButtons/shuttle.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set ShuttleHub Shuttle Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetGravityRC()
  --retrieve default
  local DefaultSetting = 0
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1 * r},
    {text = 2,value = 2 * r},
    {text = 3,value = 3 * r},
    {text = 4,value = 4 * r},
    {text = 5,value = 5 * r},
    {text = 10,value = 10 * r},
    {text = 15,value = 15 * r},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.GravityRC then
    hint = ChoGGi.CheatMenuSettings.GravityRC / r
  end

  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      for _,Object in ipairs(UICity.labels.Rover or empty_table) do
        Object:SetGravity(amount)
      end
      ChoGGi.CheatMenuSettings.GravityRC = amount
    else
      for _,Object in ipairs(UICity.labels.Rover or empty_table) do
        Object:SetGravity(DefaultSetting)
      end
      ChoGGi.CheatMenuSettings.GravityRC = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC gravity is now: " .. choice[1].text,
      "RC","UI/Icons/IPButtons/transport_route.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Gravity","Current gravity: " .. hint)
end

function ChoGGi.SetGravityDrones()
  --retrieve default
  local DefaultSetting = 0
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1 * r},
    {text = 2,value = 2 * r},
    {text = 3,value = 3 * r},
    {text = 4,value = 4 * r},
    {text = 5,value = 5 * r},
    {text = 10,value = 10 * r},
    {text = 15,value = 15 * r},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.GravityDrone then
    hint = ChoGGi.CheatMenuSettings.GravityDrone / r
  end
  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      --loop through and set all
      for _,Object in ipairs(UICity.labels.Drone or empty_table) do
        Object:SetGravity(amount)
      end
      ChoGGi.CheatMenuSettings.GravityDrone = amount
    else
      --loop through and set all
      for _,Object in ipairs(UICity.labels.Drone or empty_table) do
        Object:SetGravity(DefaultSetting)
      end
      ChoGGi.CheatMenuSettings.GravityDrone = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC gravity is now: " .. choice[1].text,
      "RC","UI/Icons/IPButtons/transport_route.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Gravity","Current gravity: " .. hint)
end
