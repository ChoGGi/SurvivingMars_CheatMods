-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local iconD = "CommonAssets/UI/Menu/ShowAll.tga"
local iconRC = "CommonAssets/UI/Menu/HostGame.tga"

local str_ExpandedCM_Drones = "Expanded CM.Drones"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[517--[[Drones--]]]," .."),
  ActionId = str_ExpandedCM_Drones,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000505--[[Work Radius RC Rover--]]],
  ActionId = "Expanded CM.Drones.Work Radius RC Rover",
  ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverMaxRadius,
      302535920000506--[[Change RC Rover drone radius (this ignores slider).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetRoverWorkRadius,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000507--[[Work Radius DroneHub--]]],
  ActionId = "Expanded CM.Drones.Work Radius DroneHub",
  ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CommandCenterMaxRadius,
      302535920000508--[[Change DroneHub drone radius (this ignores slider).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDroneHubWorkRadius,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000509--[[Drone Rock To Concrete Speed--]]],
  ActionId = "Expanded CM.Drones.Drone Rock To Concrete Speed",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount,
      302535920000510--[[How long it takes drones to convert rock to concrete.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000511--[[Drone Move Speed--]]],
  ActionId = "Expanded CM.Drones.Drone Move Speed",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedDrone,
      302535920000512--[[How fast drones will move.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDroneMoveSpeed,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000513--[[Change Amount Of Drones In Hub--]]],
  ActionId = "Expanded CM.Drones.Change Amount Of Drones In Hub",
  ActionIcon = iconD,
  RolloverText = S[302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).--]]],
  OnAction = ChoGGi.MenuFuncs.SetDroneAmountDroneHub,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetDroneAmountDroneHub,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000515--[[DroneFactory Build Speed--]]],
  ActionId = "Expanded CM.Drones.DroneFactory Build Speed",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneFactoryBuildSpeed,
      302535920000516--[[Change how fast drone factories build drones.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000517--[[Drone Gravity--]]],
  ActionId = "Expanded CM.Drones.Drone Gravity",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.GravityDrone,
      302535920000518--[[Change gravity of Drones.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetGravityDrones,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000519--[[Drone Battery Infinite--]]],
  ActionId = "Expanded CM.Drones.Drone Battery Infinite",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneMoveBatteryUse,
      302535920000519--[[Drone Battery Infinite--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000521--[[Drone Build Speed--]]],
  ActionId = "Expanded CM.Drones.Drone Build Speed",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneConstructAmount,
      302535920000522--[[Instant build/repair when resources are ready.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000523--[[Drone Meteor Malfunction--]]],
  ActionId = "Expanded CM.Drones.Drone Meteor Malfunction",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneMeteorMalfunctionChance,
      302535920000524--[[Drones will not malfunction when close to a meteor impact site.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[4645--[[Drone Recharge Time--]]],
  ActionId = "Expanded CM.Drones.Drone Recharge Time",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneRechargeTime,
      302535920000526--[[Faster/Slower Drone Recharge.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DroneRechargeTime_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000527--[[Drone Repair Supply Leak Speed--]]],
  ActionId = "Expanded CM.Drones.Drone Repair Supply Leak Speed",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneRepairSupplyLeak,
      302535920000528--[[Faster Drone fix supply leak.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000529--[[Drone Carry Amount--]]],
  ActionId = "Expanded CM.Drones.Drone Carry Amount",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DroneResourceCarryAmount,
      302535920000530--[[Change amount drones can carry.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDroneCarryAmount,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000531--[[Drones Per Drone Hub--]]],
  ActionId = "Expanded CM.Drones.Drones Per Drone Hub",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CommandCenterMaxDrones,
      302535920000532--[[Change amount of drones Drone Hubs will command.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDronesPerDroneHub,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Drones,
  ActionName = S[302535920000533--[[Drones Per RC Rover--]]],
  ActionId = "Expanded CM.Drones.Drones Per RC Rover",
  ActionIcon = iconD,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverMaxDrones,
      302535920000534--[[Change amount of drones RC Rovers will command.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetDronesPerRCRover,
}


local str_ExpandedCM_Shuttles = "Expanded CM.Shuttles"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[745--[[Shuttles--]]]," .."),
  ActionId = str_ExpandedCM_Shuttles,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Shuttles,
  ActionName = S[302535920000535--[[Set ShuttleHub Shuttle Capacity--]]],
  ActionId = "Expanded CM.Shuttles.Set ShuttleHub Shuttle Capacity",
  ActionIcon = iconD,
  RolloverText = function()
    local ChoGGi = ChoGGi
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.BuildingSettings.ShuttleHub and ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles,
      302535920000536--[[Change amount of shuttles per shuttlehub.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Shuttles,
  ActionName = S[302535920000537--[[Set Capacity--]]],
  ActionId = "Expanded CM.Shuttles.Set Capacity",
  ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageShuttle,
      302535920000538--[[Change capacity of shuttles.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetShuttleCapacity,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Shuttles,
  ActionName = S[302535920000539--[[Set Speed--]]],
  ActionId = "Expanded CM.Shuttles.Set Speed",
  ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedShuttle,
      302535920000540--[[Change speed of shuttles.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetShuttleSpeed,
}

local str_ExpandedCM_Rovers = "Expanded CM.Rovers"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[5438--[[Rovers--]]]," .."),
  ActionId = str_ExpandedCM_Rovers,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",

  ActionSortKey = "00",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rovers,
  ActionName = S[302535920000541--[[Set Charging Distance--]]],
  ActionId = "Expanded CM.Rovers.Set Charging Distance",
  ActionIcon = iconRC,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCChargeDist,
      302535920000542--[[Distance from power lines that rovers can charge.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetRoverChargeRadius,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rovers,
  ActionName = S[302535920000543--[[RC Move Speed--]]],
  ActionId = "Expanded CM.Rovers.RC Move Speed",
  ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedRC,
      302535920000544--[[How fast RCs will move.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetRCMoveSpeed,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rovers,
  ActionName = S[302535920000545--[[RC Gravity--]]],
  ActionId = "Expanded CM.Rovers.RC Gravity",
  ActionIcon = iconRC,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.GravityRC,
      302535920000546--[[Change gravity of RCs.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetGravityRC,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rovers,
  ActionName = S[302535920000547--[[RC Rover Drone Recharge Free--]]],
  ActionId = "Expanded CM.Rovers.RC Rover Drone Recharge Free",
  ActionIcon = iconRC,
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverDroneRechargeCost,
      302535920000548--[[No more draining Rover Battery when recharging drones.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rovers,
  ActionName = S[302535920000549--[[RC Transport Instant Transfer--]]],
  ActionId = "Expanded CM.Rovers.RC Transport Instant Transfer",
  ActionIcon = "CommonAssets/UI/Menu/Mirror.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCRoverTransferResourceWorkTime,
      302535920000550--[[RC Rover quick Transfer/Gather resources.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rovers,
  ActionName = S[302535920000551--[[RC Transport Storage Capacity--]]],
  ActionId = "Expanded CM.Rovers.RC Transport Storage Capacity",
  ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RCTransportStorageCapacity,
      302535920000552--[[Change amount of resources RC Transports can carry.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetRCTransportStorageCapacity,
}

local str_ExpandedCM_Rockets = "Expanded CM.Rockets"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[5238--[[Rockets--]]]," .."),
  ActionId = str_ExpandedCM_Rockets,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rockets,
  ActionName = S[302535920000850--[[Change Resupply Settings--]]],
  ActionId = "Expanded CM.Rockets.Change Resupply Settings",
  ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
  RolloverText = S[302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeResupplySettings,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rockets,
  ActionName = S[302535920000557--[[Launch Empty Rocket--]]],
  ActionId = "Expanded CM.Rockets.Launch Empty Rocket",
  ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
  RolloverText = S[302535920000558--[[Launches an empty rocket to Mars.--]]],
  OnAction = ChoGGi.MenuFuncs.LaunchEmptyRocket,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rockets,
  ActionName = S[302535920000559--[[Cargo Capacity--]]],
  ActionId = "Expanded CM.Rockets.Cargo Capacity",
  ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CargoCapacity,
      302535920000560--[[Change amount of storage space in rockets.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetRocketCargoCapacity,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rockets,
  ActionName = S[302535920000561--[[Travel Time--]]],
  ActionId = "Expanded CM.Rockets.Travel Time",
  ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.TravelTimeEarthMars,
      302535920000562--[[Change how long to take to travel between planets.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetRocketTravelTime,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Rockets,
  ActionName = S[4594--[[Colonists Per Rocket--]]],
  ActionId = "Expanded CM.Rockets.4594--[[Colonists Per Rocket",
  ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
  RolloverText = S[302535920000564--[[Change how many colonists can arrive on Mars in a single Rocket.--]]],
  OnAction = ChoGGi.MenuFuncs.SetColonistsPerRocket,
}
