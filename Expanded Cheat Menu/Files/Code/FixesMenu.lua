function ChoGGi.MsgFuncs.FixesMenu_LoadingScreenPreClose()

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/ Fire All Fixes",
    ChoGGi.MenuFuncs.FireAllFixes,
    nil,
    "Fires all the non-toggle fixes (nuke 'em from orbit and all that).\n\nDoesn't include ECM ones.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Remove Particles With Null Polylines",
    ChoGGi.MenuFuncs.ParticlesWithNullPolylines,
    nil,
    "It won't hurt anything to run this, as for when/if: I suppose if you have a broken looking object? or a meteor crashes into your mirror sphere power decoy thingy.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Remove Missing Class Objects",
    ChoGGi.MenuFuncs.RemoveMissingClassObjects,
    nil,
    "Probably from mods that were removed (if you're getting a PinDlg error then this should fix it).",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Mirror Sphere Stuck",
    ChoGGi.MenuFuncs.MirrorSphereStuck,
    nil,
    "If you have a mirror sphere stuck at the edge of the map, and it just won't die/move... (also removes any broked cone of a captured sphere)",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Stutter With High FPS",
    ChoGGi.MenuFuncs.StutterWithHighFPS,
    nil,
    "If your units are doing stutter movement, but your FPS is fine then you likely have a unit with broked pathing (or there's one of those magical invisible walls in it's way).",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Drones Keep Trying Blocked Rocks",
    ChoGGi.MenuFuncs.DronesKeepTryingBlockedRocks,
    nil,
    "If you have a certain dronehub who's drones keep trying to get rock they can't reach, try this.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Idle Drones Won't Build When Resources Available",
    ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites,
    nil,
    "If you have drones that are idle while contruction sites need to be built and resources are available then you likely have some unreachable building sites.\n\nThis removes any of those (resources won't be touched).",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Remove Yellow Grid Marks",
    ChoGGi.MenuFuncs.RemoveYellowGridMarks,
    nil,
    "If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Project Morpheus Radar Fell Down",
    ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown,
    nil,
    "Sometimes the blue radar thingy falls off.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Cables & Pipes: Instant Repair",
    ChoGGi.MenuFuncs.CablesAndPipesRepair,
    nil,
    "Instantly repair all broken pipes and cables.",
    "ViewCamPath.tga"
  )

---------------------------toggles
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Toggle: Psychologist Resting Bonus Doesn't Work",
    ChoGGi.MenuFuncs.NoRestingBonusPsychologistFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.NoRestingBonusPsychologistFix and "(Enabled)" or "(Disabled)"
      return des .. " The Psychologist profile is supposed to give a +5 sanity bonus to colonists during rest (now it will)."
    end,
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Toggle: Drone Carry Amount",
    ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DroneResourceCarryAmountFix and "(Enabled)" or "(Disabled)"
      return des .. " Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.\nThis forces them to pick up whenever there's more then one resource).\n\nIf you have an insane production amount set then it'll take an (in-game) hour between calling drones."
    end,
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Toggle: Sort Command Center Dist",
    ChoGGi.MenuFuncs.SortCommandCenterDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SortCommandCenterDist and "(Enabled)" or "(Disabled)"
      return des .. " Each Sol goes through all buildings and sorts their cc list by nearest.\n\nTakes less then a second on a map with 3616 buildings and 54 drone hubs."
    end,
    "Axis.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/Attach Buildings To Nearest Working Dome",
    ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome,
    nil,
    "If you placed inside buildings outside and removed the dome they're attached to; use this.",
    "ReportBug.tga"
  )

-----------------------ECM fixes
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[99]ECM Whoopsies/See tooltip",
    nil,
    "Skip",
    "Fixes for stuff that I messed up, these should all be fine to fire even without the issues, but they shouldn't be needed."
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[99]ECM Whoopsies/[1]Fix Black Cube Colonists",
    ChoGGi.MenuFuncs.ColonistsFixBlackCube,
    nil,
    "If any colonists are black cubes click this.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[99]ECM Whoopsies/[1]Align All Buildings To Hex Grid",
    ChoGGi.MenuFuncs.AlignAllBuildingsToHexGrid,
    nil,
    "If you have any buildings that aren't aligned to the hex grids use this.",
    "ReportBug.tga"
  )
end
