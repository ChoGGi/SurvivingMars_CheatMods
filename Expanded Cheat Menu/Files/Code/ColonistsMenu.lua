local icon = "AlignSel.tga"
local icon2 = "Cube.tga"

function ChoGGi.MsgFuncs.ColonistsMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/No More Earthsick",
    ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.NoMoreEarthsick and "(Enabled)" or "(Disabled)"
      return des .. " Colonists will never become Earthsick (and removes any when you enable this)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Traits: Restrict For Selected Building Type",
    function()
      ChoGGi.MenuFuncs.SetBuildingTraits("restricttraits")
    end,
    nil,
    "Select a building and use this to only allow workers with certain traits to work there (block overrides).",
    icon2
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Traits: Block For Selected Building Type",
    function()
      ChoGGi.MenuFuncs.SetBuildingTraits("blocktraits")
    end,
    nil,
    "Select a building and use this to block workers with certain traits from working there (overrides restrict).",
    icon2
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/The Soylent Option",
    ChoGGi.MenuFuncs.TheSoylentOption,
    "Ctrl-Numpad 1",
    "Turns selected/moused over colonist into food (between 1-5), or shows a list with homeless/unemployed.",
    icon2
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Move Speed",
    ChoGGi.MenuFuncs.SetColonistMoveSpeed,
    nil,
    "How fast colonists will move.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Add Or Remove Applicants",
    ChoGGi.MenuFuncs.AddApplicantsToPool,
    nil,
    "Add random applicants to the passenger pool (has option to remove all).",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Gravity",
    ChoGGi.MenuFuncs.SetColonistsGravity,
    nil,
    "Change gravity of Colonists.",
    icon
  )

-------------------------------work
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Fire All Colonists!",
    ChoGGi.MenuFuncs.FireAllColonists,
    nil,
    "Fires everyone from every job.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Set All Work Shifts",
    ChoGGi.MenuFuncs.SetAllWorkShifts,
    nil,
    "Set all shifts on or off (able to cancel).",
    "ToggleEnvMap.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Colonists Avoid Fired Workplace",
    ChoGGi.MenuFuncs.AvoidWorkplace_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.AvoidWorkplaceSols,"(Disabled)","(Enabled)")
      return des .. " After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nWorks after colonist idle."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Performance Penalty Non-Specialist",
    ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.NonSpecialistPerformancePenalty,"(Disabled)","(Enabled)")
      return des .. " Disable performance penalty for non-Specialists.\nActivated when colonist changes job."
    end,
    icon
  )

  local function OutsideWorkplaceRadiusText()
    local des = Consts.DefaultOutsideWorkplacesRadius
    return "Change how many hexes colonists search outside their dome when looking for a Workplace.\nCurrent: " .. des
  end

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Outside Workplace Radius",
    ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius,
    nil,
    OutsideWorkplaceRadiusText(),
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Add Specialization To All",
    ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll,
    nil,
    "If Colonist has no Specialization then add a random one",
    icon
  )

-------------------------------stats
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Min Comfort Birth",
    ChoGGi.MenuFuncs.SetMinComfortBirth,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.MinComfortBirth,"(Disabled)","(Enabled)")
      return des .. " Change the limit on birthing comfort (more/less babies)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Visit Fail Penalty",
    ChoGGi.MenuFuncs.VisitFailPenalty_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.VisitFailPenalty,"(Disabled)","(Enabled)")
      return des .. " Disable comfort penalty when failing to satisfy a need via a visit."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Renegade Creation Toggle",
    ChoGGi.MenuFuncs.RenegadeCreation_Toggle,
    nil,
    function()
      local des = ""
      if Consts.RenegadeCreation == 9999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable creation of renegades.\nWorks after daily update."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Set Renegade Status",
    ChoGGi.MenuFuncs.SetRenegadeStatus,
    nil,
    "I'm afraid it could be 9/11 times 1,000.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Morale Always Max",
    ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.HighStatLevel,"(Disabled)","(Enabled)")
      return des .. " Colonists always max morale (will effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe)."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/See Dead Sanity Damage",
    ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.SeeDeadSanity,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from seeing dead.\nWorks after in-game hour."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/No Home Comfort Damage",
    ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.NoHomeComfort,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking comfort damage from not having a home.\nWorks after in-game hour."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Sanity Damage",
    ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.DustStormSanityDamage,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from certain events.\nWorks after in-game hour."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/University Grad Remove Idiot",
    ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait and "(Enabled)" or "(Disabled)"
      return des .. " When colonist graduates this will remove idiot trait."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Chance Of Negative Trait",
    ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.LowSanityNegativeTraitChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of getting a negative trait when Sanity reaches zero.\nWorks after colonist idle."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Suicide",
    ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.LowSanitySuicideChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of suicide when Sanity reaches zero.\nWorks after colonist idle."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Suffocate",
    ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle,
    nil,
    function()
      local des = ""
      if Consts.OxygenMaxOutsideTime == 99999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable colonists suffocating with no oxygen.\nWorks after in-game hour."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Starve",
    ChoGGi.MenuFuncs.ColonistsStarve_Toggle,
    nil,
    function()
      local des = ""
      if Consts.TimeBeforeStarving == 99999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable colonists starving with no food.\nWorks after colonist idle."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Positive Playground",
    ChoGGi.MenuFuncs.PositivePlayground_Toggle,
    nil,
    function()
      local des = ""
      if Consts.positive_playground_chance == 101 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " 100% Chance to get a perk (when grown) if colonist has visited a playground as a child."
    end,
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Project Morpheus Positive Trait",
    ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
    nil,
    function()
      local des = ""
      if Consts.ProjectMorphiousPositiveTraitChance == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " 100% Chance to get positive trait when Resting and ProjectMorpheus is active."
    end,
    icon
  )

  -------------------
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Age New",
    function()
      ChoGGi.MenuFuncs.SetColonistsAge(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain age.",
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Age",
    function()
      ChoGGi.MenuFuncs.SetColonistsAge(2)
    end,
    nil,
    "This will make all colonists a certain age.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Gender New",
    function()
      ChoGGi.MenuFuncs.SetColonistsGender(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain gender.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Gender",
    function()
      ChoGGi.MenuFuncs.SetColonistsGender(2)
    end,
    nil,
    "This will make all colonists a certain gender.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Specialization New",
    function()
      ChoGGi.MenuFuncs.SetColonistsSpecialization(1)
    end,
    nil,
    "This will make all newly arrived colonists a certain specialization (children and spec = black cube).",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Specialization",
    function()
      ChoGGi.MenuFuncs.SetColonistsSpecialization(2)
    end,
    nil,
    "This will make all colonists a certain specialization.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Race New",
    function()
      ChoGGi.MenuFuncs.SetColonistsRace(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain race.",
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Race",
    function()
      ChoGGi.MenuFuncs.SetColonistsRace(2)
    end,
    nil,
    "This will make all colonists a certain race.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Traits New",
    function()
      ChoGGi.MenuFuncs.SetColonistsTraits(1)
    end,
    nil,
    "This will make all newly arrived and born colonists have certain traits.",
    icon
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Traits",
    function()
      ChoGGi.MenuFuncs.SetColonistsTraits(2)
    end,
    nil,
    "Choose traits for all colonists.",
    icon
  )

  -------------------

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Set Stats",
    ChoGGi.MenuFuncs.SetColonistsStats,
    nil,
    "Change the stats of all colonists (health/sanity/comfort/morale).\n\nNot permanent.",
    icon
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Death Age",
    ChoGGi.MenuFuncs.SetDeathAge,
    nil,
    "Change the age at which colonists die.",
    icon
  )
end
