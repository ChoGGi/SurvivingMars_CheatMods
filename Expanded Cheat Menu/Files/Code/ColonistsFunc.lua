local UsualIcon = "UI/Icons/Notifications/colonist.tga"

function ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.NoMoreEarthsick = not ChoGGi.UserSettings.NoMoreEarthsick
  if ChoGGi.UserSettings.NoMoreEarthsick then
    local Table = UICity.labels.Colonist or empty_table
    for i = 1, #Table do
      if Table[i].status_effects.StatusEffect_Earthsick then
        Table[i]:Affect("StatusEffect_Earthsick", false)
      end
    end
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(
    tostring(ChoGGi.UserSettings.NoMoreEarthsick) .. ": Whoops somebody broke the rocket, guess you're stuck on mars.",
    "Colonists"
  )
end

function ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle()
  ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait = not ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(
    tostring(ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait) .. "Water? Like out of the toilet?",
    "Idiots"
  )
end

DeathReasons.ChoGGi_Soylent = "Evil Overlord"
NaturalDeathReasons.ChoGGi_Soylent = true
function ChoGGi.MenuFuncs.TheSoylentOption()
  local UICity = UICity
  local ChoGGi = ChoGGi
  local DoneObject = DoneObject
  local CreateRealTimeThread = CreateRealTimeThread

  --don't drop BlackCube/MysteryResource
  local reslist = {}
  local all = AllResourcesList
  for i = 1, #all do
    if all[i] ~= "BlackCube" and all[i] ~= "MysteryResource" then
      reslist[#reslist+1] = all[i]
    end
  end

  local function MeatbagsToSoylent(MeatBag,res)
    if MeatBag.dying then
      return
    end

    if res then
      res = reslist[UICity:Random(1,#reslist)]
    else
      res = "Food"
    end
    PlaceResourcePile(MeatBag:GetVisualPos(), res, UICity:Random(1,5) * ChoGGi.Consts.ResourceScale)
    MeatBag:SetCommand("Die","ChoGGi_Soylent")
    MeatBag.ChoGGi_Soylent = true
    CreateRealTimeThread(function()
      --gotta wait for a tad else log gets spammed with changepath and other stuff
      Sleep(100)
      local Table = GetObjects({class="Colonist"}) or empty_table
      for i = 1, #Table do
        if Table[i].ChoGGi_Soylent then
          Table[i]:Done()
          --Table[i]:PopAndCallDestructor()
          ChoGGi.CodeFuncs.DeleteObject(Table[i])
        end
      end
    end)
  end

  --one meatbag at a time
  local sel = ChoGGi.CodeFuncs.SelObject()
  if sel and sel.class == "Colonist"then
    MeatbagsToSoylent(sel)
    return
  end

  --culling the herd
  local ItemList = {
    {text = " Homeless",value = "Homeless"},
    {text = " Unemployed",value = "Unemployed"},
    {text = " Renegades",value = "Renegade"},
    {text = "Specialization: none",value = "none"},
  }
  local function AddToList(Table,Text)
    for i = 1, #Table do
      ItemList[#ItemList+1] = {
        text = Text .. Table[i],value = Table[i],idx = i,
      }
    end
  end
  AddToList(ChoGGi.Tables.ColonistAges,"Age: ")
  AddToList(ChoGGi.Tables.ColonistBirthplaces,"Birthplace: ")
  AddToList(ChoGGi.Tables.ColonistGenders,"Gender: ")
  AddToList(ChoGGi.Tables.ColonistRaces,"Race: ")
  AddToList(ChoGGi.Tables.ColonistSpecializations,"Specialization: ")

  local CallBackFunc = function(choice)
    local value = choice[1].value
    local check1 = choice[1].check1
    local dome
    sel = SelectedObj
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check2 then
      dome = sel.dome
    end

    local Table
    local function CullLabel(Label)
      Table = UICity.labels[Label] or empty_table
      for i = #Table, 1, -1 do
        if dome then
          if Table[i].dome and Table[i].dome == dome then
            MeatbagsToSoylent(Table[i],check1)
          end
        else
          MeatbagsToSoylent(Table[i],check1)
        end
      end
    end
    local function CullTrait(Trait)
      Table = UICity.labels.Colonist or empty_table
      for i = #Table, 1, -1 do
        if Table[i].traits[Trait] then
          if dome then
            if Table[i].dome and Table[i].dome == dome then
              MeatbagsToSoylent(Table[i],check1)
            end
          else
            MeatbagsToSoylent(Table[i],check1)
          end
        end
      end
    end
    local function Cull(Trait,TraitType,Race)
      --only race is stored as number (maybe there's a cock^?^?^?^?CoC around)
      Trait = Race or Trait
      Table = UICity.labels.Colonist or empty_table
      for i = #Table, 1, -1 do
        if Table[i][TraitType] == Trait then
          if dome then
            if Table[i].dome and Table[i].dome == dome then
              MeatbagsToSoylent(Table[i],check1)
            end
          else
            MeatbagsToSoylent(Table[i],check1)
          end
        end
      end
    end

    if value == "Homeless" or value == "Unemployed" then
      CullLabel(value)
    elseif ChoGGi.Tables.ColonistSpecializations[value] or value == "none" then
      CullLabel(value)
    elseif ChoGGi.Tables.ColonistAges[value] then
      CullTrait(value)
    elseif ChoGGi.Tables.ColonistBirthplaces[value] then
      Cull(value,"birthplace")
    elseif ChoGGi.Tables.ColonistGenders[value] then
      CullTrait(value)
    elseif ChoGGi.Tables.ColonistRaces[value] then
      Cull(value,"race",choice[1].idx)
    elseif value == "Renegade" then
      CullTrait(value)
    end

    if value == "Child" then
      --wonder why they never added this to fallout 3?
      ChoGGi.ComFuncs.MsgPopup(
        "Congratulations: You've been awarded the Childkiller title.\n\n\n\nI think somebody has been playing too much Fallout...",
        "Childkiller",
        "UI/Icons/Logos/logo_09.tga",
        true
      )
      if not UICity.ChoGGi.Childkiller then
        Msg("ChoGGi_Childkiller")
        UICity.ChoGGi.Childkiller = true
      end
    else
      ChoGGi.ComFuncs.MsgPopup(
        "Wholesale slaughter: " .. choice[1].text,
        "Snacks",
        "UI/Icons/Sections/Food_1.tga"
      )
    end
  end

  local Check1 = "Random resource"
  local Check1Hint = "Drops random resource instead of food."
  local Check2 = "Dome Only"
  local Check2Hint = "Will only apply to colonists in the same dome as selected colonist."
  local hint = "Convert useless meatbags into productive protein.\n\nCertain colonists may take some time (traveling in shuttles).\n\nThis will not effect your applicants/game failure (genocide without reprisal)."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"The Soylent Option",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
end

function ChoGGi.MenuFuncs.AddApplicantsToPool()
  local ChoGGi = ChoGGi
  local GetRandomTrait = GetRandomTrait
  local GenerateApplicant = GenerateApplicant
  local GenerateTraits = GenerateTraits
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
    if choice[1].check1 then
      g_ApplicantPool = {}
      ChoGGi.ComFuncs.MsgPopup("Emptied applicants pool.",
        "Applicants",UsualIcon
      )
    else
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
        ChoGGi.ComFuncs.MsgPopup("Added applicants: " .. choice[1].text,
          "Applicants",UsualIcon
        )
      end
    end
  end

  local hint = "Warning: Will take some time for 25K and up."
  local Check1 = "Clear Applicant Pool"
  local Check1Hint = "Remove all the applicants currently in the pool (checking this will ignore your list selection).\n\nCurrent Pool Size: " .. #g_ApplicantPool
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Applicants To Pool",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.FireAllColonists()
  local CallBackFunc = function()
    local tab = UICity.labels.Colonist or empty_table
    for i = 1, #tab do
      tab[i]:GetFired()
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    "Are you sure you want to fire everyone?",
    CallBackFunc,
    "Yer outta here!"
  )
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

    ChoGGi.ComFuncs.MsgPopup("Early night? Vamos al bar un trago!",
      "Shifts",UsualIcon
    )
  end
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shifts","Are you sure you want to change all shifts?")
end

function ChoGGi.MenuFuncs.SetMinComfortBirth()

  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.MinComfortBirth / r
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
      ChoGGi.ComFuncs.SetConstsG("MinComfortBirth",value)
      ChoGGi.ComFuncs.SetSavedSetting("MinComfortBirth",Consts.MinComfortBirth)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text .. "\nLook at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
        "Colonists",UsualIcon,true
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"MinComfortBirth","Current: " .. hint)
end

function ChoGGi.MenuFuncs.VisitFailPenalty_Toggle()
  ChoGGi.ComFuncs.SetConstsG("VisitFailPenalty",ChoGGi.ComFuncs.NumRetBool(Consts.VisitFailPenalty,0,ChoGGi.Consts.VisitFailPenalty))

  ChoGGi.ComFuncs.SetSavedSetting("VisitFailPenalty",Consts.VisitFailPenalty)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.VisitFailPenalty) .. "\nThe mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
    "Colonists",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.RenegadeCreation_Toggle()
  ChoGGi.ComFuncs.SetConstsG("RenegadeCreation",ChoGGi.ComFuncs.ValueRetOpp(Consts.RenegadeCreation,9999900,ChoGGi.Consts.RenegadeCreation))

  ChoGGi.ComFuncs.SetSavedSetting("RenegadeCreation",Consts.RenegadeCreation)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RenegadeCreation) .. ": I just love findin' subversives.",
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
      dome = sel.dome
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
        if tab[i].dome and tab[i].dome == dome then
          tab[i][Type](tab[i],"Renegade")
        end
      else
        tab[i][Type](tab[i],"Renegade")
      end
    end
    ChoGGi.ComFuncs.MsgPopup("OK, a limosine that can fly. Now I have seen everything.\nReally? Have you seen a man eat his own head?\nNo.\nSo then, you haven't seen everything.",
      "Colonists",UsualIcon,true
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Make Renegades",nil,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle()
  -- was -100
  ChoGGi.ComFuncs.SetConstsG("HighStatLevel",ChoGGi.ComFuncs.NumRetBool(Consts.HighStatLevel,0,ChoGGi.Consts.HighStatLevel))
  ChoGGi.ComFuncs.SetConstsG("LowStatLevel",ChoGGi.ComFuncs.NumRetBool(Consts.LowStatLevel,0,ChoGGi.Consts.LowStatLevel))
  ChoGGi.ComFuncs.SetConstsG("HighStatMoraleEffect",ChoGGi.ComFuncs.ValueRetOpp(Consts.HighStatMoraleEffect,999900,ChoGGi.Consts.HighStatMoraleEffect))
  ChoGGi.ComFuncs.SetSavedSetting("HighStatMoraleEffect",Consts.HighStatMoraleEffect)
  ChoGGi.ComFuncs.SetSavedSetting("HighStatLevel",Consts.HighStatLevel)
  ChoGGi.ComFuncs.SetSavedSetting("LowStatLevel",Consts.LowStatLevel)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.HighStatMoraleEffect) .. ": Happy as a pig in shit",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle()
  ChoGGi.ComFuncs.SetConstsG("SeeDeadSanity",ChoGGi.ComFuncs.NumRetBool(Consts.SeeDeadSanity,0,ChoGGi.Consts.SeeDeadSanity))
  ChoGGi.ComFuncs.SetSavedSetting("SeeDeadSanity",Consts.SeeDeadSanity)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.SeeDeadSanity) .. ": I love me some corpses.",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle()
  ChoGGi.ComFuncs.SetConstsG("NoHomeComfort",ChoGGi.ComFuncs.NumRetBool(Consts.NoHomeComfort,0,ChoGGi.Consts.NoHomeComfort))
  ChoGGi.ComFuncs.SetSavedSetting("NoHomeComfort",Consts.NoHomeComfort)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.NoHomeComfort) .. "\nOh, give me a home where the Buffalo roam\nWhere the Deer and the Antelope play;\nWhere seldom is heard a discouraging word,",
    "Colonists",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle()
  ChoGGi.ComFuncs.SetConstsG("DustStormSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.DustStormSanityDamage,0,ChoGGi.Consts.DustStormSanityDamage))
  ChoGGi.ComFuncs.SetConstsG("MysteryDreamSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.MysteryDreamSanityDamage,0,ChoGGi.Consts.MysteryDreamSanityDamage))
  ChoGGi.ComFuncs.SetConstsG("ColdWaveSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.ColdWaveSanityDamage,0,ChoGGi.Consts.ColdWaveSanityDamage))
  ChoGGi.ComFuncs.SetConstsG("MeteorSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.MeteorSanityDamage,0,ChoGGi.Consts.MeteorSanityDamage))

  ChoGGi.ComFuncs.SetSavedSetting("DustStormSanityDamage",Consts.DustStormSanityDamage)
  ChoGGi.ComFuncs.SetSavedSetting("MysteryDreamSanityDamage",Consts.MysteryDreamSanityDamage)
  ChoGGi.ComFuncs.SetSavedSetting("ColdWaveSanityDamage",Consts.ColdWaveSanityDamage)
  ChoGGi.ComFuncs.SetSavedSetting("MeteorSanityDamage",Consts.MeteorSanityDamage)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DustStormSanityDamage) .. ": Happy as a pig in shit",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle()
  ChoGGi.ComFuncs.SetConstsG("LowSanityNegativeTraitChance",ChoGGi.ComFuncs.NumRetBool(Consts.LowSanityNegativeTraitChance,0,ChoGGi.CodeFuncs.GetLowSanityNegativeTraitChance()))

  ChoGGi.ComFuncs.SetSavedSetting("LowSanityNegativeTraitChance",Consts.LowSanityNegativeTraitChance)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.LowSanityNegativeTraitChance) .. ": Stupid and happy",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle()
  ChoGGi.ComFuncs.SetConstsG("LowSanitySuicideChance",ChoGGi.ComFuncs.ToggleBoolNum(Consts.LowSanitySuicideChance))

  ChoGGi.ComFuncs.SetSavedSetting("LowSanitySuicideChance",Consts.LowSanitySuicideChance)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.LowSanitySuicideChance) .. ": Getting away ain't that easy",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle()
  ChoGGi.ComFuncs.SetConstsG("OxygenMaxOutsideTime",ChoGGi.ComFuncs.ValueRetOpp(Consts.OxygenMaxOutsideTime,99999900,ChoGGi.Consts.OxygenMaxOutsideTime))

  ChoGGi.ComFuncs.SetSavedSetting("OxygenMaxOutsideTime",Consts.OxygenMaxOutsideTime)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.OxygenMaxOutsideTime) .. ": Free Air",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.ColonistsStarve_Toggle()
  ChoGGi.ComFuncs.SetConstsG("TimeBeforeStarving",ChoGGi.ComFuncs.ValueRetOpp(Consts.TimeBeforeStarving,99999900,ChoGGi.Consts.TimeBeforeStarving))

  ChoGGi.ComFuncs.SetSavedSetting("TimeBeforeStarving",Consts.TimeBeforeStarving)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.TimeBeforeStarving) .. ": Free Food",
    "Colonists","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.MenuFuncs.AvoidWorkplace_Toggle()
  ChoGGi.ComFuncs.SetConstsG("AvoidWorkplaceSols",ChoGGi.ComFuncs.NumRetBool(Consts.AvoidWorkplaceSols,0,ChoGGi.Consts.AvoidWorkplaceSols))

  ChoGGi.ComFuncs.SetSavedSetting("AvoidWorkplaceSols",Consts.AvoidWorkplaceSols)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.AvoidWorkplaceSols) .. ": No Shame",
    "Colonists",UsualIcon
  )
