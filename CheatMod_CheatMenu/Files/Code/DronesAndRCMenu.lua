function ChoGGi.MsgFuncs.DronesAndRCMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  local iconD = "ShowAll.tga"
  local iconRC = "HostGame.tga"

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Work Radius RC Rover",
    ChoGGi.MenuFuncs.SetRoverWorkRadius,
    nil,
    "Change RC drone radius.",
    "DisableRMMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Work Radius DroneHub",
    ChoGGi.MenuFuncs.SetDroneHubWorkRadius,
    nil,
    "Change DroneHub drone radius.",
    "DisableRMMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Rock To Concrete Speed",
    ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed,
    nil,
    "How long it takes drones to convert rock to concrete.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Move Speed",
    ChoGGi.MenuFuncs.SetDroneMoveSpeed,
    nil,
    "How fast drones will move.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Change Amount Of Drones In Hub",
    ChoGGi.MenuFuncs.SetDroneAmountDroneHub,
    "Shift-D",
    "Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/DroneFactory Build Speed",
    ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed,
    nil,
    "Change how fast drone factories build drones.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Gravity",
    ChoGGi.MenuFuncs.SetGravityDrones,
    nil,
    "Change gravity of Drones.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Battery Infinite",
    ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
      return des .. " Drone Battery Infinite."
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Build Speed",
    ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle,
    nil,
    function()
      local des = ""
      if Consts.DroneConstructAmount == 999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Instant build/repair when resources are ready."
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Meteor Malfunction",
    ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
      return des .. " Drones will not malfunction when close to a meteor impact site."
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Recharge Time",
    ChoGGi.MenuFuncs.DroneRechargeTime_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
      return des .. " Faster Drone Recharge."
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Repair Supply Leak Speed",
    ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.DroneRepairSupplyLeak,"(Disabled)","(Enabled)")
      return des .. " Faster Drone fix supply leak."
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drone Carry Amount",
    ChoGGi.MenuFuncs.SetDroneCarryAmount,
    nil,
    "Change amount drones can carry.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drones Per Drone Hub",
    ChoGGi.MenuFuncs.SetDronesPerDroneHub,
    nil,
    "Change amount of drones Drone Hubs will command.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Drones/Drones Per RC Rover",
    ChoGGi.MenuFuncs.SetDronesPerRCRover,
    nil,
    "Change amount of drones RC Rovers will command.",
    iconD
  )

  -------------Shuttles
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Shuttles/Set ShuttleHub Shuttle Capacity",
    ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity,
    nil,
    "Change amount of shuttles per shuttlehub.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Shuttles/Set Capacity",
    ChoGGi.MenuFuncs.SetShuttleCapacity,
    nil,
    "Change capacity of shuttles.",
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Shuttles/Set Speed",
    ChoGGi.MenuFuncs.SetShuttleSpeed,
    nil,
    "Change speed of shuttles.",
    "move_gizmo.tga"
  )

  -------------RCs
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rovers/Set Charging Distance",
    ChoGGi.MenuFuncs.SetRoverChargeRadius,
    nil,
    "Distance from power lines that rovers can charge.",
    iconRC
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rovers/RC Move Speed",
    ChoGGi.MenuFuncs.SetRCMoveSpeed,
    nil,
    "How fast RCs will move.",
    "move_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rovers/RC Gravity",
    ChoGGi.MenuFuncs.SetGravityRC,
    nil,
    "Change gravity of RCs.",
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rovers/RC Rover Drone Recharge Free",
    ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
      return des .. " No more draining Rover Battery when recharging drones."
    end,
    iconRC
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rovers/RC Transport Instant Transfer",
    ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
      return des .. " RC Rover quick Transfer/Gather resources."
    end,
    "Mirror.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rovers/RC Transport Storage Capacity",
    ChoGGi.MenuFuncs.SetRCTransportStorageCapacity,
    nil,
    "Change amount of resources RC Transports can carry.",
    "scale_gizmo.tga"
  )

end
