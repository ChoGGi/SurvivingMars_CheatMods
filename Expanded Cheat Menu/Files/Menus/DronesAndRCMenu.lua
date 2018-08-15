-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

local iconD = "ShowAll.tga"
local iconRC = "HostGame.tga"

local Actions = ChoGGi.Temp.Actions

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000505--[[Work Radius RC Rover--]]]),
  ChoGGi.MenuFuncs.SetRoverWorkRadius,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverMaxRadius,
      302535920000506--[[Change RC Rover drone radius (this ignores slider).--]]
    )
  end,
  "DisableRMMaps.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000507--[[Work Radius DroneHub--]]]),
  ChoGGi.MenuFuncs.SetDroneHubWorkRadius,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CommandCenterMaxRadius,
      302535920000508--[[Change DroneHub drone radius (this ignores slider).--]]
    )
  end,
  "DisableRMMaps.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000509--[[Drone Rock To Concrete Speed--]]]),
  ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount,
      302535920000510--[[How long it takes drones to convert rock to concrete.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000511--[[Drone Move Speed--]]]),
  ChoGGi.MenuFuncs.SetDroneMoveSpeed,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedDrone,
      302535920000512--[[How fast drones will move.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000513--[[Change Amount Of Drones In Hub--]]]),
  ChoGGi.MenuFuncs.SetDroneAmountDroneHub,
  ChoGGi.UserSettings.KeyBindings.SetDroneAmountDroneHub,
  302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).--]],
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000515--[[DroneFactory Build Speed--]]]),
  ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneFactoryBuildSpeed,
      302535920000516--[[Change how fast drone factories build drones.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000517--[[Drone Gravity--]]]),
  ChoGGi.MenuFuncs.SetGravityDrones,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.GravityDrone,
      302535920000518--[[Change gravity of Drones.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000519--[[Drone Battery Infinite--]]]),
  ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneMoveBatteryUse,
      302535920000519--[[Drone Battery Infinite--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000521--[[Drone Build Speed--]]]),
  ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneConstructAmount,
      302535920000522--[[Instant build/repair when resources are ready.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000523--[[Drone Meteor Malfunction--]]]),
  ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneMeteorMalfunctionChance,
      302535920000524--[[Drones will not malfunction when close to a meteor impact site.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[4645--[[Drone Recharge Time--]]]),
  ChoGGi.MenuFuncs.DroneRechargeTime_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneRechargeTime,
      302535920000526--[[Faster/Slower Drone Recharge.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000527--[[Drone Repair Supply Leak Speed--]]]),
  ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneRepairSupplyLeak,
      302535920000528--[[Faster Drone fix supply leak.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000529--[[Drone Carry Amount--]]]),
  ChoGGi.MenuFuncs.SetDroneCarryAmount,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneResourceCarryAmount,
      302535920000530--[[Change amount drones can carry.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000531--[[Drones Per Drone Hub--]]]),
  ChoGGi.MenuFuncs.SetDronesPerDroneHub,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CommandCenterMaxDrones,
      302535920000532--[[Change amount of drones Drone Hubs will command.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[517--[[Drones--]]],"/",S[302535920000533--[[Drones Per RC Rover--]]]),
  ChoGGi.MenuFuncs.SetDronesPerRCRover,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverMaxDrones,
      302535920000534--[[Change amount of drones RC Rovers will command.--]]
    )
  end,
  iconD
)

-------------Shuttles
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[745--[[Shuttles--]]],"/",S[302535920000535--[[Set ShuttleHub Shuttle Capacity--]]]),
  ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity,
  nil,
  function()
    local ChoGGi = ChoGGi
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.BuildingSettings.ShuttleHub and ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles,
      302535920000536--[[Change amount of shuttles per shuttlehub.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[745--[[Shuttles--]]],"/",S[302535920000537--[[Set Capacity--]]]),
  ChoGGi.MenuFuncs.SetShuttleCapacity,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageShuttle,
      302535920000538--[[Change capacity of shuttles.--]]
    )
  end,
  "scale_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[745--[[Shuttles--]]],"/",S[302535920000539--[[Set Speed--]]]),
  ChoGGi.MenuFuncs.SetShuttleSpeed,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedShuttle,
      302535920000540--[[Change speed of shuttles.--]]
    )
  end,
  "move_gizmo.tga"
)

-------------RCs
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5438--[[Rovers--]]],"/",S[302535920000541--[[Set Charging Distance--]]]),
  ChoGGi.MenuFuncs.SetRoverChargeRadius,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCChargeDist,
      302535920000542--[[Distance from power lines that rovers can charge.--]]
    )
  end,
  iconRC
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5438--[[Rovers--]]],"/",S[302535920000543--[[RC Move Speed--]]]),
  ChoGGi.MenuFuncs.SetRCMoveSpeed,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedRC,
      302535920000544--[[How fast RCs will move.--]]
    )
  end,
  "move_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5438--[[Rovers--]]],"/",S[302535920000545--[[RC Gravity--]]]),
  ChoGGi.MenuFuncs.SetGravityRC,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.GravityRC,
      302535920000546--[[Change gravity of RCs.--]]
    )
  end,
  iconD
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5438--[[Rovers--]]],"/",S[302535920000547--[[RC Rover Drone Recharge Free--]]]),
  ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverDroneRechargeCost,
      302535920000548--[[No more draining Rover Battery when recharging drones.--]]
    )
  end,
  iconRC
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5438--[[Rovers--]]],"/",S[302535920000549--[[RC Transport Instant Transfer--]]]),
  ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverTransferResourceWorkTime,
      302535920000550--[[RC Rover quick Transfer/Gather resources.--]]
    )
  end,
  "Mirror.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5438--[[Rovers--]]],"/",S[302535920000551--[[RC Transport Storage Capacity--]]]),
  ChoGGi.MenuFuncs.SetRCTransportStorageCapacity,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCTransportStorageCapacity,
      302535920000552--[[Change amount of resources RC Transports can carry.--]]
    )
  end,
  "scale_gizmo.tga"
)