end

function ChoGGi.MenuFuncs.PositivePlayground_Toggle()
  ChoGGi.ComFuncs.SetConstsG("positive_playground_chance",ChoGGi.ComFuncs.ValueRetOpp(Consts.positive_playground_chance,101,ChoGGi.Consts.positive_playground_chance))

  ChoGGi.ComFuncs.SetSavedSetting("positive_playground_chance",Consts.positive_playground_chance)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.positive_playground_chance) .. "\nWe've all seen them, on the playground, at the store, walking on the streets.",
    "Traits","UI/Icons/Upgrades/home_collective_02.tga",true
  )
end

function ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle()
  ChoGGi.ComFuncs.SetConstsG("ProjectMorphiousPositiveTraitChance",ChoGGi.ComFuncs.ValueRetOpp(Consts.ProjectMorphiousPositiveTraitChance,100,ChoGGi.Consts.ProjectMorphiousPositiveTraitChance))

  ChoGGi.ComFuncs.SetSavedSetting("ProjectMorphiousPositiveTraitChance",Consts.ProjectMorphiousPositiveTraitChance)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance) .. "\nSay, \"Small umbrella, small umbrella.\"",
    "Colonists","UI/Icons/Upgrades/rejuvenation_treatment_04.tga",true
  )
end

function ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle()
  ChoGGi.ComFuncs.SetConstsG("NonSpecialistPerformancePenalty",ChoGGi.ComFuncs.NumRetBool(Consts.NonSpecialistPerformancePenalty,0,ChoGGi.CodeFuncs.GetNonSpecialistPerformancePenalty()))

  ChoGGi.ComFuncs.SetSavedSetting("NonSpecialistPerformancePenalty",Consts.NonSpecialistPerformancePenalty)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.NonSpecialistPerformancePenalty) .. "\nYou never know what you're gonna get.",
    "Penalty",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius()
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
  if ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius then
    hint = ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetConstsG("DefaultOutsideWorkplacesRadius",value)
      ChoGGi.ComFuncs.SetSavedSetting("DefaultOutsideWorkplacesRadius",value)
      ChoGGi.SettingFuncs.WriteSettings()
        ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": There's a voice that keeps on calling me\nDown the road is where I'll always be\nMaybe tomorrow, I'll find what I call home\nUntil tomorrow, you know I'm free to roam",
          "Colonists","UI/Icons/Sections/dome.tga",true
        )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Outside Workplace Radius","Current distance: " .. hint .. "\n\nYou may not want to make it too far away unless you turned off suffocation.")
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

      ChoGGi.ComFuncs.MsgPopup("Death age: " .. choice[1].text,
        "Colonists","UI/Icons/Sections/attention.tga"
      )
    end
  end

  local hint = "Usual age is around " .. RetDeathAge(UICity.labels.Colonist[1]) .. ". This doesn't stop colonists from becoming seniors; just death (research ForeverYoung for enternal labour)."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Death Age",hint)
