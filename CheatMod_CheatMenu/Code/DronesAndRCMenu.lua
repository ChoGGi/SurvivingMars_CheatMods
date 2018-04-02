--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

-------------
ChoGGi.AddAction(
  "Gameplay/Drones/Gravity - 1000",
  function()
    ChoGGi.SetGravity(true,1)
  end,
  nil,
  "Lowers the gravity of drones (restart to set newly built ones).",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Gravity (Default)",
  function()
    ChoGGi.SetGravity(nil,1)
  end,
  nil,
  "Default gravity.",
  "groups.tga"
)
-------------
ChoGGi.AddAction(
  "Gameplay/RC/Gravity - 5000",
  function()
    ChoGGi.SetGravity(true,2)
  end,
  nil,
  "Lowers the gravity of RCs.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/Gravity (Default)",
  function()
    ChoGGi.SetGravity(nil,2)
  end,
  nil,
  "Default gravity.",
  "groups.tga"
)
-------------
ChoGGi.AddAction(
  "Gameplay/Drones/Drone Battery Infinite Toggle",
  ChoGGi.DroneBatteryInfiniteToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
    return des .. " Drone Battery Infinite."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Build Speed Toggle",
  ChoGGi.DroneBuildSpeedToggle,
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
  "Gameplay/RC/RC Rover Drone Recharge Free Toggle",
  ChoGGi.RCRoverDroneRechargeFreeToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
    return des .. " No more draining Rover Battery when recharging drones."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/RC Transport Resource Toggle",
  ChoGGi.RCTransportResourceToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
    return des .. " RC Rover quick Transfer/Gather resources."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Meteor Malfunction Toggle",
  ChoGGi.DroneMeteorMalfunctionToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
    return des .. " Drones will not malfunction when close to a meteor impact site."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Recharge Time Toggle",
  ChoGGi.DroneRechargeTimeToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
    return des .. " Faster Drone Recharge."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Repair Supply Leak Toggle",
  ChoGGi.DroneRepairSupplyLeakToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneRepairSupplyLeak,"(Disabled)","(Enabled)")
    return des .. " Faster Drone fix supply leak."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Carry Amount + 10",
  function()
    ChoGGi.DroneCarryAmount(true,ChoGGi.CheatMenuSettings.DroneResourceCarryAmount + 10)
  end,
  nil,
  "Drones carry + 10 items.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Carry Amount (Default)",
  function()
    ChoGGi.DroneCarryAmount(false,ChoGGi.DroneResourceCarryAmount())
  end,
  nil,
  function()
    return "Drones carry " .. ChoGGi.DroneResourceCarryAmount() .. " items."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per Drone Hub + 25",
  function()
    ChoGGi.DronesPerDroneHub(true,ChoGGi.CheatMenuSettings.CommandCenterMaxDrones + 25)
  end,
  "Ctrl-Shift-D",
  "Drone hubs command + 25 drones.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per Drone Hub (Default)",
  function()
    ChoGGi.DronesPerDroneHub(false,ChoGGi.CommandCenterMaxDrones())
  end,
  nil,
  function()
    return "Drone hubs command " .. ChoGGi.CommandCenterMaxDrones() .. " drones."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per RC Rover + 25",
  function()
    ChoGGi.DronesPerRCRover(true,ChoGGi.CheatMenuSettings.RCRoverMaxDrones + 25)
  end,
  "Ctrl-Shift-R",
  "RC Rovers command + 25 drones.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per RC Rover (Default)",
  function()
    ChoGGi.DronesPerRCRover(false,ChoGGi.RCRoverMaxDrones())
  end,
  nil,
  function()
    return "RC Rovers command " .. ChoGGi.RCRoverMaxDrones() .. " drones."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/RC Transport Storage Increase + 256",
  function()
    ChoGGi.RCTransportStorage(true,
      (ChoGGi.CheatMenuSettings.RCTransportStorage / ChoGGi.Consts.ResourceScale) + 256
    )
  end,
  "Ctrl-Shift-T",
  "RC Transports can carry + 256 items.",
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/RC Transport Storage (Default)",
  function()
    ChoGGi.RCTransportStorage(false,ChoGGi.RCTransportResourceCapacity())
  end,
  nil,
  function()
    return "RC Transports can carry " .. ChoGGi.RCTransportResourceCapacity() .. " items."
  end,
  "ToggleTerrainHeight.tga"
)

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"DronesAndRCMenu")
end
