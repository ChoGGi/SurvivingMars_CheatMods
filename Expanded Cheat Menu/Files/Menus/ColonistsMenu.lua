-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

local icon = "AlignSel.tga"

--~ AddAction(Entry,Menu,Action,Key,Des,Icon)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000369--[[No More Earthsick--]]]),
  ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NoMoreEarthsick,
      302535920000370--[[Colonists will never become Earthsick (and removes any when you enable this).--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000371--[[Traits: Restrict For Selected Building Type--]]]),
  function()
    ChoGGi.MenuFuncs.SetBuildingTraits("restricttraits")
  end,
  nil,
  302535920000372--[[Select a building and use this to only allow workers with certain traits to work there (block overrides).--]],
  "SelectByClassName.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000373--[[Traits: Block For Selected Building Type--]]]),
  function()
    ChoGGi.MenuFuncs.SetBuildingTraits("blocktraits")
  end,
  nil,
  302535920000374--[[Select a building and use this to block workers with certain traits from working there (overrides restrict).--]],
  "SelectByClassName.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000375--[[The Soylent Option--]]]),
  ChoGGi.MenuFuncs.TheSoylentOption,
  ChoGGi.UserSettings.KeyBindings.TheSoylentOption,
  302535920000376--[[Turns selected/moused over colonist into food (between 1-5), or shows a list with choices.--]],
  "Cube.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000377--[[Colonists Move Speed--]]]),
  ChoGGi.MenuFuncs.SetColonistMoveSpeed,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SpeedColonist,
      302535920000378--[[How fast colonists will move.--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000379--[[Add Or Remove Applicants--]]]),
  ChoGGi.MenuFuncs.AddApplicantsToPool,
  nil,
  302535920000380--[[Add random applicants to the passenger pool (has option to remove all).--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000381--[[Colonists Gravity--]]]),
  ChoGGi.MenuFuncs.SetColonistsGravity,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.GravityColonist,
      302535920000382--[[Change gravity of Colonists.--]]
    )
  end,
  icon
)

