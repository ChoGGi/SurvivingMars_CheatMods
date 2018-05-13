local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

local UsualIcon = "UI/Icons/Notifications/colonist.tga"

DeathReasons.ChoGGi_Soylent = "Evil Overlord"

function ChoGGi.MenuFuncs.TheSoylentOption()
  --can't drop BlackCubes
  local list = {}
  local all = AllResourcesList
  for i = 1, #all do
    if all[i] ~= "BlackCube" then
      list[#list+1] = all[i]
    end
  end

  local function MeatbagsToSoylent(MeatBag,res)
    if MeatBag.dying then
      return
    end

    if res then
      res = list[UICity:Random(1,#list)]
    else
      res = "Food"
    end
    PlaceResourcePile(MeatBag:GetVisualPos(), res, UICity:Random(1,5) * CConsts.ResourceScale)
    --PlaceResourcePile(MeatBag:GetLogicalPos(), res, UICity:Random(1,5) * CConsts.ResourceScale)
    MeatBag:SetCommand("Die","ChoGGi_Soylent")
  end

  --one at a time
  local sel = CCodeFuncs.SelObject()
  if sel and sel.class == "Colonist"then
    MeatbagsToSoylent(sel)
    return
  end

  --culling the herd
  local ItemList = {
    {text = "Homeless",value = "Homeless"},
    {text = "Unemployed",value = "Unemployed"},
    {text = "Both",value = "Both"},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    local check1 = choice[1].check1
    local dome
    sel = SelectedObj
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check2 then
      dome = sel.dome.handle
    end

    local function Cull(Label)
      local tab = UICity.labels[Label] or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            MeatbagsToSoylent(Obj,check1)
          end
        else
          MeatbagsToSoylent(Obj,check1)
        end
      end
    end

    if value == "Both" then
      Cull("Homeless")
      Cull("Unemployed")
    elseif value == "Homeless" or value == "Unemployed" then
      Cull(value)
    end
    CComFuncs.MsgPopup("Monster... " .. choice[1].text,
      "Snacks","UI/Icons/Sections/Food_1.tga"
    )
  end

  local Check1 = "Random resource"
  local Check1Hint = "Drops random resource instead of food."
  local Check2 = "Dome Only"
  local Check2Hint = "Will only apply to colonists in the same dome as selected colonist."
  local hint = "Convert useless meatbags into productive protein.\n\nCertain colonists may take some time (traveling in shuttles)."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"The Soylent Option",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
end

function ChoGGi.MenuFuncs.AddApplicantsToPool()
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
    local value = choice[1].value
    if type(value) == "number" then
      local now = GameTime()
      local self = SA_AddApplicants
      for _ = 1, value do
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
      CComFuncs.MsgPopup("Added applicants: " .. choice[1].text,
        "Applicants",UsualIcon
      )
    end
  end

  local hint = "Warning: Will take some time for 25K and up."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Applicants To Pool",hint)
end

function ChoGGi.MenuFuncs.FireAllColonists()
  local FireAllColonists = function()
    local tab = UICity.labels.Colonist or empty_table
    for i = 1, #tab do
      tab[i]:GetFired()
    end
  end
  CComFuncs.QuestionBox("Are you sure you want to fire everyone?",FireAllColonists,"Yer outta here!")
end

function ChoGGi.MenuFuncs.SetAllWorkShifts()
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

    local tab = UICity.labels.ShiftsBuilding or empty_table
    for i = 1, #tab do
      if tab[i].closed_shifts then
        tab[i].closed_shifts = shift
      end
    end

    CComFuncs.MsgPopup("Early night? Vamos al bar un trago!",
      "Shifts",UsualIcon
    )
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shifts","Are you sure you want to change all shifts?")
end

function ChoGGi.MenuFuncs.SetMinComfortBirth()

  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts.MinComfortBirth / r
  local hint_low = "Lower = more babies"
  local hint_high = "Higher = less babies"
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 0,value = 0,hint = hint_low},
    {text = 35,value = 35,hint = hint_low},
    {text = 140,value = 140,hint = hint_high},
    {text = 280,value = 280,hint = hint_high},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.MinComfortBirth then
    hint = ChoGGi.UserSettings.MinComfortBirth / r
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      value = value * r
      CComFuncs.SetConstsG("MinComfortBirth",value)
      CComFuncs.SetSavedSetting("MinComfortBirth",Consts.MinComfortBirth)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Selected: " .. choice[1].text .. "\nLook at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
        "Colonists",UsualIcon,true
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"MinComfortBirth","Current: " .. hint)
end

function ChoGGi.MenuFuncs.VisitFailPenalty_Toggle()
  CComFuncs.SetConstsG("VisitFailPenalty",CComFuncs.NumRetBool(Consts.VisitFailPenalty,0,CConsts.VisitFailPenalty))

  CComFuncs.SetSavedSetting("VisitFailPenalty",Consts.VisitFailPenalty)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.VisitFailPenalty) .. "\nThe mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
    "Colonists",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.RenegadeCreation_Toggle()
  CComFuncs.SetConstsG("RenegadeCreation",CComFuncs.ValueRetOpp(Consts.RenegadeCreation,9999900,CConsts.RenegadeCreation))

  CComFuncs.SetSavedSetting("RenegadeCreation",Consts.RenegadeCreation)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RenegadeCreation) .. ": I just love findin' subversives.",
    "Colonists",UsualIcon
  )
