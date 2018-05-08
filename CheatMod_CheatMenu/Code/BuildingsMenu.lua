function ChoGGi.BuildingsMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)
  local icon = "Cube.tga"

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Sensor Tower Sound",
    ChoGGi.SensorTowerSound_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SensorTowerSound and "(Enabled)" or "(Disabled)"
      return des .. " Toggle the sensor tower working sound."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Protection Radius",
    ChoGGi.SetProtectionRadius,
    nil,
    "Change threat protection coverage distance.",
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Unlock Locked Buildings",
    ChoGGi.UnlockLockedBuildings,
    nil,
    "Gives you a list of buildings you can unlock in the build menu.",
    "toggle_post.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Pipes Pillars Spacing",
    ChoGGi.PipesPillarsSpacing_Toggle,
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

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Unlimited Connection Length",
    ChoGGi.UnlimitedConnectionLength_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.UnlimitedConnectionLength and "(Enabled)" or "(Disabled)"
      return des .. " No more length limits to pipes, cables, and passages."
    end,
    "road_type.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Powerless Building",
    ChoGGi.BuildingPower_Toggle,
    nil,
    "Toggle electricity use for selected building type.",
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Set Charge & Discharge Rates",
    ChoGGi.SetMaxChangeOrDischarge,
    "Ctrl-Shift-R",
    "Change how fast Air/Water/Battery storage capacity changes.",
    icon
  )

  local function UseLastOrientationText()
    local des = ChoGGi.CheatMenuSettings.UseLastOrientation and "(Enabled)" or "(Disabled)"
    return des  .. " Use last building placement orientation."
  end
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Use Last Orientation",
    ChoGGi.UseLastOrientation_Toggle,
    "F7",
    UseLastOrientationText(),
    "ToggleMapAreaEditor.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Farm Shifts All On",
    ChoGGi.FarmShiftsAllOn,
    nil,
    "Turns on all the farm shifts.",
    icon
  )
  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Buildings/Production Amount Set",
    ChoGGi.SetProductionAmount,
    "Ctrl-Shift-P",
    "Set production of buildings of selected type, also applies to newly placed ones.\nWorks on any building that produces.",
    icon
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
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Sanatoriums Cure All",
    ChoGGi.SanatoriumCureAll_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
      return des .. " Sanatoriums can cure all bad traits."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Schools Train All",
    ChoGGi.SchoolTrainAll_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
      return des .. " Schools can train all good traits."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show All Traits",
    ChoGGi.ShowAllTraits_Toggle,
    nil,
    function()
      local des = ""
      if g_SchoolTraits and #g_SchoolTraits == 18 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Shows all appropriate traits in Sanatoriums/Schools popup menu."
    end,
    "LightArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show Full List",
    ChoGGi.SanatoriumSchoolShowAll,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing all traits in side pane."
    end,
    "LightArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Maintenance Free",
    ChoGGi.MaintenanceBuildingsFree_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
      return des .. " Buildings don't build up maintenance points."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Moisture Vaporator Penalty",
    ChoGGi.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return des .. " Disable penalty when Moisture Vaporators are close to each other."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Crop Fail Threshold",
    ChoGGi.CropFailThreshold_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
      return des .. " Remove Threshold for failing crops (crops won't fail)."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Cheap Construction",
    ChoGGi.CheapConstruction_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return des .. " Build with minimal resources."
    end,
    icon
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Building Damage Crime",
    ChoGGi.BuildingDamageCrime_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return des .. " Disable damage from renegedes to buildings."
    end,
    icon
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
    "ViewCamPath.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Build",
    ChoGGi.CablesAndPipesInstant_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
      return des .. " Cables and pipes are built instantly."
    end,
    "ViewCamPath.tga"
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
    "Expanded CM/Buildings/Show Hidden Buildings",
    ChoGGi.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return des .. " Show hidden buildings (restart game to toggle)."
    end,
    "LightArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Build Spires Outside of Spire Point",
    ChoGGi.Building_dome_spot_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
      return des .. " Build spires outside spire point.\nUse with Remove Building Limits to fill up a dome with spires."
    end,
    "toggle_post.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Buildings/Instant Build",
    ChoGGi.Building_instant_build_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
      return des .. " Allow buildings to be built instantly.\nDoesn't work with domes."
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
