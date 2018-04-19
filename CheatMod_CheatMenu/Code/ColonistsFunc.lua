
function ChoGGi.SetGravityColonists()
  --retrieve default
  local DefaultSetting = 0
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {
      text = " Default: " .. DefaultSetting,
      value = DefaultSetting,
    },
    {
      text = 1,
      value = 1 * r,
    },
    {
      text = 2,
      value = 2 * r,
    },
    {
      text = 3,
      value = 3 * r,
    },
    {
      text = 4,
      value = 4 * r,
    },
    {
      text = 5,
      value = 5 * r,
    },
    {
      text = 10,
      value = 10 * r,
    },
    {
      text = 15,
      value = 15 * r,
    },
    {
      text = 25,
      value = 25 * r,
    },
    {
      text = 50,
      value = 50 * r,
    },
    {
      text = 75,
      value = 75 * r,
    },
    {
      text = 100,
      value = 100 * r,
    },
    {
      text = 250,
      value = 250 * r,
    },
    {
      text = 500,
      value = 500 * r,
    },
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.GravityColonist then
    hint = ChoGGi.CheatMenuSettings.GravityColonist / r
  end

  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        Object:SetGravity(amount)
      end
      ChoGGi.CheatMenuSettings.GravityColonist = amount
    else
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        Object:SetGravity(DefaultSetting)
      end
      ChoGGi.CheatMenuSettings.GravityColonist = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Colonist gravity is now: " .. choice[1].text,
      "Colonists","UI/Icons/Sections/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Colonist Gravity","Current gravity: " .. hint)
end

