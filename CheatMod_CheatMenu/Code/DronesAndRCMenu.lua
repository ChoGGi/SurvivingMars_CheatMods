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
  "Gameplay/Drones/Drone Battery Infinite",
  ChoGGi.DroneBatteryInfinite_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneMoveBatteryUse,"(Disabled)","(Enabled)")
    return des .. " Drone Battery Infinite."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Build Speed",
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
  "Gameplay/RC/RC Rover Drone Recharge Free",
  ChoGGi.RCRoverDroneRechargeFree_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,"(Disabled)","(Enabled)")
    return des .. " No more draining Rover Battery when recharging drones."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/RC Transport Resource",
  ChoGGi.RCTransportResource_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,"(Disabled)","(Enabled)")
    return des .. " RC Rover quick Transfer/Gather resources."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Meteor Malfunction",
  ChoGGi.DroneMeteorMalfunction_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,"(Disabled)","(Enabled)")
    return des .. " Drones will not malfunction when close to a meteor impact site."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Recharge Time",
  ChoGGi.DroneRechargeTime_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DroneRechargeTime,"(Disabled)","(Enabled)")
    return des .. " Faster Drone Recharge."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Repair Supply Leak Speed",
  ChoGGi.DroneRepairSupplyLeak_Toggle,
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
    ChoGGi.SetDroneCarryAmount(true)
  end,
  nil,
  "Drones will carry + 10 items.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drone Carry Amount (Default)",
  ChoGGi.SetDroneCarryAmount,
  nil,
  function()
    return "Drones will carry " .. ChoGGi.GetDroneResourceCarryAmount() .. " items."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per Drone Hub + 50",
  function()
    ChoGGi.SetDronesPerDroneHub(true)
  end,
  "Ctrl-Shift-D",
  "Drone hubs will command + 50 drones.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per Drone Hub (Default)",
  ChoGGi.SetDronesPerDroneHub,
  nil,
  function()
    return "Drone hubs will command " .. ChoGGi.GetCommandCenterMaxDrones() .. " drones."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per RC Rover + 50",
  function()
    ChoGGi.SetDronesPerRCRover(true)
  end,
  "Ctrl-Shift-R",
  "RC Rovers will command + 50 drones.",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Drones/Drones Per RC Rover (Default)",
  ChoGGi.SetDronesPerRCRover,
  nil,
  function()
    return "RC Rovers will command " .. ChoGGi.GetRCRoverMaxDrones() .. " drones."
  end,
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/RC Transport Storage Increase + 250",
  function()
    ChoGGi.SetRCTransportStorageCapacity(true)
  end,
  "Ctrl-Shift-T",
  "RC Transports will carry + 250 items.",
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/RC/RC Transport Storage (Default)",
  ChoGGi.SetRCTransportStorageCapacity,
  nil,
  function()
    return "RC Transports will carry " .. ChoGGi.GetRCTransportStorageCapacity() / ChoGGi.Consts.ResourceScale .. " items."
  end,
  "ToggleTerrainHeight.tga"
)
