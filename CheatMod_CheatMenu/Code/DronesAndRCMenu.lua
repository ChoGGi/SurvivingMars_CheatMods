function ChoGGi.DronesAndRCMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Expanded CM/Drones/Work Radius RC Rover",
    ChoGGi.SetRoverWorkRadius,
    nil,
    "Change RC drone radius.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Work Radius DroneHub",
    ChoGGi.SetDroneHubWorkRadius,
    nil,
    "Change DroneHub drone radius.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Rock To Concrete Speed",
    ChoGGi.SetRockToConcreteSpeed,
    nil,
    "How long it takes drones to convert rock to concrete.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Move Speed",
    ChoGGi.SetDroneMoveSpeed,
    nil,
    "How fast drones will move.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Change Amount Of Drones In Hub",
    ChoGGi.SetDroneAmountDroneHub,
    "Shift-D",
    "Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/DroneFactory Build Speed",
    ChoGGi.SetDroneFactoryBuildSpeed,
    nil,
    "Change how fast drone factories build drones.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Gravity",
    ChoGGi.SetGravityDrones,
    nil,
    "Change gravity of Drones.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Battery Infinite",
    ChoGGi.DroneBatteryInfinite_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
      return des .. " Drone Battery Infinite."
    end,
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Build Speed",
    ChoGGi.DroneBuildSpeed_Toggle,
    nil,
    function()
      local des
      if Consts.DroneConstructAmount == 999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Instant build/repair when resources are ready."
    end,
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Meteor Malfunction",
    ChoGGi.DroneMeteorMalfunction_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
      return des .. " Drones will not malfunction when close to a meteor impact site."
    end,
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Recharge Time",
    ChoGGi.DroneRechargeTime_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
      return des .. " Faster Drone Recharge."
    end,
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Repair Supply Leak Speed",
    ChoGGi.DroneRepairSupplyLeak_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.DroneRepairSupplyLeak,"(Disabled)","(Enabled)")
      return des .. " Faster Drone fix supply leak."
    end,
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drone Carry Amount",
    ChoGGi.SetDroneCarryAmount,
    nil,
    "Change amount drones can carry.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drones Per Drone Hub",
    ChoGGi.SetDronesPerDroneHub,
    nil,
    "Change amount of drones Drone Hubs will command.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Drones/Drones Per RC Rover",
    ChoGGi.SetDronesPerRCRover,
    nil,
    "Change amount of drones RC Rovers will command.",
    "groups.tga"
  )

  -------------Shuttles
  ChoGGi.AddAction(
    "Expanded CM/Shuttles/Set ShuttleHub Shuttle Amount",
    ChoGGi.SetShuttleHubCapacity,
    nil,
    "Change amount of shuttles per shuttlehub.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Shuttles/Set Capacity",
    ChoGGi.SetShuttleCapacity,
    nil,
    "Change capacity of shuttles.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Shuttles/Set Speed",
    ChoGGi.SetShuttleSpeed,
    nil,
    "Change speed of shuttles.",
    "move_gizmo.tga"
  )

  -------------RCs
  ChoGGi.AddAction(
    "Expanded CM/RC/RC Move Speed",
    ChoGGi.SetRCMoveSpeed,
    nil,
    "How fast RCs will move.",
    "move_gizmo.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/RC/RC Gravity",
    ChoGGi.SetGravityRC,
    nil,
    "Change gravity of RCs.",
    "groups.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/RC/RC Rover Drone Recharge Free",
    ChoGGi.RCRoverDroneRechargeFree_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
      return des .. " No more draining Rover Battery when recharging drones."
    end,
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/RC/RC Transport Instant Transfer",
    ChoGGi.RCTransportInstantTransfer_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
      return des .. " RC Rover quick Transfer/Gather resources."
    end,
    "MeasureTool.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/RC/RC Transport Storage Capacity",
    ChoGGi.SetRCTransportStorageCapacity,
    nil,
    "Change amount of resources RC Transports can carry.",
    "groups.tga"
  )

end
