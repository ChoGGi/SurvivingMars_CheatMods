local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)
  local icon = "Cube.tga"

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Storage Amount Of Diner & Grocery",
    cMenuFuncs.SetStorageAmountOfDinerGrocery,
    nil,
    function()
      local des = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage and "(Enabled)" or "(Disabled)"
      return des .. " Change how much food is stored in them (less chance of starving colonists when busy)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Triboelectric Scrubber Radius",
    function()
      cMenuFuncs.SetUIRangeBuildingRadius("TriboelectricScrubber","\nLadies and gentlemen, this is your captain speaking. We have a small problem.\nAll four engines have stopped. We are doing our damnedest to get them going again.\nI trust you are not in too much distress.")
    end,
    nil,
    function()
      local des = ChoGGi.UserSettings.TriboelectricScrubberRadius and "(Enabled)" or "(Disabled)"
      return des .. " Extend the range of the scrubber."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/SubsurfaceHeater Radius",
    function()
      cMenuFuncs.SetUIRangeBuildingRadius("SubsurfaceHeater","\nSome smart quip about heating?")
    end,
    nil,
    function()
      local des = ChoGGi.UserSettings.SubsurfaceHeaterRadius and "(Enabled)" or "(Disabled)"
      return des .. " Extend the range of the heater."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Defence Towers Attack DustDevils",
    cMenuFuncs.DefenceTowersAttackDustDevils_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DefenceTowersAttackDustDevils and "(Enabled)" or "(Disabled)"
      return des .. " Defence towers will attack dustdevils."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Always Dusty",
    cMenuFuncs.AlwaysDustyBuildings_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.AlwaysDustyBuildings and "(Enabled)" or "(Disabled)"
      return des .. " Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Empty Mech Depot",
    cCodeFuncs.EmptyMechDepot,
    "Ctrl-Shift-Numpad 2",
    "Empties out selected/moused over mech depot into a small depot in front of it.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Annoying Sounds",
    cMenuFuncs.AnnoyingSounds_Toggle,
    nil,
    "Toggle annoying sounds (Sensor Tower, Mirror Sphere).",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Protection Radius",
    cMenuFuncs.SetProtectionRadius,
    nil,
    "Change threat protection coverage distance.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Unlock Locked Buildings",
    cMenuFuncs.UnlockLockedBuildings,
    nil,
    "Gives you a list of buildings you can unlock in the build menu.",
    "toggle_post.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Pipes Pillars Spacing",
    cMenuFuncs.PipesPillarsSpacing_Toggle,
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

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Unlimited Connection Length",
    cMenuFuncs.UnlimitedConnectionLength_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.UnlimitedConnectionLength and "(Enabled)" or "(Disabled)"
      return des .. " No more length limits to pipes, cables, and passages."
    end,
    "road_type.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Powerless Building",
    cMenuFuncs.BuildingPower_Toggle,
    nil,
    "Toggle electricity use for selected building type.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Set Charge & Discharge Rates",
    cMenuFuncs.SetMaxChangeOrDischarge,
    "Ctrl-Shift-R",
    "Change how fast Air/Water/Battery storage capacity changes.",
    icon
  )

  local function UseLastOrientationText()
    local des = ChoGGi.UserSettings.UseLastOrientation and "(Enabled)" or "(Disabled)"
    return des  .. " Use last building placement orientation."
  end
  cComFuncs.AddAction(
    "Expanded CM/Buildings/Use Last Orientation",
    cMenuFuncs.UseLastOrientation_Toggle,
    "F7",
    UseLastOrientationText(),
    "ToggleMapAreaEditor.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Farm Shifts All On",
    cMenuFuncs.FarmShiftsAllOn,
    nil,
    "Turns on all the farm shifts.",
    icon
  )
  --------------------
  cComFuncs.AddAction(
    "Expanded CM/Buildings/Production Amount Set",
    cMenuFuncs.SetProductionAmount,
    "Ctrl-Shift-P",
    "Set production of buildings of selected type, also applies to newly placed ones.\nWorks on any building that produces.",
    icon
  )
  --------------------
  cComFuncs.AddAction(
    "Expanded CM/Buildings/Fully Automated Buildings",
    cMenuFuncs.FullyAutomatedBuildings,
    nil,
    function()
      local des = ChoGGi.UserSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
      return des  .. " No more colonists needed.\nThanks to BoehserOnkel for the idea."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums Cure All",
    cMenuFuncs.SanatoriumCureAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle curing all traits (use \"Show All Traits\" & \"Show Full List\" to manually set)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Schools Train All",
    cMenuFuncs.SchoolTrainAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle curing all traits (use \"Show All Traits\" & \"Show Full List\" to manually set)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show All Traits",
    cMenuFuncs.ShowAllTraits_Toggle,
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

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show Full List",
    cMenuFuncs.SanatoriumSchoolShowAll,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing full list of trait selectors in side pane."
    end,
    "LightArea.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Maintenance Free Inside",
    cMenuFuncs.MaintenanceFreeBuildingsInside_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.InsideBuildingsNoMaintenance and "(Enabled)" or "(Disabled)"
      return des .. " Buildings inside domes don't build maintenance points (takes away instead of adding)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Maintenance Free",
    cMenuFuncs.MaintenanceFreeBuildings_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
      return des .. " Building maintenance points reverse (takes away instead of adding)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Moisture Vaporator Penalty",
    cMenuFuncs.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return des .. " Disable penalty when Moisture Vaporators are close to each other."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Crop Fail Threshold",
    cMenuFuncs.CropFailThreshold_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
      return des .. " Remove Threshold for failing crops (crops won't fail)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Cheap Construction",
    cMenuFuncs.CheapConstruction_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return des .. " Build with minimal resources."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Building Damage Crime",
    cMenuFuncs.BuildingDamageCrime_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return des .. " Disable damage from renegedes to buildings."
    end,
    icon
  )

  --------------------
  cComFuncs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: No Chance Of Break",
    cMenuFuncs.CablesAndPipesNoBreak_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.BreakChanceCablePipe and "(Enabled)" or "(Disabled)"
      return des .. " Cables & pipes will never break."
    end,
    "ViewCamPath.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Build",
    cMenuFuncs.CablesAndPipesInstant_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
      return des .. " Cables and pipes are built instantly."
    end,
    "ViewCamPath.tga"
  )
  --------------------
  cComFuncs.AddAction(
    "Expanded CM/Buildings/Unlimited Wonders",
    cMenuFuncs.Building_wonder_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return des .. " Unlimited wonder build limit (restart game to toggle)."
    end,
    "toggle_post.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Show Hidden Buildings",
    cMenuFuncs.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return des .. " Show hidden buildings (restart game to toggle)."
    end,
    "LightArea.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Build Spires Outside of Spire Point",
    cMenuFuncs.Building_dome_spot_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
      return des .. " Build spires outside spire point.\nUse with Remove Building Limits to fill up a dome with spires."
    end,
    "toggle_post.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Buildings/Instant Build",
    cMenuFuncs.Building_instant_build_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
      return des .. " Allow buildings to be built instantly.\nDoesn't work with domes."
    end,
    "toggle_post.tga"
  )
  --------------------
  cComFuncs.AddAction(
    "Expanded CM/Buildings/Remove Building Limits",
    cMenuFuncs.RemoveBuildingLimits_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveBuildingLimits and "(Enabled)" or "(Disabled)"
      return des .. " Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes)."
    end,
    "toggle_post.tga"
  )
end
