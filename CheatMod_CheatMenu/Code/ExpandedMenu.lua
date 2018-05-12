function ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  --menus under Gameplay menu without a separate file
  --ChoGGi.Funcs.AddAction(Menu,Action,Key,Des,Icon)

  -------------rockets
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Rocket/Cargo Capacity",
    ChoGGi.MenuFuncs.SetRocketCargoCapacity,
    nil,
    "Change amount of storage space in rockets.",
    "scale_gizmo.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Rocket/Travel Time",
    ChoGGi.MenuFuncs.SetRocketTravelTime,
    nil,
    "Change how long to take to travel between planets.",
    "place_particles.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Rocket/Colonists Per Rocket",
    ChoGGi.MenuFuncs.SetColonistsPerRocket,
    nil,
    "Change how many colonists can arrive on Mars in a single Rocket.",
    "ToggleMarkers.tga"
  )

  --------------------capacity
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots Temp",
    ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.StorageMechanizedDepotsTemp and "(Enabled)" or "(Disabled)"
      return des .. " Allow the temporary storage to hold 100 instead of 50 cubes."
    end,
    "Cube.tga"
  )
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Worker Capacity",
    ChoGGi.MenuFuncs.SetWorkerCapacity,
    "Ctrl-Shift-W",
    "Change how many workers per building type.",
    "scale_gizmo.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Building Capacity",
    ChoGGi.MenuFuncs.SetBuildingCapacity,
    "Ctrl-Shift-C",
    "Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).",
    "scale_gizmo.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Building Visitor Capacity",
    ChoGGi.MenuFuncs.SetVisitorCapacity,
    "Ctrl-Shift-V",
    "Set visitors capacity of all buildings of selected type, also applies to newly placed ones.",
    "scale_gizmo.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Storage Universal Depot",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    "Change universal storage depot capacity.",
    "MeasureTool.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Storage Other Depot",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    "Change other storage depot capacity.",
    "MeasureTool.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Storage Waste Depot",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    "Change waste storage depot capacity.",
    "MeasureTool.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots",
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
    end,
    nil,
    "Change mechanized depot storage capacity.",
    "Cube.tga"
  )

  --------------------fixes
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Fixes/Remove Yellow Grid Marks",
    ChoGGi.MenuFuncs.RemoveYellowGridMarks,
    nil,
    "If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them.",
    "ReportBug.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Fixes/Drone Carry Amount",
    ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DroneResourceCarryAmountFix and "(Enabled)" or "(Disabled)"
      return des .. " Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.\nThis forces them to pick up whenever there's more then one resource).\n\nIf you have an insane production amount set then it'll take an (in-game) hour between calling drones."
    end,
    "ReportBug.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Fixes/Project Morpheus Radar Fell Down",
    ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown,
    nil,
    "Sometimes the blue radar thingy falls off.",
    "ReportBug.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Fixes/Fix Black Cube Colonists",
    ChoGGi.MenuFuncs.ColonistsFixBlackCube,
    nil,
    "If any colonists are black cubes click this.",
    "ReportBug.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Fixes/Attach Buildings To Nearest Working Dome",
    ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome,
    nil,
    "If you placed inside buildings outside and removed the dome they're attached to; use this.",
    "ReportBug.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Fixes/Cables & Pipes: Instant Repair",
    ChoGGi.MenuFuncs.CablesAndPipesRepair,
    nil,
    "Instantly repair all broken pipes and cables.",
    "ViewCamPath.tga"
  )
--[[
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Radius/Triboelectric Scrubber Radius...",
    ChoGGi.MenuFuncs.SetTriboelectricScrubberRadius,
    nil,
    "Change Triboelectric Scrubber radius.",
    "DisableRMMaps.tga"
  )
--]]
end
