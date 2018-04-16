function ChoGGi.FillAllStatsOfAllColonists()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.stat_morale = 100 * ChoGGi.Consts.ResourceScale
    colonist.stat_sanity = 100 * ChoGGi.Consts.ResourceScale
    colonist.stat_comfort = 100 * ChoGGi.Consts.ResourceScale
    colonist.stat_health = 100 * ChoGGi.Consts.ResourceScale
  end
end

function ChoGGi.AddApplicants()
  local number = 250
  local now = GameTime()
  local self = SA_AddApplicants
  for i = 1, number do
    local colonist = GenerateApplicant(now)
    local to_add = self.Trait
    if self.Trait == "random_positive" then
      to_add = GetRandomTrait(colonist.traits, {}, {}, "Positive", "base")
    elseif self.Trait == "random_negative" then
      to_add = GetRandomTrait(colonist.traits, {}, {}, "Negative", "base")
    elseif self.Trait == "random_rare" then
      to_add = GetRandomTrait(colonist.traits, {}, {}, "Rare", "base")
    elseif self.Trait == "random_common" then
      to_add = GetRandomTrait(colonist.traits, {}, {}, "Common", "base")
    elseif self.Trait == "random" then
      to_add = GenerateTraits(colonist, false, 1)
    else
      to_add = self.Trait
    end
    if type(to_add) == "table" then
      for trait in pairs(to_add) do
        colonist.traits[trait] = true
      end
    else
      colonist.traits[to_add] = true
    end
    if self.Specialization ~= "any" then
      colonist.traits[self.Specialization] = true
      colonist.specialist = self.Specialization
    end
  end
  ChoGGi.MsgPopup("Added 250 applicants",
    "Applicants","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.FireAllColonists(Which)
  local FireAllColonists = function()
    for _,object in ipairs(UICity.labels.Colonist or empty_table) do
        object:GetFired()
    end
  end
  ChoGGi.QuestionBox("Are you sure you want to fire everyone?",FireAllColonists,"Yer outta here!")
end

function ChoGGi.AllShifts_Toggle(Bool,Msg)
  local AllShiftsToggle = function()
    --for _,object in ipairs(UICity.labels.Building or empty_table) do
    for _,object in ipairs(UICity.labels.ShiftsBuilding or empty_table) do
      if object.closed_shifts then
        if Bool == true then
          object.closed_shifts = {true,true,true}
        else
          object.closed_shifts = {false,false,false}
        end
      end
    end
  end
  ChoGGi.QuestionBox("Are you sure you want to turn " .. Msg .. ": all shifts?",AllShiftsToggle,"Early night? Vamos al bar les serviria un trago.")
end

function ChoGGi.MinComfortBirth_Toggle()
  Consts.MinComfortBirth = ChoGGi.NumRetBool(Consts.MinComfortBirth,0,ChoGGi.Consts.MinComfortBirth)
  ChoGGi.CheatMenuSettings.MinComfortBirth = Consts.MinComfortBirth
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.MinComfortBirth .. ": Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.VisitFailPenalty_Toggle()
  Consts.VisitFailPenalty = ChoGGi.NumRetBool(Consts.VisitFailPenalty,0,ChoGGi.Consts.VisitFailPenalty)
  ChoGGi.CheatMenuSettings.VisitFailPenalty = Consts.VisitFailPenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.VisitFailPenalty .. ": The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.RenegadeCreation_Toggle()
  if Consts.RenegadeCreation == 9999900 then
    Consts.RenegadeCreation = ChoGGi.Consts.RenegadeCreation
  else
    Consts.RenegadeCreation = 9999900
  end
  ChoGGi.CheatMenuSettings.RenegadeCreation = Consts.RenegadeCreation
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.RenegadeCreation .. ": I just love findin' subversives.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsMoraleAlwaysMax_Toggle()
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
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.HighStatMoraleEffect .. ": Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.SeeDeadSanityDamage_Toggle()
  Consts.SeeDeadSanity = ChoGGi.NumRetBool(Consts.SeeDeadSanity,0,ChoGGi.Consts.SeeDeadSanity)
  ChoGGi.CheatMenuSettings.SeeDeadSanity = Consts.SeeDeadSanity
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.SeeDeadSanity .. ": I love me some corpses.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.NoHomeComfortDamage_Toggle()
  Consts.NoHomeComfort = ChoGGi.NumRetBool(Consts.NoHomeComfort,0,ChoGGi.Consts.NoHomeComfort)
  ChoGGi.CheatMenuSettings.NoHomeComfort = Consts.NoHomeComfort
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.NoHomeComfort .. ": Oh, give me a home where the Buffalo roam\nWhere the Deer and the Antelope play;\nWhere seldom is heard a discouraging word,",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfSanityDamage_Toggle()
  Consts.DustStormSanityDamage = ChoGGi.NumRetBool(Consts.DustStormSanityDamage,0,ChoGGi.Consts.DustStormSanityDamage)
  Consts.MysteryDreamSanityDamage = ChoGGi.NumRetBool(Consts.MysteryDreamSanityDamage,0,ChoGGi.Consts.MysteryDreamSanityDamage)
  Consts.ColdWaveSanityDamage = ChoGGi.NumRetBool(Consts.ColdWaveSanityDamage,0,ChoGGi.Consts.ColdWaveSanityDamage)
  Consts.MeteorSanityDamage = ChoGGi.NumRetBool(Consts.MeteorSanityDamage,0,ChoGGi.Consts.MeteorSanityDamage)
  ChoGGi.CheatMenuSettings.DustStormSanityDamage = Consts.DustStormSanityDamage
  ChoGGi.CheatMenuSettings.MysteryDreamSanityDamage = Consts.MysteryDreamSanityDamage
  ChoGGi.CheatMenuSettings.ColdWaveSanityDamage = Consts.ColdWaveSanityDamage
  ChoGGi.CheatMenuSettings.MeteorSanityDamage = Consts.MeteorSanityDamage
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DustStormSanityDamage .. ": Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfNegativeTrait_Toggle()
  Consts.LowSanityNegativeTraitChance = ChoGGi.NumRetBool(Consts.LowSanityNegativeTraitChance,0,ChoGGi.GetLowSanityNegativeTraitChance())
  ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance = Consts.LowSanityNegativeTraitChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance .. ": Stupid and happy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsChanceOfSuicide_Toggle()
  Consts.LowSanitySuicideChance = ChoGGi.ToggleBoolNum(Consts.LowSanitySuicideChance)
  ChoGGi.CheatMenuSettings.LowSanitySuicideChance = Consts.LowSanitySuicideChance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.LowSanitySuicideChance .. ": Getting away ain't that easy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsSuffocate_Toggle()
  if Consts.OxygenMaxOutsideTime == 99999900 then
    Consts.OxygenMaxOutsideTime = ChoGGi.Consts.OxygenMaxOutsideTime
  else
    Consts.OxygenMaxOutsideTime = 99999900
  end
  ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime = Consts.OxygenMaxOutsideTime
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime .. ": Free Air",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsStarve_Toggle()
  if Consts.TimeBeforeStarving == 99999900 then
    Consts.TimeBeforeStarving = ChoGGi.Consts.TimeBeforeStarving
  else
    Consts.TimeBeforeStarving = 99999900
  end
  ChoGGi.CheatMenuSettings.TimeBeforeStarving = Consts.TimeBeforeStarving
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.TimeBeforeStarving .. ": Free Food",
   "Colonists","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.AvoidWorkplace_Toggle()
  ConstsAvoidWorkplaceSols = ChoGGi.NumRetBool(Consts.AvoidWorkplaceSols,0,ChoGGi.Consts.AvoidWorkplaceSols)
  ChoGGi.CheatMenuSettings.AvoidWorkplaceSols = Consts.AvoidWorkplaceSols
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.AvoidWorkplaceSols .. ": No Shame",
   "Colonists","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.PositivePlayground_Toggle()
  if Consts.positive_playground_chance == 101 then
    Consts.positive_playground_chance = ChoGGi.Consts.positive_playground_chance
  else
    Consts.positive_playground_chance = 101
  end
  ChoGGi.CheatMenuSettings.positive_playground_chance = Consts.positive_playground_chance
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.positive_playground_chance .. ": We've all seen them, on the playground, at the store, walking on the streets.",
    "Traits","UI/Icons/Upgrades/home_collective_02.tga"
  )
