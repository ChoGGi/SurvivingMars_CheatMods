local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.DronesAndRCMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  local iconD = "ShowAll.tga"
  local iconRC = "HostGame.tga"

  CComFuncs.AddAction(
    "Expanded CM/Drones/Work Radius RC Rover",
    CMenuFuncs.SetRoverWorkRadius,
    nil,
    "Change RC drone radius.",
    "DisableRMMaps.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Work Radius DroneHub",
    CMenuFuncs.SetDroneHubWorkRadius,
    nil,
    "Change DroneHub drone radius.",
    "DisableRMMaps.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Rock To Concrete Speed",
    CMenuFuncs.SetDroneRockToConcreteSpeed,
    nil,
    "How long it takes drones to convert rock to concrete.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Move Speed",
    CMenuFuncs.SetDroneMoveSpeed,
    nil,
    "How fast drones will move.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Change Amount Of Drones In Hub",
    CMenuFuncs.SetDroneAmountDroneHub,
    "Shift-D",
    "Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/DroneFactory Build Speed",
    CMenuFuncs.SetDroneFactoryBuildSpeed,
    nil,
    "Change how fast drone factories build drones.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Gravity",
    CMenuFuncs.SetGravityDrones,
    nil,
    "Change gravity of Drones.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Battery Infinite",
    CMenuFuncs.DroneBatteryInfinite_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
      return des .. " Drone Battery Infinite."
    end,
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Build Speed",
    CMenuFuncs.DroneBuildSpeed_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Meteor Malfunction",
    CMenuFuncs.DroneMeteorMalfunction_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
      return des .. " Drones will not malfunction when close to a meteor impact site."
    end,
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Recharge Time",
    CMenuFuncs.DroneRechargeTime_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
      return des .. " Faster Drone Recharge."
    end,
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Repair Supply Leak Speed",
    CMenuFuncs.DroneRepairSupplyLeak_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.DroneRepairSupplyLeak,"(Disabled)","(Enabled)")
      return des .. " Faster Drone fix supply leak."
    end,
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drone Carry Amount",
    CMenuFuncs.SetDroneCarryAmount,
    nil,
    "Change amount drones can carry.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drones Per Drone Hub",
    CMenuFuncs.SetDronesPerDroneHub,
    nil,
    "Change amount of drones Drone Hubs will command.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Drones/Drones Per RC Rover",
    CMenuFuncs.SetDronesPerRCRover,
    nil,
    "Change amount of drones RC Rovers will command.",
    iconD
  )

  -------------Shuttles
  CComFuncs.AddAction(
    "Expanded CM/Shuttles/Set ShuttleHub Shuttle Capacity",
    CMenuFuncs.SetShuttleHubShuttleCapacity,
    nil,
    "Change amount of shuttles per shuttlehub.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Shuttles/Set Capacity",
    CMenuFuncs.SetShuttleCapacity,
    nil,
    "Change capacity of shuttles.",
    "scale_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Shuttles/Set Speed",
    CMenuFuncs.SetShuttleSpeed,
    nil,
    "Change speed of shuttles.",
    "move_gizmo.tga"
  )

  -------------RCs
  CComFuncs.AddAction(
    "Expanded CM/Rovers/Set Charging Distance",
    CMenuFuncs.SetRoverChargeRadius,
    nil,
    "Distance from power lines that rovers can charge.",
    iconRC
  )

  CComFuncs.AddAction(
    "Expanded CM/Rovers/RC Move Speed",
    CMenuFuncs.SetRCMoveSpeed,
    nil,
    "How fast RCs will move.",
    "move_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Rovers/RC Gravity",
    CMenuFuncs.SetGravityRC,
    nil,
    "Change gravity of RCs.",
    iconD
  )

  CComFuncs.AddAction(
    "Expanded CM/Rovers/RC Rover Drone Recharge Free",
    CMenuFuncs.RCRoverDroneRechargeFree_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
      return des .. " No more draining Rover Battery when recharging drones."
    end,
    iconRC
  )

  CComFuncs.AddAction(
    "Expanded CM/Rovers/RC Transport Instant Transfer",
    CMenuFuncs.RCTransportInstantTransfer_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
      return des .. " RC Rover quick Transfer/Gather resources."
    end,
    "Mirror.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Rovers/RC Transport Storage Capacity",
    CMenuFuncs.SetRCTransportStorageCapacity,
    nil,
    "Change amount of resources RC Transports can carry.",
    "scale_gizmo.tga"
  )

end
