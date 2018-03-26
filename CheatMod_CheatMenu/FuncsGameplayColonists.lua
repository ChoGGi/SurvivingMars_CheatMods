function ChoGGi.BirthThreshold()
  if Consts.BirthThreshold == 999999900 then
    Consts.BirthThreshold = ChoGGi.Consts.BirthThreshold
  else
    Consts.BirthThreshold = 999999900
  end
  ChoGGi.CheatMenuSettings.BirthThreshold = Consts.BirthThreshold
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.MinComfortBirthToggle()
  if Consts.MinComfortBirth == 0 then
    Consts.MinComfortBirth = ChoGGi.Consts.MinComfortBirth
  else
    Consts.MinComfortBirth = 0
  end
  ChoGGi.CheatMenuSettings.MinComfortBirth = Consts.MinComfortBirth
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.VisitFailPenaltyToggle()
  if Consts.VisitFailPenalty == 0 then
    Consts.VisitFailPenalty = ChoGGi.Consts.VisitFailPenalty
  else
    Consts.VisitFailPenalty = 0
  end
  ChoGGi.CheatMenuSettings.VisitFailPenalty = Consts.VisitFailPenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.RenegadeCreationToggle()
  if Consts.RenegadeCreation == 9999900 then
    Consts.RenegadeCreation = ChoGGi.Consts.RenegadeCreation
  else
    Consts.RenegadeCreation = 9999900
  end
  ChoGGi.CheatMenuSettings.RenegadeCreation = Consts.RenegadeCreation
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("I just love findin' subversives.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsMoraleMaxToggle()
  if Consts.HighStatMoraleEffect == 999900 then
    Consts.HighStatMoraleEffect = ChoGGi.Consts.HighStatMoraleEffect
    Consts.HighStatLevel = ChoGGi.Consts.HighStatLevel
    Consts.LowStatLevel = ChoGGi.Consts.LowStatLevel
  else
    Consts.HighStatMoraleEffect = 999900
    Consts.HighStatLevel = -100
    Consts.LowStatLevel = -100
  end
  ChoGGi.CheatMenuSettings.HighStatMoraleEffect = Consts.HighStatMoraleEffect
  ChoGGi.CheatMenuSettings.HighStatLevel = Consts.HighStatLevel
  ChoGGi.CheatMenuSettings.LowStatLevel = Consts.LowStatLevel
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfSanityDamageToggle()
  if Consts.DustStormSanityDamage == 0 then
    Consts.DustStormSanityDamage = ChoGGi.Consts.DustStormSanityDamage
    Consts.MysteryDreamSanityDamage = ChoGGi.Consts.MysteryDreamSanityDamage
    Consts.ColdWaveSanityDamage = ChoGGi.Consts.ColdWaveSanityDamage
    Consts.MeteorSanityDamage = ChoGGi.Consts.MeteorSanityDamage
  else
    Consts.DustStormSanityDamage = 0
    Consts.MysteryDreamSanityDamage = 0
    Consts.ColdWaveSanityDamage = 0
    Consts.MeteorSanityDamage = 0
  end
  ChoGGi.CheatMenuSettings.DustStormSanityDamage = Consts.DustStormSanityDamage
  ChoGGi.CheatMenuSettings.MysteryDreamSanityDamage = Consts.MysteryDreamSanityDamage
  ChoGGi.CheatMenuSettings.ColdWaveSanityDamage = Consts.ColdWaveSanityDamage
  ChoGGi.CheatMenuSettings.MeteorSanityDamage = Consts.MeteorSanityDamage
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfNegativeTraitToggle()
  if Consts.LowSanityNegativeTraitChance == 0 then
    Consts.LowSanityNegativeTraitChance = ChoGGi.LowSanityNegativeTraitChance()
  else
    Consts.LowSanityNegativeTraitChance = 0
  end
  ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance = Consts.LowSanityNegativeTraitChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Stupid and happy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsChanceOfSuicideToggle()
  if Consts.LowSanitySuicideChance == 0 then
    Consts.LowSanitySuicideChance = ChoGGi.Consts.LowSanitySuicideChance
  else
    Consts.LowSanitySuicideChance = 0
  end
  ChoGGi.CheatMenuSettings.LowSanitySuicideChance = Consts.LowSanitySuicideChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Getting away ain't that easy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsSuffocateToggle()
  if Consts.OxygenMaxOutsideTime == 99999900 then
    Consts.OxygenMaxOutsideTime = ChoGGi.Consts.OxygenMaxOutsideTime
  else
    Consts.OxygenMaxOutsideTime = 99999900
  end
  ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime = Consts.OxygenMaxOutsideTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Free Air",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsStarveToggle()
  if Consts.TimeBeforeStarving == 99999900 then
    Consts.TimeBeforeStarving = ChoGGi.Consts.TimeBeforeStarving
  else
    Consts.TimeBeforeStarving = 99999900
  end
  ChoGGi.CheatMenuSettings.TimeBeforeStarving = Consts.TimeBeforeStarving
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Free Food",
   "Colonists","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.AvoidWorkplaceToggle()
  if Consts.AvoidWorkplaceSols == 0 then
    Consts.AvoidWorkplaceSols = ChoGGi.Consts.AvoidWorkplaceSols
  else
    Consts.AvoidWorkplaceSols = 0
  end
  ChoGGi.CheatMenuSettings.AvoidWorkplaceSols = Consts.AvoidWorkplaceSols
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("No Shame",
   "Colonists","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.PositivePlaygroundToggle()
  if Consts.positive_playground_chance == 101 then
    Consts.positive_playground_chance = ChoGGi.Consts.positive_playground_chance
  else
    Consts.positive_playground_chance = 101
  end
  ChoGGi.CheatMenuSettings.positive_playground_chance = Consts.positive_playground_chance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("We've all seen them, on the playground, at the store, walking on the streets.",
    "Traits","UI/Icons/Upgrades/home_collective_02.tga"
  )
end

function ChoGGi.ProjectMorpheusPositiveTraitToggle()
  if Consts.ProjectMorphiousPositiveTraitChance == 100 then
    Consts.ProjectMorphiousPositiveTraitChance = ChoGGi.Consts.ProjectMorphiousPositiveTraitChance
  else
    Consts.ProjectMorphiousPositiveTraitChance = 100
  end
  ChoGGi.CheatMenuSettings.ProjectMorphiousPositiveTraitChance = Consts.ProjectMorphiousPositiveTraitChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup('Say, "Small umbrella, small umbrella."',
   "Colonists","UI/Icons/Upgrades/rejuvenation_treatment_04.tga"
  )
end

function ChoGGi.PerformancePenaltyNonSpecialistToggle()
  if Consts.positive_playground_chance == 0 then
    Consts.positive_playground_chance = ChoGGi.Consts.NonSpecialistPerformancePenalty
  else
    Consts.positive_playground_chance = 0
  end
  ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty = Consts.NonSpecialistPerformancePenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("You never know what you're gonna get.",
   "Penalty","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.OutsideWorkplaceRadius(Bool)
  if Bool then
    Consts.DefaultOutsideWorkplacesRadius = Consts.DefaultOutsideWorkplacesRadius + 16
  else
    Consts.DefaultOutsideWorkplacesRadius = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
  end
  ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius = Consts.DefaultOutsideWorkplacesRadius
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Maybe tomorrow, I'll find what I call home. Until tomorrow, you know I'm free to roam.",
   "Colonists","UI/Icons/Sections/dome.tga"
  )
end

function ChoGGi.SetColonistsAge(Age,Msg)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.age_trait = Age
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsSex(Sex,Msg)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.gender = Sex
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.NewColonistAge(Type,Msg)
  ChoGGi.CheatMenuSettings.NewColonistAge = Type
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.NewColonistSex(Type,Msg)
  ChoGGi.CheatMenuSettings.NewColonistSex = Type
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsMorale(Number,Msg)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.stat_morale = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsSanity(Number,Msg)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.stat_sanity = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsComfort(Number,Msg)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.stat_comfort = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Upgrades/home_collective_04.tga")
end

function ChoGGi.SetColonistsHealth(Number,Msg)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.stat_health = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.PositiveTraitsRemoveAll()
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist:RemoveTrait("Workaholic")
    colonist:RemoveTrait("Survivor")
    colonist:RemoveTrait("Sexy")
    colonist:RemoveTrait("Composed")
    colonist:RemoveTrait("Genius")
    colonist:RemoveTrait("Celebrity")
    colonist:RemoveTrait("Saint")
    colonist:RemoveTrait("Religious")
    colonist:RemoveTrait("Gamer")
    colonist:RemoveTrait("DreamerPostMystery")
    colonist:RemoveTrait("Empath")
    colonist:RemoveTrait("Nerd")
    colonist:RemoveTrait("Rugged")
    colonist:RemoveTrait("Fit")
    colonist:RemoveTrait("Enthusiast")
    colonist:RemoveTrait("Hippie")
    colonist:RemoveTrait("Extrovert")
    colonist:RemoveTrait("Martianborn")
  end
  ChoGGi.MsgPopup("Added All Positive Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

function ChoGGi.PositiveTraitsAddAll()
  --CountColonistsWithTrait(trait)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist:AddTrait("Workaholic")
    colonist:AddTrait("Survivor")
    colonist:AddTrait("Sexy")
    colonist:AddTrait("Composed")
    colonist:AddTrait("Genius")
    colonist:AddTrait("Celebrity")
    colonist:AddTrait("Saint")
    colonist:AddTrait("Religious")
    colonist:AddTrait("Gamer")
    colonist:AddTrait("DreamerPostMystery")
    colonist:AddTrait("Empath")
    colonist:AddTrait("Nerd")
    colonist:AddTrait("Rugged")
    colonist:AddTrait("Fit")
    colonist:AddTrait("Enthusiast")
    colonist:AddTrait("Hippie")
    colonist:AddTrait("Extrovert")
    colonist:AddTrait("Martianborn")
  end
  ChoGGi.MsgPopup("Added All Positive Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

function ChoGGi.NegativeTraitsRemoveAll()
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist:RemoveTrait("Lazy")
    colonist:RemoveTrait("Refugee")
    colonist:RemoveTrait("ChronicCondition")
    colonist:RemoveTrait("Infected")
    colonist:RemoveTrait("Idiot")
    colonist:RemoveTrait("Alcoholic")
    colonist:RemoveTrait("Gambler")
    colonist:RemoveTrait("Glutton")
    colonist:RemoveTrait("Hypochondriac")
    colonist:RemoveTrait("Whiner")
    colonist:RemoveTrait("Clone")
    colonist:RemoveTrait("Renegade")
    colonist:RemoveTrait("Melancholic")
    colonist:RemoveTrait("Introvert")
    colonist:RemoveTrait("Coward")
    colonist:RemoveTrait("Tourist")
  end
  ChoGGi.MsgPopup("Removed All Negative Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

function ChoGGi.NegativeTraitsAddAll()
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist:AddTrait("Lazy")
    colonist:AddTrait("Refugee")
    colonist:AddTrait("ChronicCondition")
    colonist:AddTrait("Infected")
    colonist:AddTrait("Idiot")
    colonist:AddTrait("Alcoholic")
    colonist:AddTrait("Gambler")
    colonist:AddTrait("Glutton")
    colonist:AddTrait("Hypochondriac")
    colonist:AddTrait("Whiner")
    colonist:AddTrait("Clone")
    colonist:AddTrait("Renegade")
    colonist:AddTrait("Melancholic")
    colonist:AddTrait("Introvert")
    colonist:AddTrait("Coward")
    colonist:AddTrait("Tourist")
  end
  ChoGGi.MsgPopup("Removed All Negative Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

function ChoGGi.ColonistsAddSpecializationToAll()
  local jobs = { 'scientist', 'engineer', 'security', 'geologist', 'botanist', 'medic' }
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    if colonist.traits.none then
      colonist:SetSpecialization(jobs[ UICity:Random(1, 6) ], "init")
    end
  end
  ChoGGi.MsgPopup("No lazy good fer nuthins round here",
   "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: FuncsGameplayColonists.lua",true)
end