end

function ChoGGi.ProjectMorpheusPositiveTrait_Toggle()
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

function ChoGGi.PerformancePenaltyNonSpecialist_Toggle()
  Consts.NonSpecialistPerformancePenalty = ChoGGi.NumRetBool(Consts.NonSpecialistPerformancePenalty,0,ChoGGi.GetNonSpecialistPerformancePenalty())
  ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty = Consts.NonSpecialistPerformancePenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty .. ": You never know what you're gonna get.",
   "Penalty","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.OutsideWorkplaceRadius(Bool)
  if Bool == true then
    Consts.DefaultOutsideWorkplacesRadius = Consts.DefaultOutsideWorkplacesRadius + 10
  else
    Consts.DefaultOutsideWorkplacesRadius = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
  end
  ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius = Consts.DefaultOutsideWorkplacesRadius
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius .. ": Maybe tomorrow, I'll find what I call home. Until tomorrow, you know I'm free to roam.",
   "Colonists","UI/Icons/Sections/dome.tga"
  )
end

function ChoGGi.SetDeathAge()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.death_age = 250
  end
end

function ChoGGi.ColonistsRandomRaceAll()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.race = UICity:Random(1,5)
    colonist:ChooseEntity()
  end
end

function ChoGGi.SetColonistsRace(Race,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.race = Race
    colonist:ChooseEntity()
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.ColonistsRandomAgeAll()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    ChoGGi.ColonistUpdateAge(colonist,ChoGGi.ColonistAges[UICity:Random(1,6)])
  end
end

function ChoGGi.SetColonistsAge(Age,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    ChoGGi.ColonistUpdateAge(colonist,Age)
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.ColonistsRandomGenderAll()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    ChoGGi.ColonistUpdateGender(colonist,ChoGGi.ColonistGenders[UICity:Random(1,5)])
  end
end

function ChoGGi.SetColonistsGender(Gender,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    ChoGGi.ColonistUpdateGender(colonist,Gender)
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.NewColonistAge(Type,Msg)
  ChoGGi.CheatMenuSettings.NewColonistAge = Type
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.NewColonistGender(Type,Msg)
  ChoGGi.CheatMenuSettings.NewColonistGender = Type
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsMorale(Number,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.stat_morale = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsSanity(Number,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.stat_sanity = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.SetColonistsComfort(Number,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.stat_comfort = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Upgrades/home_collective_04.tga")
end

function ChoGGi.SetColonistsHealth(Number,Msg)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    colonist.stat_health = Number
  end
  ChoGGi.MsgPopup(Msg,"Colonists","UI/Icons/Notifications/colonist.tga")
end

function ChoGGi.ColonistsRandomSpecializationAll()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    if not colonist.entity:find("Child",1,true) then
      colonist:SetSpecialization(ChoGGi.ColonistSpecializations[UICity:Random(1,6)],"init")
    end
  end
end

function ChoGGi.ColonistsAddSpecializationToAll()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    --skip children, or they'll be a black cube
    if colonist.specialist == "none" and not colonist.entity:find("Child",1,true) then
      colonist:SetSpecialization(ChoGGi.ColonistSpecializations[UICity:Random(1,6)],"init") --1-6 = num of specializations
    end
  end
  ChoGGi.MsgPopup("No lazy good fer nuthins round here",
   "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.ColonistsFixBlackCube()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    if colonist.entity:find("Child",1,true) then
      colonist.specialist = "none"

      colonist.traits.Youth = nil
      colonist.traits.Adult = nil
      colonist.traits["Middle Aged"] = nil
      colonist.traits.Senior = nil
      colonist.traits.Retiree = nil

      colonist.traits.Child = true
      colonist.age_trait = "Child"
      colonist.age = 0
      colonist:ChooseEntity()
      colonist:SetResidence(false)
      colonist:UpdateResidence()
    end
  end
  ChoGGi.MsgPopup("Fixed black cubes",
   "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.AllPositiveTraits_Toggle(Bool)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    for i = 1, #ChoGGi.PositiveTraits do
      if Bool == true then
        colonist:AddTrait(ChoGGi.PositiveTraits[i])
      else
        colonist:RemoveTrait(ChoGGi.PositiveTraits[i])
      end
      Notify(colonist, "UpdateMorale")
    end
  end
  ChoGGi.MsgPopup("All Positive Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end

function ChoGGi.AllNegativeTraits_Toggle(Bool)
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    for i = 1, #ChoGGi.NegativeTraits do
      if Bool == true then
        colonist:AddTrait(ChoGGi.NegativeTraits[i])
      else
        colonist:RemoveTrait(ChoGGi.NegativeTraits[i])
      end
      Notify(colonist, "UpdateMorale")
    end
  end
  ChoGGi.MsgPopup("All Negative Traits",
    "Traits","UI/Icons/Sections/traits.tga"
  )
end
