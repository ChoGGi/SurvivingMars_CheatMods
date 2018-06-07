--See LICENSE for terms

local icon = "ReportBug.tga"

function ChoGGi.MsgFuncs.FixesMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[9]" .. ChoGGi.ComFuncs.Trans(302535920000581,"Toggle Collisions On Selected Object"),
    ChoGGi.MenuFuncs.CollisionsObject_Toggle,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000582,"Just in case you get something stuck somewhere."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[9]" .. ChoGGi.ComFuncs.Trans(302535920000583,"Rebuild Walkable Points In Domes"),
    ChoGGi.MenuFuncs.RebuildWalkablePointsInDomes,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000584,"Useful? who knows, won't hurt."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[9]" .. ChoGGi.ComFuncs.Trans(302535920000585,"Colonists Stuck Outside Rocket"),
    ChoGGi.MenuFuncs.ColonistsStuckOutsideRocket,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000586,"If any colonists are stuck AND you don't have any other rockets unloading colonists.\n\nThis will do a little copy n paste fix (they'll keep the same traits/whatnot)."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[9]" .. ChoGGi.ComFuncs.Trans(302535920000587,"Remove Missing Class Objects (Warning)"),
    ChoGGi.MenuFuncs.RemoveMissingClassObjects,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000588,"Warning: May crash game, SAVE FIRST. These are probably from mods that were removed (if you're getting a PinDlg error then this should fix it)."),
    icon
  )

---------------------------------most
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]" .. " " .. ChoGGi.ComFuncs.Trans(302535920000589,"Fire Most Fixes"),
    ChoGGi.MenuFuncs.FireMostFixes,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000590,"Fires all the fixes in the \"Most\" menu (nuke 'em from orbit and all that)."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000591,"Colonists Trying To Board Rocket Freezes Game"),
    ChoGGi.MenuFuncs.ColonistsTryingToBoardRocketFreezesGame,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000592,"Doesn't fix the underlying cause, but it works."),
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000593,"Remove Particles With Null Polylines"),
    ChoGGi.MenuFuncs.ParticlesWithNullPolylines,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000594,"It won't hurt anything to run this, as for when/if: I suppose if you have a broken looking object? or a meteor crashes into your mirror sphere power decoy thingy."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000595,"Mirror Sphere Stuck"),
    ChoGGi.MenuFuncs.MirrorSphereStuck,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000596,"If you have a mirror sphere stuck at the edge of the map, and it just won't die/move... (also removes any broked cone of a captured sphere)"),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000597,"Stutter With High FPS or Human Centipede"),
    ChoGGi.MenuFuncs.StutterWithHighFPS,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000598,"If your units are doing stutter movement, but your FPS is fine then you likely have a unit with broked pathing (or there's one of those magical invisible walls in it's way).\n\nThis also works for colonists practicing the human centipede."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000599,"Drones Keep Trying Blocked Areas"),
    ChoGGi.MenuFuncs.DronesKeepTryingBlockedAreas,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000600,"If you have a certain dronehub who's drones keep trying to get somewhere they can't reach, try this."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000601,"Idle Drones Won't Build When Resources Available"),
    ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000602,"If you have drones that are idle while contruction sites need to be built and resources are available then you likely have some unreachable building sites.\n\nThis removes any of those (resources won't be touched)."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000603,"Remove Yellow Grid Marks"),
    ChoGGi.MenuFuncs.RemoveYellowGridMarks,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000604,"If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000605,"Project Morpheus Radar Fell Down"),
    ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000606,"Sometimes the blue radar thingy falls off."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000157,"Cables & Pipes") .. ": " .. ChoGGi.ComFuncs.Trans(302535920000607,"Instant Repair"),
    ChoGGi.MenuFuncs.CablesAndPipesRepair,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000608,"Instantly repair all broken pipes and cables."),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[0]Most/" .. ChoGGi.ComFuncs.Trans(302535920000609,"Attach Buildings To Nearest Working Dome"),
    ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000610,"If you placed inside buildings outside and removed the dome they're attached to; use this."),
    icon
  )
---------------------------toggles
--[[
fixed in curiosity

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/" .. ChoGGi.ComFuncs.Trans()"Toggle: Psychologist Resting Bonus Doesn't Work",
    ChoGGi.MenuFuncs.NoRestingBonusPsychologistFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.NoRestingBonusPsychologistFix and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. ChoGGi.ComFuncs.Trans()" The Psychologist profile is supposed to give a +5 sanity bonus to colonists during rest (now it will)."
    end,
    icon
  )
--]]
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[6]Toggles/" .. ChoGGi.ComFuncs.Trans(302535920000611,"Toggle: Rover Infinite Loop In Curiosity Update"),
    ChoGGi.MenuFuncs.RoverInfiniteLoopCuriosity_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RoverInfiniteLoopCuriosity and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000612,"If everything freezes, but you can still move the camera around after moving a rover (enabled by default, restart to toggle).")
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[6]Toggles/" .. ChoGGi.ComFuncs.Trans(302535920000613,"Toggle: Drone Carry Amount"),
    ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DroneResourceCarryAmountFix and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000614,"Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.\nThis forces them to pick up whenever there's more then one resource).\n\nIf you have an insane production amount set then it'll take an (in-game) hour between calling drones.")
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[6]Toggles/" .. ChoGGi.ComFuncs.Trans(302535920000615,"Toggle: Sort Command Center Dist"),
    ChoGGi.MenuFuncs.SortCommandCenterDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SortCommandCenterDist and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000616,"Each Sol goes through all buildings and sorts their cc list by nearest.\n\nTakes less then a second on a map with 3616 buildings and 54 drone hubs.")
    end,
    "Axis.tga"
  )

-----------------------ECM fixes
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[99]ECM Whoopsies/" .. ChoGGi.ComFuncs.Trans(302535920000617,"See tooltip"),
    nil,
    "Skip",
    ChoGGi.ComFuncs.Trans(302535920000618,"Fixes for stuff that I messed up, these should all be fine to fire even without the issues, but they shouldn't be needed.")
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[99]ECM Whoopsies/[1]" .. ChoGGi.ComFuncs.Trans(302535920000619,"Fix Black Cube Colonists"),
    ChoGGi.MenuFuncs.ColonistsFixBlackCube,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000620,"If any colonists are black cubes click this."),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Fixes/[99]ECM Whoopsies/[1]" .. ChoGGi.ComFuncs.Trans(302535920000621,"Align All Buildings To Hex Grid"),
    ChoGGi.MenuFuncs.AlignAllBuildingsToHexGrid,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000622,"If you have any buildings that aren't aligned to the hex grids use this."),
    icon
  )
end
