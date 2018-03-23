UserActions.AddActions({

    ["MaintenanceBuildingsFree"] = {

      menu = "Gameplay/Buildings/Maintenance Buildings Free",
      description = "Buildings don't get dusty",
      action = function()
        Consts.BuildingMaintenancePointsModifier = -100
        CheatMenuSettings["BuildingMaintenancePointsModifier"] = -100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "MaintenanceBuildingsFree",
          "Buildings",
          "The spice must flow!",
          "UI/Icons/Sections/dust.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["MaintenanceBuildingsDefault"] = {

      menu = "Gameplay/Buildings/Maintenance Buildings Default",
      description = "Buildings get dusty",
      action = function()
        local BuildingMaintenance = 100
        if UICity:IsTechDiscovered("HullPolarization") then
          BuildingMaintenance = 75
        end
        Consts.BuildingMaintenancePointsModifier = BuildingMaintenance
        CheatMenuSettings["BuildingMaintenancePointsModifier"] = BuildingMaintenance
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "MaintenanceBuildingsDefault",
          "Buildings",
          "The spice is flowing",
          "UI/Icons/Sections/dust.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["MoistureVaporatorPenaltyRemove"] = {

      menu = "Gameplay/Buildings/Moisture Vaporator Penalty Remove",
      description = "Remove penalty when Moisture Vaporators are close to each other.",
      action = function()
        const.MoistureVaporatorRange = 0
        const.MoistureVaporatorPenaltyPercent = 0
        CheatMenuSettings["MoistureVaporatorRange"] = 0
        CheatMenuSettings["MoistureVaporatorPenaltyPercent"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "MoistureVaporatorPenaltyRemove",
          "Buildings",
          "All right, pussy, pussy, pussy! Come on in pussy lovers! Here at the Titty Twister we're slashing pussy in half! Give us an offer on our vast selection of pussy, this is a pussy blow out! All right, we got white pussy, black pussy, Spanish pussy, yellow pussy, we got hot pussy, cold pussy, we got wet pussy, we got smelly pussy, we got hairy pussy, bloody pussy, we got snappin' pussy, we got silk pussy, velvet pussy, Naugahyde pussy, we even got horse pussy, dog pussy, chicken pussy! Come on, you want pussy, come on in, pussy lovers! If we don't got it, you don't want it! Come on in, pussy lovers!",
          "UI/Icons/Upgrades/zero_space_04.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["MoistureVaporatorPenaltyDefault"] = {

      menu = "Gameplay/Buildings/Moisture Vaporator Penalty Default",
      description = "Default penalty when Moisture Vaporators are close to each other.",
      action = function()
        const.MoistureVaporatorRange = 5
        const.MoistureVaporatorPenaltyPercent = 40
        CheatMenuSettings["MoistureVaporatorRange"] = 5
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "MoistureVaporatorPenaltyDefault",
          "Buildings",
          "All right, pussy, pussy, pussy! Come on in pussy lovers! Here at the Titty Twister we're slashing pussy in half! Give us an offer on our vast selection of pussy, this is a pussy blow out! All right, we got white pussy, black pussy, Spanish pussy, yellow pussy, we got hot pussy, cold pussy, we got wet pussy, we got smelly pussy, we got hairy pussy, bloody pussy, we got snappin' pussy, we got silk pussy, velvet pussy, Naugahyde pussy, we even got horse pussy, dog pussy, chicken pussy! Come on, you want pussy, come on in, pussy lovers! If we don't got it, you don't want it! Come on in, pussy lovers!",
          "UI/Icons/Upgrades/zero_space_04.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["ConstructionForFree"] = {

      menu = "Gameplay/Buildings/Construction For Free",
      description = "Build without resources.",
      action = function()
        Consts.Metals_cost_modifier = -100
        Consts.Metals_dome_cost_modifier = -100
        Consts.PreciousMetals_cost_modifier = -100
        Consts.PreciousMetals_dome_cost_modifier = -100
        Consts.Concrete_cost_modifier = -100
        Consts.Concrete_dome_cost_modifier = -100
        Consts.Polymers_cost_modifier = -100
        Consts.Polymers_dome_cost_modifier = -100
        Consts.Electronics_cost_modifier = -100
        Consts.Electronics_dome_cost_modifier = -100
        Consts.MachineParts_cost_modifier = -100
        Consts.MachineParts_dome_cost_modifier = -100
        Consts.rebuild_cost_modifier = -100
        CheatMenuSettings["Metals_cost_modifier"] = -100
        CheatMenuSettings["Metals_dome_cost_modifier"] = -100
        CheatMenuSettings["PreciousMetals_cost_modifier"] = -100
        CheatMenuSettings["PreciousMetals_dome_cost_modifier"] = -100
        CheatMenuSettings["Concrete_cost_modifier"] = -100
        CheatMenuSettings["Concrete_dome_cost_modifier"] = -100
        CheatMenuSettings["Polymers_cost_modifier"] = -100
        CheatMenuSettings["Polymers_dome_cost_modifier"] = -100
        CheatMenuSettings["Electronics_cost_modifier"] = -100
        CheatMenuSettings["Electronics_dome_cost_modifier"] = -100
        CheatMenuSettings["MachineParts_cost_modifier"] = -100
        CheatMenuSettings["MachineParts_dome_cost_modifier"] = -100
        CheatMenuSettings["rebuild_cost_modifier"] = -100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ConstructionForFree",
          "Buildings",
          "Get yourself a beautiful showhome (even if it'll fall apart after you move in)",
          "UI/Icons/Upgrades/build_2.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ConstructionForDefault"] = {

      menu = "Gameplay/Buildings/Construction For Default",
      description = "Build with resources.",
      action = function()
        Consts.Metals_cost_modifier = 0
        Consts.Metals_dome_cost_modifier = 0
        Consts.PreciousMetals_cost_modifier = 0
        Consts.PreciousMetals_dome_cost_modifier = 0
        Consts.Concrete_cost_modifier = 0
        Consts.Concrete_dome_cost_modifier = 0
        Consts.Polymers_dome_cost_modifier = 0
        Consts.Polymers_cost_modifier = 0
        Consts.Electronics_cost_modifier = 0
        Consts.Electronics_dome_cost_modifier = 0
        Consts.MachineParts_cost_modifier = 0
        Consts.MachineParts_dome_cost_modifier = 0
        Consts.rebuild_cost_modifier = 100
        CheatMenuSettings["Metals_cost_modifier"] = 0
        CheatMenuSettings["Metals_dome_cost_modifier"] = 0
        CheatMenuSettings["PreciousMetals_cost_modifier"] = 0
        CheatMenuSettings["PreciousMetals_dome_cost_modifier"] = 0
        CheatMenuSettings["Concrete_cost_modifier"] = 0
        CheatMenuSettings["Concrete_dome_cost_modifier"] = 0
        CheatMenuSettings["Polymers_cost_modifier"] = 0
        CheatMenuSettings["Polymers_dome_cost_modifier"] = 0
        CheatMenuSettings["Electronics_cost_modifier"] = 0
        CheatMenuSettings["Electronics_dome_cost_modifier"] = 0
        CheatMenuSettings["MachineParts_cost_modifier"] = 0
        CheatMenuSettings["MachineParts_dome_cost_modifier"] = 0
        CheatMenuSettings["rebuild_cost_modifier"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ConstructionForDefault",
          "Buildings",
          "Get yourself a beautiful showhome (even if it'll fall apart after you move in)",
          "UI/Icons/Upgrades/build_2.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["SpacingPipesPillarsMax"] = {

      menu = "Gameplay/Buildings/Spacing Pipes Pillars Max",
      description = "Only places Pillars at start and end (you'll need to redo existing).",
      action = function()
        Consts.PipesPillarSpacing = 1000
        CheatMenuSettings["PipesPillarSpacing"] = 1000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "SpacingPipesPillarsMax",
          "Buildings",
          "Is that a rocket in your pocket?",
          "UI/Icons/Sections/spaceship.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["SpacingPipesPillarsDefault"] = {

      menu = "Gameplay/Buildings/Spacing Pipes Pillars Default",
      description = "Default pillar placing.",
      action = function()
        Consts.PipesPillarSpacing = 4
        CheatMenuSettings["PipesPillarSpacing"] = 4
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "SpacingPipesPillarsDefault",
          "Buildings",
          "Is that a rocket in your pocket?",
          "UI/Icons/Sections/spaceship.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["BuildingDamageCrimeNever"] = {

      menu = "Gameplay/Buildings/Building Damage Crime Never",
      description = "Sets the amount to 0 for CrimeEventSabotageBuildingsCount and CrimeEventDestroyedBuildingsCount",
      action = function()
        Consts.CrimeEventSabotageBuildingsCount = 0
        Consts.CrimeEventDestroyedBuildingsCount = 0
        CheatMenuSettings["CrimeEventSabotageBuildingsCount"] = 0
        CheatMenuSettings["CrimeEventDestroyedBuildingsCount"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "BuildingDamageCrimeNever",
          "Buildings",
          "We were all feeling a bit shagged and fagged and fashed, it being a night of no small expenditure.",
          "UI/Icons/Notifications/fractured_dome.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["BuildingDamageCrimeDefault"] = {

      menu = "Gameplay/Buildings/Building Damage Crime Default",
      description = "Sets the amount to Default for CrimeEventSabotageBuildingsCount and CrimeEventDestroyedBuildingsCount",
      action = function()
        Consts.CrimeEventSabotageBuildingsCount = 1
        Consts.CrimeEventDestroyedBuildingsCount = 1
        CheatMenuSettings["CrimeEventSabotageBuildingsCount"] = 1
        CheatMenuSettings["CrimeEventDestroyedBuildingsCount"] = 1
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "BuildingDamageCrimeDefault",
          "Buildings",
          "We were all feeling a bit shagged and fagged and fashed, it being a night of no small expenditure.",
          "UI/Icons/Notifications/fractured_dome.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["InstantCablesAndPipes"] = {

      menu = "Gameplay/Buildings/Instant Cables And Pipes",
      description = "Cables and pipes are built instantly.",
      action = function()
        --[[
          Consts.InstantCables = 1
          Consts.InstantPipes = 1
          --]]
        GrantTech("SuperiorCables")
        GrantTech("SuperiorPipes")
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "InstantCablesAndPipes",
          "Buildings",
          "Got nuthin'",
          "UI/Icons/Notifications/timer.tga",
          nil,
          {expiration=5000})
        )
      end
    },

})
