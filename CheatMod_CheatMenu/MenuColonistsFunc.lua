function ChoGGi.BirthThreshold()
  if Consts.BirthThreshold == 999999900 then
    Consts.BirthThreshold = ChoGGi.Consts.BirthThreshold
  else
    Consts.BirthThreshold = 999999900
  end
  ChoGGi.CheatMenuSettings.BirthThreshold = Consts.BirthThreshold
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.BirthThreshold .. " Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.MinComfortBirthToggle()
  Consts.MinComfortBirth = ChoGGi.NumRetBool(Consts.MinComfortBirth,0,ChoGGi.Consts.MinComfortBirth)
  ChoGGi.CheatMenuSettings.MinComfortBirth = Consts.MinComfortBirth
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.MinComfortBirth .. " Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.VisitFailPenaltyToggle()
  Consts.VisitFailPenalty = ChoGGi.NumRetBool(Consts.VisitFailPenalty,0,ChoGGi.Consts.VisitFailPenalty)
  ChoGGi.CheatMenuSettings.VisitFailPenalty = Consts.VisitFailPenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.VisitFailPenalty .. " The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
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
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.RenegadeCreation .. " I just love findin' subversives.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsMoraleMaxToggle()
-- -100
  Consts.HighStatLevel = ChoGGi.NumRetBool(Consts.HighStatLevel,0,ChoGGi.Consts.HighStatLevel)
  Consts.LowStatLevel = ChoGGi.NumRetBool(Consts.LowStatLevel,0,ChoGGi.Consts.LowStatLevel)
  if Consts.HighStatMoraleEffect == 999900 then
    Consts.HighStatMoraleEffect = ChoGGi.Consts.HighStatMoraleEffect
  else
    Consts.HighStatMoraleEffect = 999900
  end
  ChoGGi.CheatMenuSettings.HighStatMoraleEffect = Consts.HighStatMoraleEffect
  ChoGGi.CheatMenuSettings.HighStatLevel = Consts.HighStatLevel
  ChoGGi.CheatMenuSettings.LowStatLevel = Consts.LowStatLevel
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.HighStatMoraleEffect .. " Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfSanityDamageToggle()
  Consts.DustStormSanityDamage = ChoGGi.NumRetBool(Consts.DustStormSanityDamage,0,ChoGGi.Consts.DustStormSanityDamage)
  Consts.MysteryDreamSanityDamage = ChoGGi.NumRetBool(Consts.MysteryDreamSanityDamage,0,ChoGGi.Consts.MysteryDreamSanityDamage)
  Consts.ColdWaveSanityDamage = ChoGGi.NumRetBool(Consts.ColdWaveSanityDamage,0,ChoGGi.Consts.ColdWaveSanityDamage)
  Consts.MeteorSanityDamage = ChoGGi.NumRetBool(Consts.MeteorSanityDamage,0,ChoGGi.Consts.MeteorSanityDamage)
  ChoGGi.CheatMenuSettings.DustStormSanityDamage = Consts.DustStormSanityDamage
  ChoGGi.CheatMenuSettings.MysteryDreamSanityDamage = Consts.MysteryDreamSanityDamage
  ChoGGi.CheatMenuSettings.ColdWaveSanityDamage = Consts.ColdWaveSanityDamage
  ChoGGi.CheatMenuSettings.MeteorSanityDamage = Consts.MeteorSanityDamage
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DustStormSanityDamage .. " Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfNegativeTraitToggle()
  Consts.LowSanityNegativeTraitChance = ChoGGi.NumRetBool(Consts.LowSanityNegativeTraitChance,0,ChoGGi.Consts.LowSanityNegativeTraitChance)
  ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance = Consts.LowSanityNegativeTraitChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance .. " Stupid and happy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsChanceOfSuicideToggle()
  Consts.LowSanitySuicideChance = ChoGGi.ToggleBoolNum(Consts.LowSanitySuicideChance)
  ChoGGi.CheatMenuSettings.LowSanitySuicideChance = Consts.LowSanitySuicideChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.LowSanitySuicideChance .. " Getting away ain't that easy",
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
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime .. " Free Air",
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
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.TimeBeforeStarving .. " Free Food",
   "Colonists","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.AvoidWorkplaceToggle()
  ConstsAvoidWorkplaceSols = ChoGGi.NumRetBool(Consts.AvoidWorkplaceSols,0,ChoGGi.Consts.AvoidWorkplaceSols)
  ChoGGi.CheatMenuSettings.AvoidWorkplaceSols = Consts.AvoidWorkplaceSols
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.AvoidWorkplaceSols .. " No Shame",
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
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.positive_playground_chance .. " We've all seen them, on the playground, at the store, walking on the streets.",
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
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.ProjectMorphiousPositiveTraitChance .. ' Say, "Small umbrella, small umbrella."',
   "Colonists","UI/Icons/Upgrades/rejuvenation_treatment_04.tga"
  )
end

function ChoGGi.PerformancePenaltyNonSpecialistToggle()
  Consts.NonSpecialistPerformancePenalty = ChoGGi.NumRetBool(Consts.NonSpecialistPerformancePenalty,0,ChoGGi.Consts.NonSpecialistPerformancePenalty)
  ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty = Consts.NonSpecialistPerformancePenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty .. " You never know what you're gonna get.",
   "Penalty","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.OutsideWorkplaceRadius(Bool)
  if Bool == true then
    Consts.DefaultOutsideWorkplacesRadius = Consts.DefaultOutsideWorkplacesRadius + 16
  else
    Consts.DefaultOutsideWorkplacesRadius = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
  end
  ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius = Consts.DefaultOutsideWorkplacesRadius
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius .. " Maybe tomorrow, I'll find what I call home. Until tomorrow, you know I'm free to roam.",
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

function ChoGGi.ColonistsAddSpecializationToAll()
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    if colonist.traits.none then
      colonist:SetSpecialization(ChoGGi.ColonistSpecializations[UICity:Random(1,6)],"init") --1-6 = num of specializations
    end
  end
  ChoGGi.MsgPopup("No lazy good fer nuthins round here",
   "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.PositiveTraitsAllToggle(Bool)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    for i = 1, #ChoGGi.PositiveTraits do
      if Bool == true then
        colonist:AddTrait(ChoGGi.PositiveTraits[i])
      else
        colonist:RemoveTrait(ChoGGi.PositiveTraits[i])
      end
    end
  end
  ChoGGi.MsgPopup("All Positive Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

function ChoGGi.NegativeTraitsAllToggle(Bool)
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    for i = 1, #ChoGGi.NegativeTraits do
      if Bool == true then
        colonist:AddTrait(ChoGGi.NegativeTraits[i])
      else
        colonist:RemoveTrait(ChoGGi.NegativeTraits[i])
      end
    end
  end
  ChoGGi.MsgPopup("All Negative Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuColonistsFunc.lua",true)
end
