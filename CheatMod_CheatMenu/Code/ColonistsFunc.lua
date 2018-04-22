
function ChoGGi.SetGravityColonists()
  --retrieve default
  local DefaultSetting = 0
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1 * r},
    {text = 2,value = 2 * r},
    {text = 3,value = 3 * r},
    {text = 4,value = 4 * r},
    {text = 5,value = 5 * r},
    {text = 10,value = 10 * r},
    {text = 15,value = 15 * r},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
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
    else
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        Object:SetGravity(DefaultSetting)
      end
    end
    ChoGGi.SetSavedSetting("GravityColonist",amount)

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Colonist gravity is now: " .. choice[1].text,
      "Colonists","UI/Icons/Sections/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Colonist Gravity","Current gravity: " .. hint)
end

function ChoGGi.AddApplicantsToPool()
  local ItemList = {
    {text = 1,value = 1},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      local now = GameTime()
      local self = SA_AddApplicants
      for _ = 1, amount do
     -- for i = 1, amount do
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

function ChoGGi.FireAllColonists()
  local FireAllColonists = function()
    for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
      Object:GetFired()
    end
  end
  ChoGGi.QuestionBox("Are you sure you want to fire everyone?",FireAllColonists,"Yer outta here!")
end

function ChoGGi.SetAllWorkShifts()
  local ItemList = {
    {text = "Turn On All Shifts",value = 0},
    {text = "Turn Off All Shifts",value = 3.1415926535},
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
  ChoGGi.SetConstsG("MinComfortBirth",ChoGGi.NumRetBool(Consts.MinComfortBirth,0,ChoGGi.Consts.MinComfortBirth))

  ChoGGi.SetSavedSetting("MinComfortBirth",Consts.MinComfortBirth)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.MinComfortBirth) .. ": Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.VisitFailPenalty_Toggle()
  ChoGGi.SetConstsG("VisitFailPenalty",ChoGGi.NumRetBool(Consts.VisitFailPenalty,0,ChoGGi.Consts.VisitFailPenalty))

  ChoGGi.SetSavedSetting("VisitFailPenalty",Consts.VisitFailPenalty)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.VisitFailPenalty) .. ": The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.RenegadeCreation_Toggle()
  ChoGGi.SetConstsG("RenegadeCreation",ChoGGi.ValueRetOpp(Consts.RenegadeCreation,9999900,ChoGGi.Consts.RenegadeCreation))

  ChoGGi.SetSavedSetting("RenegadeCreation",Consts.RenegadeCreation)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RenegadeCreation) .. ": I just love findin' subversives.",
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
  ChoGGi.SetConstsG("HighStatLevel",ChoGGi.NumRetBool(Consts.HighStatLevel,0,ChoGGi.Consts.HighStatLevel))
  ChoGGi.SetConstsG("LowStatLevel",ChoGGi.NumRetBool(Consts.LowStatLevel,0,ChoGGi.Consts.LowStatLevel))
  ChoGGi.SetConstsG("HighStatMoraleEffect",ChoGGi.ValueRetOpp(Consts.HighStatMoraleEffect,999900,ChoGGi.Consts.HighStatMoraleEffect))
  ChoGGi.SetSavedSetting("HighStatMoraleEffect",Consts.HighStatMoraleEffect)
  ChoGGi.SetSavedSetting("HighStatLevel",Consts.HighStatLevel)
  ChoGGi.SetSavedSetting("LowStatLevel",Consts.LowStatLevel)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.HighStatMoraleEffect) .. ": Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.SeeDeadSanityDamage_Toggle()
  ChoGGi.SetConstsG("SeeDeadSanity",ChoGGi.NumRetBool(Consts.SeeDeadSanity,0,ChoGGi.Consts.SeeDeadSanity))
  ChoGGi.SetSavedSetting("SeeDeadSanity",Consts.SeeDeadSanity)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SeeDeadSanity) .. ": I love me some corpses.",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.NoHomeComfortDamage_Toggle()
  ChoGGi.SetConstsG("NoHomeComfort",ChoGGi.NumRetBool(Consts.NoHomeComfort,0,ChoGGi.Consts.NoHomeComfort))
  ChoGGi.SetSavedSetting("NoHomeComfort",Consts.NoHomeComfort)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.NoHomeComfort) .. ": Oh, give me a home where the Buffalo roam\nWhere the Deer and the Antelope play;\nWhere seldom is heard a discouraging word,",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfSanityDamage_Toggle()
  ChoGGi.SetConstsG("DustStormSanityDamage",ChoGGi.NumRetBool(Consts.DustStormSanityDamage,0,ChoGGi.Consts.DustStormSanityDamage))
  ChoGGi.SetConstsG("MysteryDreamSanityDamage",ChoGGi.NumRetBool(Consts.MysteryDreamSanityDamage,0,ChoGGi.Consts.MysteryDreamSanityDamage))
  ChoGGi.SetConstsG("ColdWaveSanityDamage",ChoGGi.NumRetBool(Consts.ColdWaveSanityDamage,0,ChoGGi.Consts.ColdWaveSanityDamage))
  ChoGGi.SetConstsG("MeteorSanityDamage",ChoGGi.NumRetBool(Consts.MeteorSanityDamage,0,ChoGGi.Consts.MeteorSanityDamage))

  ChoGGi.SetSavedSetting("DustStormSanityDamage",Consts.DustStormSanityDamage)
  ChoGGi.SetSavedSetting("MysteryDreamSanityDamage",Consts.MysteryDreamSanityDamage)
  ChoGGi.SetSavedSetting("ColdWaveSanityDamage",Consts.ColdWaveSanityDamage)
  ChoGGi.SetSavedSetting("MeteorSanityDamage",Consts.MeteorSanityDamage)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DustStormSanityDamage) .. ": Happy as a pig in shit",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ChanceOfNegativeTrait_Toggle()
  ChoGGi.SetConstsG("LowSanityNegativeTraitChance",ChoGGi.NumRetBool(Consts.LowSanityNegativeTraitChance,0,ChoGGi.GetLowSanityNegativeTraitChance()))

  ChoGGi.SetSavedSetting("LowSanityNegativeTraitChance",Consts.LowSanityNegativeTraitChance)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance) .. ": Stupid and happy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsChanceOfSuicide_Toggle()
  ChoGGi.SetConstsG("LowSanitySuicideChance",ChoGGi.ToggleBoolNum(Consts.LowSanitySuicideChance))

  ChoGGi.SetSavedSetting("LowSanitySuicideChance",Consts.LowSanitySuicideChance)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.LowSanitySuicideChance) .. ": Getting away ain't that easy",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsSuffocate_Toggle()
  ChoGGi.SetConstsG("OxygenMaxOutsideTime",ChoGGi.ValueRetOpp(Consts.OxygenMaxOutsideTime,99999900,ChoGGi.Consts.OxygenMaxOutsideTime))

  ChoGGi.SetSavedSetting("OxygenMaxOutsideTime",Consts.OxygenMaxOutsideTime)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime) .. ": Free Air",
    "Colonists","UI/Icons/Sections/colonist.tga"
  )
