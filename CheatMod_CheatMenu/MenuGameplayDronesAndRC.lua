UserActions.AddActions({

  ["DroneBatteryInfinite"] = {

    menu = "Gameplay/Drones/Drone Battery Infinite",
    action = function()
      Consts.DroneMoveBatteryUse = 0
      Consts.DroneCarryBatteryUse = 0
      Consts.DroneConstructBatteryUse = 0
      Consts.DroneBuildingRepairBatteryUse = 0
      Consts.DroneDeconstructBatteryUse = 0
      Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = 0
      CheatMenuSettings["DroneMoveBatteryUse"] = 0
      CheatMenuSettings["DroneCarryBatteryUse"] = 0
      CheatMenuSettings["DroneConstructBatteryUse"] = 0
      CheatMenuSettings["DroneBuildingRepairBatteryUse"] = 0
      CheatMenuSettings["DroneDeconstructBatteryUse"] = 0
      CheatMenuSettings["DroneTransformWasteRockObstructorToStockpileBatteryUse"] = 0
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneBatteryInfinite",
        "Drones",
        "What happens when the drones get into your Jolt Cola supply...",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneBatteryDefault"] = {

    menu = "Gameplay/Drones/Drone Battery Default",
    action = function()
      Consts.DroneMoveBatteryUse = 100
      Consts.DroneCarryBatteryUse = 150
      Consts.DroneConstructBatteryUse = 300
      Consts.DroneBuildingRepairBatteryUse = 100
      Consts.DroneDeconstructBatteryUse = 100
      Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = 100
      CheatMenuSettings["DroneMoveBatteryUse"] = 100
      CheatMenuSettings["DroneCarryBatteryUse"] = 100
      CheatMenuSettings["DroneConstructBatteryUse"] = 100
      CheatMenuSettings["DroneBuildingRepairBatteryUse"] = 100
      CheatMenuSettings["DroneDeconstructBatteryUse"] = 100
      CheatMenuSettings["DroneTransformWasteRockObstructorToStockpileBatteryUse"] = 100
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneBatteryDefault",
        "Drones",
        "What happens when the drones get into your Jolt Cola supply...",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneCarryAmountIncrease"] = {

    menu = "Gameplay/Drones/Drone Carry Amount + 10",
    action = function()
      Consts.DroneResourceCarryAmount = Consts.DroneResourceCarryAmount + 10
      CheatMenuSettings["DroneResourceCarryAmount"] = Consts.DroneResourceCarryAmount
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneCarryAmountIncrease",
        "Drones",
        "What happens when the drones get into your Jolt Cola supply...",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneCarryAmountDefault"] = {

    menu = "Gameplay/Drones/Drone Carry Amount Default",
    action = function()
      local CarryAmount = 1
      if UICity:IsTechDiscovered("ArtificialMuscles") then
        CarryAmount = 2
      end
      Consts.DroneResourceCarryAmount = CarryAmount
      CheatMenuSettings["DroneResourceCarryAmount"] = CarryAmount
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneCarryAmountDefault",
        "Drones",
        "What happens when the drones don't get into your Jolt Cola supply...",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneBuildSpeedInstant"] = {

    menu = "Gameplay/Drones/Drone Build Speed Instant",
    description = "Instant build/repair when resources are ready.",
    action = function()
      Consts.DroneConstructAmount = 999900
      Consts.DroneBuildingRepairAmount = 999900
      CheatMenuSettings["DroneConstructAmount"] = 999900
      CheatMenuSettings["DroneBuildingRepairAmount"] = 999900
      WriteSettings()
      --Consts.DroneConstrutionTime = 0
      --Consts.AndroidConstrutionTime = 0
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneBuildSpeedInstant",
        "Drones",
        "What happens when the drones get into your Jolt Cola supply... and drink it",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneBuildSpeedDefault"] = {

    menu = "Gameplay/Drones/Drone Build Speed Default",
    description = "Default build/repair when resources are ready.",
    action = function()
      Consts.DroneConstructAmount = 100
      Consts.DroneBuildingRepairAmount = 5000
      CheatMenuSettings["DroneConstructAmount"] = 100
      CheatMenuSettings["DroneBuildingRepairAmount"] = 5000
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneBuildSpeedDefault",
        "Drones",
        "What happens when the drones don't get into your Jolt Cola supply... and don't drink it",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DronesPerDroneHubIncrease"] = {

    menu = "Gameplay/Drones/Drones Per Drone Hub + 25",
    description = "Command more drones with each hub",
    action = function()
      Consts.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones + 25
      CheatMenuSettings["CommandCenterMaxDrones"] = Consts.CommandCenterMaxDrones
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DronesPerDroneHub200",
        "Drones",
        "AI's taking over",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DronesPerDroneHubDefault"] = {

    menu = "Gameplay/Drones/Drones Per Drone Hub (Default)",
    description = "Command Default drones with each hub",
    action = function()
      local DroneAmount = 20
      if UICity:IsTechDiscovered("DroneSwarm") then
        DroneAmount = 80
      end
      Consts.CommandCenterMaxDrones = DroneAmount
      CheatMenuSettings["CommandCenterMaxDrones"] = DroneAmount
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DronesPerDroneHubDefault",
        "Drones",
        "AI stopped taking over",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DronesPerRCRoverIncrease"] = {

    menu = "Gameplay/Drones/Drones Per RC Rover + 25",
    description = "Command more drones with each rover",
    action = function()
      Consts.RCRoverMaxDrones = Consts.RCRoverMaxDrones + 25
      CheatMenuSettings["RCRoverMaxDrones"] = Consts.RCRoverMaxDrones
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DronesPerRCRoverIncrease",
        "Drones",
        "AI took over",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ["DronesPerRCRoverDefault"] = {

    menu = "Gameplay/Drones/Drones Per RC Rover Default",
    description = "Command Default drones with each rover",
    action = function()
      local DroneAmount = 8
      if UICity:IsTechDiscovered("RoverCommandAI") then
        DroneAmount = 12
      end
      Consts.RCRoverMaxDrones = DroneAmount
      CheatMenuSettings["RCRoverMaxDrones"] = DroneAmount
      WriteSettings()
       CreateRealTimeThread(AddCustomOnScreenNotification(
        "DronesPerRCRoverDefault",
        "Drones",
        "AI lost",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["RCRoverDroneRechargeFree"] = {

    menu = "Gameplay/RC/RC Rover Drone Recharge Free",
    description = "No more draining Rover Battery when recharging drones",
    action = function()
      Consts.RCRoverDroneRechargeCost = 0
      CheatMenuSettings["RCRoverDroneRechargeCost"] = 0
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCRoverDroneRechargeFree",
        "RC",
        "More where that came from",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["RCRoverDroneRechargeDefault"] = {

    menu = "Gameplay/RC/RC Rover Drone Recharge Default",
    description = "Default draining Rover Battery when recharging drones",
    action = function()
      Consts.RCRoverDroneRechargeCost = 15000
      CheatMenuSettings["RCRoverDroneRechargeCost"] = 15000
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCRoverDroneRechargeDefault",
        "RC",
        "More where that came from",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["RCTransportResourceFast"] = {

    menu = "Gameplay/RC/RC Transport Resource Fast",
    description = "The time it takes for an RC Rover to Transfer/Gather resources (0 seconds).",
    action = function()
      Consts.RCRoverTransferResourceWorkTime = 0
      Consts.RCTransportGatherResourceWorkTime = 0
      CheatMenuSettings["RCRoverTransferResourceWorkTime"] = 0
      CheatMenuSettings["RCTransportGatherResourceWorkTime"] = 0
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCTransportResourceFast",
        "RC",
        "Slight of hand",
        "UI/Icons/IPButtons/resources_section.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["RCTransportResourceDefault"] = {

    menu = "Gameplay/RC/RC Transport Resource Default",
    description = "The time it takes for an RC Rover to Transfer/Gather resources (Default).",
    action = function()
      Consts.RCRoverTransferResourceWorkTime = 1000
      local ResourceWorkTime = 15000
      if UICity:IsTechDiscovered("TransportOptimization") then
        ResourceWorkTime = 7500
      end
      Consts.RCTransportGatherResourceWorkTime = ResourceWorkTime
      CheatMenuSettings["RCRoverTransferResourceWorkTime"] = 1000
      CheatMenuSettings["RCTransportGatherResourceWorkTime"] = ResourceWorkTime
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCTransportResourceDefault",
        "RC",
        "Slight of hand",
        "UI/Icons/IPButtons/resources_section.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneMeteorMalfunctionDisable"] = {

    menu = "Gameplay/Drones/Drone Meteor Malfunction Disable",
    description = "Drones will not malfunction when close to a meteor impact site.",
    action = function()
      Consts.DroneMeteorMalfunctionChance = 0
      CheatMenuSettings["DroneMeteorMalfunctionChance"] = 0
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneMeteorMalfunctionDisable",
        "Drones",
        "I'm singing in the rain. Just singin' in the rain. What a glorious feeling",
        "UI/Icons/Notifications/meteor_storm.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneMeteorMalfunctionDefault"] = {

    menu = "Gameplay/Drones/Drone Meteor Malfunction Default",
    description = "Drones may malfunction when close to a meteor impact site.",
    action = function()
      Consts.DroneMeteorMalfunctionChance = 50
      CheatMenuSettings["DroneMeteorMalfunctionChance"] = 50
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneMeteorMalfunctionDefault",
        "Drones",
        "Off to a rocky start...",
        "UI/Icons/Notifications/meteor_storm.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ["DroneRechargeTimeFast"] = {

    menu = "Gameplay/Drones/Drone Recharge Time Fast",
    description = "The time it takes for a Drone to be fully recharged (0 seconds).",
    action = function()
      Consts.DroneRechargeTime = 0
      CheatMenuSettings["DroneRechargeTime"] = 0
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneRechargeTimeFast",
        "Drones",
        "Well, if jacking on'll make strangers think I'm cool, I'll do it!",
        "UI/Icons/Notifications/low_battery.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ["DroneRechargeTimeDefault"] = {

    menu = "Gameplay/Drones/Drone Recharge Time Default",
    description = "The time it takes for a Drone to be fully recharged (Default).",
    action = function()
      Consts.DroneRechargeTime = 40000
      CheatMenuSettings["DroneRechargeTime"] = 40000
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneRechargeTimeDefault",
        "Drones",
        "Well, if jacking on'll make strangers think I'm cool, I'll do it!",
        "UI/Icons/Notifications/low_battery.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ["DroneRepairSupplyLeakFast"] = {

    menu = "Gameplay/Drones/Drone Repair Supply Leak Fast",
    description = "The amount of time in seconds it takes a Drone to fix a supply leak (0 seconds).",
    action = function()
      Consts.DroneRepairSupplyLeak = 0
      CheatMenuSettings["DroneRepairSupplyLeak"] = 0
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneRepairSupplyLeakFast",
        "Drones",
        "You know what they say about leaky pipes",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["DroneRepairSupplyLeakDefault"] = {

    menu = "Gameplay/Drones/Drone Repair Supply Leak Default",
    description = "The amount of time in seconds it takes a Drone to fix a supply leak (Default).",
    action = function()
      Consts.DroneRepairSupplyLeak = 180
      CheatMenuSettings["DroneRepairSupplyLeak"] = 180
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "DroneRepairSupplyLeakDefault",
        "Drones",
        "You know what they say about leaky pipes",
        "UI/Icons/IPButtons/drone.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ["RCTransportStorageIncrease"] = {

    menu = "Gameplay/RC/RC Transport Storage Increase + 100",
    description = "Adds 100 to Transport Storage",
    action = function()
      local rcvehicles = UICity.labels.RCTransport or empty_table
      for _,rcvehicle in ipairs(rcvehicles) do
        rcvehicle.max_shared_storage = rcvehicle.max_shared_storage + (100 * const.ResourceScale)
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCTransportStorageIncrease",
        "RC",
        "I chuckle at your 30 spaces",
        "UI/Icons/bmc_building_storages_shine.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["RCTransportStorageDefault"] = {

    menu = "Gameplay/RC/RC Transport Storage Default",
    description = "I miss 30 spaces",
    action = function()
      local rcvehicles = UICity.labels.RCTransport or empty_table
      local TransportSpace = 30
      if UICity:IsTechDiscovered("TransportOptimization") then
        TransportSpace = 45
      end
      for _,rcvehicle in ipairs(rcvehicles) do
        rcvehicle.max_shared_storage = TransportSpace * const.ResourceScale
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCTransportStorageDefault",
        "RC",
        "Default space",
        "UI/Icons/bmc_building_storages_shine.tga",
        nil,
        {expiration=5000})
      )
    end
  },
})
