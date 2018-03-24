UserActions.AddActions({

  ChoGGi_ColonistsAddSpecializationToAll = {
    menu = "Gameplay/Colonists/[5]Work/Add Specialization To All",
    description = "If Colonist has no Specialization then add a random one",
    action = function()
      local jobs = { 'scientist', 'engineer', 'security', 'geologist', 'botanist', 'medic' }
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.none then
          colonist:SetSpecialization(jobs[ UICity:Random(1, 6) ], "init")
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsAddSpecializationToAll",
        "Colonists",
        "No lazy good fer nuthins round here",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_MinComfortBirthZero = {
    menu = "Gameplay/Colonists/[3]Stats/Min Comfort Birth 0",
    description = "No lower limit on birthing comfort",
    action = function()
      Consts.MinComfortBirth = 0
      ChoGGi.CheatMenuSettings["MinComfortBirth"] = Consts.MinComfortBirth
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "MinComfortBirthZero",
        "Colonists",
        "Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_MinComfortBirthDefault = {
    menu = "Gameplay/Colonists/[3]Stats/Min Comfort Birth Default",
    description = "Default limit on birthing comfort",
    action = function()
      Consts.MinComfortBirth = 70000
      ChoGGi.CheatMenuSettings["MinComfortBirth"] = Consts.MinComfortBirth
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "MinComfortBirthDefault",
        "Colonists",
        "Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_VisitFailPenaltyZero = {
    menu = "Gameplay/Colonists/[3]Stats/Visit Fail Penalty 0",
    description = "0 Comfort penalty when failing to satisfy a need via a visit",
    action = function()
      Consts.VisitFailPenalty = 0
      ChoGGi.CheatMenuSettings["VisitFailPenalty"] = Consts.VisitFailPenalty
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "VisitFailPenaltyZero",
        "Penalty",
        "The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_VisitFailPenaltyDefault = {
    menu = "Gameplay/Colonists/[3]Stats/Visit Fail Penalty Default",
    description = "Default Comfort penalty when failing to satisfy a need via a visit",
    action = function()
      Consts.VisitFailPenalty = 10000
      ChoGGi.CheatMenuSettings["VisitFailPenalty"] = Consts.VisitFailPenalty
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "VisitFailPenaltyDefault",
        "Penalty",
        "The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments.",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RenegadeCreationStop = {
    menu = "Gameplay/Colonists/[5]Work/Renegade Creation Stop",
    description = "Stops renegades from being converted",
    action = function()
      Consts.RenegadeCreation = 9999900
      ChoGGi.CheatMenuSettings["RenegadeCreation"] = Consts.RenegadeCreation
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RenegadeCreationStop",
        "Colonists",
        "I just love findin' subversives.",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RenegadeCreationDefault = {
    menu = "Gameplay/Colonists/[5]Work/Renegade Creation Default",
    description = "Doesn't stop renegades from being converted",
    action = function()
      Consts.RenegadeCreation = 70000
      ChoGGi.CheatMenuSettings["RenegadeCreation"] = Consts.RenegadeCreation
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RenegadeCreationDefault",
        "Colonists",
        "I just love findin' subversives.",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsMoraleMaxAlways = {
    menu = "Gameplay/Colonists/[3]Stats/Morale Max Always",
    description = "Colonists always have max morale (may effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.HighStatLevel = -100
      Consts.HighStatMoraleEffect = 999900
      Consts.LowStatLevel = -100
      ChoGGi.CheatMenuSettings["HighStatLevel"] = Consts.HighStatLevel
      ChoGGi.CheatMenuSettings["HighStatMoraleEffect"] = Consts.HighStatMoraleEffect
      ChoGGi.CheatMenuSettings["LowStatLevel"] = Consts.LowStatLevel
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsMoraleMaxAlways",
        "Colonists",
        "Happy as a pig in shit",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsMoraleMaxDefault = {
    menu = "Gameplay/Colonists/[3]Stats/Morale Default",
    description = "Colonists morale Default.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.HighStatLevel = 70000
      Consts.HighStatMoraleEffect = 5000
      Consts.LowStatLevel = 30000
      ChoGGi.CheatMenuSettings["HighStatLevel"] = Consts.HighStatLevel
      ChoGGi.CheatMenuSettings["HighStatMoraleEffect"] = Consts.HighStatMoraleEffect
      ChoGGi.CheatMenuSettings["LowStatLevel"] = Consts.LowStatLevel
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsMoraleMaxDefault",
        "Colonists",
        "Not as happy as a pig in shit",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetMorale100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Morale 100",
    description = "Set all Colonists Morale to 100",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_morale = 100000
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetMorale100",
        "Colonists",
        "Happy days are here again",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSanityMax = {
    menu = "Gameplay/Colonists/[3]Stats/Set Sanity Max",
    description = "Set all Colonists Sanity to Max",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_sanity = 9999900
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSanityMax",
        "Colonists",
        "No need for shrinks",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSanity100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Sanity 100",
    description = "Set all Colonists Sanity to 100",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_sanity = 100000
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSanity100",
        "Colonists",
        "No need for shrinks",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetComfortMax = {
    menu = "Gameplay/Colonists/[3]Stats/Set Comfort Max",
    description = "Set all Colonists Comfort to Max",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_comfort = 9999900
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetComfortMax",
        "Colonists",
        "Happy days are here again",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetComfort100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Comfort 100",
    description = "Set all Colonists Comfort to 100",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_comfort = 100000
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetComfort100",
        "Colonists",
        "Happy days are here again",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetHealthMax = {
    menu = "Gameplay/Colonists/[3]Stats/Set Health Max",
    description = "Set all Colonists Health to Max",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_health = 9999900
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetHealthMax",
        "Colonists",
        "Healthy!",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetHealth100 = {
    menu = "Gameplay/Colonists/[3]Stats/Set Health 100",
    description = "Set all Colonists Health to 100",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.stat_health = 100000
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetHealth100",
        "Colonists",
        "Healthy!",
        "UI/Icons/Upgrades/home_collective_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetAgesToChild = {
    menu = "Gameplay/Colonists/[1]Age/[1]Make all Colonists Children",
    description = "Make all Colonists Child age",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.Retiree then
          colonist.age_trait = "Child"
        elseif colonist.traits.Senior then
          colonist.age_trait = "Child"
        elseif colonist.traits.Adult then
          colonist.age_trait = "Child"
        elseif colonist.traits.Youth then
          colonist.age_trait = "Child"
        elseif colonist.traits["Middle Aged"] then
          colonist.age_trait = "Child"
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetAgesToChild",
        "Colonists",
        "When you're youngest at heart",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetAgesToYouth = {
    menu = "Gameplay/Colonists/[1]Age/[2]Make all Colonists Youths",
    description = "Make all Colonists Youth age",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.Retiree then
          colonist.age_trait = "Youth"
        elseif colonist.traits.Senior then
          colonist.age_trait = "Youth"
        elseif colonist.traits.Adult then
          colonist.age_trait = "Youth"
        elseif colonist.traits.Child then
          colonist.age_trait = "Youth"
        elseif colonist.traits["Middle Aged"] then
          colonist.age_trait = "Youth"
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetAgesToYouth",
        "Colonists",
        "When you're young at heart",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetAgesToAdult = {
    menu = "Gameplay/Colonists/[1]Age/[3]Make all Colonists Middle Aged",
    description = "Make all Colonists Adult age (doesn't always work for everyone who knows why?)",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.Retiree then
          colonist.age_trait = "Adult"
        elseif colonist.traits.Senior then
          colonist.age_trait = "Adult"
        elseif colonist.traits.Youth then
          colonist.age_trait = "Adult"
        elseif colonist.traits.Child then
          colonist.age_trait = "Adult"
        elseif colonist.traits["Middle Aged"] then
          colonist.age_trait = "Adult"
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetAgesToAdult",
        "Colonists",
        "Time for the rat race",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetAgesToMiddleAged = {
    menu = "Gameplay/Colonists/[1]Age/[3]Make all Colonists Middle Aged",
    description = "Make all Colonists Middle Aged (doesn't always work for everyone who knows why?)",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.Retiree then
          colonist.age_trait = "Middle Aged"
        elseif colonist.traits.Senior then
          colonist.age_trait = "Middle Aged"
        elseif colonist.traits.Youth then
          colonist.age_trait = "Middle Aged"
        elseif colonist.traits.Child then
          colonist.age_trait = "Middle Aged"
        elseif colonist.traits.Adult then
          colonist.age_trait = "Middle Aged"
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetAgesToMiddleAged",
        "Colonists",
        "Time for the rat race",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetAgesToSenior = {
    menu = "Gameplay/Colonists/[1]Age/[4]Make all Colonists Senior",
    description = "Make all Colonists Senior age",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.Retiree then
          colonist.age_trait = "Senior"
        elseif colonist.traits.Youth then
          colonist.age_trait = "Senior"
        elseif colonist.traits.Adult then
          colonist.age_trait = "Senior"
        elseif colonist.traits.Child then
          colonist.age_trait = "Senior"
        elseif colonist.traits["Middle Aged"] then
          colonist.age_trait = "Senior"
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetAgesToSenior",
        "Colonists",
        "When you're (very much) young at heart",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetAgesToRetiree = {
    menu = "Gameplay/Colonists/[1]Age/[5]Make all Colonists Retirees",
    description = "Make all Colonists Retiree age",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        if colonist.traits.Senior then
          colonist.age_trait = "Retiree"
        elseif colonist.traits.Youth then
          colonist.age_trait = "Retiree"
        elseif colonist.traits.Adult then
          colonist.age_trait = "Retiree"
        elseif colonist.traits.Child then
          colonist.age_trait = "Retiree"
        elseif colonist.traits["Middle Aged"] then
          colonist.age_trait = "Retiree"
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetAgesToRetiree",
        "Colonists",
        "Time for some long pig",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSexOther = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Others",
    description = "Make all Colonist's sex Other",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.gender = "Other"
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSexOther",
        "Colonists",
        "Whole lotta nothing going on",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSexAndroid = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Androids",
    description = "Make all Colonist's sex Android",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.gender = "Android"
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSexAndroid",
        "Colonists",
        "Whole lotta nothing going on",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSexClone = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Clones",
    description = "Make all Colonist's sex Clone",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.gender = "Clone"
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSexClone",
        "Colonists",
        "Whole lotta nothing going on",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSexMale = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Male",
    description = "Make all Colonist's sex Male",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.gender = "Male"
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSexMale",
        "Colonists",
        "Gay ol' time",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsSetSexFemale = {
    menu = "Gameplay/Colonists/[2]Sex/Make all Colonists Female",
    description = "Make all Colonist's sex Female",
    action = function()
      for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
        colonist.gender = "Female"
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsSetSexFemale",
        "Colonists",
        "Gay ol' time",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ChanceOfSanityDamageNever = {
    menu = "Gameplay/Colonists/[3]Stats/Chance Of Sanity Damage Never",
    description = "Stops sanity damage from certain events.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.DustStormSanityDamage = 0
      Consts.MysteryDreamSanityDamage = 0
      Consts.ColdWaveSanityDamage = 0
      Consts.MeteorSanityDamage = 0
      ChoGGi.CheatMenuSettings["DustStormSanityDamage"] = Consts.DustStormSanityDamage
      ChoGGi.CheatMenuSettings["MysteryDreamSanityDamage"] = Consts.MysteryDreamSanityDamage
      ChoGGi.CheatMenuSettings["ColdWaveSanityDamage"] = Consts.ColdWaveSanityDamage
      ChoGGi.CheatMenuSettings["MeteorSanityDamage"] = Consts.MeteorSanityDamage
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChanceOfSanityDamageNever",
        "Colonists",
        "Ignorance is bliss",
        "UI/Icons/Notifications/dust_storm_2.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ChanceOfSanityDamageDefault = {
    menu = "Gameplay/Colonists/[3]Stats/Chance Of Sanity Damage Default",
    description = "Sanity damage on certain events.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.DustStormSanityDamage = 300
      Consts.MysteryDreamSanityDamage = 500
      Consts.ColdWaveSanityDamage = 300
      Consts.MeteorSanityDamage = 12000
      ChoGGi.CheatMenuSettings["DustStormSanityDamage"] = Consts.DustStormSanityDamage
      ChoGGi.CheatMenuSettings["MysteryDreamSanityDamage"] = Consts.MysteryDreamSanityDamage
      ChoGGi.CheatMenuSettings["ColdWaveSanityDamage"] = Consts.ColdWaveSanityDamage
      ChoGGi.CheatMenuSettings["MeteorSanityDamage"] = Consts.MeteorSanityDamage
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChanceOfSanityDamageDefault",
        "Colonists",
        "Ignorance is bliss",
        "UI/Icons/Notifications/dust_storm_2.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsChanceOfNegativeTraitNever = {
    menu = "Gameplay/Colonists/[4]Traits/Chance Of Negative Trait Never",
    description = "0% Chance of getting a negative trait when Sanity reaches zero.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.LowSanityNegativeTraitChance = 0
      ChoGGi.CheatMenuSettings["LowSanityNegativeTraitChance"] = Consts.LowSanityNegativeTraitChance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsChanceOfNegativeTraitNever",
        "Traits",
        "Stupid and happy",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsChanceOfNegativeTraitDefault = {
    menu = "Gameplay/Colonists/[4]Traits/Chance Of Negative Trait Default",
    description = "Default Chance of getting a negative trait when Sanity reaches zero.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      local TraitChance = 30
      if UICity:IsTechDiscovered("SupportiveCommunity") then
        TraitChance = 7.5
      end
      Consts.LowSanityNegativeTraitChance = TraitChance
      ChoGGi.CheatMenuSettings["LowSanityNegativeTraitChance"] = Consts.LowSanityNegativeTraitChance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsChanceOfNegativeTraitDefault",
        "Traits",
        "Stupid and happy",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsChanceOfSuicideNever = {
    menu = "Gameplay/Colonists/[3]Stats/Chance Of Suicide Never",
    description = "0% Chance of suicide when Sanity reaches zero.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.LowSanitySuicideChance = 0
      ChoGGi.CheatMenuSettings["LowSanitySuicideChance"] = Consts.LowSanitySuicideChance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsChanceOfSuicideNever",
        "Colonists",
        "Getting away ain't that easy",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsChanceOfSuicideDefault = {
    menu = "Gameplay/Colonists/[3]Stats/Chance Of Suicide Default",
    description = "Default Chance of suicide when Sanity reaches zero.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.LowSanitySuicideChance = 1
      ChoGGi.CheatMenuSettings["LowSanitySuicideChance"] = Consts.LowSanitySuicideChance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsChanceOfSuicideDefault",
        "Colonists",
        "Getting away is that easy",
        "UI/Icons/Sections/morale.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsWontSuffocate = {
    menu = "Gameplay/Colonists/[3]Stats/Colonists Won't Suffocate",
    description = "Only works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.OxygenMaxOutsideTime = 99999900
      ChoGGi.CheatMenuSettings["OxygenMaxOutsideTime"] = Consts.OxygenMaxOutsideTime
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsWontSuffocate",
        "Colonists",
        "Free Air",
        "UI/Icons/Sections/colonist.tga",
        --"UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsWillSuffocate = {
    menu = "Gameplay/Colonists/[3]Stats/Colonists Will Suffocate",
    description = "Only works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.OxygenMaxOutsideTime = 120000
      ChoGGi.CheatMenuSettings["OxygenMaxOutsideTime"] = Consts.OxygenMaxOutsideTime
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsWillSuffocate",
        "Colonists",
        "Free Air",
        "UI/Icons/Sections/colonist.tga",
        --"UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsWontStarve = {
    menu = "Gameplay/Colonists/[3]Stats/Colonists Won't Starve",
    description = "Only works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.TimeBeforeStarving = 99999900
      ChoGGi.CheatMenuSettings["TimeBeforeStarving"] = Consts.TimeBeforeStarving
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsWontStarve",
        "Colonists",
        "Free Food",
        "UI/Icons/Sections/Food_2.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsWillStarve = {
    menu = "Gameplay/Colonists/[3]Stats/Colonists Will Starve",
    description = "Only works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.TimeBeforeStarving = 1080000
      ChoGGi.CheatMenuSettings["TimeBeforeStarving"] = Consts.TimeBeforeStarving
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsWillStarve",
        "Colonists",
        "Free Food",
        "UI/Icons/Sections/Food_2.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_AvoidWorkplaceFalse = {
    menu = "Gameplay/Colonists/[5]Work/Colonists Avoid Fired Workplace False",
    description = "After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.AvoidWorkplaceSols = 0
      ChoGGi.CheatMenuSettings["AvoidWorkplaceSols"] = Consts.AvoidWorkplaceSols
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "AvoidWorkplaceFalse",
        "Colonists",
        "No Shame",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_AvoidWorkplaceDefault = {
    menu = "Gameplay/Colonists/[5]Work/Colonists Avoid Fired Workplace Default",
    description = "After being fired, Colonists will avoid that Workplace for 5 days when searching for a Workplace.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.AvoidWorkplaceSols = 5
      ChoGGi.CheatMenuSettings["AvoidWorkplaceSols"] = Consts.AvoidWorkplaceSols
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "AvoidWorkplaceDefault",
        "Colonists",
        "No Shame",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_PositivePlayground100 = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Playground 100%",
    description = "100% Chance to get a perk when grown if colonist has visited a playground as a child (or I broke it completely, testers?).",
    action = function()
      Consts.positive_playground_chance = 1000
      ChoGGi.CheatMenuSettings["positive_playground_chance"] = Consts.positive_playground_chance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "PositivePlayground100",
        "Traits",
        "We've all seen them, on the playground, at the store, walking on the streets.",
        "UI/Icons/Upgrades/home_collective_02.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_PositivePlaygroundDefault = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Playground Default",
    description = "Default Chance to get a perk when grown if colonist has visited a playground as a child.",
    action = function()
      Consts.positive_playground_chance = 100
      ChoGGi.CheatMenuSettings["positive_playground_chance"] = Consts.positive_playground_chance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "PositivePlaygroundDefault",
        "Traits",
        "We've all seen them, on the playground, at the store, walking on the streets.",
        "UI/Icons/Upgrades/home_collective_02.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ProjectMorpheusPositiveTrait100 = {
    menu = "Gameplay/Colonists/[4]Traits/Project Morpheus Positive Trait 100%",
    description = "100% Chance to get positive trait when Resting and ProjectMorpheus is active.",
    action = function()
      Consts.ProjectMorphiousPositiveTraitChance = 100
      ChoGGi.CheatMenuSettings["ProjectMorphiousPositiveTraitChance"] = Consts.ProjectMorphiousPositiveTraitChance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ProjectMorpheusPositiveTrait100",
        "Colonists",
        "red pill, blue pill, yada yada yada",
        "UI/Icons/Upgrades/rejuvenation_treatment_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ProjectMorpheusPositiveTraitDefault = {
    menu = "Gameplay/Colonists/[4]Traits/Project Morpheus Positive Trait Default",
    description = "Default Chance to get positive trait when Resting and ProjectMorpheus is active.",
    action = function()
      Consts.ProjectMorphiousPositiveTraitChance = 2
      ChoGGi.CheatMenuSettings["ProjectMorphiousPositiveTraitChance"] = Consts.ProjectMorphiousPositiveTraitChance
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ProjectMorpheusPositiveTraitDefault",
        "Colonists",
        "red pill, blue pill, yada yada yada",
        "UI/Icons/Upgrades/rejuvenation_treatment_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_PerformancePenaltyNonSpecialistNever = {
    menu = "Gameplay/Colonists/[5]Work/Performance Penalty Non-Specialist Never",
    description = "Performance penalty for non-Specialists = 0.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.NonSpecialistPerformancePenalty = 0
      --Consts.FounderPerformancePenalty = 0
      ChoGGi.CheatMenuSettings["NonSpecialistPerformancePenalty"] = Consts.NonSpecialistPerformancePenalty
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "PerformancePenaltyNonSpecialistNever",
        "Penalty",
        "You never know what you're gonna get.",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_PerformancePenaltyNonSpecialistDefault = {
    menu = "Gameplay/Colonists/[5]Work/Performance Penalty Non-Specialist Default",
    description = "Performance penalty for non-Specialists = 0.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      local PerformancePenalty = 50
      if UICity:IsTechDiscovered("GeneralTraining") then
        PerformancePenalty = 40
      end
      Consts.NonSpecialistPerformancePenalty = PerformancePenalty
      --Consts.FounderPerformancePenalty = 0
      ChoGGi.CheatMenuSettings["NonSpecialistPerformancePenalty"] = Consts.NonSpecialistPerformancePenalty
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "PerformancePenaltyNonSpecialistDefault",
        "Penalty",
        "You know what you're gonna get.",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_OutsideWorkplaceRadiusLarge = {
    menu = "Gameplay/Colonists/[5]Work/Outside Workplace Radius Large",
    description = "Colonists search 256 hexes outside their Dome when looking for a Workplace.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.DefaultOutsideWorkplacesRadius = 256
      ChoGGi.CheatMenuSettings["DefaultOutsideWorkplacesRadius"] = Consts.DefaultOutsideWorkplacesRadius
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "OutsideWorkplaceRadiusLarge",
        "Colonists",
        "Maybe tomorrow, IӬl find what I call home. Until tomorrow, you know Iӭ free to roam.",
        "UI/Icons/Sections/dome.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_OutsideWorkplaceRadiusDefault = {
    menu = "Gameplay/Colonists/[5]Work/Outside Workplace Radius Default",
    description = "Colonists search 10 hexes outside their Dome when looking for a Workplace.\nOnly works on colonists that have yet to spawn (maybe).",
    action = function()
      Consts.DefaultOutsideWorkplacesRadius = 10
      ChoGGi.CheatMenuSettings["DefaultOutsideWorkplacesRadius"] = Consts.DefaultOutsideWorkplacesRadius
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "OutsideWorkplaceRadiusDefault",
        "Colonists",
        "Maybe tomorrow, IӬl find what I call home. Until tomorrow, you know Iӭ free to roam.",
        "UI/Icons/Sections/dome.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_PositiveTraitsAddAll = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Traits Add All",
    description = "Add all Positive traits to colonists",
    action = function()
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
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "PositiveTraitsAddAll",
        "Traits",
        "Added All Positive Traits",
        "UI/Icons/Sections/traits.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_PositiveTraitsRemoveAll = {
    menu = "Gameplay/Colonists/[4]Traits/Positive Traits Remove All",
    description = "Remove all Positive traits from colonists",
    action = function()
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
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "PositiveTraitsRemoveAll",
        "Traits",
        "Added All Positive Traits",
        "UI/Icons/Sections/traits.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_NegativeTraitsRemoveAll = {
    menu = "Gameplay/Colonists/[4]Traits/Negative Traits Remove All",
    description = "Remove all negative traits from colonists",
    action = function()
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
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "NegativeTraitsRemoveAll",
        "Traits",
        "Removed All Negative Traits",
        "UI/Icons/Sections/traits.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_NegativeTraitsAddAll = {
    menu = "Gameplay/Colonists/[4]Traits/Negative Traits Add All",
    description = "Add all negative traits to colonists",
    action = function()
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
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "NegativeTraitsAddAll",
        "Traits",
        "Removed All Negative Traits",
        "UI/Icons/Sections/traits.tga",
        nil,
        {expiration=5000})
      )
    end
  },

})
