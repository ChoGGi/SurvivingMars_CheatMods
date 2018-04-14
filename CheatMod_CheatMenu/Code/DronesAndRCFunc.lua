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
    "RC","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCTransportResource_Toggle()
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

function ChoGGi.SetDroneCarryAmount(Bool)
  if Bool == true then
    Consts.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount + 10
  else
    Consts.DroneResourceCarryAmount = ChoGGi.GetDroneResourceCarryAmount()
  end
  ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneResourceCarryAmount .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.SetDronesPerDroneHub(Bool,Which)
  if Bool == true then
    Consts.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones + 50
  else
    Consts.CommandCenterMaxDrones = ChoGGi.GetCommandCenterMaxDrones()
  end
  ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("RC Drones: " .. ChoGGi.CheatMenuSettings.CommandCenterMaxDrones,
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.SetDronesPerRCRover(Bool)
  if Bool == true then
    Consts.RCRoverMaxDrones = Consts.RCRoverMaxDrones + 50
  else
    Consts.RCRoverMaxDrones = ChoGGi.GetRCRoverMaxDrones()
  end
  ChoGGi.CheatMenuSettings.RCRoverMaxDrones = Consts.RCRoverMaxDrones
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("RC Drones: " .. ChoGGi.CheatMenuSettings.RCRoverMaxDrones,
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.SetRCTransportStorageCapacity(Bool)
  --update saved amount
  if Bool == true then
    ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity + (250 * ChoGGi.Consts.ResourceScale)
  else
    if ChoGGi.GetRCTransportStorageCapacity() == 45000 then
      ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = ChoGGi.GetRCTransportStorageCapacity()
    else
      ChoGGi.CheatMenuSettings.RCTransportStorageCapacity = ChoGGi.Consts.RCTransportStorageCapacity
    end
  end
  --update each rc
  if UICity.labels.RCTransport and #UICity.labels.RCTransport > 0 then
    for i = 1, #UICity.labels.RCTransport do
      local rcvehicle = UICity.labels.RCTransport[i]
      rcvehicle.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity
      --if it's a negative number something fucked up, so make it the default
      if rcvehicle.max_shared_storage < 0 then
        rcvehicle.max_shared_storage = ChoGGi.GetRCTransportStorageCapacity()
      end
    end
  end
  --for newly placed transports
  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity == 45000 then
    --we need 45 for the already placed rc above, but 30 for ones yet to be placed
    RCTransport.max_shared_storage = 30000
  else
    RCTransport.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(" Storage: " .. ChoGGi.CheatMenuSettings.RCTransportStorageCapacity / ChoGGi.Consts.ResourceScale,
    "RC","UI/Icons/bmc_building_storages_shine.tga"
  )
end
