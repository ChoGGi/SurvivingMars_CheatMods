function ChoGGi.SetGravityColonists()
  --retrieve default
  local DefaultSetting = 0
  local ListDisplay = {DefaultSetting,50,125,250,500,1000,2000,3000,4000,5000}
  local hint
  if ChoGGi.CheatMenuSettings.GravityColonist then
    hint = "Current gravity: " .. ChoGGi.CheatMenuSettings.GravityColonist
  end
  local TempFunc = function(choice)
    local amount = ListDisplay[choice]
    --loop through and set all
    for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
      Object:SetGravity(amount)
    end
    --save option for spawned
    if choice == 1 then
      ChoGGi.CheatMenuSettings.GravityColonist = false
    else
      ChoGGi.CheatMenuSettings.GravityColonist = amount
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Colonist gravity is now: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Sections/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Colonists Gravity",6,hint)
end


function ChoGGi.AddApplicantsToPool()
  local ListDisplay = {10,25,50,100,250,500,1000,2500,5000,10000,25000,50000,100000}
  local TempFunc = function(choice)
    local now = GameTime()
    local self = SA_AddApplicants
    for i = 1, ListDisplay[choice] do
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
    ChoGGi.MsgPopup("Added applicants: " .. ListDisplay[choice],
      "Applicants","UI/Icons/Sections/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Add Applicants To Pool",5,"Will take some time for 25K and up.")
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
  local TempFunc = function(choice)
    local shift
    if choice == 1 then
      shift = {false,false,false}
    else
      shift = {true,true,true}
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
  ChoGGi.FireFuncAfterChoice(TempFunc,{"Turn On All Shifts","Turn Off All Shifts"},"Set Shifts",1,"Are you sure you want to change all shifts?")
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
  local ListDisplay = {DefaultSetting,15,20,25,30,35,40,45,50,75,100,125,250,500}
  local hintCap = DefaultSetting
  if ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius then
    hintCap = ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius
  end
  local hint = "Current distance: " .. hintCap
  local TempFunc = function(choice)
    Consts.DefaultOutsideWorkplacesRadius = ListDisplay[choice]
    ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius = ListDisplay[choice]
    ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(ListDisplay[choice] .. ": Maybe tomorrow, I'll find what I call home. Until tomorrow, you know I'm free to roam.",
       "Colonists","UI/Icons/Sections/dome.tga"
      )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Outside Workplace Radius",1,hint)
end

function ChoGGi.SetDeathAge()
  --show list of options to pick
  local ListDisplay = {60,75,100,250,500,1000,10000,"Logan's Run (Novel)","Logan's Run (Movie)","TNG: Half a Life","The Happy Place","In Time"}
  local ListActual = {60,75,100,250,500,1000,10000,21,30,60,60,26}
  local TempFunc = function(choice)
    for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
      colonist.death_age = ListActual[choice]
    end
    ChoGGi.MsgPopup("Death age: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Death Age")
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
  local ListDisplay = {}
  table.insert(ListDisplay,DefaultSetting)
  for i = 1, #ChoGGi.ColonistAges do
    table.insert(ListDisplay,ChoGGi.ColonistAges[i])
  end
  local hint = "Warning: Child will remove specialization."
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint .. "\n\nWarning: Child will remove specialization."
  end
  local TempFunc = function(choice)
    --new
    if iType == 1 then
      if choice == 1 then
        ChoGGi.CheatMenuSettings.NewColonistAge = false
      else
        ChoGGi.CheatMenuSettings.NewColonistAge = ListDisplay[choice]
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateAge(Object,ListDisplay[choice])
      end
    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. "olonist Age",1,hint)
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

  local ListDisplay = {}
  table.insert(ListDisplay,DefaultSetting)
  table.insert(ListDisplay,"MaleOrFemale")
  for i = 1, #ChoGGi.ColonistGenders do
    table.insert(ListDisplay,ChoGGi.ColonistGenders[i])
  end
  local hint = DefaultSetting .. ": Any gender\nMaleOrFemale: Only set as male or female"
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint .. "\n\n" .. DefaultSetting .. ": Any gender\nMaleOrFemale: Only set as male or female"
  end

  local TempFunc = function(choice)
    --new
    if iType == 1 then
      if choice == 1 then
        ChoGGi.CheatMenuSettings.NewColonistGender = false
      else
        ChoGGi.CheatMenuSettings.NewColonistGender = ListDisplay[choice]
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateGender(Object,ListDisplay[choice])
      end
    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. "olonist Gender",1,hint)
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

  local ListDisplay = {}
  table.insert(ListDisplay,DefaultSetting)
  if iType == 1 then
    table.insert(ListDisplay,"Random")
  end
  table.insert(ListDisplay,"none")
  for i = 1, #ChoGGi.ColonistSpecializations do
    table.insert(ListDisplay,ChoGGi.ColonistSpecializations[i])
  end
  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint .. "\n\nDefault: How the game normally works\nRandom: Everyone gets a spec"
  end

  local TempFunc = function(choice)
    --new
    if iType == 1 then
      if choice == 1 then
        ChoGGi.CheatMenuSettings.NewColonistSpecialization = false
      else
        ChoGGi.CheatMenuSettings.NewColonistSpecialization = ListDisplay[choice]
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateSpecialization(Object,ListDisplay[choice])
      end
    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. "olonist Specialization",1,hint)
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

  local ListDisplay = {}
  table.insert(ListDisplay,DefaultSetting)
  for i = 1, #ChoGGi.ColonistRaces do
    table.insert(ListDisplay,ChoGGi.ColonistRaces[i])
  end
  local ListDisplay2 = {DefaultSetting,"Herrenvolk","Schwarzvolk","Asiatischvolk","Indischvolk","Südost Asiatischvolk"}
  local ListActual = {DefaultSetting,1,2,3,4,5}
  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint
  end

  local TempFunc = function(choice)
    --new
    if iType == 1 then
      if choice == 1 then
        ChoGGi.CheatMenuSettings.NewColonistRace = false
      else
        ChoGGi.CheatMenuSettings.NewColonistRace = ListActual[choice]
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
        ChoGGi.ColonistUpdateRace(Object,ListActual[choice])
      end
    end
    ChoGGi.MsgPopup("Nationalsozialistische Rassenhygiene: " .. ListDisplay2[choice],
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. "olonist Race",1,hint)
end