function ChoGGi.AddApplicantsToPool()
  local ItemList = {
    {
      text = 1,
      value = 1,
    },
    {
      text = 10,
      value = 10,
    },
    {
      text = 25,
      value = 25,
    },
    {
      text = 50,
      value = 50,
    },
    {
      text = 75,
      value = 75,
    },
    {
      text = 100,
      value = 100,
    },
    {
      text = 250,
      value = 250,
    },
    {
      text = 500,
      value = 500,
    },
    {
      text = 1000,
      value = 1000,
    },
    {
      text = 2500,
      value = 2500,
    },
    {
      text = 5000,
      value = 5000,
    },
    {
      text = 10000,
      value = 10000,
    },
    {
      text = 25000,
      value = 25000,
    },
    {
      text = 50000,
      value = 50000,
    },
    {
      text = 100000,
      value = 100000,
    },
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      local now = GameTime()
      local self = SA_AddApplicants
      for i = 1, amount do
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
      ChoGGi.MsgPopup("Added applicants: " .. choice[1].text,
        "Applicants","UI/Icons/Sections/colonist.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Applicants To Pool","Will take some time for 25K and up.")
end

function ChoGGi.FireAllColonists(Which)
  local FireAllColonists = function()
    for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
      Object:GetFired()
    end
  end
  ChoGGi.QuestionBox("Are you sure you want to fire everyone?",FireAllColonists,"Yer outta here!")
end

function ChoGGi.SetAllWorkShifts()
  local ItemList = {
    {
      text = "Turn On All Shifts",
      value = 0,
    },
    {
      text = "Turn Off All Shifts",
      value = 3.1415926535,
    },
  }

  local CallBackFunc = function(choice)
    local shift
    if choice[1].value == 3.1415926535 then
      shift = {true,true,true}
    else
      shift = {false,false,false}
    end

    for _,Object in ipairs(UICity.labels.ShiftsBuilding or empty_table) do
      if Object.closed_shifts then
        Object.closed_shifts = shift
      end
    end

    ChoGGi.MsgPopup("Early night? Vamos al bar un trago!",
      "Shifts","UI/Icons/Sections/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shifts","Are you sure you want to change all shifts?")
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
function ChoGGi.MakeAllColonistsRenegades()
  for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
    Object:AddTrait("Renegade",true)
  end
  ChoGGi.MsgPopup("Really? Have you seen a man eat his own head?",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsMoraleAlwaysMax_Toggle()
  -- was -100
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
  Consts.AvoidWorkplaceSols = ChoGGi.NumRetBool(Consts.AvoidWorkplaceSols,0,ChoGGi.Consts.AvoidWorkplaceSols)
  ChoGGi.CheatMenuSettings.AvoidWorkplaceSols = Consts.AvoidWorkplaceSols
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.AvoidWorkplaceSols .. ": No Shame",
   "Colonists","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.PositivePlayground_Toggle()
  if Consts.positive_playground_chance == 101 then
    Consts.positive_playground_chance = ChoGGi.Consts.positive_playground_chance
    g_Consts.positive_playground_chance = ChoGGi.Consts.positive_playground_chance
  else
    Consts.positive_playground_chance = 101
    g_Consts.positive_playground_chance = 101
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
  g_Consts.NonSpecialistPerformancePenalty = Consts.NonSpecialistPerformancePenalty
  ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty = Consts.NonSpecialistPerformancePenalty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty .. ": You never know what you're gonna get.",
   "Penalty","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.SetOutsideWorkplaceRadius()
  --show list of options to pick
  local DefaultSetting = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
  local ItemList = {
    {
      text = " Default: " .. DefaultSetting,
      value = DefaultSetting,
    },
    {
      text = 15,
      value = 15,
    },
    {
      text = 20,
      value = 20,
    },
    {
      text = 25,
      value = 25,
    },
    {
      text = 50,
      value = 50,
    },
    {
      text = 75,
      value = 75,
    },
    {
      text = 100,
      value = 100,
    },
    {
      text = 250,
      value = 250,
    },
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius then
    hint = ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius
  end

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      Consts.DefaultOutsideWorkplacesRadius = amount
      ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius = amount
    else
      Consts.DefaultOutsideWorkplacesRadius = DefaultSetting
      ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius = DefaultSetting
    end
    ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": Maybe tomorrow, I'll find what I call home. Until tomorrow, you know I'm free to roam.",
       "Colonists","UI/Icons/Sections/dome.tga"
      )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Outside Workplace Radius","Current distance: " .. hint .. "\n\nYou may not want to make it too far away unless you turned off suffocation.")
end

function ChoGGi.SetDeathAge()
  local ItemList = {
    {
      text = 60,
      value = 60,
    },
    {
      text = 75,
      value = 75,
    },
    {
      text = 100,
      value = 100,
    },
    {
      text = 250,
      value = 250,
    },
    {
      text = 500,
      value = 500,
    },
    {
      text = 1000,
      value = 1000,
    },
    {
      text = 10000,
      value = 10000,
    },
    {
      text = "Logan's Run (Novel)",
      value = 21,
    },
    {
      text = "Logan's Run (Movie)",
      value = 30,
    },
    {
      text = "TNG: Half a Life",
      value = 60,
    },
    {
      text = "The Happy Place",
      value = 60,
    },
    {
      text = "In Time",
      value = 26,
    },
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.death_age = amount
      end
      ChoGGi.MsgPopup("Death age: " .. choice[1].text,
        "Colonists","UI/Icons/Sections/attention.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Death Age")
end

function ChoGGi.ColonistsAddSpecializationToAll()
  for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
    if Object.specialist == "none" then
      ChoGGi.ColonistUpdateSpecialization(Object,"Random")
    end
  end
  ChoGGi.MsgPopup("No lazy good fer nuthins round here",
   "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.SetColonistsAge(iType)
  --show list of options to pick
  local DefaultSetting = "Default"
  local sType = ""
  local sSetting = "NewColonistAge"

  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = "Random"
    sSetting = nil
  end

  local ItemList = {}
  table.insert(ItemList,{
    text = DefaultSetting,
    value = DefaultSetting,
  })
  for i = 1, #ChoGGi.ColonistAges do
    table.insert(ItemList,{
      text = ChoGGi.ColonistAges[i],
      value = ChoGGi.ColonistAges[i],
    })
  end

  local hint = "Warning: Child will remove specialization."
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint .. "\n\nWarning: Child will remove specialization."
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.NewColonistAge = false
      else
        ChoGGi.CheatMenuSettings.NewColonistAge = value
      end
      ChoGGi.WriteSettings()

    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateAge(Object,value)
      end
    end

    ChoGGi.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Age",hint)
end

function ChoGGi.SetColonistsGender(iType)
  --show list of options to pick
  local DefaultSetting = "Default"
  local sType = ""
  local sSetting = "NewColonistGender"
  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = "Random"
    sSetting = nil
  end

  local ItemList = {}
  table.insert(ItemList,{
    text = DefaultSetting,
    value = DefaultSetting,
  })
  table.insert(ItemList,{
    text = "MaleOrFemale",
    value = "MaleOrFemale",
  })
  for i = 1, #ChoGGi.ColonistGenders do
    table.insert(ItemList,{
      text = ChoGGi.ColonistGenders[i],
      value = ChoGGi.ColonistGenders[i],
    })
  end

  local hint = DefaultSetting .. ": Any gender\nMaleOrFemale: Only set as male or female"
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint .. "\n\n" .. DefaultSetting .. ": Any gender\nMaleOrFemale: Only set as male or female"
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.NewColonistGender = false
      else
        ChoGGi.CheatMenuSettings.NewColonistGender = value
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateGender(Object,value)
      end
    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Gender",hint)
end

function ChoGGi.SetColonistsSpecialization(iType)
  --show list of options to pick
  local DefaultSetting = "Default"
  local sType = ""
  local sSetting = "NewColonistSpecialization"
  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = "Random"
    sSetting = nil
  end

  local ItemList = {}
  table.insert(ItemList,{
    text = DefaultSetting,
    value = DefaultSetting,
  })
  if iType == 1 then
    table.insert(ItemList,{
      text = "Random",
      value = "Random",
    })
  end
  table.insert(ItemList,{
    text = "none",
    value = "none",
  })
  for i = 1, #ChoGGi.ColonistSpecializations do
    table.insert(ItemList,{
      text = ChoGGi.ColonistSpecializations[i],
      value = ChoGGi.ColonistSpecializations[i],
    })
  end

  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint .. "\n\nDefault: How the game normally works\nRandom: Everyone gets a spec"
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.NewColonistSpecialization = false
      else
        ChoGGi.CheatMenuSettings.NewColonistSpecialization = value
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateSpecialization(Object,value)
      end
    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Specialization",hint)
end

function ChoGGi.SetColonistsRace(iType)
  --show list of options to pick
  local DefaultSetting = "Default"
  local sType = ""
  local sSetting = "NewColonistRace"
  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = "Random"
    sSetting = nil
  end

  local ItemList = {}
  table.insert(ItemList,{
    text = DefaultSetting,
    value = DefaultSetting,
    race = DefaultSetting,
  })
  local race = {"Herrenvolk","Schwarzvolk","Asiatischvolk","Indischvolk","Südost Asiatischvolk"}
  for i = 1, #ChoGGi.ColonistRaces do
    table.insert(ItemList,{
      text = ChoGGi.ColonistRaces[i],
      value = i,
      race = race[i],
    })
  end

  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.NewColonistRace = false
      else
        ChoGGi.CheatMenuSettings.NewColonistRace = value
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateRace(Object,value)
      end
    end
    ChoGGi.MsgPopup("Nationalsozialistische Rassenhygiene: " .. choice[1].race,
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Race",hint)
end

function ChoGGi.SetColonistsTraits(iType)
  --show list of options to pick
  local DefaultSetting = "Default"
  local sType = ""
  local sSetting = "NewColonistTraits"
  local sType = "New C"
  local ItemList

  if iType == 2 then
    sType = "C"
    sSetting = nil
    DefaultSetting = "Random"
    ItemList = {
      {
        text = " Default: " .. DefaultSetting,
        value = DefaultSetting,
      },
      {
        text = "Add All Positive Traits",
        value = "PositiveTraits",
      },
      {
        text = "Add All Negative Traits",
        value = "NegativeTraits",
      },
      {
        text = "Remove All Positive Traits",
        value = "PositiveTraits",
      },
      {
        text = "Remove All Negative Traits",
        value = "NegativeTraits",
      },
    }
  else
    ItemList = {
      {
        text = " Default: " .. DefaultSetting,
        value = DefaultSetting,
      },
      {
        text = "All Positive Traits",
        value = "PositiveTraits",
      },
      {
        text = "All Negative Traits",
        value = "NegativeTraits",
      },
    }
  end

  local hint = "Random: Each colonist gets three positive and three negative traits (random = if same trait then you won't get three)."
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.NewColonistTraits = false
      else
        ChoGGi.CheatMenuSettings.NewColonistTraits = value
      end
      ChoGGi.WriteSettings()
    --existing

    elseif iType == 2 then
      if value == DefaultSetting then
        for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
          --remove all traits
          ChoGGi.ColonistUpdateTraits(Object,false,"PositiveTraits")
          ChoGGi.ColonistUpdateTraits(Object,false,"NegativeTraits")
          --add random ones
          Object:AddTrait(ChoGGi.PositiveTraits[UICity:Random(1,#ChoGGi.PositiveTraits)],true)
          Object:AddTrait(ChoGGi.PositiveTraits[UICity:Random(1,#ChoGGi.PositiveTraits)],true)
          Object:AddTrait(ChoGGi.PositiveTraits[UICity:Random(1,#ChoGGi.PositiveTraits)],true)
          Object:AddTrait(ChoGGi.NegativeTraits[UICity:Random(1,#ChoGGi.NegativeTraits)],true)
          Object:AddTrait(ChoGGi.NegativeTraits[UICity:Random(1,#ChoGGi.NegativeTraits)],true)
          Object:AddTrait(ChoGGi.NegativeTraits[UICity:Random(1,#ChoGGi.NegativeTraits)],true)
          Notify(Object,"UpdateMorale")
        end

      else
        local Bool = true
        if choice[1].which == 4 or choice[1].which == 5 then
          Bool = false
        end
        for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
          ChoGGi.ColonistUpdateTraits(Object,Bool,value)
        end
      end

    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint)
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


function ChoGGi.ChangeColonistsTrait()

  --build list of traits
  local ItemList = {}
  for i = 1, #ChoGGi.NegativeTraits do
    table.insert(ItemList,{
      text = ChoGGi.NegativeTraits[i],
      value = ChoGGi.NegativeTraits[i],
    })
  end
  for i = 1, #ChoGGi.PositiveTraits do
    table.insert(ItemList,{
      text = ChoGGi.PositiveTraits[i],
      value = ChoGGi.PositiveTraits[i],
    })
  end
  --add hint descriptions
  for i = 1, #ItemList do
    ItemList[i].hint = ": " .. _InternalTranslate(DataInstances.Trait[ItemList[i].text].description)
  end

  local CallBackFunc = function(choice)
    local Bool
    local Which

    --nothing checked so just return
    if not ChoGGi.ListChoiceCustom_CheckBox1 and not ChoGGi.ListChoiceCustom_CheckBox2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Colonists","UI/Icons/Notifications/colonist.tga")
      return
    elseif ChoGGi.ListChoiceCustom_CheckBox1 and ChoGGi.ListChoiceCustom_CheckBox2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Colonists","UI/Icons/Notifications/colonist.tga")
      return
    end

    --add
    if ChoGGi.ListChoiceCustom_CheckBox1 then
      Bool = true
      Which = "Added"
    --remove
    elseif ChoGGi.ListChoiceCustom_CheckBox2 then
      Bool = false
      Which = "Removed"
    end

    --MultiSel
    for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
      for i = 1, #choice do
        if Bool == true then
          Object:AddTrait(choice[i].value,true)
        else
          Object:RemoveTrait(choice[i].value)
        end
      end
    end

    ChoGGi.MsgPopup(Which .. " trait(s)","Colonists","UI/Icons/Notifications/colonist.tga")

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Trait(s)","Check Add or Remove, and use Shift or Ctrl to select multiple traits.",true,"Add","Check to add selected traits","Remove","Check to remove selected traits")
end

function ChoGGi.SetStatsOfAllColonists()

	local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {
      text = "All Stats Max",
      value = 100000 * r,
    },
    {
      text = "All Stats Fill",
      value = 100 * r,
    },
    {
      text = "Health Max",
      value = 100000 * r,
    },
    {
      text = "Health Fill",
      value = 100 * r,
    },
    {
      text = "Morale Fill",
      value = 100 * r,
    },
    {
      text = "Sanity Max",
      value = 100000 * r,
    },
    {
      text = "Sanity Fill",
      value = 100 * r,
    },
    {
      text = "Comfort Max",
      value = 100000 * r,
    },
    {
      text = "Comfort Fill",
      value = 100 * r,
    },
  }

  --show list of options to pick
  local CallBackFunc = function(choice)
    local value = choice[1].value

    if choice[1].which == 1 or choice[1].which == 2 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_morale = value
        colonist.stat_sanity = value
        colonist.stat_comfort = value
        colonist.stat_health = value
      end
    elseif choice[1].which == 3 or choice[1].which == 4 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_health = value
      end
    elseif choice[1].which == 5 or choice[1].which == 6 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_morale = value
      end
    elseif choice[1].which == 7 or choice[1].which == 8 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_sanity = value
      end
    elseif choice[1].which == 9 or choice[1].which == 10 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_comfort = value
      end
    end

    ChoGGi.MsgPopup(choice[1].text,"Colonists","UI/Icons/Notifications/colonist.tga")
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Stats Of All Colonists","Fill: Stat bar filled to 100\nMax: 100000 (choose fill to reset)\n\nWarning: Disable births or else...")
end