end

function ChoGGi.ColonistsStarve_Toggle()
  ChoGGi.SetConstsG("TimeBeforeStarving",ChoGGi.ValueRetOpp(Consts.TimeBeforeStarving,99999900,ChoGGi.Consts.TimeBeforeStarving))

  ChoGGi.SetSavedSetting("TimeBeforeStarving",Consts.TimeBeforeStarving)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.TimeBeforeStarving) .. ": Free Food",
   "Colonists","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.AvoidWorkplace_Toggle()
  ChoGGi.SetConstsG("AvoidWorkplaceSols",ChoGGi.NumRetBool(Consts.AvoidWorkplaceSols,0,ChoGGi.Consts.AvoidWorkplaceSols))

  ChoGGi.SetSavedSetting("AvoidWorkplaceSols",Consts.AvoidWorkplaceSols)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.AvoidWorkplaceSols) .. ": No Shame",
   "Colonists","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.PositivePlayground_Toggle()
  ChoGGi.SetConstsG("positive_playground_chance",ChoGGi.ValueRetOpp(Consts.positive_playground_chance,101,ChoGGi.Consts.positive_playground_chance))

  ChoGGi.SetSavedSetting("positive_playground_chance",Consts.positive_playground_chance)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.positive_playground_chance) .. ": We've all seen them, on the playground, at the store, walking on the streets.",
    "Traits","UI/Icons/Upgrades/home_collective_02.tga"
  )
end

function ChoGGi.ProjectMorpheusPositiveTrait_Toggle()
  ChoGGi.SetConstsG("ProjectMorphiousPositiveTraitChance",ChoGGi.ValueRetOpp(Consts.ProjectMorphiousPositiveTraitChance,100,ChoGGi.Consts.ProjectMorphiousPositiveTraitChance))

  ChoGGi.SetSavedSetting("ProjectMorphiousPositiveTraitChance",Consts.ProjectMorphiousPositiveTraitChance)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ProjectMorphiousPositiveTraitChance) .. ' Say, "Small umbrella, small umbrella."',
   "Colonists","UI/Icons/Upgrades/rejuvenation_treatment_04.tga"
  )
end

