UserActions.AddActions({

  ChoGGi_ResearchEveryBreakthrough = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[11]Research Every Breakthrough",
    description = "Research all Breakthroughs",
    action = function()
      GrantTech("ConstructionNanites")
      GrantTech("HullPolarization")
      GrantTech("ProjectPhoenix")
      GrantTech("SoylentGreen")
      GrantTech("NeuralEmpathy")
      GrantTech("RapidSleep")
      GrantTech("ThePositronicBrain")
      GrantTech("SafeMode")
      GrantTech("HiveMind")
      GrantTech("SpaceRehabilitation")
      GrantTech("WirelessPower")
      GrantTech("PrintedElectronics")
      GrantTech("CoreMetals")
      GrantTech("CoreWater")
      GrantTech("CoreRareMetals")
      GrantTech("SuperiorCables")
      GrantTech("SuperiorPipes")
      GrantTech("AlienImprints")
      GrantTech("NocturnalAdaptation")
      GrantTech("GeneSelection")
      GrantTech("MartianDiet")
      GrantTech("EternalFusion")
      GrantTech("SuperconductingComputing")
      GrantTech("NanoRefinement")
      GrantTech("ArtificialMuscles")
      GrantTech("InspiringArchitecture")
      GrantTech("GiantCrops")
      GrantTech("NeoConcrete")
      GrantTech("AdvancedDroneDrive")
      GrantTech("DryFarming")
      GrantTech("MartianSteel")
      GrantTech("VectorPump")
      GrantTech("Superfungus")
      GrantTech("HypersensitivePhotovoltaics")
      GrantTech("FrictionlessComposites")
      GrantTech("ZeroSpaceComputing")
      GrantTech("MultispiralArchitecture")
      GrantTech("MagneticExtraction")
      GrantTech("SustainedWorkload")
      GrantTech("ForeverYoung")
      GrantTech("MartianbornIngenuity")
      GrantTech("CryoSleep")
      GrantTech("Cloning")
      GrantTech("GoodVibrations")
      GrantTech("DomeStreamlining")
      GrantTech("PrefabCompression")
      GrantTech("ExtractorAI")
      GrantTech("ServiceBots")
      GrantTech("OverchargeAmplification")
      GrantTech("PlutoniumSynthesis")
      GrantTech("InterplanetaryLearning")
      GrantTech("Vocation-Oriented Society")
      GrantTech("PlasmaRocket")
      GrantTech("AutonomousHubs")
      GrantTech("FactoryAutomation")
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChoGGi_ResearchEveryBreakthrough",
        "Research",
        "Unleash your inner Black Monolith",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_UnlockEveryBreakthrough = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[12]Unlock Every Breakthrough",
    description = "Unlocks all Breakthroughs",
    action = function()
      DiscoverTech("ConstructionNanites")
      DiscoverTech("HullPolarization")
      DiscoverTech("ProjectPhoenix")
      DiscoverTech("SoylentGreen")
      DiscoverTech("NeuralEmpathy")
      DiscoverTech("RapidSleep")
      DiscoverTech("ThePositronicBrain")
      DiscoverTech("SafeMode")
      DiscoverTech("HiveMind")
      DiscoverTech("SpaceRehabilitation")
      DiscoverTech("WirelessPower")
      DiscoverTech("PrintedElectronics")
      DiscoverTech("CoreMetals")
      DiscoverTech("CoreWater")
      DiscoverTech("CoreRareMetals")
      DiscoverTech("SuperiorCables")
      DiscoverTech("SuperiorPipes")
      DiscoverTech("AlienImprints")
      DiscoverTech("NocturnalAdaptation")
      DiscoverTech("GeneSelection")
      DiscoverTech("MartianDiet")
      DiscoverTech("EternalFusion")
      DiscoverTech("SuperconductingComputing")
      DiscoverTech("NanoRefinement")
      DiscoverTech("ArtificialMuscles")
      DiscoverTech("InspiringArchitecture")
      DiscoverTech("GiantCrops")
      DiscoverTech("NeoConcrete")
      DiscoverTech("AdvancedDroneDrive")
      DiscoverTech("DryFarming")
      DiscoverTech("MartianSteel")
      DiscoverTech("VectorPump")
      DiscoverTech("Superfungus")
      DiscoverTech("HypersensitivePhotovoltaics")
      DiscoverTech("FrictionlessComposites")
      DiscoverTech("ZeroSpaceComputing")
      DiscoverTech("MultispiralArchitecture")
      DiscoverTech("MagneticExtraction")
      DiscoverTech("SustainedWorkload")
      DiscoverTech("ForeverYoung")
      DiscoverTech("MartianbornIngenuity")
      DiscoverTech("CryoSleep")
      DiscoverTech("Cloning")
      DiscoverTech("GoodVibrations")
      DiscoverTech("DomeStreamlining")
      DiscoverTech("PrefabCompression")
      DiscoverTech("ExtractorAI")
      DiscoverTech("ServiceBots")
      DiscoverTech("OverchargeAmplification")
      DiscoverTech("PlutoniumSynthesis")
      DiscoverTech("InterplanetaryLearning")
      DiscoverTech("Vocation-Oriented Society")
      DiscoverTech("PlasmaRocket")
      DiscoverTech("AutonomousHubs")
      DiscoverTech("FactoryAutomation")
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChoGGi_UnlockEveryBreakthrough",
        "Research",
        "Unleash your inner Black Monolith",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ResearchEveryMystery = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[13]Research Every Mystery",
    description = "Research all Mysteries",
    action = function()
      GrantTech("BlackCubesDisposal")
      GrantTech("AlienDiggersDestruction")
      GrantTech("AlienDiggersDetection")
      GrantTech("XenoExtraction")
      GrantTech("RegolithExtractor")
      GrantTech("PowerDecoy")
      GrantTech("Xeno-Terraforming")
      GrantTech("DreamSimulation")
      GrantTech("NumberSixTracing")
      GrantTech("DefenseTower")
      GrantTech("SolExploration")
      GrantTech("WildfireCure")
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChoGGi_ResearchEveryMystery",
        "Research",
        "Unleash your inner Black Cube Dome",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

})
