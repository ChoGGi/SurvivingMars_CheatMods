-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local TConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Trans
local icon = "AlignSel.tga"
local icon2 = "Cube.tga"

function ChoGGi.MsgFuncs.ColonistsMenu_ChoGGi_Loaded()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000369--[[No More Earthsick--]])),
    ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.NoMoreEarthsick,
        302535920000370 --,"Colonists will never become Earthsick (and removes any when you enable this)."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000371--[[Traits: Restrict For Selected Building Type--]])),
    function()
      ChoGGi.MenuFuncs.SetBuildingTraits("restricttraits")
    end,
    nil,
    T(302535920000372--[[Select a building and use this to only allow workers with certain traits to work there (block overrides).--]]),
    icon2
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000373--[[Traits: Block For Selected Building Type--]])),
    function()
      ChoGGi.MenuFuncs.SetBuildingTraits("blocktraits")
    end,
    nil,
    T(302535920000374--[[Select a building and use this to block workers with certain traits from working there (overrides restrict).--]]),
    icon2
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000375--[[The Soylent Option--]])),
    ChoGGi.MenuFuncs.TheSoylentOption,
    "Ctrl-Alt-Numpad 1",
    T(302535920000376--[[Turns selected/moused over colonist into food (between 1-5), or shows a list with choices.--]]),
    icon2
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000377--[[Colonists Move Speed--]])),
    ChoGGi.MenuFuncs.SetColonistMoveSpeed,
    nil,
    T(302535920000378--[[How fast colonists will move.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000379--[[Add Or Remove Applicants--]])),
    ChoGGi.MenuFuncs.AddApplicantsToPool,
    nil,
    T(302535920000380--[[Add random applicants to the passenger pool (has option to remove all).--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000381--[[Colonists Gravity--]])),
    ChoGGi.MenuFuncs.SetColonistsGravity,
    nil,
    T(302535920000382--[[Change gravity of Colonists.--]]),
    icon
  )

-------------------------------work
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[3]",T(302535920000212--[[Work--]]),"/",T(302535920000383--[[Fire All Colonists!--]])),
    ChoGGi.MenuFuncs.FireAllColonists,
    nil,
    T(302535920000384--[[Fires everyone from every job.--]]),
    "ToggleEnvMap.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[3]",T(302535920000212--[[Work--]]),"/",T(302535920000385--[[Set All Work Shifts--]])),
    ChoGGi.MenuFuncs.SetAllWorkShifts,
    nil,
    T(302535920000386--[[Set all shifts on or off (able to cancel).--]]),
    "ToggleEnvMap.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[3]",T(302535920000212--[[Work--]]),"/",T(302535920000387--[[Colonists Avoid Fired Workplace--]])),
    ChoGGi.MenuFuncs.AvoidWorkplace_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.AvoidWorkplaceSols,
        302535920000388 --,"After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nWorks after colonist idle."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[3]",T(302535920000212--[[Work--]]),"/",T(302535920000389--[[Performance Penalty Non-Specialist--]])),
    ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.NonSpecialistPerformancePenalty,
        302535920000390,"Disable performance penalty for non-Specialists.\nActivated when colonist changes job."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[3]",T(302535920000212--[[Work--]]),"/",T(302535920000392--[[Outside Workplace Radius--]])),
    ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius,
    nil,
    ChoGGi.ComFuncs.SettingState(Consts.DefaultOutsideWorkplacesRadius,
      302535920000391 --,"Change how many hexes colonists search outside their dome when looking for a Workplace."
    ),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[3]",T(302535920000212--[[Work--]]),"/",T(302535920000393--[[Add Specialization To All--]])),
    ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll,
    nil,
    T(302535920000394--[[If Colonist has no Specialization then add a random one--]]),
    icon
  )

