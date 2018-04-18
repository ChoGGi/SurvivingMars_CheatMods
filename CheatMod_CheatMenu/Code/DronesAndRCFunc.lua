function ChoGGi.SetDroneFactoryBuildSpeed()
  local DefaultSetting
  for _,Value in ipairs(DroneFactory:GetProperties()) do
    if Value.id == "performance" then
      DefaultSetting = Value.default
    end
  end

  local ListDisplay = {DefaultSetting,150,250,500,750,500,1000,2500,5000,10000}
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed then
    hint = ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed
  end
  local TempFunc = function(choice)
    if choice == 1 then
      ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed = false
    else
      ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed = ListDisplay[choice]
    end

    for _,Object in ipairs(UICity.labels.DroneFactory or empty_table) do
      Object.performance = ListDisplay[choice]
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Selected: " .. ListDisplay[choice],
      "TITLE","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Caption",1,"Currently: " .. hint)
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

--somewhere above 1000 fucks the save
function ChoGGi.SetDroneCarryAmount()
  --retrieve default
  local DefaultAmount = ChoGGi.GetDroneResourceCarryAmount()
  local ListDisplay = {DefaultAmount,5,10,25,50,75,100,150,250,500,1000}
  local hint = DefaultAmount
  if ChoGGi.CheatMenuSettings.DroneResourceCarryAmount then
    hint = ChoGGi.CheatMenuSettings.DroneResourceCarryAmount
  end
  local TempFunc = function(choice)
    Consts.DroneResourceCarryAmount = ListDisplay[choice]
    g_Consts.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount
    UpdateDroneResourceUnits()

    if choice == 1 then
      ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount
    else
      ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = ListDisplay[choice]
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Drones can carry: " .. ListDisplay[choice] .. " items.",
      "Drones","UI/Icons/IPButtons/drone.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Drone Carry Capacity",1,"Current capacity: " .. hint .. "\n\nWarning: If you set this amount larger then a building's \"Stored\" amount drones will NOT empty those buildings.")
end

function ChoGGi.SetDronesPerDroneHub()
  --retrieve default
  local DefaultAmount = ChoGGi.GetCommandCenterMaxDrones()
  local ListDisplay = {DefaultAmount,50,100,150,250,500,1000}
  local hint
  if ChoGGi.CheatMenuSettings.CommandCenterMaxDrones then
    hint = "Current capacity: " .. ChoGGi.CheatMenuSettings.CommandCenterMaxDrones
  end
  local TempFunc = function(choice)
    Consts.CommandCenterMaxDrones = ListDisplay[choice]
    if choice == 1 then
      ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones
    else
      ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = ListDisplay[choice]
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("DroneHubs can control: " .. ListDisplay[choice] .. " drones.",
      "RC","UI/Icons/IPButtons/drone.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set DroneHub Drone Capacity",1,hint)
end

function ChoGGi.SetDronesPerRCRover()
  --retrieve default
  local DefaultAmount = ChoGGi.GetRCRoverMaxDrones()
  local ListDisplay = {DefaultAmount,50,100,150,250,500,1000}
  local hint
  if ChoGGi.CheatMenuSettings.RCRoverMaxDrones then
    hint = "Current capacity: " .. ChoGGi.CheatMenuSettings.RCRoverMaxDrones
  end
  local TempFunc = function(choice)
    Consts.RCRoverMaxDrones = ListDisplay[choice]
    if choice == 1 then
      ChoGGi.CheatMenuSettings.RCRoverMaxDrones = Consts.RCRoverMaxDrones
    else
      ChoGGi.CheatMenuSettings.RCRoverMaxDrones = ListDisplay[choice]
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC Rovers can control: " .. ListDisplay[choice] .. " drones.",
      "RC","UI/Icons/IPButtons/transport_route.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set RC Rover Drone Capacity",1,hint)
end

--somewhere above 2000 it will fuck the save
function ChoGGi.SetRCTransportStorageCapacity()
  --retrieve default
  local DefaultAmount = ChoGGi.GetRCTransportStorageCapacity() / ChoGGi.Consts.ResourceScale
  local ListDisplay = {DefaultAmount,50,100,250,500,1000,2000}
  local hint = DefaultAmount
  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity then
    hint = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity / ChoGGi.Consts.ResourceScale
  end
  local TempFunc = function(choice)
    local amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    --loop through and set all
    for _,Object in ipairs(UICity.labels.RCTransport or empty_table) do
      Object.max_shared_storage = amount
    end
    --save option for spawned
    if choice == 1 then
      ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = false
    else
      ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = amount
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC Transport capacity is now: " .. ListDisplay[choice],
      "RC","UI/Icons/bmc_building_storages_shine.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set RC Transport Capacity",1,"Current capacity: " .. hint)
end

