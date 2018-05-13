local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)
  local icon = "Cube.tga"

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Empty Mech Depot",
    CCodeFuncs.EmptyMechDepot,
    nil,
    "Empties out selected/moused over mech depot into a small depot in front of it.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Annoying Sounds",
    CMenuFuncs.AnnoyingSounds_Toggle,
    nil,
    "Toggle annoying sounds (Sensor Tower, Mirror Sphere).",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Protection Radius",
    CMenuFuncs.SetProtectionRadius,
    nil,
    "Change threat protection coverage distance.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Unlock Locked Buildings",
    CMenuFuncs.UnlockLockedBuildings,
    nil,
    "Gives you a list of buildings you can unlock in the build menu.",
    "toggle_post.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Pipes Pillars Spacing",
    CMenuFuncs.PipesPillarsSpacing_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Unlimited Connection Length",
    CMenuFuncs.UnlimitedConnectionLength_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.UnlimitedConnectionLength and "(Enabled)" or "(Disabled)"
      return des .. " No more length limits to pipes, cables, and passages."
    end,
    "road_type.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Powerless Building",
    CMenuFuncs.BuildingPower_Toggle,
    nil,
    "Toggle electricity use for selected building type.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Set Charge & Discharge Rates",
    CMenuFuncs.SetMaxChangeOrDischarge,
    "Ctrl-Shift-R",
    "Change how fast Air/Water/Battery storage capacity changes.",
    icon
  )

  local function UseLastOrientationText()
    local des = ChoGGi.UserSettings.UseLastOrientation and "(Enabled)" or "(Disabled)"
    return des  .. " Use last building placement orientation."
  end
  CComFuncs.AddAction(
    "Expanded CM/Buildings/Use Last Orientation",
    CMenuFuncs.UseLastOrientation_Toggle,
    "F7",
    UseLastOrientationText(),
    "ToggleMapAreaEditor.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Farm Shifts All On",
    CMenuFuncs.FarmShiftsAllOn,
    nil,
    "Turns on all the farm shifts.",
    icon
  )
  --------------------
  CComFuncs.AddAction(
    "Expanded CM/Buildings/Production Amount Set",
    CMenuFuncs.SetProductionAmount,
    "Ctrl-Shift-P",
    "Set production of buildings of selected type, also applies to newly placed ones.\nWorks on any building that produces.",
    icon
  )
  --------------------
  CComFuncs.AddAction(
    "Expanded CM/Buildings/Fully Automated Buildings",
    CMenuFuncs.FullyAutomatedBuildings,
    nil,
    function()
      local des = ChoGGi.UserSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
      return des  .. " No more colonists needed.\nThanks to BoehserOnkel for the idea."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums Cure All",
    CMenuFuncs.SanatoriumCureAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
      return des .. " Sanatoriums can cure all bad traits."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Schools Train All",
    CMenuFuncs.SchoolTrainAll_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
      return des .. " Schools can train all good traits."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show All Traits",
    CMenuFuncs.ShowAllTraits_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Sanatoriums & Schools: Show Full List",
    CMenuFuncs.SanatoriumSchoolShowAll,
    nil,
    function()
      local des = ChoGGi.UserSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing all traits in side pane."
    end,
    "LightArea.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Maintenance Free",
    CMenuFuncs.MaintenanceBuildingsFree_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
      return des .. " Buildings don't build up maintenance points."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Moisture Vaporator Penalty",
    CMenuFuncs.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return des .. " Disable penalty when Moisture Vaporators are close to each other."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Crop Fail Threshold",
    CMenuFuncs.CropFailThreshold_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
      return des .. " Remove Threshold for failing crops (crops won't fail)."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Cheap Construction",
    CMenuFuncs.CheapConstruction_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return des .. " Build with minimal resources."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Building Damage Crime",
    CMenuFuncs.BuildingDamageCrime_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return des .. " Disable damage from renegedes to buildings."
    end,
    icon
  )

  --------------------
  CComFuncs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: No Chance Of Break",
    CMenuFuncs.CablesAndPipesNoBreak_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.BreakChanceCablePipe and "(Enabled)" or "(Disabled)"
      return des .. " Cables & pipes will never break."
    end,
    "ViewCamPath.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Cables & Pipes: Instant Build",
    CMenuFuncs.CablesAndPipesInstant_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
      return des .. " Cables and pipes are built instantly."
    end,
    "ViewCamPath.tga"
  )
  --------------------
  CComFuncs.AddAction(
    "Expanded CM/Buildings/Unlimited Wonders",
    CMenuFuncs.Building_wonder_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return des .. " Unlimited wonder build limit (restart game to toggle)."
    end,
    "toggle_post.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Show Hidden Buildings",
    CMenuFuncs.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return des .. " Show hidden buildings (restart game to toggle)."
    end,
    "LightArea.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Build Spires Outside of Spire Point",
    CMenuFuncs.Building_dome_spot_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
      return des .. " Build spires outside spire point.\nUse with Remove Building Limits to fill up a dome with spires."
    end,
    "toggle_post.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Buildings/Instant Build",
    CMenuFuncs.Building_instant_build_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
      return des .. " Allow buildings to be built instantly.\nDoesn't work with domes."
    end,
    "toggle_post.tga"
  )
  --------------------
  CComFuncs.AddAction(
    "Expanded CM/Buildings/Remove Building Limits",
    CMenuFuncs.RemoveBuildingLimits_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.RemoveBuildingLimits and "(Enabled)" or "(Disabled)"
      return des .. " Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes)."
    end,
    "toggle_post.tga"
  )
end
