UserActions.AddActions({

    ["ColonistsAddSpecializationToAll"] = {

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

    ["MinComfortBirthZero"] = {

      menu = "Gameplay/Colonists/[3]Stats/Min Comfort Birth 0",
      description = "No lower limit on birthing comfort",
      action = function()
        Consts.MinComfortBirth = 0
        CheatMenuSettings["MinComfortBirth"] = 0
        WriteSettings()
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
    ["MinComfortBirthDefault"] = {

      menu = "Gameplay/Colonists/[3]Stats/Min Comfort Birth Default",
      description = "Default limit on birthing comfort",
      action = function()
        Consts.MinComfortBirth = 70000
        CheatMenuSettings["MinComfortBirth"] = 70000
        WriteSettings()
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

    ["VisitFailPenaltyZero"] = {

      menu = "Gameplay/Colonists/[3]Stats/Visit Fail Penalty 0",
      description = "0 Comfort penalty when failing to satisfy a need via a visit",
      action = function()
        Consts.VisitFailPenalty = 0
        CheatMenuSettings["VisitFailPenalty"] = 0
        WriteSettings()
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
    ["VisitFailPenaltyDefault"] = {

      menu = "Gameplay/Colonists/[3]Stats/Visit Fail Penalty Default",
      description = "Default Comfort penalty when failing to satisfy a need via a visit",
      action = function()
        Consts.VisitFailPenalty = 10000
        CheatMenuSettings["VisitFailPenalty"] = 10000
        WriteSettings()
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

    ["RenegadeCreationStop"] = {

      menu = "Gameplay/Colonists/[5]Work/Renegade Creation Stop",
      description = "Stops renegades from being converted",
      action = function()
        Consts.RenegadeCreation = 9999900
        CheatMenuSettings["RenegadeCreation"] = 9999900
        WriteSettings()
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
    ["RenegadeCreationDefault"] = {

      menu = "Gameplay/Colonists/[5]Work/Renegade Creation Default",
      description = "Doesn't stop renegades from being converted",
      action = function()
        Consts.RenegadeCreation = 70000
        CheatMenuSettings["RenegadeCreation"] = 70000
        WriteSettings()
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

    ["ColonistsMoraleMaxAlways"] = {

      menu = "Gameplay/Colonists/[3]Stats/Morale Max Always",
      description = "Colonists always have max morale.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.HighStatLevel = -100
        Consts.HighStatMoraleEffect = 999900
        Consts.LowStatLevel = -100
        CheatMenuSettings["HighStatLevel"] = -100
        CheatMenuSettings["HighStatMoraleEffect"] = 999900
        CheatMenuSettings["LowStatLevel"] = -100
        WriteSettings()
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
    ["ColonistsMoraleMaxDefault"] = {

      menu = "Gameplay/Colonists/[3]Stats/Morale Default",
      description = "Colonists morale Default.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.HighStatLevel = 70000
        Consts.HighStatMoraleEffect = 5000
        Consts.LowStatLevel = 30000
        CheatMenuSettings["HighStatLevel"] = 70000
        CheatMenuSettings["HighStatMoraleEffect"] = 5000
        CheatMenuSettings["LowStatLevel"] = 30000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsMoraleMaxDefault",
          "Colonists",
          "Happy as a pig in shit",
          "UI/Icons/Sections/morale.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["ColonistsSetMorale100"] = {

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
    ["ColonistsSetSanityMax"] = {

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
    ["ColonistsSetSanity100"] = {

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
    ["ColonistsSetComfortMax"] = {

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
    ["ColonistsSetComfort100"] = {

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
    ["ColonistsSetHealthMax"] = {

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
    ["ColonistsSetHealth100"] = {

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

    ["ColonistsSetAgesToChild"] = {

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
    ["ColonistsSetAgesToYouth"] = {

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
    ["ColonistsSetAgesToAdult"] = {

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
    ["ColonistsSetAgesToMiddleAged"] = {

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
    ["ColonistsSetAgesToSenior"] = {

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
    ["ColonistsSetAgesToRetiree"] = {

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
    ["ColonistsSetSexOther"] = {

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
    ["ColonistsSetSexAndroid"] = {

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
    ["ColonistsSetSexClone"] = {

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

    ["ColonistsSetSexMale"] = {

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
    ["ColonistsSetSexFemale"] = {

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

    ["ChanceOfSanityDamageNever"] = {

      menu = "Gameplay/Colonists/[3]Stats/Chance Of Sanity Damage Never",
      description = "Stops sanity damage from certain events.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.DustStormSanityDamage = 0
        Consts.MysteryDreamSanityDamage = 0
        Consts.ColdWaveSanityDamage = 0
        Consts.MeteorSanityDamage = 0
        CheatMenuSettings["DustStormSanityDamage"] = 0
        CheatMenuSettings["MysteryDreamSanityDamage"] = 0
        CheatMenuSettings["ColdWaveSanityDamage"] = 0
        CheatMenuSettings["MeteorSanityDamage"] = 0
        WriteSettings()
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
    ["ChanceOfSanityDamageDefault"] = {

      menu = "Gameplay/Colonists/[3]Stats/Chance Of Sanity Damage Default",
      description = "Sanity damage on certain events.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.DustStormSanityDamage = 300
        Consts.MysteryDreamSanityDamage = 500
        Consts.ColdWaveSanityDamage = 300
        Consts.MeteorSanityDamage = 12000
        CheatMenuSettings["DustStormSanityDamage"] = 300
        CheatMenuSettings["MysteryDreamSanityDamage"] = 500
        CheatMenuSettings["ColdWaveSanityDamage"] = 300
        CheatMenuSettings["MeteorSanityDamage"] = 12000
        WriteSettings()
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

    ["ColonistsChanceOfNegativeTraitNever"] = {

      menu = "Gameplay/Colonists/[4]Traits/Chance Of Negative Trait Never",
      description = "0% Chance of getting a negative trait when Sanity reaches zero.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.LowSanityNegativeTraitChance = 0
        CheatMenuSettings["LowSanityNegativeTraitChance"] = 0
        WriteSettings()
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
    ["ColonistsChanceOfNegativeTraitDefault"] = {

      menu = "Gameplay/Colonists/[4]Traits/Chance Of Negative Trait Default",
      description = "Default Chance of getting a negative trait when Sanity reaches zero.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        local TraitChance = 30
        if UICity:IsTechDiscovered("SupportiveCommunity") then
          TraitChance = 7.5
        end
        Consts.LowSanityNegativeTraitChance = TraitChance
        CheatMenuSettings["LowSanityNegativeTraitChance"] = TraitChance
        WriteSettings()
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
    ["ColonistsChanceOfSuicideNever"] = {

      menu = "Gameplay/Colonists/[3]Stats/Chance Of Suicide Never",
      description = "0% Chance of suicide when Sanity reaches zero.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.LowSanitySuicideChance = 0
        CheatMenuSettings["LowSanitySuicideChance"] = 0
        WriteSettings()
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
    ["ColonistsChanceOfSuicideDefault"] = {

      menu = "Gameplay/Colonists/[3]Stats/Chance Of Suicide Default",
      description = "Default Chance of suicide when Sanity reaches zero.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.LowSanitySuicideChance = 1
        CheatMenuSettings["LowSanitySuicideChance"] = 1
        WriteSettings()
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

    ["ColonistsWontSuffocate"] = {

      menu = "Gameplay/Colonists/[3]Stats/Colonists Won't Suffocate",
      description = "Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.OxygenMaxOutsideTime = 99999900
        CheatMenuSettings["OxygenMaxOutsideTime"] = 99999900
        WriteSettings()
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
    ["ColonistsWillSuffocate"] = {

      menu = "Gameplay/Colonists/[3]Stats/Colonists Will Suffocate",
      description = "Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.OxygenMaxOutsideTime = 120000
        CheatMenuSettings["OxygenMaxOutsideTime"] = 120000
        WriteSettings()
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
    ["ColonistsWontStarve"] = {

      menu = "Gameplay/Colonists/[3]Stats/Colonists Won't Starve",
      description = "Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.TimeBeforeStarving = 99999900
        CheatMenuSettings["TimeBeforeStarving"] = 99999900
        WriteSettings()
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
    ["ColonistsWillStarve"] = {

      menu = "Gameplay/Colonists/[3]Stats/Colonists Will Starve",
      description = "Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.TimeBeforeStarving = 1080000
        CheatMenuSettings["TimeBeforeStarving"] = 1080000
        WriteSettings()
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

    ["AvoidWorkplaceFalse"] = {

      menu = "Gameplay/Colonists/[5]Work/Colonists Avoid Fired Workplace False",
      description = "After being fired, Colonists won't avoid that Workplace searching for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.AvoidWorkplaceSols = 0
        CheatMenuSettings["AvoidWorkplaceSols"] = 0
        WriteSettings()
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
    ["AvoidWorkplaceDefault"] = {

      menu = "Gameplay/Colonists/[5]Work/Colonists Avoid Fired Workplace Default",
      description = "After being fired, Colonists will avoid that Workplace for 5 days when searching for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.AvoidWorkplaceSols = 5
        CheatMenuSettings["AvoidWorkplaceSols"] = 5
        WriteSettings()
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

    ["PositivePlayground100"] = {
      menu = "Gameplay/Colonists/[4]Traits/Positive Playground 100%",
      description = "100% Chance to get a perk when grown if colonist has visited a playground as a child.",
      action = function()
        Consts.positive_playground_chance = 1000
        CheatMenuSettings["positive_playground_chance"] = 1000
        WriteSettings()
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
    ["PositivePlaygroundDefault"] = {
      menu = "Gameplay/Colonists/[4]Traits/Positive Playground Default",
      description = "Default Chance to get a perk when grown if colonist has visited a playground as a child.",
      action = function()
        Consts.positive_playground_chance = 100
        CheatMenuSettings["positive_playground_chance"] = 100
        WriteSettings()
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
    ["ProjectMorpheusPositiveTrait100"] = {

      menu = "Gameplay/Colonists/[4]Traits/Project Morpheus Positive Trait 100%",
      description = "100% Chance to get positive trait when Resting and ProjectMorpheus is active.",
      action = function()
        Consts.ProjectMorphiousPositiveTraitChance = 100
        CheatMenuSettings["ProjectMorphiousPositiveTraitChance"] = 100
        WriteSettings()
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
    ["ProjectMorpheusPositiveTraitDefault"] = {

      menu = "Gameplay/Colonists/[4]Traits/Project Morpheus Positive Trait Default",
      description = "Default Chance to get positive trait when Resting and ProjectMorpheus is active.",
      action = function()
        Consts.ProjectMorphiousPositiveTraitChance = 2
        CheatMenuSettings["ProjectMorphiousPositiveTraitChance"] = 2
        WriteSettings()
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
    ["PerformancePenaltyNonSpecialistNever"] = {

      menu = "Gameplay/Colonists/[5]Work/Performance Penalty Non-Specialist Never",
      description = "Performance penalty for non-Specialists = 0.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.NonSpecialistPerformancePenalty = 0
        --Consts.FounderPerformancePenalty = 0
        CheatMenuSettings["NonSpecialistPerformancePenalty"] = 0
        WriteSettings()
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
    ["PerformancePenaltyNonSpecialistDefault"] = {

      menu = "Gameplay/Colonists/[5]Work/Performance Penalty Non-Specialist Default",
      description = "Performance penalty for non-Specialists = 0.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        local PerformancePenalty = 50
        if UICity:IsTechDiscovered("GeneralTraining") then
          PerformancePenalty = 40
        end
        Consts.NonSpecialistPerformancePenalty = PerformancePenalty
        --Consts.FounderPerformancePenalty = 0
        CheatMenuSettings["NonSpecialistPerformancePenalty"] = PerformancePenalty
        WriteSettings()
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
    ["OutsideWorkplaceRadiusLarge"] = {
      menu = "Gameplay/Colonists/[5]Work/Outside Workplace Radius Large",
      description = "Colonists search 256 hexes outside their Dome when looking for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.DefaultOutsideWorkplacesRadius = 256
        CheatMenuSettings["DefaultOutsideWorkplacesRadius"] = 256
        WriteSettings()
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
    ["OutsideWorkplaceRadiusDefault"] = {
      menu = "Gameplay/Colonists/[5]Work/Outside Workplace Radius Default",
      description = "Colonists search 10 hexes outside their Dome when looking for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.DefaultOutsideWorkplacesRadius = 10
        CheatMenuSettings["DefaultOutsideWorkplacesRadius"] = 10
        WriteSettings()
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

    ["PositiveTraitsAddAll"] = {
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
    ["PositiveTraitsRemoveAll"] = {
      menu = "Gameplay/Colonists/[4]Traits/Positive Traits Remove All",
      description = "Remove all Positive traits from colonists",
      action = function()
        --CountColonistsWithTrait(trait)
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

    ["NegativeTraitsRemoveAll"] = {
      menu = "Gameplay/Colonists/[4]Traits/Negative Traits Remove All",
      description = "Remove all negative traits from colonists",
      action = function()
        --CountColonistsWithTrait(trait)
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
    ["NegativeTraitsAddAll"] = {
      menu = "Gameplay/Colonists/[4]Traits/Negative Traits Add All",
      description = "Add all negative traits to colonists",
      action = function()
        --CountColonistsWithTrait(trait)
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
