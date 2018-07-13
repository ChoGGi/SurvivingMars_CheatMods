-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
local icon = "Cube.tga"

function ChoGGi.MsgFuncs.BuildingsMenu_ChoGGi_Loaded()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000164--[[Storage Amount Of Diner & Grocery--]])),
    ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ServiceWorkplaceFoodStorage,
        302535920000167--[[Change how much food is stored in them (less chance of starving colonists when busy).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000168--[[Triboelectric Scrubber Radius--]])),
    function()
      ChoGGi.MenuFuncs.SetUIRangeBuildingRadius("TriboelectricScrubber",Concat("\n",T(302535920000169--[[Ladies and gentlemen, this is your captain speaking. We have a small problem.
All four engines have stopped. We are doing our damnedest to get them going again.
I trust you are not in too much distress.--]])))
    end,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.TriboelectricScrubberRadius,
        302535920000170--[[Extend the range of the scrubber.--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000171--[[SubsurfaceHeater Radius--]])),
    function()
      ChoGGi.MenuFuncs.SetUIRangeBuildingRadius("SubsurfaceHeater","\n",T(302535920000172--[[Some smart quip about heating?--]]))
    end,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SubsurfaceHeaterRadius,
        302535920000173--[[Extend the range of the heater.--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000174--[[Always Dusty--]])),
    ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.AlwaysDustyBuildings,
        302535920000175--[[Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000176--[[Empty Mech Depot--]])),
    ChoGGi.CodeFuncs.EmptyMechDepot,
    nil,
    T(302535920000177--[[Empties out selected/moused over mech depot into a small depot in front of it.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000178--[[Protection Radius--]])),
    ChoGGi.MenuFuncs.SetProtectionRadius,
    nil,
    T(302535920000179--[[Change threat protection coverage distance.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000180--[[Unlock Locked Buildings--]])),
    ChoGGi.MenuFuncs.UnlockLockedBuildings,
    nil,
    T(302535920000181--[[Gives you a list of buildings you can unlock in the build menu.--]]),
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000182--[[Pipes Pillars Spacing--]])),
    ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.PipesPillarSpacing,
        302535920000183--[[Only place Pillars at start and end.--]]
      )
    end,
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000184--[[Unlimited Connection Length--]])),
    ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.UnlimitedConnectionLength,
        302535920000185--[[No more length limits to pipes, cables, and passages.--]]
      )
    end,
    "road_type.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/[12]",T(302535920000186--[[Power-free Building--]])),
    ChoGGi.MenuFuncs.BuildingPower_Toggle,
    nil,
    T(302535920000187--[[Toggle electricity use for selected building type.--]]),
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/[13]",T(302535920001251--[[Water-free Building--]])),
    ChoGGi.MenuFuncs.BuildingWater_Toggle,
    nil,
    T(302535920001252--[[Toggle water use for selected building type.--]]),
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/[14]",T(302535920001253--[[Oxygen-free Building--]])),
    ChoGGi.MenuFuncs.BuildingAir_Toggle,
    nil,
    T(302535920001254--[[Toggle oxygen use for selected building type.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000188--[[Set Charge & Discharge Rates--]])),
    ChoGGi.MenuFuncs.SetMaxChangeOrDischarge,
    ChoGGi.UserSettings.KeyBindings.SetMaxChangeOrDischarge,
    T(302535920000189--[[Change how fast Air/Water/Battery storage capacity changes.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000191--[[Use Last Orientation--]])),
    ChoGGi.MenuFuncs.UseLastOrientation_Toggle,
    "F7",
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.UseLastOrientation,
      302535920000190--[[Use last building placement orientation.--]]
    ),
    "ToggleMapAreaEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000198--[[Sanatoriums Cure All--]])),
    ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SanatoriumCureAll,
        302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000200--[[Schools Train All--]])),
    ChoGGi.MenuFuncs.SchoolTrainAll_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SchoolTrainAll,
        302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000192--[[Farm Shifts All On--]])),
    ChoGGi.MenuFuncs.FarmShiftsAllOn,
    nil,
    T(302535920000193--[[Turns on all the farm shifts.--]]),
    icon
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000194--[[Production Amount Set--]])),
    ChoGGi.MenuFuncs.SetProductionAmount,
    ChoGGi.UserSettings.KeyBindings.SetProductionAmount,
    T(302535920000195--[[Set production of buildings of selected type, also applies to newly placed ones.
Works on any building that produces.--]]),
    icon
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000196--[[Fully Automated Building--]])),
    ChoGGi.MenuFuncs.SetFullyAutomatedBuildings,
    nil,
    T(302535920000197--[[Work without workers (select a building and this will apply to all of type or selected).
Thanks to BoehserOnkel for the idea.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000202--[[Sanatoriums & Schools: Show All Traits--]])),
    ChoGGi.MenuFuncs.ShowAllTraits_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(g_SchoolTraits,
        302535920000203--[[Shows all appropriate traits in Sanatoriums/Schools side panel popup menu.--]]
      )
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000204--[[Sanatoriums & Schools: Show Full List--]])),
    ChoGGi.MenuFuncs.SanatoriumSchoolShowAll,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SanatoriumSchoolShowAll,
        302535920000205--[[Toggle showing full list of trait selectors in side pane.--]]
      )
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000206--[[Maintenance Free Inside--]])),
    ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.InsideBuildingsNoMaintenance,
        302535920000207--[[Buildings inside domes don't build maintenance points (takes away instead of adding).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000208--[[Maintenance Free--]])),
    ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RemoveMaintenanceBuildUp,
        302535920000209--[[Building maintenance points reverse (takes away instead of adding).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000210--[[Moisture Vaporator Penalty--]])),
    ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(const.MoistureVaporatorRange,
        302535920000211--[[Disable penalty when Moisture Vaporators are close to each other.--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(4711--[[Crop Fail Threshold--]])),
    ChoGGi.MenuFuncs.CropFailThreshold_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.CropFailThreshold,
        302535920000213--[[Remove Threshold for failing crops (crops won't fail).--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000214--[[Cheap Construction--]])),
    ChoGGi.MenuFuncs.CheapConstruction_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.rebuild_cost_modifier,
        302535920000215--[[Build with minimal resources.--]]
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000216--[[Building Damage Crime--]])),
    ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.CrimeEventSabotageBuildingsCount,
        302535920000217--[[Disable damage from renegedes to buildings.--]]
      )
    end,
    icon
  )

  --------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000218--[[Cables & Pipes--]]),": ",T(302535920000218--[[No Chance Of Break--]])),
    ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.BreakChanceCablePipe,
        Concat(T(302535920000157--[[Cables & Pipes--]]),": ",T(302535920000219--[[will never break.--]]))
      )
    end,
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000157--[[Cables & Pipes--]]),": ",T(134--[[Instant Build--]])),
    ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.InstantCables,
        Concat(T(302535920000157--[[Cables & Pipes--]])," ",T(302535920000221--[[are built instantly.--]]))
      )
    end,
    "ViewCamPath.tga"
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000222--[[Unlimited Wonders--]])),
    ChoGGi.MenuFuncs.Building_wonder_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_wonder,
        302535920000223--[[Unlimited wonder build limit (restart game to toggle).--]]
      )
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000224--[[Show Hidden Buildings--]])),
    ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_hide_from_build_menu,
        302535920000225--[[Show hidden buildings (restart game to toggle).--]]
      )
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000226--[[Build Spires Outside of Spire Point--]])),
    ChoGGi.MenuFuncs.Building_dome_spot_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_dome_spot,
        302535920000227--[[Build spires outside spire point.
Use with Remove Building Limits to fill up a dome with spires.--]]
      )
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920001241--[[Instant Build--]])),
    ChoGGi.MenuFuncs.Building_instant_build_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_instant_build,
        302535920000229--[[Allow buildings to be built instantly.
Doesn't work with domes.--]]
      )
    end,
    "toggle_post.tga"
  )
  --------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(3980--[[Buildings--]]),"/",T(302535920000230--[[Remove Building Limits--]])),
    ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RemoveBuildingLimits,
        302535920000231--[[Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes).--]]
      )
    end,
    "toggle_post.tga"
  )
end
