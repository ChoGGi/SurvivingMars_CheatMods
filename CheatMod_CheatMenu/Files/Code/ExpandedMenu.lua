local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  --menus under Gameplay menu without a separate file
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  -------------rockets
  CComFuncs.AddAction(
    "Expanded CM/Rocket/Cargo Capacity",
    CMenuFuncs.SetRocketCargoCapacity,
    nil,
    "Change amount of storage space in rockets.",
    "scale_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Rocket/Travel Time",
    CMenuFuncs.SetRocketTravelTime,
    nil,
    "Change how long to take to travel between planets.",
    "place_particles.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Rocket/Colonists Per Rocket",
    CMenuFuncs.SetColonistsPerRocket,
    nil,
    "Change how many colonists can arrive on Mars in a single Rocket.",
    "ToggleMarkers.tga"
  )

  --------------------capacity
  CComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots Temp",
    CMenuFuncs.StorageMechanizedDepotsTemp_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.StorageMechanizedDepotsTemp and "(Enabled)" or "(Disabled)"
      return des .. " Allow the temporary storage to hold 100 instead of 50 cubes."
    end,
    "Cube.tga"
  )
  CComFuncs.AddAction(
    "Expanded CM/Capacity/Worker Capacity",
    CMenuFuncs.SetWorkerCapacity,
    "Ctrl-Shift-W",
    "Change how many workers per building type.",
    "scale_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Capacity/Building Capacity",
    CMenuFuncs.SetBuildingCapacity,
    "Ctrl-Shift-C",
    "Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).",
    "scale_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Capacity/Building Visitor Capacity",
    CMenuFuncs.SetVisitorCapacity,
    "Ctrl-Shift-V",
    "Set visitors capacity of all buildings of selected type, also applies to newly placed ones.",
    "scale_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Universal Depot",
    function()
      CMenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    "Change universal storage depot capacity.",
    "MeasureTool.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Other Depot",
    function()
      CMenuFuncs.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    "Change other storage depot capacity.",
    "MeasureTool.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Waste Depot",
    function()
      CMenuFuncs.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    "Change waste storage depot capacity.",
    "MeasureTool.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Capacity/Storage Mechanized Depots",
    function()
      CMenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
    end,
    nil,
    "Change mechanized depot storage capacity.",
    "Cube.tga"
  )

  --------------------fixes
  CComFuncs.AddAction(
    "Expanded CM/Fixes/Align All Buildings To Hex Grid",
    CMenuFuncs.AlignAllBuildingsToHexGrid,
    nil,
    "If you have any buildings that aren't aligned to the hex grids use this.",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Idle Drones Won't Build When Resources Available",
    CMenuFuncs.RemoveUnreachableConstructionSites,
    nil,
    "If you have drones that are idle while contruction sites need to be built and resources are available then you likely have some unreachable building sites.\n\nThis removes any of those (resources won't be touched).",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Remove Yellow Grid Marks",
    CMenuFuncs.RemoveYellowGridMarks,
    nil,
    "If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them.",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Drone Carry Amount",
    CMenuFuncs.DroneResourceCarryAmountFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DroneResourceCarryAmountFix and "(Enabled)" or "(Disabled)"
      return des .. " Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.\nThis forces them to pick up whenever there's more then one resource).\n\nIf you have an insane production amount set then it'll take an (in-game) hour between calling drones."
    end,
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Project Morpheus Radar Fell Down",
    CMenuFuncs.ProjectMorpheusRadarFellDown,
    nil,
    "Sometimes the blue radar thingy falls off.",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Fix Black Cube Colonists",
    CMenuFuncs.ColonistsFixBlackCube,
    nil,
    "If any colonists are black cubes click this.",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Attach Buildings To Nearest Working Dome",
    CMenuFuncs.AttachBuildingsToNearestWorkingDome,
    nil,
    "If you placed inside buildings outside and removed the dome they're attached to; use this.",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Fixes/Cables & Pipes: Instant Repair",
    CMenuFuncs.CablesAndPipesRepair,
    nil,
    "Instantly repair all broken pipes and cables.",
    "ViewCamPath.tga"
  )
--[[
  CComFuncs.AddAction(
    "Expanded CM/Radius/Triboelectric Scrubber Radius...",
    CMenuFuncs.SetTriboelectricScrubberRadius,
    nil,
    "Change Triboelectric Scrubber radius.",
    "DisableRMMaps.tga"
  )
--]]
end