end
function ChoGGi.MenuFuncs.SetRenegadeStatus()
  local ItemList = {
    {text = "Make All Renegades",value = "Make"},
    {text = "Remove All Renegades",value = "Remove"},
  }

  local CallBackFunc = function(choice)
    local dome
    local sel = SelectedObj
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    local Type
    local value = choice[1].value
    if value == "Make" then
      Type = "AddTrait"
    elseif value == "Remove" then
      Type = "RemoveTrait"
    end

    local tab = UICity.labels.Colonist or empty_table
    for i = 1, #tab do
      if dome then
        if tab[i].dome and tab[i].dome.handle == dome then
          tab[i][Type](tab[i],"Renegade")
        end
      else
        tab[i][Type](tab[i],"Renegade")
      end
    end
    CComFuncs.MsgPopup("OK, a limosine that can fly. Now I have seen everything.\nReally? Have you seen a man eat his own head?\nNo.\nSo then, you haven't seen everything.",
      "Colonists",UsualIcon,true
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Make Renegades",nil,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle()
  -- was -100
  CComFuncs.SetConstsG("HighStatLevel",CComFuncs.NumRetBool(Consts.HighStatLevel,0,CConsts.HighStatLevel))
  CComFuncs.SetConstsG("LowStatLevel",CComFuncs.NumRetBool(Consts.LowStatLevel,0,CConsts.LowStatLevel))
  CComFuncs.SetConstsG("HighStatMoraleEffect",CComFuncs.ValueRetOpp(Consts.HighStatMoraleEffect,999900,CConsts.HighStatMoraleEffect))
  CComFuncs.SetSavedSetting("HighStatMoraleEffect",Consts.HighStatMoraleEffect)
  CComFuncs.SetSavedSetting("HighStatLevel",Consts.HighStatLevel)
  CComFuncs.SetSavedSetting("LowStatLevel",Consts.LowStatLevel)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.HighStatMoraleEffect) .. ": Happy as a pig in shit",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle()
  CComFuncs.SetConstsG("SeeDeadSanity",CComFuncs.NumRetBool(Consts.SeeDeadSanity,0,CConsts.SeeDeadSanity))
  CComFuncs.SetSavedSetting("SeeDeadSanity",Consts.SeeDeadSanity)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.SeeDeadSanity) .. ": I love me some corpses.",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle()
  CComFuncs.SetConstsG("NoHomeComfort",CComFuncs.NumRetBool(Consts.NoHomeComfort,0,CConsts.NoHomeComfort))
  CComFuncs.SetSavedSetting("NoHomeComfort",Consts.NoHomeComfort)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.NoHomeComfort) .. "\nOh, give me a home where the Buffalo roam\nWhere the Deer and the Antelope play;\nWhere seldom is heard a discouraging word,",
    "Colonists",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle()
  CComFuncs.SetConstsG("DustStormSanityDamage",CComFuncs.NumRetBool(Consts.DustStormSanityDamage,0,CConsts.DustStormSanityDamage))
  CComFuncs.SetConstsG("MysteryDreamSanityDamage",CComFuncs.NumRetBool(Consts.MysteryDreamSanityDamage,0,CConsts.MysteryDreamSanityDamage))
  CComFuncs.SetConstsG("ColdWaveSanityDamage",CComFuncs.NumRetBool(Consts.ColdWaveSanityDamage,0,CConsts.ColdWaveSanityDamage))
  CComFuncs.SetConstsG("MeteorSanityDamage",CComFuncs.NumRetBool(Consts.MeteorSanityDamage,0,CConsts.MeteorSanityDamage))

  CComFuncs.SetSavedSetting("DustStormSanityDamage",Consts.DustStormSanityDamage)
  CComFuncs.SetSavedSetting("MysteryDreamSanityDamage",Consts.MysteryDreamSanityDamage)
  CComFuncs.SetSavedSetting("ColdWaveSanityDamage",Consts.ColdWaveSanityDamage)
  CComFuncs.SetSavedSetting("MeteorSanityDamage",Consts.MeteorSanityDamage)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DustStormSanityDamage) .. ": Happy as a pig in shit",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle()
  CComFuncs.SetConstsG("LowSanityNegativeTraitChance",CComFuncs.NumRetBool(Consts.LowSanityNegativeTraitChance,0,CCodeFuncs.GetLowSanityNegativeTraitChance()))

  CComFuncs.SetSavedSetting("LowSanityNegativeTraitChance",Consts.LowSanityNegativeTraitChance)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.LowSanityNegativeTraitChance) .. ": Stupid and happy",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle()
  CComFuncs.SetConstsG("LowSanitySuicideChance",CComFuncs.ToggleBoolNum(Consts.LowSanitySuicideChance))

  CComFuncs.SetSavedSetting("LowSanitySuicideChance",Consts.LowSanitySuicideChance)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.LowSanitySuicideChance) .. ": Getting away ain't that easy",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle()
  CComFuncs.SetConstsG("OxygenMaxOutsideTime",CComFuncs.ValueRetOpp(Consts.OxygenMaxOutsideTime,99999900,CConsts.OxygenMaxOutsideTime))

  CComFuncs.SetSavedSetting("OxygenMaxOutsideTime",Consts.OxygenMaxOutsideTime)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.OxygenMaxOutsideTime) .. ": Free Air",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ColonistsStarve_Toggle()
  CComFuncs.SetConstsG("TimeBeforeStarving",CComFuncs.ValueRetOpp(Consts.TimeBeforeStarving,99999900,CConsts.TimeBeforeStarving))

  CComFuncs.SetSavedSetting("TimeBeforeStarving",Consts.TimeBeforeStarving)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.TimeBeforeStarving) .. ": Free Food",
    "Colonists","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.MenuFuncs.AvoidWorkplace_Toggle()
  CComFuncs.SetConstsG("AvoidWorkplaceSols",CComFuncs.NumRetBool(Consts.AvoidWorkplaceSols,0,CConsts.AvoidWorkplaceSols))

  CComFuncs.SetSavedSetting("AvoidWorkplaceSols",Consts.AvoidWorkplaceSols)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.AvoidWorkplaceSols) .. ": No Shame",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.PositivePlayground_Toggle()
  CComFuncs.SetConstsG("positive_playground_chance",CComFuncs.ValueRetOpp(Consts.positive_playground_chance,101,CConsts.positive_playground_chance))

  CComFuncs.SetSavedSetting("positive_playground_chance",Consts.positive_playground_chance)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.positive_playground_chance) .. "\nWe've all seen them, on the playground, at the store, walking on the streets.",
    "Traits","UI/Icons/Upgrades/home_collective_02.tga",true
  )