function ChoGGi.SetShuttleCapacity()
  --retrieve default
  local DefaultAmount
  for _,Value in ipairs(CargoShuttle:GetProperties()) do
    if Value.id == "max_shared_storage" then
      DefaultAmount = Value.default / ChoGGi.Consts.ResourceScale
    end
  end
  local ListDisplay = {DefaultAmount,10,25,50,100,250,500,1000}
  local hint
  if ChoGGi.CheatMenuSettings.StorageShuttle then
    hint = "Current capacity: " .. ChoGGi.CheatMenuSettings.StorageShuttle / ChoGGi.Consts.ResourceScale
  end
  local TempFunc = function(choice)
    --loop through and set all shuttles
    local amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
      object.max_shared_storage = amount
    end
    --save option for spawned shuttles
    if choice == 1 then
      ChoGGi.CheatMenuSettings.StorageShuttle = false
    else
      ChoGGi.CheatMenuSettings.StorageShuttle = amount
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Shuttle storage is now: " .. ListDisplay[choice],
      "Shuttle","UI/Icons/IPButtons/shuttle.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Cargo Shuttle Capacity",1,hint)
end

function ChoGGi.SetShuttleSpeed()
  --retrieve default
  local DefaultAmount
  for _,Value in ipairs(CargoShuttle:GetProperties()) do
    if Value.id == "max_speed" then
      DefaultAmount = Value.default / ChoGGi.Consts.ResourceScale
    end
  end
  local ListDisplay = {DefaultAmount,5,10,15,25,50,100,250,500,1000,10000}
  local hint
  if ChoGGi.CheatMenuSettings.SpeedShuttle then
    hint = "Current speed: " .. ChoGGi.CheatMenuSettings.SpeedShuttle / ChoGGi.Consts.ResourceScale
  end
  local TempFunc = function(choice)
    local amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    --loop through and set all shuttles
    for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
      object.max_speed = amount
    end
    --save option for spawned shuttles
    if choice == 1 then
      ChoGGi.CheatMenuSettings.SpeedShuttle = false
    else
      ChoGGi.CheatMenuSettings.SpeedShuttle = amount
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Shuttle speed is now: " .. ListDisplay[choice],
      "Shuttle","UI/Icons/IPButtons/shuttle.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Cargo Shuttle Speed",1,hint)
end

function ChoGGi.SetShuttleHubCapacity()
  --retrieve default
  local DefaultAmount
  for _,Value in ipairs(ShuttleHub:GetProperties()) do
    if Value.id == "max_shuttles" then
      DefaultAmount = Value.default / ChoGGi.Consts.ResourceScale
    end
  end
  local ListDisplay = {DefaultAmount,25,50,100,250,500,1000}
  local hint
  if ChoGGi.CheatMenuSettings.ShuttleHub then
    hint = "Current capacity: " .. ChoGGi.CheatMenuSettings.ShuttleHub / ChoGGi.Consts.ResourceScale
  end
  local TempFunc = function(choice)
    --loop through and set all shuttles
    for _,object in ipairs(UICity.labels.ShuttleHub or empty_table) do
      object.max_shuttles = ListDisplay[choice]
    end
    --save option for spawned shuttles
    if choice == 1 then
      ChoGGi.CheatMenuSettings.BuildingsCapacity.ShuttleHub = false
    else
      ChoGGi.CheatMenuSettings.BuildingsCapacity.ShuttleHub = ListDisplay[choice]
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("ShuttleHub shuttle capacity is now: " .. ListDisplay[choice],
      "Shuttle","UI/Icons/IPButtons/shuttle.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set ShuttleHub Shuttle Capacity",1,hint)
end

function ChoGGi.SetGravityRC()
  --retrieve default
  local DefaultAmount = 0
  local ListDisplay = {DefaultAmount,1,2,3,4,5,10,25,50,75,100,150,250,500,1000}
  local hint
  if ChoGGi.CheatMenuSettings.GravityRC then
    hint = "Current gravity: " .. ChoGGi.CheatMenuSettings.GravityRC / ChoGGi.Consts.ResourceScale
  end
  local TempFunc = function(choice)
    local amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    --loop through and set all
    for _,Object in ipairs(UICity.labels.Rover or empty_table) do
      Object:SetGravity(amount)
    end
    --save option for spawned
    if choice == 1 then
      ChoGGi.CheatMenuSettings.GravityRC = false
    else
      ChoGGi.CheatMenuSettings.GravityRC = amount
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("RC gravity is now: " .. ListDisplay[choice],
      "RC","UI/Icons/IPButtons/transport_route.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set RC Gravity",6,hint)
end

function ChoGGi.SetGravityDrones()
  --retrieve default
  local DefaultAmount = 0
  local ListDisplay = {DefaultAmount,1,2,3,4,5,10,25,50,75,100,150,250,500}
  local hint
  if ChoGGi.CheatMenuSettings.GravityDrone then
    hint = "Current gravity: " .. ChoGGi.CheatMenuSettings.GravityDrone / ChoGGi.Consts.ResourceScale
  end
  local TempFunc = function(choice)
    local amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    --loop through and set all
    for _,Object in ipairs(UICity.labels.Drone or empty_table) do
      Object:SetGravity(amount)
    end
    --save option for spawned
    if choice == 1 then
      ChoGGi.CheatMenuSettings.GravityDrone = false
    else
      ChoGGi.CheatMenuSettings.GravityDrone = amount
    end

    ChoGGi.WriteSettings()

    ChoGGi.MsgPopup("RC gravity is now: " .. ListDisplay[choice],
      "RC","UI/Icons/IPButtons/transport_route.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Drone Gravity",3,hint)
end