-------------------------------work
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[3]",S[302535920000212--[[Work--]]],"/",S[302535920000383--[[Fire All Colonists!--]]]),
  ChoGGi.MenuFuncs.FireAllColonists,
  nil,
  302535920000384--[[Fires everyone from every job.--]],
  "ToggleEnvMap.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[3]",S[302535920000212--[[Work--]]],"/",S[302535920000385--[[Set All Work Shifts--]]]),
  ChoGGi.MenuFuncs.SetAllWorkShifts,
  nil,
  302535920000386--[[Set all shifts on or off (able to cancel).--]],
  "ToggleEnvMap.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[3]",S[302535920000212--[[Work--]]],"/",S[302535920000387--[[Colonists Avoid Fired Workplace--]]]),
  ChoGGi.MenuFuncs.AvoidWorkplace_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.AvoidWorkplaceSols,
      302535920000388--[["After being fired, Colonists won't avoid that Workplace searching for a Workplace.
Works after colonist idle."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[3]",S[302535920000212--[[Work--]]],"/",S[302535920000389--[[Performance Penalty Non-Specialist--]]]),
  ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NonSpecialistPerformancePenalty,
      302535920000390--[["Disable performance penalty for non-Specialists.
Activated when colonist changes job."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[3]",S[302535920000212--[[Work--]]],"/",S[302535920000392--[[Outside Workplace Radius--]]]),
  ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius,
  nil,
  ChoGGi.ComFuncs.SettingState(
    ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius,
    302535920000391--[[Change how many hexes colonists search outside their dome when looking for a Workplace.--]]
  ),
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[3]",S[302535920000212--[[Work--]]],"/",S[302535920000393--[[Add Specialization To All--]]]),
  ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll,
  nil,
  302535920000394--[[If Colonist has no Specialization then add a random one--]],
  icon
)

-------------------------------stats
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000395--[[Min Comfort Birth--]]]),
  ChoGGi.MenuFuncs.SetMinComfortBirth,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.MinComfortBirth,
      302535920000396--[[Change the limit on birthing comfort (more/less babies).--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000397--[[Visit Fail Penalty--]]]),
  ChoGGi.MenuFuncs.VisitFailPenalty_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.VisitFailPenalty,
      302535920000398--[[Disable comfort penalty when failing to satisfy a need via a visit.--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000399--[[Renegade Creation Toggle--]]]),
  ChoGGi.MenuFuncs.RenegadeCreation_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.RenegadeCreation,
      302535920000400--[["Disable creation of renegades.
Works after daily update."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000401--[[Set Renegade Status--]]]),
  ChoGGi.MenuFuncs.SetRenegadeStatus,
  nil,
  302535920000448--[[I'm afraid it could be 9/11 times 1,000.--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000402--[[Morale Always Max--]]]),
  ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.HighStatLevel,
      302535920000403--[["Colonists always max morale (will effect birthing rates).
Only works on colonists that have yet to spawn (maybe)."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000404--[[See Dead Sanity Damage--]]]),
  ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.SeeDeadSanity,
      302535920000405--[["Disable colonists taking sanity damage from seeing dead.
Works after in-game hour."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000406--[[No Home Comfort Damage--]]]),
  ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NoHomeComfort,
      302535920000407--[["Disable colonists taking comfort damage from not having a home.
Works after in-game hour."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[302535920000408--[[Chance Of Sanity Damage--]]]),
  ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DustStormSanityDamage,
      302535920000409--[["Disable colonists taking sanity damage from certain events.
Works after in-game hour."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[2]",S[235--[[Traits--]]],"/",S[302535920000410--[[University Grad Remove Idiot--]]]),
  ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait,
      302535920000411--[[When colonist graduates this will remove idiot trait.--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[2]",S[235--[[Traits--]]],"/",S[302535920000412--[[Chance Of Negative Trait--]]]),
  ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.LowSanityNegativeTraitChance,
      302535920000413--[["isable chance of getting a negative trait when Sanity reaches zero.
Works after colonist idle."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[1]",S[5568--[[Stats--]]],"/",S[4576--[[Chance Of Suicide--]]]),
  ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.LowSanitySuicideChance,
      302535920000415--[["Disable chance of suicide when Sanity reaches zero.
Works after colonist idle."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000416--[[Colonists Suffocate--]]]),
  ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.OxygenMaxOutsideTime,
      302535920000417--[["Disable colonists suffocating with no oxygen.
Works after in-game hour."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000418--[[Colonists Starve--]]]),
  ChoGGi.MenuFuncs.ColonistsStarve_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.TimeBeforeStarving,
      302535920000419--[["Disable colonists starving with no food.
Works after colonist idle."--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[2]",S[235--[[Traits--]]],"/",S[302535920000420--[[Positive Playground--]]]),
  ChoGGi.MenuFuncs.PositivePlayground_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.positive_playground_chance,
      302535920000421--[[100% Chance to get a perk (when grown) if colonist has visited a playground as a child.--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/[2]",S[235--[[Traits--]]],"/",S[302535920000422--[[Project Morpheus Positive Trait--]]]),
  ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance,
      302535920000423--[[100% Chance to get positive trait when Resting and ProjectMorpheus is active.--]]
    )
  end,
  icon
)

-------------------
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000424--[[Set Age New--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsAge(1)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NewColonistAge,
      302535920000425--[[This will make all newly arrived and born colonists a certain age.--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000426--[[Set Age--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsAge(2)
  end,
  nil,
  302535920000427--[[This will make all colonists a certain age.--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000428--[[Set Gender New--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsGender(1)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NewColonistGender,
      302535920000429--[[This will make all newly arrived and born colonists a certain gender.--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000430--[[Set Gender--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsGender(2)
  end,
  nil,
  302535920000431--[[This will make all colonists a certain gender.--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000432--[[Set Specialization New--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsSpecialization(1)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NewColonistSpecialization,
      302535920000433--[[This will make all newly arrived colonists a certain specialization (children and spec = black cube).--]]
    )
  end,
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000434--[[Set Specialization--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsSpecialization(2)
  end,
  nil,
  302535920000435--[[This will make all colonists a certain specialization.--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000436--[[Set Race New--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsRace(1)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NewColonistRace,
      302535920000437--[[This will make all newly arrived and born colonists a certain race.--]]
    )
  end,
  icon
)
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000438--[[Set Race--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsRace(2)
  end,
  nil,
  302535920000439--[[This will make all colonists a certain race.--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000440--[[Set Traits New--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsTraits(1)
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.NewColonistTraits,
      302535920000441--[[This will make all newly arrived and born colonists have certain traits.--]]
    )
  end,
  icon
)
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000442--[[Set Traits--]]]),
  function()
    ChoGGi.MenuFuncs.SetColonistsTraits(2)
  end,
  nil,
  302535920000443--[[Choose traits for all colonists.--]],
  icon
)

-------------------

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000444--[[Set Stats--]]]),
  ChoGGi.MenuFuncs.SetColonistsStats,
  nil,
  302535920000445--[["Change the stats of all colonists (health/sanity/comfort/morale).

Not permanent."--]],
  icon
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[547--[[Colonists--]]],"/",S[302535920000446--[[Colonist Death Age--]]]),
  ChoGGi.MenuFuncs.SetDeathAge,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DeathAgeColonist,
      302535920000447--[[Change the age at which colonists die (applies to newly arrived and born colonists as well).--]]
    )
  end,
  icon
)
