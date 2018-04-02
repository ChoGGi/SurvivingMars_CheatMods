function ChoGGi.DroneBatteryInfiniteToggle()
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

function ChoGGi.DroneBuildSpeedToggle()
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

function ChoGGi.RCRoverDroneRechargeFreeToggle()
  Consts.RCRoverDroneRechargeCost = ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,0,ChoGGi.Consts.RCRoverDroneRechargeCost)
  ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost = Consts.RCRoverDroneRechargeCost
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost .. ": More where that came from",
    "RC","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCTransportResourceToggle()
  Consts.RCRoverTransferResourceWorkTime = ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime)
  Consts.RCTransportGatherResourceWorkTime = ChoGGi.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.RCTransportGatherResourceWorkTime())
  ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime = Consts.RCRoverTransferResourceWorkTime
  ChoGGi.CheatMenuSettings.RCTransportGatherResourceWorkTime = Consts.RCTransportGatherResourceWorkTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime .. ": Slight of hand",
    "RC","UI/Icons/IPButtons/resources_section.tga"
  )
end

function ChoGGi.DroneMeteorMalfunctionToggle()
  Consts.DroneMeteorMalfunctionChance = ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,ChoGGi.Consts.DroneMeteorMalfunctionChance)
  ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance = Consts.DroneMeteorMalfunctionChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance .. ": I'm singing in the rain. Just singin' in the rain. What a glorious feeling",
    "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.DroneRechargeTimeToggle()
  Consts.DroneRechargeTime = ChoGGi.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime)
  ChoGGi.CheatMenuSettings.DroneRechargeTime = Consts.DroneRechargeTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneRechargeTime .. ": Well, if jacking on'll make strangers think I'm cool, I'll do it!",
    "Drones","UI/Icons/Notifications/low_battery.tga"
  )
end

function ChoGGi.DroneRepairSupplyLeakToggle()
  Consts.DroneRepairSupplyLeak = ChoGGi.NumRetBool(Consts.DroneRepairSupplyLeak,0,ChoGGi.Consts.DroneRepairSupplyLeak)
  ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak = Consts.DroneRepairSupplyLeak
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak .. ": You know what they say about leaky pipes",
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DroneCarryAmount(Bool)
  if Bool == true then
    Consts.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount + 10
  else
    Consts.DroneResourceCarryAmount = ChoGGi.DroneResourceCarryAmount()
  end
  ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DroneResourceCarryAmount .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DronesPerDroneHub(Bool,Which)
  if Bool == true then
    Consts.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones + 25
  else
    Consts.CommandCenterMaxDrones = ChoGGi.CommandCenterMaxDrones()
  end
  ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("RC Drones: " .. Which,
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DronesPerRCRover(Bool,Which)
  if Bool == true then
    Consts.RCRoverMaxDrones = Consts.RCRoverMaxDrones + 25
  else
    Consts.RCRoverMaxDrones = ChoGGi.RCRoverMaxDrones()
  end
  ChoGGi.CheatMenuSettings.RCRoverMaxDrones = Consts.RCRoverMaxDrones
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("RC Drones: " .. Which,
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCTransportStorage(Bool,Which)
  if not UICity.labels.RCTransport then
    if Bool == true then
      ChoGGi.CheatMenuSettings.RCTransportStorage = ChoGGi.CheatMenuSettings.RCTransportStorage + (256 * ChoGGi.Consts.ResourceScale)
    else
      ChoGGi.CheatMenuSettings.RCTransportStorage = ChoGGi.RCTransportResourceCapacity() * ChoGGi.Consts.ResourceScale
    end
  else
    for _,rcvehicle in ipairs(UICity.labels.RCTransport or empty_table) do
      if Bool == true then
        rcvehicle.max_shared_storage = rcvehicle.max_shared_storage + (256 * ChoGGi.Consts.ResourceScale)
        ChoGGi.CheatMenuSettings.RCTransportStorage = rcvehicle.max_shared_storage
      else
        rcvehicle.max_shared_storage = ChoGGi.RCTransportResourceCapacity() * ChoGGi.Consts.ResourceScale
        ChoGGi.CheatMenuSettings.RCTransportStorage = rcvehicle.max_shared_storage
      end
    end
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(" Storage: " .. Which,
    "Drones","UI/Icons/bmc_building_storages_shine.tga"
  )
end

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"DronesAndRCFunc")
end