function ChoGGi.PerformancePenaltyNonSpecialist_Toggle()
  ChoGGi.SetConstsG("NonSpecialistPerformancePenalty",ChoGGi.NumRetBool(Consts.NonSpecialistPerformancePenalty,0,ChoGGi.GetNonSpecialistPerformancePenalty()))

  ChoGGi.SetSavedSetting("NonSpecialistPerformancePenalty",Consts.NonSpecialistPerformancePenalty)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty) .. ": You never know what you're gonna get.",
   "Penalty","UI/Icons/Notifications/colonist.tga"
  )
end

function ChoGGi.SetOutsideWorkplaceRadius()
  --show list of options to pick
  local DefaultSetting = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 15,value = 15},
    {text = 20,value = 20},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius then
    hint = ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetConstsG("DefaultOutsideWorkplacesRadius",value)
      ChoGGi.SetSavedSetting("DefaultOutsideWorkplacesRadius",value)
      ChoGGi.WriteSettings()
        ChoGGi.MsgPopup(choice[1].text .. ": Maybe tomorrow, I'll find what I call home. Until tomorrow, you know I'm free to roam.",
         "Colonists","UI/Icons/Sections/dome.tga"
        )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Outside Workplace Radius","Current distance: " .. hint .. "\n\nYou may not want to make it too far away unless you turned off suffocation.")
end

