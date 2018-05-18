local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.DronesAndRCMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  local iconD = "ShowAll.tga"
  local iconRC = "HostGame.tga"

  cComFuncs.AddAction(
    "Expanded CM/Drones/Work Radius RC Rover",
    cMenuFuncs.SetRoverWorkRadius,
    nil,
    "Change RC drone radius.",
    "DisableRMMaps.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Work Radius DroneHub",
    cMenuFuncs.SetDroneHubWorkRadius,
    nil,
    "Change DroneHub drone radius.",
    "DisableRMMaps.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Rock To Concrete Speed",
    cMenuFuncs.SetDroneRockToConcreteSpeed,
    nil,
    "How long it takes drones to convert rock to concrete.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Move Speed",
    cMenuFuncs.SetDroneMoveSpeed,
    nil,
    "How fast drones will move.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Change Amount Of Drones In Hub",
    cMenuFuncs.SetDroneAmountDroneHub,
    "Shift-D",
    "Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/DroneFactory Build Speed",
    cMenuFuncs.SetDroneFactoryBuildSpeed,
    nil,
    "Change how fast drone factories build drones.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Gravity",
    cMenuFuncs.SetGravityDrones,
    nil,
    "Change gravity of Drones.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Battery Infinite",
    cMenuFuncs.DroneBatteryInfinite_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
      return des .. " Drone Battery Infinite."
    end,
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Build Speed",
    cMenuFuncs.DroneBuildSpeed_Toggle,
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

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Meteor Malfunction",
    cMenuFuncs.DroneMeteorMalfunction_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
      return des .. " Drones will not malfunction when close to a meteor impact site."
    end,
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Recharge Time",
    cMenuFuncs.DroneRechargeTime_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
      return des .. " Faster Drone Recharge."
    end,
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Repair Supply Leak Speed",
    cMenuFuncs.DroneRepairSupplyLeak_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.DroneRepairSupplyLeak,"(Disabled)","(Enabled)")
      return des .. " Faster Drone fix supply leak."
    end,
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drone Carry Amount",
    cMenuFuncs.SetDroneCarryAmount,
    nil,
    "Change amount drones can carry.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drones Per Drone Hub",
    cMenuFuncs.SetDronesPerDroneHub,
    nil,
    "Change amount of drones Drone Hubs will command.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Drones/Drones Per RC Rover",
    cMenuFuncs.SetDronesPerRCRover,
    nil,
    "Change amount of drones RC Rovers will command.",
    iconD
  )

  -------------Shuttles
  cComFuncs.AddAction(
    "Expanded CM/Shuttles/Set ShuttleHub Shuttle Capacity",
    cMenuFuncs.SetShuttleHubShuttleCapacity,
    nil,
    "Change amount of shuttles per shuttlehub.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Shuttles/Set Capacity",
    cMenuFuncs.SetShuttleCapacity,
    nil,
    "Change capacity of shuttles.",
    "scale_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Shuttles/Set Speed",
    cMenuFuncs.SetShuttleSpeed,
    nil,
    "Change speed of shuttles.",
    "move_gizmo.tga"
  )

  -------------RCs
  cComFuncs.AddAction(
    "Expanded CM/Rovers/Set Charging Distance",
    cMenuFuncs.SetRoverChargeRadius,
    nil,
    "Distance from power lines that rovers can charge.",
    iconRC
  )

  cComFuncs.AddAction(
    "Expanded CM/Rovers/RC Move Speed",
    cMenuFuncs.SetRCMoveSpeed,
    nil,
    "How fast RCs will move.",
    "move_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Rovers/RC Gravity",
    cMenuFuncs.SetGravityRC,
    nil,
    "Change gravity of RCs.",
    iconD
  )

  cComFuncs.AddAction(
    "Expanded CM/Rovers/RC Rover Drone Recharge Free",
    cMenuFuncs.RCRoverDroneRechargeFree_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
      return des .. " No more draining Rover Battery when recharging drones."
    end,
    iconRC
  )

  cComFuncs.AddAction(
    "Expanded CM/Rovers/RC Transport Instant Transfer",
    cMenuFuncs.RCTransportInstantTransfer_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
      return des .. " RC Rover quick Transfer/Gather resources."
    end,
    "Mirror.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Rovers/RC Transport Storage Capacity",
    cMenuFuncs.SetRCTransportStorageCapacity,
    nil,
    "Change amount of resources RC Transports can carry.",
    "scale_gizmo.tga"
  )

end