end

function ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll()
  local tab = UICity.labels.Colonist or empty_table
  for i = 1, #tab do
    if tab[i].specialist == "none" then
      ChoGGi.CodeFuncs.ColonistUpdateSpecialization(tab[i],"Random")
    end
  end

  ChoGGi.ComFuncs.MsgPopup("No lazy good fer nuthins round here",
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
  for i = 1, #ChoGGi.Tables.ColonistAges do
  ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.ColonistAges[i],
      value = ChoGGi.Tables.ColonistAges[i],
      hint = IsChild(ChoGGi.Tables.ColonistAges[i]),
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
      dome = sel.dome
    end
    local value = choice[1].value
    --new
    if iType == 1 then
      ChoGGi.ComFuncs.SetSavedSetting("NewColonistAge",value)
      ChoGGi.SettingFuncs.WriteSettings()

    --existing
    elseif iType == 2 then
      if choice[1].check2 then
        if sel then
          ChoGGi.CodeFuncs.ColonistUpdateAge(sel,value)
        end
      else
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
              ChoGGi.CodeFuncs.ColonistUpdateAge(tab[i],value)
            end
          else
            ChoGGi.CodeFuncs.ColonistUpdateAge(tab[i],value)
          end
        end
      end

    end

    ChoGGi.ComFuncs.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Age",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
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
  for i = 1, #ChoGGi.Tables.ColonistGenders do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.ColonistGenders[i],
      value = ChoGGi.Tables.ColonistGenders[i],
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
      dome = sel.dome
    end
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.ComFuncs.SetSavedSetting("NewColonistGender",value)
      ChoGGi.SettingFuncs.WriteSettings()
    --existing
    elseif iType == 2 then
      if choice[1].check2 then
        if sel then
          ChoGGi.CodeFuncs.ColonistUpdateGender(sel,value)
        end
      else
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
              ChoGGi.CodeFuncs.ColonistUpdateGender(tab[i],value)
            end
          else
            ChoGGi.CodeFuncs.ColonistUpdateGender(tab[i],value)
          end
        end
      end

    end
    ChoGGi.ComFuncs.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Gender",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
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
  for i = 1, #ChoGGi.Tables.ColonistSpecializations do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.ColonistSpecializations[i],
      value = ChoGGi.Tables.ColonistSpecializations[i],
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
      dome = sel.dome
    end
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.ComFuncs.SetSavedSetting("NewColonistSpecialization",value)
      ChoGGi.SettingFuncs.WriteSettings()
    --existing
    elseif iType == 2 then
      if choice[1].check2 then
        if sel then
          ChoGGi.CodeFuncs.ColonistUpdateSpecialization(sel,value)
        end
      else
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
              ChoGGi.CodeFuncs.ColonistUpdateSpecialization(tab[i],value)
            end
          else
            ChoGGi.CodeFuncs.ColonistUpdateSpecialization(tab[i],value)
          end
        end
      end

    end
    ChoGGi.ComFuncs.MsgPopup(sType .. "olonists: " .. choice[1].text,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Specialization",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
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
  for i = 1, #ChoGGi.Tables.ColonistRaces do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.ColonistRaces[i],
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
      dome = sel.dome
    end
    --new
    local value = choice[1].value
    if iType == 1 then
      ChoGGi.ComFuncs.SetSavedSetting("NewColonistRace",value)
      ChoGGi.SettingFuncs.WriteSettings()
    --existing
    elseif iType == 2 then
      if choice[1].check2 then
        if sel then
          ChoGGi.CodeFuncs.ColonistUpdateRace(sel,value)
        end
      else
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
              ChoGGi.CodeFuncs.ColonistUpdateRace(tab[i],value)
            end
          else
            ChoGGi.CodeFuncs.ColonistUpdateRace(tab[i],value)
          end
        end
      end

    end
    if value then
      if not UICity.ChoGGi.DaddysLittleHitler then
        Msg("ChoGGi_DaddysLittleHitler")
        UICity.ChoGGi.DaddysLittleHitler = true
      end
    end

    ChoGGi.ComFuncs.MsgPopup("Nationalsozialistische Rassenhygiene: " .. choice[1].race,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Race",hint,nil,Check1,Check1Hint,Check2,Check2Hint)
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

  for i = 1, #ChoGGi.Tables.NegativeTraits do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.NegativeTraits[i],
      value = ChoGGi.Tables.NegativeTraits[i],
    }
  end
  for i = 1, #ChoGGi.Tables.PositiveTraits do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.PositiveTraits[i],
      value = ChoGGi.Tables.PositiveTraits[i],
    }
  end
  --add hint descriptions
  for i = 1, #ItemList do
    local hinttemp = DataInstances.Trait[ItemList[i].text]
    if hinttemp then
      ItemList[i].hint = ": " .. ChoGGi.CodeFuncs.Trans(hinttemp.description)
    end
  end

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome
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
        TraitsListTemp = AddToTable(ChoGGi.Tables.NegativeTraits,TraitsListTemp)
      elseif choice[i].value == "PositiveTraits" then
        TraitsListTemp = AddToTable(ChoGGi.Tables.PositiveTraits,TraitsListTemp)
      elseif choice[i].value == "AllTraits" then
        TraitsListTemp = AddToTable(ChoGGi.Tables.PositiveTraits,TraitsListTemp)
        TraitsListTemp = AddToTable(ChoGGi.Tables.NegativeTraits,TraitsListTemp)
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
      ChoGGi.SettingFuncs.WriteSettings()

    --existing
    elseif iType == 2 then
      --random 3x3
      if choice[1].value == DefaultSetting then
        local function RandomTraits(Obj)
          --remove all traits
          ChoGGi.CodeFuncs.ColonistUpdateTraits(Obj,false,ChoGGi.Tables.PositiveTraits)
          ChoGGi.CodeFuncs.ColonistUpdateTraits(Obj,false,ChoGGi.Tables.NegativeTraits)
          --add random ones
          Obj:AddTrait(ChoGGi.Tables.PositiveTraits[UICity:Random(1,#ChoGGi.Tables.PositiveTraits)],true)
          Obj:AddTrait(ChoGGi.Tables.PositiveTraits[UICity:Random(1,#ChoGGi.Tables.PositiveTraits)],true)
          Obj:AddTrait(ChoGGi.Tables.PositiveTraits[UICity:Random(1,#ChoGGi.Tables.PositiveTraits)],true)
          Obj:AddTrait(ChoGGi.Tables.NegativeTraits[UICity:Random(1,#ChoGGi.Tables.NegativeTraits)],true)
          Obj:AddTrait(ChoGGi.Tables.NegativeTraits[UICity:Random(1,#ChoGGi.Tables.NegativeTraits)],true)
          Obj:AddTrait(ChoGGi.Tables.NegativeTraits[UICity:Random(1,#ChoGGi.Tables.NegativeTraits)],true)
          Notify(Obj,"UpdateMorale")
        end
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
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
              if tab[i].dome and tab[i].dome == dome then
                tab[i][Type](tab[i],TraitsList[j],true)
              end
            else
              tab[i][Type](tab[i],TraitsList[j],true)
            end
          end
        end

      end

    end
    ChoGGi.ComFuncs.MsgPopup(sType .. "olonists traits set: " .. #TraitsList,
      "Colonists",UsualIcon
    )
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Remove"
  local Check2Hint = "Check to remove traits"
  if iType == 1 then
    ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint,true)
  elseif iType == 2 then
    ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. "olonist Traits",hint,true,Check1,Check1Hint,Check2,Check2Hint)
  end
end

function ChoGGi.MenuFuncs.SetColonistsStats()
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

  local CallBackFunc = function(choice)
    local sel = SelectedObj
    local dome
    if sel and sel.class == "Colonist" and sel.dome and choice[1].check1 then
      dome = sel.dome
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
          if tab[i].dome and tab[i].dome == dome then
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
          if tab[i].dome and tab[i].dome == dome then
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

    ChoGGi.ComFuncs.MsgPopup(choice[1].text,"Colonists",UsualIcon)
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local hint = "Fill: Stat bar filled to 100\nMax: 100000 (choose fill to reset)\n\nWarning: Disable births or else..."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Stats Of All Colonists",hint,nil,Check1,Check1Hint)
end

function ChoGGi.MenuFuncs.SetColonistMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedColonist
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
      dome = sel.dome
    end
    local value = choice[1].value
    if type(value) == "number" then
      if choice[1].check2 then
        if sel then
          pf.SetStepLen(sel,value)
        end
      else
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
              --tab[i]:SetMoveSpeed(value)
              pf.SetStepLen(tab[i],value)
            end
          else
            --tab[i]:SetMoveSpeed(value)
            pf.SetStepLen(tab[i],value)
          end
        end
      end

      ChoGGi.ComFuncs.SetSavedSetting("SpeedColonist",value)
      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "Colonists",UsualIcon
      )
    end
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Colonist Move Speed","Current: " .. hint,nil,Check1,Check1Hint,Check2,Check2Hint)
end

function ChoGGi.MenuFuncs.SetColonistsGravity()
  local DefaultSetting = ChoGGi.Consts.GravityColonist
  local r = ChoGGi.Consts.ResourceScale
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
      dome = sel.dome
    end
    local value = choice[1].value
    if type(value) == "number" then
      value = value * r
      if choice[1].check2 then
        if sel then
          sel:SetGravity(value)
        end
      else
        local tab = UICity.labels.Colonist or empty_table
        for i = 1, #tab do
          if dome then
            if tab[i].dome and tab[i].dome == dome then
              tab[i]:SetGravity(value)
            end
          else
            tab[i]:SetGravity(value)
          end
        end
      end

      ChoGGi.ComFuncs.SetSavedSetting("GravityColonist",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Colonist gravity is now: " .. choice[1].text,
        "Colonists",UsualIcon
      )
    end
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to colonists in the same dome as selected colonist."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected colonist."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Colonist Gravity","Current gravity: " .. hint,nil,Check1,Check1Hint,Check2,Check2Hint)
end

function ChoGGi.MenuFuncs.SetBuildingTraits(sType)
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel or not sel:IsKindOf("Workplace") then
    ChoGGi.ComFuncs.MsgPopup("Select a workplace.",
      "Workplace",UsualIcon
    )
    return
  end
  local id = sel.encyclopedia_id
  local name = ChoGGi.CodeFuncs.Trans(sel.display_name)
  local BuildingSettings = ChoGGi.UserSettings.BuildingSettings
  if not BuildingSettings[id] then
    BuildingSettings[id] = {restricttraits = {},blocktraits = {},}
  end

  local ItemList = {}
  for i = 1, #ChoGGi.Tables.NegativeTraits do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.NegativeTraits[i],
      value = ChoGGi.Tables.NegativeTraits[i],
      hint = type(BuildingSettings[id][sType][ChoGGi.Tables.NegativeTraits[i]]) == "boolean" and "true" or "false",
    }
  end
  for i = 1, #ChoGGi.Tables.PositiveTraits do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.PositiveTraits[i],
      value = ChoGGi.Tables.PositiveTraits[i],
      hint = type(BuildingSettings[id][sType][ChoGGi.Tables.PositiveTraits[i]]) == "boolean" and "true" or "false",
    }
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    for i = 1, #choice do
      local value = choice[i].value

      if BuildingSettings[id][sType][value] then
        BuildingSettings[id][sType][value] = nil
      else
        BuildingSettings[id][sType][value] = true
      end
    end

    if check1 then
      local objs = GetObjects({class=sel.class})
      --all buildings
      for i = 1, #objs do
        local workplace = objs[i]
        --all three shifts
        for j = 1, #workplace.workers do
          --workers in shifts (go through table backwards for when someone gets fired)
          for k = #workplace.workers[j], 1, -1 do

            local worker = workplace.workers[j][k]
            local block,restrict = ChoGGi.CodeFuncs.RetBuildingPermissions(worker.traits,BuildingSettings[id])

            if block or not restrict then
              table.remove_entry(workplace.workers[j], worker)
              --table.remove(workplace.workers[j],k)
              workplace:SetWorkplaceWorking()
              workplace:StopWorkCycle(worker)
              if worker:IsInWorkCommand() then
                worker:InterruptCommand()
              end
              workplace:UpdateAttachedSigns()
            end

          end
        end

      end
    end

    --remove empty tables
    if not next(BuildingSettings[id].restricttraits) and not next(BuildingSettings[id].blocktraits) then
      BuildingSettings[id].restricttraits = nil
      BuildingSettings[id].blocktraits = nil
    end

    ChoGGi.SettingFuncs.WriteSettings()

    ChoGGi.ComFuncs.MsgPopup("Toggled traits: " .. #choice .. (check1 and " Fired workers" or ""),
      "Workplace"
    )
  end

  local hint = ""
  if BuildingSettings[id] and BuildingSettings[id][sType] then
    hint = "Current: " .. table.concat(BuildingSettings[id][sType],",")
  end
  hint = hint .. "\n\nSelect traits and click Ok to toggle status."
  local Check1 = "Fire Workers"
  local Check1Hint = "Will also fire workers with the traits from all " .. name .. "."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Toggle " .. sType .. " For " .. name,hint,true,Check1,Check1Hint)
end
