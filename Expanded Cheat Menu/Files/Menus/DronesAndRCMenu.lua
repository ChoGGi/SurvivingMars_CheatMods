--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
local iconD = "ShowAll.tga"
local iconRC = "HostGame.tga"

function ChoGGi.MsgFuncs.DronesAndRCMenu_ChoGGi_Loaded()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000505--[[Work Radius RC Rover--]])),
    ChoGGi.MenuFuncs.SetRoverWorkRadius,
    nil,
    T(302535920000506--[[Change RC Rover drone radius (this ignores slider).--]]),
    "DisableRMMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000507--[[Work Radius DroneHub--]])),
    ChoGGi.MenuFuncs.SetDroneHubWorkRadius,
    nil,
    T(302535920000508--[[Change DroneHub drone radius (this ignores slider).--]]),
    "DisableRMMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000509--[[Drone Rock To Concrete Speed--]])),
    ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed,
    nil,
    T(302535920000510--[[How long it takes drones to convert rock to concrete.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000511--[[Drone Move Speed--]])),
    ChoGGi.MenuFuncs.SetDroneMoveSpeed,
    nil,
    T(302535920000512--[[How fast drones will move.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000513--[[Change Amount Of Drones In Hub--]])),
    ChoGGi.MenuFuncs.SetDroneAmountDroneHub,
    ChoGGi.UserSettings.KeyBindings.SetDroneAmountDroneHub,
    T(302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000515--[[DroneFactory Build Speed--]])),
    ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed,
    nil,
    T(302535920000516--[[Change how fast drone factories build drones.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000517--[[Drone Gravity--]])),
    ChoGGi.MenuFuncs.SetGravityDrones,
    nil,
    T(302535920000518--[[Change gravity of Drones.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000519--[[Drone Battery Infinite--]])),
    ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.DroneMoveBatteryUse,
        302535920000519--[[Drone Battery Infinite--]]
      )
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000521--[[Drone Build Speed--]])),
    ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.DroneConstructAmount,
        302535920000522--[[Instant build/repair when resources are ready.--]]
      )
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000523--[[Drone Meteor Malfunction--]])),
    ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.DroneMeteorMalfunctionChance,
        302535920000524--[[Drones will not malfunction when close to a meteor impact site.--]]
      )
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(4645--[[Drone Recharge Time--]])),
    ChoGGi.MenuFuncs.DroneRechargeTime_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.DroneRechargeTime,
        302535920000526--[[Faster/Slower Drone Recharge.--]]
      )
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000527--[[Drone Repair Supply Leak Speed--]])),
    ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.DroneRepairSupplyLeak,
        302535920000528--[[Faster Drone fix supply leak.--]]
      )
    end,
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000529--[[Drone Carry Amount--]])),
    ChoGGi.MenuFuncs.SetDroneCarryAmount,
    nil,
    T(302535920000530--[[Change amount drones can carry.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000531--[[Drones Per Drone Hub--]])),
    ChoGGi.MenuFuncs.SetDronesPerDroneHub,
    nil,
    T(302535920000532--[[Change amount of drones Drone Hubs will command.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(517--[[Drones--]]),"/",T(302535920000533--[[Drones Per RC Rover--]])),
    ChoGGi.MenuFuncs.SetDronesPerRCRover,
    nil,
    T(302535920000534--[[Change amount of drones RC Rovers will command.--]]),
    iconD
  )

  -------------Shuttles
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(745--[[Shuttles--]]),"/",T(302535920000535--[[Set ShuttleHub Shuttle Capacity--]])),
    ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity,
    nil,
    T(302535920000536--[[Change amount of shuttles per shuttlehub.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(745--[[Shuttles--]]),"/",T(302535920000537--[[Set Capacity--]])),
    ChoGGi.MenuFuncs.SetShuttleCapacity,
    nil,
    T(302535920000538--[[Change capacity of shuttles.--]]),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(745--[[Shuttles--]]),"/",T(302535920000539--[[Set Speed--]])),
    ChoGGi.MenuFuncs.SetShuttleSpeed,
    nil,
    T(302535920000540--[[Change speed of shuttles.--]]),
    "move_gizmo.tga"
  )

  -------------RCs
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5438--[[Rovers--]]),"/",T(302535920000541--[[Set Charging Distance--]])),
    ChoGGi.MenuFuncs.SetRoverChargeRadius,
    nil,
    T(302535920000542--[[Distance from power lines that rovers can charge.--]]),
    iconRC
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5438--[[Rovers--]]),"/",T(302535920000543--[[RC Move Speed--]])),
    ChoGGi.MenuFuncs.SetRCMoveSpeed,
    nil,
    T(302535920000544--[[How fast RCs will move.--]]),
    "move_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5438--[[Rovers--]]),"/",T(302535920000545--[[RC Gravity--]])),
    ChoGGi.MenuFuncs.SetGravityRC,
    nil,
    T(302535920000546--[[Change gravity of RCs.--]]),
    iconD
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5438--[[Rovers--]]),"/",T(302535920000547--[[RC Rover Drone Recharge Free--]])),
    ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.RCRoverDroneRechargeCost,
        302535920000548--[[No more draining Rover Battery when recharging drones.--]]
      )
    end,
    iconRC
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5438--[[Rovers--]]),"/",T(302535920000549--[[RC Transport Instant Transfer--]])),
    ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.RCRoverTransferResourceWorkTime,
        302535920000550--[[RC Rover quick Transfer/Gather resources.--]]
      )
    end,
    "Mirror.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5438--[[Rovers--]]),"/",T(302535920000551--[[RC Transport Storage Capacity--]])),
    ChoGGi.MenuFuncs.SetRCTransportStorageCapacity,
    nil,
    T(302535920000552--[[Change amount of resources RC Transports can carry.--]]),
    "scale_gizmo.tga"
  )

end