end

function ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle()
  CComFuncs.SetConstsG("ProjectMorphiousPositiveTraitChance",CComFuncs.ValueRetOpp(Consts.ProjectMorphiousPositiveTraitChance,100,CConsts.ProjectMorphiousPositiveTraitChance))

  CComFuncs.SetSavedSetting("ProjectMorphiousPositiveTraitChance",Consts.ProjectMorphiousPositiveTraitChance)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance) .. "\nSay, \"Small umbrella, small umbrella.\"",
    "Colonists","UI/Icons/Upgrades/rejuvenation_treatment_04.tga",true
  )
end

function ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle()
  CComFuncs.SetConstsG("NonSpecialistPerformancePenalty",CComFuncs.NumRetBool(Consts.NonSpecialistPerformancePenalty,0,CCodeFuncs.GetNonSpecialistPerformancePenalty()))

  CComFuncs.SetSavedSetting("NonSpecialistPerformancePenalty",Consts.NonSpecialistPerformancePenalty)
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.NonSpecialistPerformancePenalty) .. "\nYou never know what you're gonna get.",
    "Penalty",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius()
  local DefaultSetting = CConsts.DefaultOutsideWorkplacesRadius
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
  if ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius then
    hint = ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      CComFuncs.SetConstsG("DefaultOutsideWorkplacesRadius",value)
      CComFuncs.SetSavedSetting("DefaultOutsideWorkplacesRadius",value)
      CSettingFuncs.WriteSettings()
        CComFuncs.MsgPopup(choice[1].text .. ": There's a voice that keeps on calling me\nDown the road is where I'll always be\nMaybe tomorrow, I'll find what I call home\nUntil tomorrow, you know I'm free to roam",
          "Colonists","UI/Icons/Sections/dome.tga",true
        )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Outside Workplace Radius","Current distance: " .. hint .. "\n\nYou may not want to make it too far away unless you turned off suffocation.")
