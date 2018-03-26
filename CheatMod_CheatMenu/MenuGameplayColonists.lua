UserActions.AddActions({

  ChoGGi_BirthThresholdToggle = {
    menu = "Gameplay/Colonists/Baby Birth Toggle",
    description = function()
      local action
      if Consts.BirthThreshold == 999999900 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " maxed out BirthThreshold (no chance of birth)."
    end,
    action = ChoGGi.BirthThreshold,
  },

  ChoGGi_MinComfortBirthToggle = {
    menu = "Gameplay/Colonists/Min Comfort Birth Toggle",
    description = function()
      local action = Consts.MinComfortBirth and "(Disabled)" or "(Enabled)"
      return action .. " lower limit on birthing comfort."
    end,
    action = ChoGGi.MinComfortBirthToggle
  },

  ChoGGi_VisitFailPenaltyToggle = {
    menu = "Gameplay/Colonists/Visit Fail Penalty Toggle",
    description = function()
      local action = Consts.VisitFailPenalty and "(Disabled)" or "(Enabled)"
      return action .. " comfort penalty when failing to satisfy a need via a visit."
    end,
    action = ChoGGi.VisitFailPenaltyToggle
  },

  ChoGGi_RenegadeCreationToggle = {
    menu = "Gameplay/Colonists/Renegade Creation Toggle",
    description = function()
      local action
      if Consts.RenegadeCreation == 9999900 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Creation of renegades.\nWorks after daily update."
    end,
    action = ChoGGi.RenegadeCreationToggle
  },

  ChoGGi_ColonistsMoraleMaxToggle = {
    menu = "Gameplay/Colonists/Morale Max Toggle",
    description = function()
      local action
      if Consts.HighStatMoraleEffect == 999900 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Colonists always max morale (can effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe)."
    end,
    action = ChoGGi.ColonistsMoraleMaxToggle
  },

  ChoGGi_ChanceOfSanityDamageToggle = {
    menu = "Gameplay/Colonists/[3]Stats/Chance Of Sanity Damage Toggle",
    description = function()
      local action = Consts.DustStormSanityDamage and "(Disabled)" or "(Enabled)"
      return action .. " sanity damage from certain events.\nWorks after in-game hour."
    end,
    action = ChoGGi.ChanceOfSanityDamageToggle
  },

  ChoGGi_ChanceOfNegativeTraitToggle = {
    menu = "Gameplay/Colonists/[4]Traits/Chance Of Negative Trait Toggle",
    description = function()
      local action = Consts.LowSanityNegativeTraitChance and "(Disabled)" or "(Enabled)"
      return action .. " chance of getting a negative trait when Sanity reaches zero.\nWorks after colonist idle."
    end,
    action = ChoGGi.ChanceOfNegativeTraitToggle
  },

  ChoGGi_ColonistsChanceOfSuicideToggle = {
    menu = "Gameplay/Colonists/[3]Stats/Chance Of Suicide Toggle",
    description = function()
      local action = Consts.LowSanitySuicideChance and "(Disabled)" or "(Enabled)"
      return action .. " chance of suicide when Sanity reaches zero.\nWorks after colonist idle."
    end,
    action = ChoGGi.ColonistsChanceOfSuicideToggle
  },

  ChoGGi_ColonistsSuffocateToggle = {
    menu = "Gameplay/Colonists/[3]Stats/Colonists Suffocate Toggle",
    description = function()
      local action
      if Consts.OxygenMaxOutsideTime == 99999900 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " colonists suffocating with no oxygen.\nWorks after in-game hour."
    end,
    action = ChoGGi.ColonistsSuffocateToggle
  },

  ChoGGi_ColonistsStarveToggle = {
    menu = "Gameplay/Colonists/[3]Stats/Colonists Starve Toggle",
    description = function()
      local action
      if Consts.TimeBeforeStarving == 99999900 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " colonists starving with no food.\nWorks after colonist idle."
    end,
    action = ChoGGi.ColonistsStarveToggle
  },

  ChoGGi_AvoidWorkplaceToggle = {
    menu = "Gameplay/Colonists/[5]Work/Colonists Avoid Fired Workplace Toggle",
    description = function()
      local action = Consts.AvoidWorkplaceSols and "(Disabled)" or "(Enabled)"
      return action .. " After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nWorks after colonist idle."
    end,
    action = ChoGGi.AvoidWorkplaceToggle
  },

  ChoGGi_PositivePlaygroundToggle = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Playground Toggle",
    description = function()
      local action
      if Consts.positive_playground_chance == 101 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " 100% Chance to get a perk when grown if colonist has visited a playground as a child.\nOnly works on colonists that have yet to spawn (maybe)."
    end,
    action = ChoGGi.PositivePlaygroundToggle
  },

  ChoGGi_ProjectMorpheusPositiveTraitToggle = {
    menu = "Gameplay/Colonists/[4]Traits/Project Morpheus Positive Trait Toggle",
    description = function()
      local action
      if Consts.ProjectMorphiousPositiveTraitChance == 100 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " 100% Chance to get positive trait when Resting and ProjectMorpheus is active."
    end,
    action = ChoGGi.ProjectMorpheusPositiveTraitToggle
  },

  ChoGGi_PerformancePenaltyNonSpecialistToggle = {
    menu = "Gameplay/Colonists/[5]Work/Performance Penalty Non-Specialist Toggle",
    description = function()
      local action = Consts.NonSpecialistPerformancePenalty and "(Disabled)" or "(Enabled)"
      return action .. " Performance penalty for non-Specialists.\nActivated when colonist changes job."
    end,
    action = ChoGGi.PerformancePenaltyNonSpecialistToggle
  },

  ChoGGi_OutsideWorkplaceRadiusIncrease = {
    menu = "Gameplay/Colonists/[5]Work/Outside Workplace Radius + 16",
    description = function()
      return "Colonists search " .. Consts.DefaultOutsideWorkplacesRadius .. " + 16 hexes outside their Dome when looking for a Workplace (default 10)."
    end,
    action = function()
      ChoGGi.OutsideWorkplaceRadius(true)
    end
  },

  ChoGGi_OutsideWorkplaceRadiusDefault = {
    menu = "Gameplay/Colonists/[5]Work/Outside Workplace Radius Toggle",
    description = "Colonists search 10 hexes outside their Dome when looking for a Workplace.",
    action = ChoGGi.OutsideWorkplaceRadius
  },

  ChoGGi_NewColonistAgeChild = {
    menu = "Gameplay/Colonists/[6]New/Age: Children",
    description = "Make all newly arrived and born colonists Children",
    action = function()
      ChoGGi.NewColonistAge("Child","When you're youngest at heart")
    end
  },

  ChoGGi_NewColonistAgeYouth = {
    menu = "Gameplay/Colonists/[6]New/Age: Youth",
    description = "Make all newly arrived and born colonists Youths",
    action = function()
      ChoGGi.NewColonistAge("Youth","When you're young at heart")
    end
  },

  ChoGGi_NewColonistAgeAdult = {
    menu = "Gameplay/Colonists/[6]New/Age: Adult",
    description = "Make all newly arrived and born colonists Adults",
    action = function()
      ChoGGi.NewColonistAge("Adult","Time for the rat race")
    end
  },

  ChoGGi_NewColonistAgeMiddleAged = {
    menu = "Gameplay/Colonists/[6]New/Age: Middle Aged",
    description = "Make all newly arrived and born colonists Middle Aged",
    action = function()
      ChoGGi.NewColonistAge("Middle Aged","Still time for the rat race")
    end
  },

  ChoGGi_NewColonistAgeSenior = {
    menu = "Gameplay/Colonists/[6]New/Age: Senior",
    description = "Make all newly arrived and born colonists Seniors",
    action = function()
      ChoGGi.NewColonistAge("Senior","When you're (very much) young at heart")
    end
  },

  ChoGGi_NewColonistAgeRetiree = {
    menu = "Gameplay/Colonists/[6]New/Age: Retiree",
    description = "Make all newly arrived and born colonists Retirees",
    action = function()
      ChoGGi.NewColonistAge("Retiree","Time for some long pig")
    end
  },

  ChoGGi_NewColonistAgeDefault = {
    menu = "Gameplay/Colonists/[6]New/Age: Default",
    description = "Back to random Age",
    action = function()
      ChoGGi.NewColonistAge(false,"The miracle of childbirth")
    end
  },

  ChoGGi_NewColonistSexOther = {
    menu = "Gameplay/Colonists/[6]New/Sex: Other",
    description = "Make all newly arrived and born colonists Other",
    action = function()
      ChoGGi.NewColonistSex("Other","Whole lotta nothing going on")
    end
  },

  ChoGGi_NewColonistSexAndroid = {
    menu = "Gameplay/Colonists/[6]New/Sex: Android",
    description = "Make all newly arrived and born colonists Android",
    action = function()
      ChoGGi.NewColonistSex("Android","Ever kissed a cyborg? No.\nYou will.")
    end
  },

  ChoGGi_NewColonistSexClone = {
    menu = "Gameplay/Colonists/[6]New/Sex: Clone",
    description = "Make all newly arrived and born colonists Clone",
    action = function()
      ChoGGi.NewColonistSex("Clone","Nasty Star Wars funk in the pants.")
    end
  },

  ChoGGi_NewColonistSexMale = {
    menu = "Gameplay/Colonists/[6]New/Sex: Male",
    description = "Make all newly arrived and born colonists Male",
    action = function()
      ChoGGi.NewColonistSex("Male","Sausage Fest")
    end
  },

  ChoGGi_NewColonistSexFemale = {
    menu = "Gameplay/Colonists/[6]New/Sex: Female",
    description = "Make all newly arrived and born colonists Female",
    action = function()
      ChoGGi.NewColonistSex("Female","Fish Market")
    end
  },

  ChoGGi_NewColonistSexDefault = {
    menu = "Gameplay/Colonists/[6]New/Sex: Default",
    description = "Back to random Sex",
    action = function()
      ChoGGi.NewColonistSex(false,"The miracle of childbirth")
    end
  },

--modify colonists directly

  ChoGGi_ColonistsSetMorale100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Morale 100",
    description = "Set all Colonists Morale to 100",
    action = function()
      ChoGGi.SetColonistsMorale(100000,"Happy days are here again!")
    end
  },

  ChoGGi_ColonistsSetSanityMax = {
    menu = "Gameplay/Colonists/[3]Stats/Set Sanity Max",
    description = "Set all Colonists Sanity to Max",
    action = function()
      ChoGGi.SetColonistsSanity(9999900,"No need for shrinks")
    end
  },

  ChoGGi_ColonistsSetSanity100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Sanity 100",
    description = "Set all Colonists Sanity to 100",
    action = function()
      ChoGGi.SetColonistsSanity(100000,"No need for shrinks")
    end
  },

  ChoGGi_ColonistsSetComfortMax = {
    menu = "Gameplay/Colonists/[3]Stats/Set Comfort Max",
    description = "Set all Colonists Comfort to Max",
    action = function()
      ChoGGi.SetColonistsComfort(9999900,"Happy days are here again!")
    end
  },

  ChoGGi_ColonistsSetComfort100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Comfort 100",
    description = "Set all Colonists Comfort to 100",
    action = function()
      ChoGGi.SetColonistsComfort(100000,"Happy days are here again!")
    end
  },

  ChoGGi_ColonistsSetHealthMax = {
    menu = "Gameplay/Colonists/[3]Stats/Set Health Max",
    description = "Set all Colonists Health to Max",
    action = function()
      ChoGGi.SetColonistsHealth(9999900,"Healthy!")
    end
  },

  ChoGGi_ColonistsSetHealth100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Health 100",
    description = "Set all Colonists Health to 100",
    action = function()
      ChoGGi.SetColonistsHealth(100000,"Healthy!")
    end
  },

  ChoGGi_ColonistsSetAgesToChild = {
    menu = "Gameplay/Colonists/[1]Age/[1]Make all Colonists Children",
    description = "Make all Colonists Child age",
    action = function()
      ChoGGi.SetColonistsAge("Child","When you're youngest at heart")
    end
  },

  ChoGGi_ColonistsSetAgesToYouth = {
    menu = "Gameplay/Colonists/[1]Age/[2]Make all Colonists Youths",
    description = "Make all Colonists Youth age",
    action = function()
      ChoGGi.SetColonistsAge("Youth","When you're young at heart")
    end
  },

  ChoGGi_ColonistsSetAgesToAdult = {
    menu = "Gameplay/Colonists/[1]Age/[3]Make all Colonists Adult",
    description = "Make all Colonists Adult age",
    action = function()
      ChoGGi.SetColonistsAge("Adult","Time for the rat race")
    end
  },

  ChoGGi_ColonistsSetAgesToMiddleAged = {
    menu = "Gameplay/Colonists/[1]Age/[3]Make all Colonists Middle Aged",
    description = "Make all Colonists Middle Aged.",
    action = function()
      ChoGGi.SetColonistsAge("Middle Aged","Still time for the rat race")
    end
  },

  ChoGGi_ColonistsSetAgesToSenior = {
    menu = "Gameplay/Colonists/[1]Age/[4]Make all Colonists Senior",
    description = "Make all Colonists Senior age",
    action = function()
      ChoGGi.SetColonistsAge("Senior","When you're (very much) young at heart")
    end
  },

  ChoGGi_ColonistsSetAgesToRetiree = {
    menu = "Gameplay/Colonists/[1]Age/[5]Make all Colonists Retirees",
    description = "Make all Colonists Retiree age",
    action = function()
      ChoGGi.SetColonistsAge("Retiree","Time for some long pig")
    end
  },

  ChoGGi_ColonistsSetSexOther = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Others",
    description = "Make all Colonist's sex Other",
    action = function()
      ChoGGi.SetColonistsSex("Other","Whole lotta nothing going on")
    end
  },

  ChoGGi_ColonistsSetSexAndroid = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Androids",
    description = "Make all Colonist's sex Android",
    action = function()
      ChoGGi.SetColonistsSex("Android","Ever kissed a cyborg? No.\nYou will.")
    end
  },

  ChoGGi_ColonistsSetSexClone = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Clones",
    description = "Make all Colonist's sex Clone",
    action = function()
      ChoGGi.SetColonistsSex("Clone","Nasty Star Wars funk in the pants.")
    end
  },

  ChoGGi_ColonistsSetSexMale = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Male",
    description = "Make all Colonist's sex Male",
    action = function()
      ChoGGi.SetColonistsSex("Male","Sausage Fest")
    end
  },

  ChoGGi_ColonistsSetSexFemale = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Female",
    description = "Make all Colonist's sex Female",
    action = function()
      ChoGGi.SetColonistsSex("Female","Fish Market")
    end
  },

  ChoGGi_PositiveTraitsAddAll = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Traits Add All",
    description = "Add all Positive traits to colonists",
    action = ChoGGi.PositiveTraitsAddAll
  },

  ChoGGi_PositiveTraitsRemoveAll = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Traits Remove All",
    description = "Remove all Positive traits from colonists",
    action = ChoGGi.PositiveTraitsRemoveAll
  },

  ChoGGi_NegativeTraitsRemoveAll = {
    menu = "Gameplay/Colonists/[4]Traits/Negative Traits Remove All",
    description = "Remove all negative traits from colonists",
    action = ChoGGi.NegativeTraitsRemoveAll
  },

  ChoGGi_NegativeTraitsAddAll = {
    menu = "Gameplay/Colonists/[4]Traits/Negative Traits Add All",
    description = "Add all negative traits to colonists",
    action = ChoGGi.NegativeTraitsAddAll
  },

  ChoGGi_ColonistsAddSpecializationToAll = {
    menu = "Gameplay/Colonists/[5]Work/Add Specialization To All",
    description = "If Colonist has no Specialization then add a random one",
    action = ChoGGi.ColonistsAddSpecializationToAll
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuGameplayColonists.lua",true)
end
