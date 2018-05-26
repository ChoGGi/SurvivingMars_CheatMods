--See LICENSE for terms

local icon = "Cube.tga"

function ChoGGi.MsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Storage Amount Of Diner & Grocery",
    ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery,
    nil,
    function()
      local des = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage and "(Enabled)" or "(Disabled)"
      return des .. " Change how much food is stored in them (less chance of starving colonists when busy)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Triboelectric Scrubber Radius",
    function()
      ChoGGi.MenuFuncs.SetUIRangeBuildingRadius("TriboelectricScrubber","\nLadies and gentlemen, this is your captain speaking. We have a small problem.\nAll four engines have stopped. We are doing our damnedest to get them going again.\nI trust you are not in too much distress.")
    end,
    nil,
    function()
      local des = ChoGGi.UserSettings.TriboelectricScrubberRadius and "(Enabled)" or "(Disabled)"
      return des .. " Extend the range of the scrubber."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/SubsurfaceHeater Radius",
    function()
      ChoGGi.MenuFuncs.SetUIRangeBuildingRadius("SubsurfaceHeater","\nSome smart quip about heating?")
    end,
    nil,
    function()
      local des = ChoGGi.UserSettings.SubsurfaceHeaterRadius and "(Enabled)" or "(Disabled)"
      return des .. " Extend the range of the heater."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Always Dusty",
    ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.AlwaysDustyBuildings and "(Enabled)" or "(Disabled)"
      return des .. " Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Empty Mech Depot",
    ChoGGi.CodeFuncs.EmptyMechDepot,
    "Ctrl-Alt-Numpad 2",
    "Empties out selected/moused over mech depot into a small depot in front of it.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Protection Radius",
    ChoGGi.MenuFuncs.SetProtectionRadius,
    nil,
    "Change threat protection coverage distance.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Unlock Locked Buildings",
    ChoGGi.MenuFuncs.UnlockLockedBuildings,
    nil,
    "Gives you a list of buildings you can unlock in the build menu.",
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Pipes Pillars Spacing",
    ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle,
    nil,
    function()
      local des = ""
      if Consts.PipesPillarSpacing == 1000 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Only place Pillars at start and end."
    end,
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Unlimited Connection Length",
    ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.UnlimitedConnectionLength and "(Enabled)" or "(Disabled)"
      return des .. " No more length limits to pipes, cables, and passages."
    end,
    "road_type.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Powerless Building",
    ChoGGi.MenuFuncs.BuildingPower_Toggle,
    nil,
    "Toggle electricity use for selected building type.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Set Charge & Discharge Rates",
    ChoGGi.MenuFuncs.SetMaxChangeOrDischarge,
    "Ctrl-Shift-R",
    "Change how fast Air/Water/Battery storage capacity changes.",
    icon
  )

  local function UseLastOrientationText()
    local des = ChoGGi.UserSettings.UseLastOrientation and "(Enabled)" or "(Disabled)"
    return des  .. " Use last building placement orientation."
  end
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Use Last Orientation",
    ChoGGi.MenuFuncs.UseLastOrientation_Toggle,
    "F7",
    UseLastOrientationText(),
    "ToggleMapAreaEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Farm Shifts All On",
    ChoGGi.MenuFuncs.FarmShiftsAllOn,
    nil,
    "Turns on all the farm shifts.",
    icon
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Production Amount Set",
    ChoGGi.MenuFuncs.SetProductionAmount,
    "Ctrl-Shift-P",
    "Set production of buildings of selected type, also applies to newly placed ones.\nWorks on any building that produces.",
    icon
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Fully Automated Building",
    ChoGGi.MenuFuncs.SetFullyAutomatedBuildings,
    nil,
    "Work without workers (select a building and this will apply to all of type or selected).\nThanks to BoehserOnkel for the idea.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums Cure All",
    ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle curing all traits (use \"Show All Traits\" & \"Show Full List\" to manually set)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Schools Train All",
    ChoGGi.MenuFuncs.SchoolTrainAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle curing all traits (use \"Show All Traits\" & \"Show Full List\" to manually set)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show All Traits",
    ChoGGi.MenuFuncs.ShowAllTraits_Toggle,
    nil,
    function()
      local des = ""
      if g_SchoolTraits and #g_SchoolTraits == 18 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Shows all appropriate traits in Sanatoriums/Schools side panel popup menu."
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show Full List",
    ChoGGi.MenuFuncs.SanatoriumSchoolShowAll,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing full list of trait selectors in side pane."
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Maintenance Free Inside",
    ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.InsideBuildingsNoMaintenance and "(Enabled)" or "(Disabled)"
      return des .. " Buildings inside domes don't build maintenance points (takes away instead of adding)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Maintenance Free",
    ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
      return des .. " Building maintenance points reverse (takes away instead of adding)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Moisture Vaporator Penalty",
    ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return des .. " Disable penalty when Moisture Vaporators are close to each other."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Crop Fail Threshold",
    ChoGGi.MenuFuncs.CropFailThreshold_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
      return des .. " Remove Threshold for failing crops (crops won't fail)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Cheap Construction",
    ChoGGi.MenuFuncs.CheapConstruction_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return des .. " Build with minimal resources."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Building Damage Crime",
    ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return des .. " Disable damage from renegedes to buildings."
    end,
    icon
  )

  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: No Chance Of Break",
    ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.BreakChanceCablePipe and "(Enabled)" or "(Disabled)"
      return des .. " Cables & pipes will never break."
    end,
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Build",
    ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
      return des .. " Cables and pipes are built instantly."
    end,
    "ViewCamPath.tga"
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Unlimited Wonders",
    ChoGGi.MenuFuncs.Building_wonder_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return des .. " Unlimited wonder build limit (restart game to toggle)."
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Show Hidden Buildings",
    ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return des .. " Show hidden buildings (restart game to toggle)."
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Build Spires Outside of Spire Point",
    ChoGGi.MenuFuncs.Building_dome_spot_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
      return des .. " Build spires outside spire point.\nUse with Remove Building Limits to fill up a dome with spires."
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Instant Build",
    ChoGGi.MenuFuncs.Building_instant_build_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
      return des .. " Allow buildings to be built instantly.\nDoesn't work with domes."
    end,
    "toggle_post.tga"
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Buildings/Remove Building Limits",
    ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveBuildingLimits and "(Enabled)" or "(Disabled)"
      return des .. " Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes)."
    end,
    "toggle_post.tga"
  )
end
