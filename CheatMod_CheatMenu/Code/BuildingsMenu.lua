function ChoGGi.MsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  --ChoGGi.Funcs.AddAction(Menu,Action,Key,Des,Icon)
  local icon = "Cube.tga"

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Empty Mech Depot",
    ChoGGi.Funcs.EmptyMechDepot,
    nil,
    "Empties out selected/moused over mech depot into a small depot in front of it.",
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Annoying Sounds",
    ChoGGi.MenuFuncs.AnnoyingSounds_Toggle,
    nil,
    "Toggle annoying sounds (Sensor Tower, Mirror Sphere).",
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Protection Radius",
    ChoGGi.MenuFuncs.SetProtectionRadius,
    nil,
    "Change threat protection coverage distance.",
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Unlock Locked Buildings",
    ChoGGi.MenuFuncs.UnlockLockedBuildings,
    nil,
    "Gives you a list of buildings you can unlock in the build menu.",
    "toggle_post.tga"
  )

  ChoGGi.Funcs.AddAction(
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

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Unlimited Connection Length",
    ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.UnlimitedConnectionLength and "(Enabled)" or "(Disabled)"
      return des .. " No more length limits to pipes, cables, and passages."
    end,
    "road_type.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Powerless Building",
    ChoGGi.MenuFuncs.BuildingPower_Toggle,
    nil,
    "Toggle electricity use for selected building type.",
    icon
  )

  ChoGGi.Funcs.AddAction(
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
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Use Last Orientation",
    ChoGGi.MenuFuncs.UseLastOrientation_Toggle,
    "F7",
    UseLastOrientationText(),
    "ToggleMapAreaEditor.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Farm Shifts All On",
    ChoGGi.MenuFuncs.FarmShiftsAllOn,
    nil,
    "Turns on all the farm shifts.",
    icon
  )
  --------------------
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Production Amount Set",
    ChoGGi.MenuFuncs.SetProductionAmount,
    "Ctrl-Shift-P",
    "Set production of buildings of selected type, also applies to newly placed ones.\nWorks on any building that produces.",
    icon
  )
  --------------------
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Fully Automated Buildings",
    ChoGGi.MenuFuncs.FullyAutomatedBuildings,
    nil,
    function()
      local des = ChoGGi.UserSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
      return des  .. " No more colonists needed.\nThanks to BoehserOnkel for the idea."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Sanatoriums Cure All",
    ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
      return des .. " Sanatoriums can cure all bad traits."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Schools Train All",
    ChoGGi.MenuFuncs.SchoolTrainAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
      return des .. " Schools can train all good traits."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
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
      return des .. " Shows all appropriate traits in Sanatoriums/Schools popup menu."
    end,
    "LightArea.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show Full List",
    ChoGGi.MenuFuncs.SanatoriumSchoolShowAll,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing all traits in side pane."
    end,
    "LightArea.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Maintenance Free",
    ChoGGi.MenuFuncs.MaintenanceBuildingsFree_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
      return des .. " Buildings don't build up maintenance points."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Moisture Vaporator Penalty",
    ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      local des = ChoGGi.Funcs.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return des .. " Disable penalty when Moisture Vaporators are close to each other."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Crop Fail Threshold",
    ChoGGi.MenuFuncs.CropFailThreshold_Toggle,
    nil,
    function()
      local des = ChoGGi.Funcs.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
      return des .. " Remove Threshold for failing crops (crops won't fail)."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Cheap Construction",
    ChoGGi.MenuFuncs.CheapConstruction_Toggle,
    nil,
    function()
      local des = ChoGGi.Funcs.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return des .. " Build with minimal resources."
    end,
    icon
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Building Damage Crime",
    ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle,
    nil,
    function()
      local des = ChoGGi.Funcs.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return des .. " Disable damage from renegedes to buildings."
    end,
    icon
  )

  --------------------
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: No Chance Of Break",
    ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.BreakChanceCablePipe and "(Enabled)" or "(Disabled)"
      return des .. " Cables & pipes will never break."
    end,
    "ViewCamPath.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Build",
    ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle,
    nil,
    function()
      local des = ChoGGi.Funcs.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
      return des .. " Cables and pipes are built instantly."
    end,
    "ViewCamPath.tga"
  )
  --------------------
  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Unlimited Wonders",
    ChoGGi.MenuFuncs.Building_wonder_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return des .. " Unlimited wonder build limit (restart game to toggle)."
    end,
    "toggle_post.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Show Hidden Buildings",
    ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return des .. " Show hidden buildings (restart game to toggle)."
    end,
    "LightArea.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Buildings/Build Spires Outside of Spire Point",
    ChoGGi.MenuFuncs.Building_dome_spot_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
      return des .. " Build spires outside spire point.\nUse with Remove Building Limits to fill up a dome with spires."
    end,
    "toggle_post.tga"
  )

  ChoGGi.Funcs.AddAction(
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
  ChoGGi.Funcs.AddAction(
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
