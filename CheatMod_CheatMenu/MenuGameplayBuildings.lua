UserActions.AddActions({

  ChoGGi_MaintenanceBuildingsFree = {
    menu = "Gameplay/Buildings/Maintenance Buildings Free",
    description = "Buildings don't get dusty",
    action = function()
      Consts.BuildingMaintenancePointsModifier = -100
      ChoGGi.CheatMenuSettings["BuildingMaintenancePointsModifier"] = Consts.BuildingMaintenancePointsModifier
      ChoGGi.WriteSettings()
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

  ChoGGi_MaintenanceBuildingsDefault = {
    menu = "Gameplay/Buildings/Maintenance Buildings Default",
    description = "Buildings get dusty",
    action = function()
      local BuildingMaintenance = 100
      if UICity:IsTechDiscovered("HullPolarization") then
        BuildingMaintenance = 75
      end
      Consts.BuildingMaintenancePointsModifier = BuildingMaintenance
      ChoGGi.CheatMenuSettings["BuildingMaintenancePointsModifier"] = Consts.BuildingMaintenancePointsModifier
      ChoGGi.WriteSettings()
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

  ChoGGi_MoistureVaporatorPenaltyRemove = {
    menu = "Gameplay/Buildings/Moisture Vaporator Penalty Remove",
    description = "Remove penalty when Moisture Vaporators are close to each other.",
    action = function()
      const.MoistureVaporatorRange = 0
      const.MoistureVaporatorPenaltyPercent = 0
      ChoGGi.CheatMenuSettings["MoistureVaporatorRange"] = const.MoistureVaporatorRange
      ChoGGi.CheatMenuSettings["MoistureVaporatorPenaltyPercent"] = const.MoistureVaporatorPenaltyPercent
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "MoistureVaporatorPenaltyRemove",
        "Buildings",
        "Here at the Titty Twister we're slashing pussy in half!",
        "UI/Icons/Upgrades/zero_space_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_MoistureVaporatorPenaltyDefault = {
    menu = "Gameplay/Buildings/Moisture Vaporator Penalty Default",
    description = "Default penalty when Moisture Vaporators are close to each other.",
    action = function()
      const.MoistureVaporatorRange = 5
      const.MoistureVaporatorPenaltyPercent = 40
      ChoGGi.CheatMenuSettings["MoistureVaporatorRange"] = const.MoistureVaporatorRange
      ChoGGi.CheatMenuSettings["MoistureVaporatorPenaltyPercent"] = const.MoistureVaporatorPenaltyPercent
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "MoistureVaporatorPenaltyDefault",
        "Buildings",
        "Here at the Titty Twister we're slashing pussy in half!",
        "UI/Icons/Upgrades/zero_space_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ConstructionForFree = {
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
      ChoGGi.CheatMenuSettings["Metals_cost_modifier"] = Consts.Metals_cost_modifier
      ChoGGi.CheatMenuSettings["Metals_dome_cost_modifier"] = Consts.Metals_dome_cost_modifier
      ChoGGi.CheatMenuSettings["PreciousMetals_cost_modifier"] = Consts.PreciousMetals_cost_modifier
      ChoGGi.CheatMenuSettings["PreciousMetals_dome_cost_modifier"] = Consts.PreciousMetals_dome_cost_modifier
      ChoGGi.CheatMenuSettings["Concrete_cost_modifier"] = Consts.Concrete_cost_modifier
      ChoGGi.CheatMenuSettings["Concrete_dome_cost_modifier"] = Consts.Concrete_dome_cost_modifier
      ChoGGi.CheatMenuSettings["Polymers_cost_modifier"] = Consts.Polymers_cost_modifier
      ChoGGi.CheatMenuSettings["Polymers_dome_cost_modifier"] = Consts.Polymers_dome_cost_modifier
      ChoGGi.CheatMenuSettings["Electronics_cost_modifier"] = Consts.Electronics_cost_modifier
      ChoGGi.CheatMenuSettings["Electronics_dome_cost_modifier"] = Consts.Electronics_dome_cost_modifier
      ChoGGi.CheatMenuSettings["MachineParts_cost_modifier"] = Consts.MachineParts_cost_modifier
      ChoGGi.CheatMenuSettings["MachineParts_dome_cost_modifier"] = Consts.MachineParts_dome_cost_modifier
      ChoGGi.CheatMenuSettings["rebuild_cost_modifier"] = Consts.rebuild_cost_modifier
      ChoGGi.WriteSettings()
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

  ChoGGi_ConstructionForDefault = {
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
      ChoGGi.CheatMenuSettings["Metals_cost_modifier"] = Consts.Metals_cost_modifier
      ChoGGi.CheatMenuSettings["Metals_dome_cost_modifier"] = Consts.Metals_dome_cost_modifier
      ChoGGi.CheatMenuSettings["PreciousMetals_cost_modifier"] = Consts.PreciousMetals_cost_modifier
      ChoGGi.CheatMenuSettings["PreciousMetals_dome_cost_modifier"] = Consts.PreciousMetals_dome_cost_modifier
      ChoGGi.CheatMenuSettings["Concrete_cost_modifier"] = Consts.Concrete_cost_modifier
      ChoGGi.CheatMenuSettings["Concrete_dome_cost_modifier"] = Consts.Concrete_dome_cost_modifier
      ChoGGi.CheatMenuSettings["Polymers_cost_modifier"] = Consts.Polymers_cost_modifier
      ChoGGi.CheatMenuSettings["Polymers_dome_cost_modifier"] = Consts.Polymers_dome_cost_modifier
      ChoGGi.CheatMenuSettings["Electronics_cost_modifier"] = Consts.Electronics_cost_modifier
      ChoGGi.CheatMenuSettings["Electronics_dome_cost_modifier"] = Consts.Electronics_dome_cost_modifier
      ChoGGi.CheatMenuSettings["MachineParts_cost_modifier"] = Consts.MachineParts_cost_modifier
      ChoGGi.CheatMenuSettings["MachineParts_dome_cost_modifier"] = Consts.MachineParts_dome_cost_modifier
      ChoGGi.CheatMenuSettings["rebuild_cost_modifier"] = Consts.rebuild_cost_modifier
      ChoGGi.WriteSettings()
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

  ChoGGi_SpacingPipesPillarsMax = {
    menu = "Gameplay/Buildings/Spacing Pipes Pillars Max",
    description = "Only places Pillars at start and end (you'll need to redo existing).",
    action = function()
      Consts.PipesPillarSpacing = 1000
      ChoGGi.CheatMenuSettings["PipesPillarSpacing"] = Consts.PipesPillarSpacing
      ChoGGi.WriteSettings()
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

  ChoGGi_SpacingPipesPillarsDefault = {
    menu = "Gameplay/Buildings/Spacing Pipes Pillars Default",
    description = "Default pillar placing.",
    action = function()
      Consts.PipesPillarSpacing = 4
      ChoGGi.CheatMenuSettings["PipesPillarSpacing"] = Consts.PipesPillarSpacing
      ChoGGi.WriteSettings()
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

  ChoGGi_BuildingDamageCrimeNever = {
    menu = "Gameplay/Buildings/Building Damage Crime Never",
    description = "Sets the amount to 0 for CrimeEventSabotageBuildingsCount and CrimeEventDestroyedBuildingsCount",
    action = function()
      Consts.CrimeEventSabotageBuildingsCount = 0
      Consts.CrimeEventDestroyedBuildingsCount = 0
      ChoGGi.CheatMenuSettings["CrimeEventSabotageBuildingsCount"] = Consts.CrimeEventSabotageBuildingsCount
      ChoGGi.CheatMenuSettings["CrimeEventDestroyedBuildingsCount"] = Consts.CrimeEventDestroyedBuildingsCount
      ChoGGi.WriteSettings()
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

  ChoGGi_BuildingDamageCrimeDefault = {
    menu = "Gameplay/Buildings/Building Damage Crime Default",
    description = "Sets the amount to Default for CrimeEventSabotageBuildingsCount and CrimeEventDestroyedBuildingsCount",
    action = function()
      Consts.CrimeEventSabotageBuildingsCount = 1
      Consts.CrimeEventDestroyedBuildingsCount = 1
      ChoGGi.CheatMenuSettings["CrimeEventSabotageBuildingsCount"] = Consts.CrimeEventSabotageBuildingsCount
      ChoGGi.CheatMenuSettings["CrimeEventDestroyedBuildingsCount"] = Consts.CrimeEventDestroyedBuildingsCount
      ChoGGi.WriteSettings()
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

  ChoGGi_CablesAndPipesInstant = {
    menu = "Gameplay/Buildings/Cables And Pipes Instant",
    description = "Cables and pipes are built instantly.",
    action = function()
      --GrantTech("SuperiorCables")
      --GrantTech("SuperiorPipes")
      Consts.InstantCables = 1
      Consts.InstantPipes = 1
      ChoGGi.CheatMenuSettings["SuperiorCables"] = Consts.InstantCables
      ChoGGi.CheatMenuSettings["SuperiorPipes"] = Consts.InstantPipes
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "CablesAndPipesInstant",
        "Buildings",
        "Got nuthin'",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_CablesAndPipesDefault = {
    menu = "Gameplay/Buildings/Cables And Pipes Default",
    description = "Cables and pipes are built Defaultly.",
    action = function()
      Consts.InstantCables = 0
      Consts.InstantPipes = 0
      ChoGGi.CheatMenuSettings["SuperiorCables"] = Consts.InstantCables
      ChoGGi.CheatMenuSettings["SuperiorPipes"] = Consts.InstantPipes
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "CablesAndPipesDefault",
        "Buildings",
        "Got nuthin'",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },


})