function ChoGGi.SetColonistsTraits(iType)
  --show list of options to pick
  local DefaultSetting = "Default"
  local sType = ""
  local sSetting = "NewColonistTraits"
  local ListDisplay
  local sType = "New C"
  local ListDisplay = {DefaultSetting,"All Positive Traits","All Negative Traits"}
  local ListActual = {DefaultSetting,"PositiveTraits","NegativeTraits"}
  if iType == 2 then
    sType = "C"
    sSetting = nil
    DefaultSetting = "Random"
    ListDisplay = {DefaultSetting,"Add All Positive","Add All Negative","Remove All Positive","Remove All Negative"}
    ListActual = {DefaultSetting,"PositiveTraits","NegativeTraits","PositiveTraits","NegativeTraits"}
  end
  local hint = "Random: Each colonist gets three positive and three negative traits (random = if same trait then you won't get three)."
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.CheatMenuSettings[sSetting] then
      hint = ChoGGi.CheatMenuSettings[sSetting]
    end
    hint = "Currently: " .. hint
  end

  local TempFunc = function(choice)
    --new
    if iType == 1 then
      if choice == 1 then
        ChoGGi.CheatMenuSettings.NewColonistTraits = false
      else
        ChoGGi.CheatMenuSettings.NewColonistTraits = ListActual[choice]
      end
      ChoGGi.WriteSettings()
    --existing
    elseif iType == 2 then
      if choice == 1 then
        for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
          --remove all traits
          ChoGGi.ColonistUpdateTraits(Object,false,"PositiveTraits")
          ChoGGi.ColonistUpdateTraits(Object,false,"NegativeTraits")
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
        if choice == 4 or choice == 5 then
          Bool = false
        end
        for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
          ChoGGi.ColonistUpdateTraits(Object,Bool,ListActual[choice])
        end
      end
    end
    ChoGGi.MsgPopup(sType .. "olonists: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. "olonist Traits",1,hint)
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


function ChoGGi.ChangeColonistsTrait(iType)
  --show list of options to pick
  local sType = ""
  if iType == 1 then
    sType = "Add"
  elseif iType == 2 then
    sType = "Remove"
  end

  local ListDisplay = {}
  for i = 1, #ChoGGi.NegativeTraits do
    table.insert(ListDisplay,ChoGGi.NegativeTraits[i])
  end
  for i = 1, #ChoGGi.PositiveTraits do
    table.insert(ListDisplay,ChoGGi.PositiveTraits[i])
  end
  table.sort(ListDisplay)
  local hint = ""
  for i = 1, #ListDisplay do
    hint = hint .. ListDisplay[i] .. ": " .. _InternalTranslate(DataInstances.Trait[ListDisplay[i]].description) .. "\n\n"
  end

  local TempFunc = function(choice)
    local Bool
    if iType == 1 then
      Bool = true
      sType = "Adde"
    else
      Bool = false
    end
    for _,Object in ipairs(UICity.labels.Colonist or empty_table) do
      ChoGGi.ColonistUpdateSingleTrait(Object,Bool,ListDisplay[choice])
    end

    ChoGGi.MsgPopup(sType .. "d trait: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,sType .. " Trait",1,hint,true,false)
end

function ChoGGi.SetStatsOfAllColonists()
  --show list of options to pick
  local ListDisplay = {"All Stats Max","All Stats Fill","Health Max","Health Fill","Morale Fill","Sanity Max","Sanity Fill","Comfort Max","Comfort Fill"}
  local ListActual = {100000,100,100000,100,100,100000,100,100000,100}
  local hint = "Fill: Stat bar filled to 100\nMax: 100000 (choose fill to reset)\n\nWarning: Disable births or else..."

  local TempFunc = function(choice)
    local amount = ListActual[choice] * ChoGGi.Consts.ResourceScale

    if choice == 1 or choice == 2 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_morale = amount
        colonist.stat_sanity = amount
        colonist.stat_comfort = amount
        colonist.stat_health = amount
      end
    elseif choice == 3 or choice == 4 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_health = amount
      end
    elseif choice == 5 or choice == 6 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_morale = amount
      end
    elseif choice == 7 or choice == 8 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_sanity = amount
      end
    elseif choice == 9 or choice == 10 then
      for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
        colonist.stat_comfort = amount
      end
    end

    ChoGGi.MsgPopup(ListDisplay[choice],"Colonists","UI/Icons/Notifications/colonist.tga")
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Stats Of All Colonists",1,hint)
end
