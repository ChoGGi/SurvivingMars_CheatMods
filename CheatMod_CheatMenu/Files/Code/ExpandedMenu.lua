local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  --menus under Gameplay menu without a separate file
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  -------------rockets
  cComFuncs.AddAction(
    "Expanded CM/Rocket/Cargo Capacity",
    cMenuFuncs.SetRocketCargoCapacity,
    nil,
    "Change amount of storage space in rockets.",
    "scale_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Rocket/Travel Time",
    cMenuFuncs.SetRocketTravelTime,
    nil,
    "Change how long to take to travel between planets.",
    "place_particles.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Rocket/Colonists Per Rocket",
    cMenuFuncs.SetColonistsPerRocket,
    nil,
    "Change how many colonists can arrive on Mars in a single Rocket.",
    "ToggleMarkers.tga"
  )

  --------------------capacity
  cComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots Temp",
    cMenuFuncs.StorageMechanizedDepotsTemp_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.StorageMechanizedDepotsTemp and "(Enabled)" or "(Disabled)"
      return des .. " Allow the temporary storage to hold 100 instead of 50 cubes."
    end,
    "Cube.tga"
  )
  cComFuncs.AddAction(
    "Expanded CM/Capacity/Worker Capacity",
    cMenuFuncs.SetWorkerCapacity,
    "Ctrl-Shift-W",
    "Change how many workers per building type.",
    "scale_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Capacity/Building Capacity",
    cMenuFuncs.SetBuildingCapacity,
    "Ctrl-Shift-C",
    "Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).",
    "scale_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Capacity/Building Visitor Capacity",
    cMenuFuncs.SetVisitorCapacity,
    "Ctrl-Shift-V",
    "Set visitors capacity of all buildings of selected type, also applies to newly placed ones.",
    "scale_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Universal Depot",
    function()
      cMenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    "Change universal storage depot capacity.",
    "MeasureTool.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Other Depot",
    function()
      cMenuFuncs.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    "Change other storage depot capacity.",
    "MeasureTool.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Waste Depot",
    function()
      cMenuFuncs.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    "Change waste storage depot capacity.",
    "MeasureTool.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots",
    function()
      cMenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
    end,
    nil,
    "Change mechanized depot storage capacity.",
    "Cube.tga"
  )

  --------------------fixes
  cComFuncs.AddAction(
    "Expanded CM/Fixes/Sort Command Center Dist",
    cMenuFuncs.SortCommandCenterDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SortCommandCenterDist and "(Enabled)" or "(Disabled)"
      return des .. " Each Sol goes through all buildings and sorts their cc list by nearest.\n\nTakes less then a second on a map with 3616 buildings and 54 drone hubs."
    end,
    "Axis.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Drones Keep Trying Blocked Rocks",
    cMenuFuncs.DronesKeepTryingBlockedRocks,
    nil,
    "If you have a certain dronehub who's drones keep trying to get rock they can't reach, try this.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Align All Buildings To Hex Grid",
    cMenuFuncs.AlignAllBuildingsToHexGrid,
    nil,
    "If you have any buildings that aren't aligned to the hex grids use this.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Idle Drones Won't Build When Resources Available",
    cMenuFuncs.RemoveUnreachableConstructionSites,
    nil,
    "If you have drones that are idle while contruction sites need to be built and resources are available then you likely have some unreachable building sites.\n\nThis removes any of those (resources won't be touched).",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Remove Yellow Grid Marks",
    cMenuFuncs.RemoveYellowGridMarks,
    nil,
    "If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Drone Carry Amount",
    cMenuFuncs.DroneResourceCarryAmountFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DroneResourceCarryAmountFix and "(Enabled)" or "(Disabled)"
      return des .. " Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.\nThis forces them to pick up whenever there's more then one resource).\n\nIf you have an insane production amount set then it'll take an (in-game) hour between calling drones."
    end,
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Project Morpheus Radar Fell Down",
    cMenuFuncs.ProjectMorpheusRadarFellDown,
    nil,
    "Sometimes the blue radar thingy falls off.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Fix Black Cube Colonists",
    cMenuFuncs.ColonistsFixBlackCube,
    nil,
    "If any colonists are black cubes click this.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Attach Buildings To Nearest Working Dome",
    cMenuFuncs.AttachBuildingsToNearestWorkingDome,
    nil,
    "If you placed inside buildings outside and removed the dome they're attached to; use this.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Fixes/Cables & Pipes: Instant Repair",
    cMenuFuncs.CablesAndPipesRepair,
    nil,
    "Instantly repair all broken pipes and cables.",
    "ViewCamPath.tga"
  )
--[[
  cComFuncs.AddAction(
    "Expanded CM/Radius/Triboelectric Scrubber Radius...",
    cMenuFuncs.SetTriboelectricScrubberRadius,
    nil,
    "Change Triboelectric Scrubber radius.",
    "DisableRMMaps.tga"
  )
--]]
end
