function ChoGGi.DroneBatteryInfiniteToggle()
  if Consts.DroneMoveBatteryUse == 0 then
    Consts.DroneMoveBatteryUse = ChoGGi.Consts.DroneMoveBatteryUse
    Consts.DroneCarryBatteryUse = ChoGGi.Consts.DroneCarryBatteryUse
    Consts.DroneConstructBatteryUse = ChoGGi.Consts.DroneConstructBatteryUse
    Consts.DroneBuildingRepairBatteryUse = ChoGGi.Consts.DroneBuildingRepairBatteryUse
    Consts.DroneDeconstructBatteryUse = ChoGGi.Consts.DroneDeconstructBatteryUse
    Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse
  else
    Consts.DroneMoveBatteryUse = 0
    Consts.DroneCarryBatteryUse = 0
    Consts.DroneConstructBatteryUse = 0
    Consts.DroneBuildingRepairBatteryUse = 0
    Consts.DroneDeconstructBatteryUse = 0
    Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = 0
  end
  ChoGGi.CheatMenuSettings.DroneMoveBatteryUse = Consts.DroneMoveBatteryUse
  ChoGGi.CheatMenuSettings.DroneCarryBatteryUse = Consts.DroneCarryBatteryUse
  ChoGGi.CheatMenuSettings.DroneConstructBatteryUse = Consts.DroneConstructBatteryUse
  ChoGGi.CheatMenuSettings.DroneBuildingRepairBatteryUse = Consts.DroneBuildingRepairBatteryUse
  ChoGGi.CheatMenuSettings.DroneDeconstructBatteryUse = Consts.DroneDeconstructBatteryUse
  ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileBatteryUse = Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("What happens when the drones get into your Jolt Cola supply...",
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
  ChoGGi.MsgPopup("What happens when the drones get into your Jolt Cola supply... and drink it",
   "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCRoverDroneRechargeFreeToggle()
  if Consts.RCRoverDroneRechargeCost == 0 then
    Consts.RCRoverDroneRechargeCost = ChoGGi.Consts.RCRoverDroneRechargeCost
  else
    Consts.RCRoverDroneRechargeCost = 0
  end
  ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost = Consts.RCRoverDroneRechargeCost
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("More where that came from",
   "RC","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCTransportResourceToggle()
  if Consts.RCRoverTransferResourceWorkTime == 0 then
    Consts.RCRoverTransferResourceWorkTime = ChoGGi.Consts.RCRoverTransferResourceWorkTime
    Consts.RCTransportGatherResourceWorkTime = ChoGGi.RCTransportGatherResourceWorkTime()
  else
    Consts.RCRoverTransferResourceWorkTime = 0
    Consts.RCTransportGatherResourceWorkTime = 0
  end


  ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime = Consts.RCRoverTransferResourceWorkTime
  ChoGGi.CheatMenuSettings.RCTransportGatherResourceWorkTime = Consts.RCTransportGatherResourceWorkTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Slight of hand",
   "RC","UI/Icons/IPButtons/resources_section.tga"
  )
end

function ChoGGi.DroneMeteorMalfunctionToggle()
  if Consts.DroneMeteorMalfunctionChance == 0 then
    Consts.DroneMeteorMalfunctionChance = ChoGGi.Consts.DroneMeteorMalfunctionChance
  else
    Consts.DroneMeteorMalfunctionChance = 0
  end
  ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance = Consts.DroneMeteorMalfunctionChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("I'm singing in the rain. Just singin' in the rain. What a glorious feeling",
   "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.DroneRechargeTimeToggle()
  if Consts.DroneRechargeTime == 0 then
    Consts.DroneRechargeTime = ChoGGi.Consts.DroneRechargeTime
  else
    Consts.DroneRechargeTime = 0
  end
  ChoGGi.CheatMenuSettings.DroneRechargeTime = Consts.DroneRechargeTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Well, if jacking on'll make strangers think I'm cool, I'll do it!",
   "Drones","UI/Icons/Notifications/low_battery.tga"
  )
end

function ChoGGi.DroneRepairSupplyLeakToggle()
  if Consts.DroneRepairSupplyLeak == 0 then
    Consts.DroneRepairSupplyLeak = ChoGGi.Consts.DroneRepairSupplyLeak
  else
    Consts.DroneRepairSupplyLeak = 0
  end
  ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak = Consts.DroneRepairSupplyLeak
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("You know what they say about leaky pipes",
   "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DroneCarryAmount(Bool)
  if Bool then
    Consts.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount + 10
  else
    Consts.DroneResourceCarryAmount = ChoGGi.DroneResourceCarryAmount()
  end
  ChoGGi.CheatMenuSettings.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("What happens when the drones get into your Jolt Cola supply...",
   "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DronesPerDroneHub(Bool)
  if Bool then
    Consts.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones + 25
  else
    Consts.CommandCenterMaxDrones = ChoGGi.CommandCenterMaxDrones()
  end
  ChoGGi.CheatMenuSettings.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("AI's taking over",
   "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.DronesPerRCRover(Bool)
  if Bool then
    Consts.RCRoverMaxDrones = Consts.RCRoverMaxDrones + 25
  else
    Consts.RCRoverMaxDrones = ChoGGi.RCRoverMaxDrones()
  end
  ChoGGi.CheatMenuSettings.RCRoverMaxDrones = Consts.RCRoverMaxDrones
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("AI's taking over",
   "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.RCTransportStorage(Bool)
  if Bool then
    for _,rcvehicle in ipairs(UICity.labels.RCTransport or empty_table) do
      rcvehicle.max_shared_storage = rcvehicle.max_shared_storage + (100 * ChoGGi.Consts.ResourceScale)
    end
  else
    for _,rcvehicle in ipairs(UICity.labels.RCTransport or empty_table) do
      rcvehicle.max_shared_storage = ChoGGi.RCTransportResourceCapacity() * ChoGGi.Consts.ResourceScale
    end
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("I laugh at your 30 spaces",
   "Drones","UI/Icons/bmc_building_storages_shine.tga"
  )
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: FuncsGameplayDronesAndRC.lua",true)
end
