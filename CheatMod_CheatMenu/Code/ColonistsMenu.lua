function ChoGGi.ColonistsMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Add Applicants",
    ChoGGi.AddApplicantsToPool,
    nil,
    "Add random applicants to the passenger pool.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Colonists Gravity",
    ChoGGi.SetGravityColonists,
    nil,
    "Change gravity of Colonists.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[3]Work/Fire All Colonists!",
    ChoGGi.FireAllColonists,
    nil,
    "Fires everyone from every job.",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[3]Work/Set All Work Shifts",
    ChoGGi.SetAllWorkShifts,
    nil,
    "Set all shifts on or off (able to cancel).",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Min Comfort Birth",
    ChoGGi.MinComfortBirth_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.MinComfortBirth,"(Disabled)","(Enabled)")
      return des .. " Lower limit on birthing comfort (more babies)."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Visit Fail Penalty",
    ChoGGi.VisitFailPenalty_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.VisitFailPenalty,"(Disabled)","(Enabled)")
      return des .. " Disable comfort penalty when failing to satisfy a need via a visit."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Renegade Creation Toggle",
    ChoGGi.RenegadeCreation_Toggle,
    nil,
    function()
      local des
      if Consts.RenegadeCreation == 9999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable creation of renegades.\nWorks after daily update."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Make All Colonists Renegades",
    ChoGGi.MakeAllColonistsRenegades,
    nil,
    "I'm afraid it could be 9/11 times 1,000.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Morale Always Max",
    ChoGGi.ColonistsMoraleAlwaysMax_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.HighStatLevel,"(Disabled)","(Enabled)")
      return des .. " Colonists always max morale (will effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe)."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/See Dead Sanity Damage",
    ChoGGi.SeeDeadSanityDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.SeeDeadSanity,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from seeing dead.\nWorks after in-game hour."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/No Home Comfort Damage",
    ChoGGi.NoHomeComfortDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.NoHomeComfort,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking comfort damage from not having a home.\nWorks after in-game hour."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Sanity Damage",
    ChoGGi.ChanceOfSanityDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.DustStormSanityDamage,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from certain events.\nWorks after in-game hour."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[2]Traits/Chance Of Negative Trait",
    ChoGGi.ChanceOfNegativeTrait_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.LowSanityNegativeTraitChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of getting a negative trait when Sanity reaches zero.\nWorks after colonist idle."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Suicide",
    ChoGGi.ColonistsChanceOfSuicide_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.LowSanitySuicideChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of suicide when Sanity reaches zero.\nWorks after colonist idle."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Colonists Suffocate",
    ChoGGi.ColonistsSuffocate_Toggle,
    nil,
    function()
      local des
      if Consts.OxygenMaxOutsideTime == 99999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable colonists suffocating with no oxygen.\nWorks after in-game hour."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Colonists Starve",
    ChoGGi.ColonistsStarve_Toggle,
    nil,
    function()
      local des
      if Consts.TimeBeforeStarving == 99999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable colonists starving with no food.\nWorks after colonist idle."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[3]Work/Colonists Avoid Fired Workplace",
    ChoGGi.AvoidWorkplace_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.AvoidWorkplaceSols,"(Disabled)","(Enabled)")
      return des .. " After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nWorks after colonist idle."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[2]Traits/Positive Playground",
    ChoGGi.PositivePlayground_Toggle,
    nil,
    function()
      local des
      if Consts.positive_playground_chance == 101 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " 100% Chance to get a perk (when grown) if colonist has visited a playground as a child."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[2]Traits/Project Morpheus Positive Trait",
    ChoGGi.ProjectMorpheusPositiveTrait_Toggle,
    nil,
    function()
      local des
      if Consts.ProjectMorphiousPositiveTraitChance == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " 100% Chance to get positive trait when Resting and ProjectMorpheus is active."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[3]Work/Performance Penalty Non-Specialist",
    ChoGGi.PerformancePenaltyNonSpecialist_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.NonSpecialistPerformancePenalty,"(Disabled)","(Enabled)")
      return des .. " Disable performance penalty for non-Specialists.\nActivated when colonist changes job."
    end,
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/[3]Work/Outside Workplace Radius",
    ChoGGi.SetOutsideWorkplaceRadius,
    nil,
    "Change how many hexes colonists search outside their dome when looking for a Workplace.",
    "AlignSel.tga"
  )
  -------------------
  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Age New",
    function()
      ChoGGi.SetColonistsAge(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain age.",
    "AlignSel.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Age",
    function()
      ChoGGi.SetColonistsAge(2)
    end,
    nil,
    "This will make all colonists a certain age.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Gender New",
    function()
      ChoGGi.SetColonistsGender(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain gender.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Gender",
    function()
      ChoGGi.SetColonistsGender(2)
    end,
    nil,
    "This will make all colonists a certain gender.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Specialization New",
    function()
      ChoGGi.SetColonistsSpecialization(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain specialization.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Specialization",
    function()
      ChoGGi.SetColonistsSpecialization(2)
    end,
    nil,
    "This will make all colonists a certain specialization.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Race New",
    function()
      ChoGGi.SetColonistsRace(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain race.",
    "AlignSel.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Race",
    function()
      ChoGGi.SetColonistsRace(2)
    end,
    nil,
    "This will make all colonists a certain race.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Traits New",
    function()
      ChoGGi.SetColonistsTraits(1)
    end,
    nil,
    "This will make all newly arrived and born colonists have certain traits.",
    "AlignSel.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Traits",
    function()
      ChoGGi.SetColonistsTraits(2)
    end,
    nil,
    "Choose traits for all colonists.",
    "AlignSel.tga"
  )

  -------------------

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Set Stats",
    ChoGGi.SetStatsOfAllColonists,
    nil,
    "Change the stats of all colonists.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Colonists/Colonists Death Age",
    ChoGGi.SetDeathAge,
    nil,
    "Change the age at which colonists die.",
    "AlignSel.tga"
  )
  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Colonists/[3]Work/Add Specialization To All",
    ChoGGi.ColonistsAddSpecializationToAll,
    nil,
    "If Colonist has no Specialization then add a random one",
    "AlignSel.tga"
  )
end
