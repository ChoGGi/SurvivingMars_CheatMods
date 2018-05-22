function ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  --menus under Gameplay menu without a separate file
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  -------------rockets
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/Cargo Capacity",
    ChoGGi.MenuFuncs.SetRocketCargoCapacity,
    nil,
    "Change amount of storage space in rockets.",
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/Travel Time",
    ChoGGi.MenuFuncs.SetRocketTravelTime,
    nil,
    "Change how long to take to travel between planets.",
    "place_particles.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/Colonists Per Rocket",
    ChoGGi.MenuFuncs.SetColonistsPerRocket,
    nil,
    "Change how many colonists can arrive on Mars in a single Rocket.",
    "ToggleMarkers.tga"
  )

  --------------------capacity
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots Temp",
    ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.StorageMechanizedDepotsTemp and "(Enabled)" or "(Disabled)"
      return des .. " Allow the temporary storage to hold 100 instead of 50 cubes."
    end,
    "Cube.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Worker Capacity",
    ChoGGi.MenuFuncs.SetWorkerCapacity,
    "Ctrl-Shift-W",
    "Change how many workers per building type.",
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Building Capacity",
    ChoGGi.MenuFuncs.SetBuildingCapacity,
    "Ctrl-Shift-C",
    "Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).",
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Building Visitor Capacity",
    ChoGGi.MenuFuncs.SetVisitorCapacity,
    "Ctrl-Shift-V",
    "Set visitors capacity of all buildings of selected type, also applies to newly placed ones.",
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Universal Depot",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    "Change universal storage depot capacity.",
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Other Depot",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    "Change other storage depot capacity.",
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Waste Depot",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    "Change waste storage depot capacity.",
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
    end,
    nil,
    "Change mechanized depot storage capacity.",
    "Cube.tga"
  )

end
