UserActions.AddActions({

  ChoGGi_DroneBatteryInfiniteToggle = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Battery Infinite Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
      return action .. " Drone Battery Infinite."
    end,
    action = ChoGGi.DroneBatteryInfiniteToggle
  },

  ChoGGi_DroneBuildSpeedToggle = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Build Speed Toggle",
    description = function()
      local action
      if Consts.DroneConstructAmount == 999900 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Instant build/repair when resources are ready."
    end,
    action = ChoGGi.DroneBuildSpeedToggle
  },

  ChoGGi_RCRoverDroneRechargeFreeToggle = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/RC/RC Rover Drone Recharge Free Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
      return action .. " No more draining Rover Battery when recharging drones."
    end,
    action = ChoGGi.RCRoverDroneRechargeFreeToggle
  },

  ChoGGi_RCTransportResourceToggle = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/RC/RC Transport Resource Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
      return action .. " RC Rover quick Transfer/Gather resources."
    end,
    action = ChoGGi.RCTransportResourceToggle
  },

  ChoGGi_DroneMeteorMalfunctionToggle = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Meteor Malfunction Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
      return action .. " Drones will not malfunction when close to a meteor impact site."
    end,
    action = ChoGGi.DroneMeteorMalfunctionToggle
  },

  ChoGGi_DroneRechargeTimeToggle = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Recharge Time Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
      return action .. " Faster Drone Recharge."
    end,
    action = ChoGGi.DroneRechargeTimeToggle
  },

  ChoGGi_DroneRepairSupplyLeakToggle = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Repair Supply Leak Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.DroneRepairSupplyLeak,"(Disabled)","(Enabled)")
      return action .. " Faster Drone fix supply leak."
    end,
    action = ChoGGi.DroneRepairSupplyLeakToggle
  },

  ChoGGi_DroneCarryAmountIncrease = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Carry Amount + 10",
    description = function()
      return "Drones carry + 10 items."
    end,
    action = function()
      ChoGGi.DroneCarryAmount(true,ChoGGi.CheatMenuSettings.DroneResourceCarryAmount + 10)
    end
  },

  ChoGGi_DroneCarryAmountDefault = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drone Carry Amount Default",
    description = function()
      return "Drones carry " .. ChoGGi.DroneResourceCarryAmount() .. " items."
    end,
    action = function()
      ChoGGi.DroneCarryAmount(false,ChoGGi.DroneResourceCarryAmount())
    end
  },

  ChoGGi_DronesPerDroneHubIncrease = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drones Per Drone Hub + 25",
    description = function()
      return "Drone hubs command + 25 drones."
    end,
    action = function()
      ChoGGi.DronesPerDroneHub(true,ChoGGi.CheatMenuSettings.CommandCenterMaxDrones + 25)
    end
  },

  ChoGGi_DronesPerDroneHubDefault = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drones Per Drone Hub (Default)",
    description = function()
      return "Drone hubs command " .. ChoGGi.CommandCenterMaxDrones() .. " drones."
    end,
    action = function()
      ChoGGi.DronesPerDroneHub(false,ChoGGi.CommandCenterMaxDrones())
    end
  },

  ChoGGi_DronesPerRCRoverIncrease = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drones Per RC Rover + 25",
    description = function()
      return "RC Rovers command + 25 drones."
    end,
    action = function()
      ChoGGi.DronesPerRCRover(true,ChoGGi.CheatMenuSettings.RCRoverMaxDrones + 25)
    end
  },

  ChoGGi_DronesPerRCRoverDefault = {
    icon = "groups.tga",
    menu = "Gameplay/Drones/Drones Per RC Rover Default",
    description = function()
      return "RC Rovers command " .. ChoGGi.RCRoverMaxDrones() .. " drones."
    end,
    action = function()
      ChoGGi.DronesPerRCRover(false,ChoGGi.RCRoverMaxDrones())
    end
  },

  ChoGGi_RCTransportStorageIncrease = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/RC/RC Transport Storage Increase + 256",
    description = function()
      return "RC Transports can carry + 256 items."
    end,
    action = function()
      ChoGGi.RCTransportStorage(true,(ChoGGi.CheatMenuSettings.RCTransportStorage / ChoGGi.Consts.ResourceScale) + 256)
    end
  },

  ChoGGi_RCTransportStorageDefault = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/RC/RC Transport Storage Default",
    description = function()
      return "RC Transports can carry " .. ChoGGi.RCTransportResourceCapacity() .. " items."
    end,
    action = function()
      ChoGGi.RCTransportStorage(false,ChoGGi.RCTransportResourceCapacity())
    end
  },

})

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuDronesAndRC.lua",true)
end
