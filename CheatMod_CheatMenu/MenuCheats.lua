UserActions.AddActions({

  ToggleCheatsMenu = {
    key = "F2",
    action = function()
      UAMenu.ToggleOpen()
      -- Also toggle the infopanel cheats to show/hide with the menu
      config.BuildingInfopanelCheats = not not dlgUAMenu
      ReopenSelectionXInfopanel()
    end
  },
  Console1 = {
    key = "Alt-Enter",
    action = function()
      ShowConsole(true)
    end
  },
  NewGameMenuitem2 = {
    menu = "Cheats/[06]^ WARNING ^",
    description = "WARNING: SAVE YOUR GAME",
    action = function()
    end
  },
  EditorMenuitem = {
    menu = "Cheats/[14]^ WARNING ^",
    description = "WARNING: SAVE YOUR GAME",
    action = function()
    end
  },
  AboutCheatsMenu = {
    menu = "[998]Help/[1]About",
    action = function()
      CreateRealTimeThread(WaitCustomPopupNotification,
        "About Cheats",
        "This mod enables the built-in cheats menu. Take a look at the mod code to see how to add additional menus and menu items like this about dialog.",
        { "OK" }
      )
    end
  },
  DE_HexBuildGridToggle = {
    description = "Toggle Hex Build Grid Visibility",
    menu = "[102]Debug/[09]Toggle Hex Build Grid Visibility",
    action = function()
      debug_build_grid()
    end
  },
  DE_ToggleTerrainDepositGrid = {
    description = "Toggle Terrain Deposit Grid",
    menu = "[102]Debug/[10]Toggle Terrain Deposit Grid",
    action = function()
      ToggleTerrainDepositGrid()
    end
  },
  DE_Toolbar = {
    description = "Show/Hide the User Actions toolbar",
    menu = "[102]Debug/[11]Toggle Terrain Deposit Grid",
    action = function()
      GetToolbar():Toggle()
      ToggleSidebar()
      ToggleEditorStatusbar()
    end
  },
  DE_Toggle = {
    description = "Toggle developer mode",
    menu = "[102]Debug/[12]Toggle developer mode",
    action = function()
      Platform.developer = not Platform.developer
      CheatMenuSettings["developer"] = Platform.developer
      WriteSettings()
      CreateRealTimeThread(WaitCustomPopupNotification,
        "Toggles Dev mode",
        "This Adds more menuitems, but it'll change a bunch of labels to *stripped*, and some shortcut keys don't work\r\nrestart to take effect.",
        { "OK" }
      )
    end
  },

  ["ResearchAllBreakthroughs"] = {
    menu = "Cheats/[04]Research/[11]Research All Breakthroughs",
    description = "Research every Breakthrough",
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
        "ResearchAllBreakthroughs",
        "Research",
        "Unleash your inner Black Monolith",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },
  ["UnlockAllBreakthroughs"] = {

    menu = "Cheats/[04]Research/[12]Unlock All Breakthroughs",
    description = "Unlock every Breakthrough",
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
        "UnlockAllBreakthroughs",
        "Research",
        "Unleash your inner Black Monolith",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ["ResearchAllMysteries"] = {

    menu = "Cheats/[04]Research/[13]Research All Mysteries",
    description = "Research every Mystery",
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
        "ResearchAllMysteries",
        "Research",
        "Unleash your inner Black Cube Dome",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

})