end

function ChoGGi.MenuFuncs.SetDeathAge()
  local function RetDeathAge(colonist)
    return colonist.MinAge_Senior + 5 + colonist:Random(10) + colonist:Random(5) + colonist:Random(5)
  end

  local ItemList = {
    {text = " Default",value = "Default",hint = "Uses same code as game to pick death ages."},
    {text = 60,value = 60},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
    {text = "Logan's Run (Novel)",value = "LoganNovel"},
    {text = "Logan's Run (Movie)",value = "LoganMovie"},
    {text = "TNG: Half a Life",value = "TNG"},
    {text = "The Happy Place",value = "TheHappyPlace"},
    {text = "In Time",value = "InTime"},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    local amount
    if type(value) == "number" then
      amount = value
    elseif value == "LoganNovel" then
      amount = 21
    elseif value == "LoganMovie" then
      amount = 30
    elseif value == "TNG" then
      amount = 60
    elseif value == "TheHappyPlace" then
      amount = 60
    elseif value == "InTime" then
      amount = 26
    end

    if value == "Default" or type(amount) == "number" then
      if value == "Default" then
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          tab[i].death_age = RetDeathAge(tab[i])
        end
      elseif type(amount) == "number" then
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          tab[i].death_age = amount
        end
      end

      CComFuncs.MsgPopup("Death age: " .. choice[1].text,
        "Colonists","UI/Icons/Sections/attention.tga"
      )
    end
  end

  local hint = "Usual age is around " .. RetDeathAge(UICity.labels.Colonist[1]) .. ". This doesn't stop colonists from becoming seniors; just death (research ForeverYoung for enternal labour)."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Death Age",hint)
end

function ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll()
  local tab = UICity.labels.Colonist or empty_table
  for i = 1, #tab do
    if tab[i].specialist == "none" then
      CCodeFuncs.ColonistUpdateSpecialization(tab[i],"Random")
    end
  end

  CComFuncs.MsgPopup("No lazy good fer nuthins round here",
    "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

local function IsChild(value)
  if value == "Child" then
    return "Warning: Child will remove specialization."
  end
end
function ChoGGi.MenuFuncs.SetColonistsAge(iType)
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
  ItemList[#ItemList+1] = {
    text = DefaultSetting,
    value = DefaultSetting,
  }
  for i = 1, #CTables.ColonistAges do
  ItemList[#ItemList+1] = {
      text = CTables.ColonistAges[i],
      value = CTables.ColonistAges[i],
      hint = IsChild(CTables.ColonistAges[i]),
    }
  end

  local hint = ""
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.UserSettings[sSetting] then
      hint = ChoGGi.UserSettings[sSetting]
    end
    hint = "Current: " .. hint .. "\n\nWarning: Child will remove specialization."
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    local value = choice[1].value
    --new
    if iType == 1 then
      CComFuncs.SetSavedSetting("NewColonistAge",value)
      CSettingFuncs.WriteSettings()

    --existing
    elseif iType == 2 then
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            CCodeFuncs.ColonistUpdateAge(tab[i],value)
          end
        else
          CCodeFuncs.ColonistUpdateAge(tab[i],value)
        end
      end
    end

    CComFuncs.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Age",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetColonistsGender(iType)
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
  ItemList[#ItemList+1] = {
    text = DefaultSetting,
    value = DefaultSetting,
    hint = "How the game normally works",
  }
  ItemList[#ItemList+1] = {
    text = " MaleOrFemale",
    value = "MaleOrFemale",
    hint = "Only set as male or female",
  }
  for i = 1, #CTables.ColonistGenders do
    ItemList[#ItemList+1] = {
      text = CTables.ColonistGenders[i],
      value = CTables.ColonistGenders[i],
    }
  end

  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.UserSettings[sSetting] then
      hint = ChoGGi.UserSettings[sSetting]
    end
    hint = "Current: " .. hint
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    --new
    local value = choice[1].value
    if iType == 1 then
      CComFuncs.SetSavedSetting("NewColonistGender",value)
      CSettingFuncs.WriteSettings()
    --existing
    elseif iType == 2 then
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            CCodeFuncs.ColonistUpdateGender(tab[i],value)
          end
        else
          CCodeFuncs.ColonistUpdateGender(tab[i],value)
        end
      end
    end
    CComFuncs.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Gender",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetColonistsSpecialization(iType)
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
  ItemList[#ItemList+1] = {
    text = DefaultSetting,
    value = DefaultSetting,
    hint = "How the game normally works",
  }
  if iType == 1 then
    ItemList[#ItemList+1] = {
      text = "Random",
      value = "Random",
      hint = "Everyone gets a spec",
    }
  end
  ItemList[#ItemList+1] = {
    text = "none",
    value = "none",
    hint = "Removes specializations",
  }
  for i = 1, #CTables.ColonistSpecializations do
    ItemList[#ItemList+1] = {
      text = CTables.ColonistSpecializations[i],
      value = CTables.ColonistSpecializations[i],
    }
  end

  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.UserSettings[sSetting] then
      hint = ChoGGi.UserSettings[sSetting]
    end
    hint = "Current: " .. hint
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    --new
    local value = choice[1].value
    if iType == 1 then
      CComFuncs.SetSavedSetting("NewColonistSpecialization",value)
      CSettingFuncs.WriteSettings()
    --existing
    elseif iType == 2 then
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            CCodeFuncs.ColonistUpdateSpecialization(tab[i],value)
          end
        else
          CCodeFuncs.ColonistUpdateSpecialization(tab[i],value)
        end
      end
    end
    CComFuncs.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Specialization",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetColonistsRace(iType)
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
  ItemList[#ItemList+1] = {
    text = DefaultSetting,
    value = DefaultSetting,
    race = DefaultSetting,
  }
  local race = {"Herrenvolk","Schwarzvolk","Asiatischvolk","Indischvolk","Südost Asiatischvolk"}
  for i = 1, #CTables.ColonistRaces do
    ItemList[#ItemList+1] = {
      text = CTables.ColonistRaces[i],
      value = i,
      race = race[i],
    }
  end

  local hint
  if iType == 1 then
    hint = DefaultSetting
    if ChoGGi.UserSettings[sSetting] then
      hint = ChoGGi.UserSettings[sSetting]
    end
    hint = "Current: " .. hint
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    --new
    local value = choice[1].value
    if iType == 1 then
      CComFuncs.SetSavedSetting("NewColonistRace",value)
      CSettingFuncs.WriteSettings()
    --existing
    elseif iType == 2 then
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            CCodeFuncs.ColonistUpdateRace(tab[i],value)
          end
        else
          CCodeFuncs.ColonistUpdateRace(tab[i],value)
        end
      end
    end
    CComFuncs.MsgPopup("Nationalsozialistische Rassenhygiene: " .. choice[1].race,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Race",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetColonistsTraits(iType)
  local DefaultSetting = " Default"
  local sSetting = "NewColonistTraits"
  local sType = "New C"

  local hint = ""
  if iType == 1 then
    hint = DefaultSetting
    local saved = ChoGGi.UserSettings[sSetting]
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
  hint = hint .. "\n\nDefaults to adding traits, check Remove to remove. Use Shift or Ctrl to select multiple traits."

  local ItemList = {
      {text = " " .. DefaultSetting,value = DefaultSetting,hint = "Use game defaults"},
      {text = " All Positive Traits",value = "PositiveTraits",hint = "All the positive traits..."},
      {text = " All Negative Traits",value = "NegativeTraits",hint = "All the negative traits..."},
      {text = " All Traits",value = "AllTraits",hint = "All the traits..."},
    }

  if iType == 2 then
    ItemList[1].hint = "Random: Each colonist gets three positive and three negative traits (if it picks same traits then you won't get all six)."
  end

  for i = 1, #CTables.NegativeTraits do
    ItemList[#ItemList+1] = {
      text = CTables.NegativeTraits[i],
      value = CTables.NegativeTraits[i],
    }
  end
  for i = 1, #CTables.PositiveTraits do
    ItemList[#ItemList+1] = {
      text = CTables.PositiveTraits[i],
      value = CTables.PositiveTraits[i],
    }
  end
  --add hint descriptions
  for i = 1, #ItemList do
    local hinttemp = DataInstances.Trait[ItemList[i].text]
    if hinttemp then
      ItemList[i].hint = ": " .. _InternalTranslate(hinttemp.description)
    end
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    --create list of traits
    local TraitsListTemp = {}
    local function AddToTable(List,Table)
      for x = 1, #List do
        Table[#Table+1] = List[x]
      end
      return Table
    end
    for i = 1, #choice do
      if choice[i].value == "NegativeTraits" then
        TraitsListTemp = AddToTable(CTables.NegativeTraits,TraitsListTemp)
      elseif choice[i].value == "PositiveTraits" then
        TraitsListTemp = AddToTable(CTables.PositiveTraits,TraitsListTemp)
      elseif choice[i].value == "AllTraits" then
        TraitsListTemp = AddToTable(CTables.PositiveTraits,TraitsListTemp)
        TraitsListTemp = AddToTable(CTables.NegativeTraits,TraitsListTemp)
        ex(TraitsListTemp)
      else
        if choice[i].value then
          TraitsListTemp = AddToTable(choice[i].value,TraitsListTemp)
        end
      end
    end
    --remove dupes
    table.sort(TraitsListTemp)
    local TraitsList = {}
    for i = 1, #TraitsListTemp do
      if TraitsListTemp[i] ~= TraitsListTemp[i-1] then
        TraitsList[#TraitsList+1] = TraitsListTemp[i]
      end
    end

    --new
    if iType == 1 then
      if choice[1].value == DefaultSetting then
        ChoGGi.UserSettings.NewColonistTraits = false
      else
        ChoGGi.UserSettings.NewColonistTraits = TraitsList
      end
      CSettingFuncs.WriteSettings()
    --existing

    elseif iType == 2 then

      --random 3x3
      if choice[1].value == DefaultSetting then
        local function RandomTraits(Obj)
          --remove all traits
          CCodeFuncs.ColonistUpdateTraits(Obj,false,CTables.PositiveTraits)
          CCodeFuncs.ColonistUpdateTraits(Obj,false,CTables.NegativeTraits)
          --add random ones
          Obj:AddTrait(CTables.PositiveTraits[UICity:Random(1,#CTables.PositiveTraits)],true)
          Obj:AddTrait(CTables.PositiveTraits[UICity:Random(1,#CTables.PositiveTraits)],true)
          Obj:AddTrait(CTables.PositiveTraits[UICity:Random(1,#CTables.PositiveTraits)],true)
          Obj:AddTrait(CTables.NegativeTraits[UICity:Random(1,#CTables.NegativeTraits)],true)
          Obj:AddTrait(CTables.NegativeTraits[UICity:Random(1,#CTables.NegativeTraits)],true)
          Obj:AddTrait(CTables.NegativeTraits[UICity:Random(1,#CTables.NegativeTraits)],true)
          Notify(Obj,"UpdateMorale")
        end
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome.handle == dome then
              RandomTraits(tab[i])
            end
          else
            RandomTraits(tab[i])
          end
        end

      else
        local Type = "AddTrait"
        if choice[1].check2 then
          Type = "RemoveTrait"
        end
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          for j = 1, #TraitsList do
            if dome then
              if tab[i].dome and tab[i].dome.handle == dome then
                tab[i][Type](tab[i],TraitsList[j],true)
              end
            else
              tab[i][Type](tab[i],TraitsList[j],true)
            end
          end
        end

      end

    end
    CComFuncs.MsgPopup(sType .. "olonists traits set: " .. #TraitsList,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  if iType == 1 then
    CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint,true)
  elseif iType == 2 then
    CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint,true,Check1,Check1Hint,"Remove","Check to remove traits")
  end
end

function ChoGGi.MenuFuncs.SetColonistsStats()
	local r = CConsts.ResourceScale
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

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    local max = 100000 * r
    local fill = 100 * r
    local value = choice[1].value
    local function SetStat(Stat,v)
      if v == 1 or v == 3 or v == 6 or v == 8 then
        v = max
      else
        v = fill
      end
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            tab[i][Stat] = v
          end
        else
          tab[i][Stat] = v
        end
      end
    end

    if value == 1 or value == 2 then
      if value == 1 then
        value = max
      elseif value == 2 then
        value = fill
      end

      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            tab[i].stat_morale = value
            tab[i].stat_sanity = value
            tab[i].stat_comfort = value
            tab[i].stat_health = value
          end
        else
          tab[i].stat_morale = value
          tab[i].stat_sanity = value
          tab[i].stat_comfort = value
          tab[i].stat_health = value
        end
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

    CComFuncs.MsgPopup(choice[1].text,"Colonists",UsualIcon)
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local hint = "Fill: Stat bar filled to 100\nMax: 100000 (choose fill to reset)\n\nWarning: Disable births or else..."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Stats Of All Colonists",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetColonistMoveSpeed()
  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts.SpeedColonist
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = 5,value = 5 * r},
    {text = 10,value = 10 * r},
    {text = 15,value = 15 * r},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 100,value = 100 * r},
    {text = 1000,value = 1000 * r},
    {text = 10000,value = 10000 * r},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.SpeedColonist then
    hint = ChoGGi.UserSettings.SpeedColonist
  end

  --callback
  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    local value = choice[1].value
    if type(value) == "number" then
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            --tab[i]:SetMoveSpeed(value)
            pf.SetStepLen(tab[i],value)
          end
        else
          --tab[i]:SetMoveSpeed(value)
          pf.SetStepLen(tab[i],value)
        end
      end
      CComFuncs.SetSavedSetting("SpeedColonist",value)
      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "Colonists",UsualIcon
      )
    end
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Colonist Move Speed","Current: " .. hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetGravityColonists()
  local DefaultSetting = CConsts.GravityColonist
  local r = CConsts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1},
    {text = 2,value = 2},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 15,value = 15},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.GravityColonist then
    hint = ChoGGi.UserSettings.GravityColonist / r
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome.handle
    end
    local value = choice[1].value
    if type(value) == "number" then
      value = value * r
      local tab = UICity.labels.Colonist or empty_table
      for i = 1, #tab do
        if dome then
          if tab[i].dome and tab[i].dome.handle == dome then
            tab[i]:SetGravity(value)
          end
        else
          tab[i]:SetGravity(value)
        end
      end
      CComFuncs.SetSavedSetting("GravityColonist",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Colonist gravity is now: " .. choice[1].text,
        "Colonists",UsualIcon
      )
    end
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Colonist Gravity","Current gravity: " .. hint,nil,Check1,Check1Hint)
end

