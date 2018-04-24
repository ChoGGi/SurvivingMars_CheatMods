function OnMsg.Resume()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Attach Buildings To Nearest Working Dome",
    ChoGGi.AttachBuildingsToNearestWorkingDome,
    nil,
    "If you placed inside buildings outside and removed the dome they're attached to; use this.",
    "ReportBug.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Farm Shifts All On",
    ChoGGi.FarmShiftsAllOn,
    nil,
    "Turns on all the farm shifts.",
    "DisableAOMaps.tga"
  )
  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Production Amount Refresh",
    ChoGGi.SetProductionToSavedAmt,
    nil,
    "Loops through all buildings and checks that production is set to saved amounts.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Production Amount Set",
    ChoGGi.SetProductionAmount,
    "Ctrl-Shift-P",
    "Set production of buildings of selected type, also applies to newly placed ones.\nWorks on any building that produces.",
    "DisableAOMaps.tga"
  )
  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Fully Automated Buildings",
    ChoGGi.FullyAutomatedBuildings,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
      return des  .. " No more colonists needed.\nThanks to BoehserOnkel for the idea."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Add Mystery & Breakthrough Buildings",
    ChoGGi.AddMysteryBreakthroughBuildings,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings and "(Enabled)" or "(Disabled)"
      return des .. " Show all the Mystery and Breakthrough buildings in the build menu."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Sanatoriums Cure All",
    ChoGGi.SanatoriumCureAll_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
      return des .. " Sanatoriums can cure all bad traits."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Schools Train All",
    ChoGGi.SchoolTrainAll_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
      return des .. " Schools can train all good traits."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools Show Full List",
    ChoGGi.SanatoriumSchoolShowAll,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing all traits in side pane."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Maintenance Free",
    ChoGGi.MaintenanceBuildingsFree_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
      return des .. " Buildings don't build up maintenance points."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Moisture Vaporator Penalty",
    ChoGGi.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return des .. " Disable penalty when Moisture Vaporators are close to each other."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Crop Fail Threshold",
    ChoGGi.CropFailThreshold_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
      return des .. " Remove Threshold for failing crops (crops won't fail)."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Cheap Construction",
    ChoGGi.CheapConstruction_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return des .. " Build with minimal resources."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Building Damage Crime",
    ChoGGi.BuildingDamageCrime_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return des .. " Disable damage from renegedes to buildings."
    end,
    "DisableAOMaps.tga"
  )

  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: No Chance Of Break",
    ChoGGi.CablesAndPipesNoBreak_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.BreakChanceCablePipe and "(Enabled)" or "(Disabled)"
      return des .. " Cables & pipes will never break."
    end,
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Repair",
    ChoGGi.CablesAndPipesRepair,
    nil,
    "Instantly repair all broken pipes and cables.",
    "ReportBug.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Build",
    ChoGGi.CablesAndPipesInstant_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
      return des .. " Cables and pipes are built instantly."
    end,
    "DisableAOMaps.tga"
  )
  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Unlimited Wonders",
    ChoGGi.Building_wonder_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return des .. " Unlimited wonder build limit (restart game to toggle)."
    end,
    "toggle_post.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Build Spires Outside of Spire Point",
    ChoGGi.Building_dome_spot_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
      return des .. " Wonder build limit (restart game to toggle).\nUse with Remove Building Limits to fill up a dome with spires."
    end,
    "toggle_post.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Show Hidden Buildings",
    ChoGGi.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return des .. " Show hidden buildings (restart game to toggle)."
    end,
    "toggle_post.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Instant Build",
    ChoGGi.Building_instant_build_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
      return des .. " Allow buildings to be built instantly (restart game to toggle).\nDoesn't work with domes."
    end,
    "toggle_post.tga"
  )
  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Remove Building Limits",
    ChoGGi.RemoveBuildingLimits_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.RemoveBuildingLimits and "(Enabled)" or "(Disabled)"
      return des .. " Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes)."
    end,
    "toggle_post.tga"
  )
end