-------------------------------stats
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000395--[[Min Comfort Birth--]])),
    ChoGGi.MenuFuncs.SetMinComfortBirth,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.MinComfortBirth,
        302535920000396 --,"Change the limit on birthing comfort (more/less babies)."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000397--[[Visit Fail Penalty--]])),
    ChoGGi.MenuFuncs.VisitFailPenalty_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.VisitFailPenalty,
        302535920000398 --,"Disable comfort penalty when failing to satisfy a need via a visit."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000399--[[Renegade Creation Toggle--]])),
    ChoGGi.MenuFuncs.RenegadeCreation_Toggle,
    nil,
    function()
      local des
      if Consts.RenegadeCreation == 9999900 then
        des = {T(302535920000030--[[Enabled--]]),": "}
      else
        des = {T(302535920000036--[[Disabled--]]),": "}
      end
        des[#des+1] = T(302535920000400--[[Disable creation of renegades.\nWorks after daily update.--]])
      return Concat(des)
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000401--[[Set Renegade Status--]])),
    ChoGGi.MenuFuncs.SetRenegadeStatus,
    nil,
    T(302535920000448--[[I'm afraid it could be 9/11 times 1,000.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000402--[[Morale Always Max--]])),
    ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.HighStatLevel,
        302535920000403 --,"Colonists always max morale (will effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe)."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000404--[[See Dead Sanity Damage--]])),
    ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.SeeDeadSanity,
        302535920000405 --,"Disable colonists taking sanity damage from seeing dead.\nWorks after in-game hour."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000406--[[No Home Comfort Damage--]])),
    ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.NoHomeComfort,
        302535920000407 --,"Disable colonists taking comfort damage from not having a home.\nWorks after in-game hour."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(302535920000408--[[Chance Of Sanity Damage--]])),
    ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.DustStormSanityDamage,
        302535920000409 --,"Disable colonists taking sanity damage from certain events.\nWorks after in-game hour."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[2]",T(235--[[Traits--]]),"/",T(302535920000410--[[University Grad Remove Idiot--]])),
    ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait,
        302535920000411 --,"When colonist graduates this will remove idiot trait."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[2]",T(235--[[Traits--]]),"/",T(302535920000412--[[Chance Of Negative Trait--]])),
    ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.LowSanityNegativeTraitChance,
        302535920000413 --,"Disable chance of getting a negative trait when Sanity reaches zero.\nWorks after colonist idle."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[1]",T(5568--[[Stats--]]),"/",T(4576--[[Chance Of Suicide--]])),
    ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.LowSanitySuicideChance,
        302535920000415 --,"Disable chance of suicide when Sanity reaches zero.\nWorks after colonist idle."
      )
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000416--[[Colonists Suffocate--]])),
    ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle,
    nil,
    function()
      local des
      if Consts.OxygenMaxOutsideTime == 99999900 then
        des = {T(302535920000030--[[Enabled--]]),": "}
      else
        des = {T(302535920000036--[[Disabled--]]),": "}
      end
      des[#des+1] = T(302535920000417--[[Disable colonists suffocating with no oxygen.\nWorks after in-game hour.--]])
      return Concat(des)
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000418--[[Colonists Starve--]])),
    ChoGGi.MenuFuncs.ColonistsStarve_Toggle,
    nil,
    function()
      local des
      if Consts.TimeBeforeStarving == 99999900 then
        des = {T(302535920000030--[[Enabled--]]),": "}
      else
        des = {T(302535920000036--[[Disabled--]]),": "}
      end
      des[#des+1] = T(302535920000419--[[Disable colonists starving with no food.\nWorks after colonist idle.--]])
      return TConcat(des)
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[2]",T(235--[[Traits--]]),"/",T(302535920000420--[[Positive Playground--]])),
    ChoGGi.MenuFuncs.PositivePlayground_Toggle,
    nil,
    function()
      local des
      if Consts.positive_playground_chance == 101 then
        des = {T(302535920000030--[[Enabled--]]),": "}
      else
        des = {T(302535920000036--[[Disabled--]]),": "}
      end
      des[#des+1] = T(302535920000421--[[100% Chance to get a perk (when grown) if colonist has visited a playground as a child.--]])
      return TConcat(des)
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/[2]",T(235--[[Traits--]]),"/",T(302535920000422--[[Project Morpheus Positive Trait--]])),
    ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
    nil,
    function()
      local des
      if Consts.ProjectMorphiousPositiveTraitChance == 100 then
        des = {T(302535920000030--[[Enabled--]]),": "}
      else
        des = {T(302535920000036--[[Disabled--]]),": "}
      end
      des[#des+1] = T(302535920000423--[[100% Chance to get positive trait when Resting and ProjectMorpheus is active.--]])
      return TConcat(des)
    end,
    icon
  )

  -------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000424--[[Set Age New--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsAge(1)
    end,
    nil,
    T(302535920000425--[[This will make all newly arrived and born colonists a certain age.--]]),
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000426--[[Set Age--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsAge(2)
    end,
    nil,
    T(302535920000427--[[This will make all colonists a certain age.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000428--[[Set Gender New--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsGender(1)
    end,
    nil,
    T(302535920000429--[[This will make all newly arrived and born colonists a certain gender.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000430--[[Set Gender--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsGender(2)
    end,
    nil,
    T(302535920000431--[[This will make all colonists a certain gender.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000432--[[Set Specialization New--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsSpecialization(1)
    end,
    nil,
    T(302535920000433--[[This will make all newly arrived colonists a certain specialization (children and spec = black cube).--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000434--[[Set Specialization--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsSpecialization(2)
    end,
    nil,
    T(302535920000435--[[This will make all colonists a certain specialization.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000436--[[Set Race New--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsRace(1)
    end,
    nil,
    T(302535920000437--[[This will make all newly arrived and born colonists a certain race.--]]),
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000438--[[Set Race--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsRace(2)
    end,
    nil,
    T(302535920000439--[[This will make all colonists a certain race.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000440--[[Set Traits New--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsTraits(1)
    end,
    nil,
    T(302535920000441--[[This will make all newly arrived and born colonists have certain traits.--]]),
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000442--[[Set Traits--]])),
    function()
      ChoGGi.MenuFuncs.SetColonistsTraits(2)
    end,
    nil,
    T(302535920000443--[[Choose traits for all colonists.--]]),
    icon
  )

  -------------------

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000444--[[Set Stats--]])),
    ChoGGi.MenuFuncs.SetColonistsStats,
    nil,
    T(302535920000445--[[Change the stats of all colonists (health/sanity/comfort/morale).\n\nNot permanent.--]]),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(547--[[Colonists--]]),"/",T(302535920000446--[[Colonists Death Age--]])),
    ChoGGi.MenuFuncs.SetDeathAge,
    nil,
    T(302535920000447--[[Change the age at which colonists die.--]]),
    icon
  )
end