function ChoGGi.SetDeathAge()
  local ItemList = {
    {text = 60,value = 60},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
    {text = "Logan's Run (Novel)",value = 21},
    {text = "Logan's Run (Movie)",value = 30},
    {text = "TNG: Half a Life",value = 60},
    {text = "The Happy Place",value = 60},
    {text = "In Time",value = 26},
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

local function IsChild(value)
  if value == "Child" then
    return "Warning: Child will remove specialization."
  end
end
function ChoGGi.SetColonistsAge(iType)
  --show list of options to pick
  local DefaultSetting = " Default"
  local sType = ""
  local sSetting = "NewColonistAge"

  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = " Random"
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
      hint = IsChild(ChoGGi.ColonistAges[i]),
    })
  end

  local hint = ""
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Current: " .. hint .. "\n\nWarning: Child will remove specialization."
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.SetSavedSetting("NewColonistAge",value)
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
  local DefaultSetting = " Default"
  local sType = ""
  local sSetting = "NewColonistGender"
  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = " Random"
    sSetting = nil
  end

  local ItemList = {}
  table.insert(ItemList,{
    text = DefaultSetting,
    value = DefaultSetting,
    hint = "How the game normally works",
  })
  table.insert(ItemList,{
    text = " MaleOrFemale",
    value = "MaleOrFemale",
    hint = "Only set as male or female",
  })
  for i = 1, #ChoGGi.ColonistGenders do
    table.insert(ItemList,{
      text = ChoGGi.ColonistGenders[i],
      value = ChoGGi.ColonistGenders[i],
    })
  end

  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Current: " .. hint
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.SetSavedSetting("NewColonistGender",value)
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
  local DefaultSetting = " Default"
  local sType = ""
  local sSetting = "NewColonistSpecialization"
  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = " Random"
    sSetting = nil
  end

  local ItemList = {}
  table.insert(ItemList,{
    text = DefaultSetting,
    value = DefaultSetting,
    hint = "How the game normally works",
  })
  if iType == 1 then
    table.insert(ItemList,{
      text = "Random",
      value = "Random",
      hint = "Everyone gets a spec",
    })
  end
  table.insert(ItemList,{
    text = "none",
    value = "none",
    hint = "Removes specializations",
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
    hint = "Current: " .. hint
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.SetSavedSetting("NewColonistSpecialization",value)
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
  local DefaultSetting = " Default"
  local sType = ""
  local sSetting = "NewColonistRace"
  if iType == 1 then
    sType = "New C"
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = " Random"
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
    hint = "Current: " .. hint
  end

  local CallBackFunc = function(choice)
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.SetSavedSetting("NewColonistRace",value)
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
  local DefaultSetting = " Default"
  local sSetting = "NewColonistTraits"
  local sType = "New C"

  local hint = ""
  if iType == 1 then
    hint = DefaultSetting
    local saved = ChoGGi.CheatMenuSettings[sSetting]
    if saved then
      hint = ""
      for i = 1, #saved do
        hint = hint .. saved[i] .. ","
      end
    end
    hint = "Current: " .. hint
  elseif iType == 2 then
    sType = "C"
    DefaultSetting = " Random"
  end
  hint = hint .. "\n\nCheck Add or Remove, and use Shift or Ctrl to select multiple traits."

  local ItemList = {
      {text = " " .. DefaultSetting,value = DefaultSetting,hint = "Use game defaults"},
      {text = " All Positive Traits",value = "PositiveTraits",hint = "All the positive traits..."},
      {text = " All Negative Traits",value = "NegativeTraits",hint = "All the negative traits..."},
    }

  if iType == 2 then
    ItemList[1].hint = "Random: Each colonist gets three positive and three negative traits (if it picks same traits then you won't get all six)."
  end

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
    local hinttemp = DataInstances.Trait[ItemList[i].text]
    if hinttemp then
      ItemList[i].hint = ": " .. _InternalTranslate(hinttemp.description)
    end
  end

  local CallBackFunc = function(choice)

    --create list of traits
    local TraitsListTemp = {}
    for i = 1, #choice do
      if choice[i].value == "NegativeTraits" then
        for j = 1, #ChoGGi.NegativeTraits do
          table.insert(TraitsListTemp,ChoGGi.NegativeTraits[j])
        end
      elseif choice[i].value == "PositiveTraits" then
        for j = 1, #ChoGGi.PositiveTraits do
          table.insert(TraitsListTemp,ChoGGi.PositiveTraits[j])
        end
      else
        if choice[i].value then
          table.insert(TraitsListTemp,choice[i].value)
        end
      end
    end
    --remove dupes
    table.sort(TraitsListTemp)
    local TraitsList = {}
    for i = 1, #TraitsListTemp do
      if TraitsListTemp[i] ~= TraitsListTemp[i-1] then
        table.insert(TraitsList,TraitsListTemp[i])
      end
    end

    --new
    if iType == 1 then
      if choice[1].value == DefaultSetting then
        ChoGGi.CheatMenuSettings.NewColonistTraits = false
      else
        ChoGGi.CheatMenuSettings.NewColonistTraits = TraitsList
      end
      ChoGGi.WriteSettings()
    --existing

    elseif iType == 2 then

      --nothing checked so just return
      if not ChoGGi.ListChoiceCustomDialog_CheckBox1 and not ChoGGi.ListChoiceCustomDialog_CheckBox2 then
        ChoGGi.MsgPopup("Pick a checkbox next time...","Colonists","UI/Icons/Notifications/colonist.tga")
        return
      elseif ChoGGi.ListChoiceCustomDialog_CheckBox1 and ChoGGi.ListChoiceCustomDialog_CheckBox2 then
        ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Colonists","UI/Icons/Notifications/colonist.tga")
        return
      end

      --random 3x3
      if choice[1].value == DefaultSetting then
        for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
          --remove all traits
          ChoGGi.ColonistUpdateTraits(Object,false,ChoGGi.PositiveTraits)
          ChoGGi.ColonistUpdateTraits(Object,false,ChoGGi.NegativeTraits)
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
        local Bool
        if ChoGGi.ListChoiceCustomDialog_CheckBox1 then
          Bool = true
        elseif ChoGGi.ListChoiceCustomDialog_CheckBox2 then
          Bool = false
        end

        for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
          for i = 1, #TraitsList do
            if Bool == true then
              Object:AddTrait(TraitsList[i],true)
            else
              Object:RemoveTrait(TraitsList[i])
            end
          end
        end

      end

    end
    ChoGGi.MsgPopup(sType .. "olonists traits set: " .. #TraitsList,
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  if iType == 1 then
    ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint,true)
  elseif iType == 2 then
    ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint,true,"Add","Check to add traits","Remove","Check to remove traits")
  end
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

function ChoGGi.SetStatsOfAllColonists()

	local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = "All Stats Max",value = 1},
    {text = "All Stats Fill",value = 2},
    {text = "Health Max",value = 3},
    {text = "Health Fill",value = 4},

    {text = "Morale Fill",value = 5},

    {text = "Sanity Max",value = 6},
    {text = "Sanity Fill",value = 7},

    {text = "Comfort Max",value = 8},
    {text = "Comfort Fill",value = 9},
  }

  --show list of options to pick
  local CallBackFunc = function(choice)

    local max = 100000 * r
    local fill = 100 * r
    local value = choice[1].value
    local function SetStat(Stat,v)
      if v == 1 or v == 3 or v == 6 or v == 8 then
        v = max
      else
        v = fill
      end
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist[Stat] = v
      end
    end

    if value == 1 or value == 2 then
      if value == 1 then
        value = max
      elseif value == 2 then
        value = fill
      end
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_morale = value
        colonist.stat_sanity = value
        colonist.stat_comfort = value
        colonist.stat_health = value
      end

    elseif value == 3 or value == 4 then
      SetStat("stat_health",value)
    elseif value == 5 then
      SetStat("stat_morale",value)
    elseif value == 6 or value == 7 then
      SetStat("stat_sanity",value)
    elseif value == 8 or value == 9 then
      SetStat("stat_comfort",value)
    end

    ChoGGi.MsgPopup(choice[1].text,"Colonists","UI/Icons/Notifications/colonist.tga")
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Stats Of All Colonists","Fill: Stat bar filled to 100\nMax: 100000 (choose fill to reset)\n\nWarning: Disable births or else...")
end
