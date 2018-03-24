UserActions.AddActions({

  ChoGGi_ResearchQueueLarger = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Research Queue Larger",
    description = "Add up to 25 items to queue.",
    action = function()
      const.ResearchQueueSize = 25
      ChoGGi.CheatMenuSettings["ResearchQueueSize"] = const.ResearchQueueSize
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ResearchQueueLarger",
        "Research",
        "Nerdgasm",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ResearchQueueDefault = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Research Queue Default",
    description = "Add up to 4 items to queue.",
    action = function()
      const.ResearchQueueSize = 4
      ChoGGi.CheatMenuSettings["ResearchQueueSize"] = const.ResearchQueueSize
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ResearchQueueDefault",
        "Research",
        "Awww",
        "UI/Icons/Notifications/research.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_OutsourcingFree = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Outsourcing Free",
    description = "Outsourcing is free to purchase (over n over).",
    action = function()
      Consts.OutsourceResearchCost = 0
      ChoGGi.CheatMenuSettings["OutsourceResearchCost"] = Consts.OutsourceResearchCost
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "OutsourcingFree",
        "Research",
        "Best hope you picked India as your Mars sponsor",
        "UI/Icons/Sections/research_1.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_OutsourcingDefault = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Outsourcing Default",
    description = "Outsourcing is the usual cost.",
    action = function()
      Consts.OutsourceResearchCost = 200000000
      ChoGGi.CheatMenuSettings["OutsourceResearchCost"] = Consts.OutsourceResearchCost
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "OutsourcingDefault",
        "Research",
        "Default Outsourcing",
        "UI/Icons/Sections/research_1.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_OutsourcePoints1000000 = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Outsource Points (1,000,000)",
    description = "Gives a crapload of research points (almost instant research)",
    action = function()
      Consts.OutsourceResearch = 9999900
      ChoGGi.CheatMenuSettings["OutsourceResearch"] = Consts.OutsourceResearch
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "OutsourcePoints1000000",
        "Research",
        "The same thing we do every night, Pinky - try to take over the world!",
        "UI/Icons/Upgrades/eternal_fusion_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_OutsourcePointsDefault = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Outsource Points Default",
    description = "Gives regular amount of research points",
    action = function()
      Consts.OutsourceResearch = 1000
      ChoGGi.CheatMenuSettings["OutsourceResearch"] = Consts.OutsourceResearch
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "OutsourcePointsDefault",
        "Research",
        "The same thing we do every night, Pinky - try to take over the world!",
        "UI/Icons/Upgrades/eternal_fusion_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_GameSpeedDefault = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[1]GameSpeed Default",
    description = "Default speed",
    action = function()
      const.mediumGameSpeed = 3
      const.fastGameSpeed = 5
      ChoGGi.CheatMenuSettings["mediumGameSpeed"] = const.mediumGameSpeed
      ChoGGi.CheatMenuSettings["fastGameSpeed"] = const.fastGameSpeed
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "GameSpeedDefault",
        "Speed",
        "I think I can",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_GameSpeedDouble = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[2]GameSpeed Double",
    description = "Doubles the speed of the game (at medium/fast)",
    action = function()
      const.mediumGameSpeed = 6
      const.fastGameSpeed = 10
      ChoGGi.CheatMenuSettings["mediumGameSpeed"] = const.mediumGameSpeed
      ChoGGi.CheatMenuSettings["fastGameSpeed"] = const.fastGameSpeed
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "GameSpeedDouble",
        "Speed",
        "ndale! ndale! rriba! rriba! pa! pa! pa! Yeehaw!",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_GameSpeedTriple = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[3]GameSpeed Triple",
    description = "Triples the speed of the game (at medium/fast)",
    action = function()
      const.mediumGameSpeed = 9
      const.fastGameSpeed = 15
      ChoGGi.CheatMenuSettings["mediumGameSpeed"] = const.mediumGameSpeed
      ChoGGi.CheatMenuSettings["fastGameSpeed"] = const.fastGameSpeed
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "GameSpeedTriple",
        "Speed",
        "Bugatti Veyron",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_GameSpeedQuad = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[4]GameSpeed Quad",
    description = "Quadruples the speed of the game (at medium/fast)",
    action = function()
      const.mediumGameSpeed = 12
      const.fastGameSpeed = 20
      ChoGGi.CheatMenuSettings["mediumGameSpeed"] = const.mediumGameSpeed
      ChoGGi.CheatMenuSettings["fastGameSpeed"] = const.fastGameSpeed
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "GameSpeedQuad",
        "Speed",
        "Bugatti Chiron",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_DeepScanEnable = {
    icon = "change_height_down.tga",
    menu = "Gameplay/Scan/Deep Scan Enable",
    description = "Enable deep scan and make deep resources exploitable. Also deep scanning probes.",
    action = function()
      Consts.DeepScanAvailable = 1
      Consts.IsDeepWaterExploitable = 1
      Consts.IsDeepMetalsExploitable = 1
      Consts.IsDeepPreciousMetalsExploitable = 1
      ChoGGi.CheatMenuSettings["DeepScanAvailable"] = Consts.DeepScanAvailable
      ChoGGi.CheatMenuSettings["IsDeepWaterExploitable"] = Consts.IsDeepWaterExploitable
      ChoGGi.CheatMenuSettings["IsDeepMetalsExploitable"] = Consts.IsDeepMetalsExploitable
      ChoGGi.CheatMenuSettings["IsDeepPreciousMetalsExploitable"] = Consts.IsDeepPreciousMetalsExploitable
      ChoGGi.WriteSettings()
      --GrantTech("AdaptedProbes")
      --GrantTech("DeepScanning")
      --GrantTech("DeepWaterExtraction")
      --GrantTech("DeepMetalExtraction")
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChoGGi_DeepScanEnable",
        "Scan",
        "Down the rabbit hole",
        "UI/Icons/Notifications/scan.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_DeepScanDisable = {
    icon = "change_height_up.tga",
    menu = "Gameplay/Scan/Deep Scan Disable",
    description = "Enable deep scan and make deep resources exploitable. Also deep scanning probes.",
    action = function()
      Consts.DeepScanAvailable = 0
      Consts.IsDeepWaterExploitable = 0
      Consts.IsDeepMetalsExploitable = 0
      Consts.IsDeepPreciousMetalsExploitable = 0
      ChoGGi.CheatMenuSettings["DeepScanAvailable"] = Consts.DeepScanAvailable
      ChoGGi.CheatMenuSettings["IsDeepWaterExploitable"] = Consts.IsDeepWaterExploitable
      ChoGGi.CheatMenuSettings["IsDeepMetalsExploitable"] = Consts.IsDeepMetalsExploitable
      ChoGGi.CheatMenuSettings["IsDeepPreciousMetalsExploitable"] = Consts.IsDeepPreciousMetalsExploitable
      ChoGGi.WriteSettings()
      --GrantTech("AdaptedProbes")
      --GrantTech("DeepScanning")
      --GrantTech("DeepWaterExtraction")
      --GrantTech("DeepMetalExtraction")
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChoGGi_DeepScanDisable",
        "Scan",
        "Down the rabbit hole",
        "UI/Icons/Notifications/scan.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_DeeperScanEnable = {
    icon = "change_height_down.tga",
    menu = "Gameplay/Scan/Deeper Scan Enable",
    description = "Uncovers extremely rich underground deposits",
    action = function()
      GrantTech("CoreMetals")
      GrantTech("CoreWater")
      GrantTech("CoreRareMetals")
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ChoGGi_DeeperScanEnable",
        "Scan",
        "Further down the rabbit hole",
        "UI/Icons/Notifications/scan.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ScannerQueueLarger = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Scan/Scanner Queue Larger",
    description = "Queue up to 100 squares instead of 5",
    action = function()
      const.ExplorationQueueMaxSize = 100
      ChoGGi.CheatMenuSettings["ExplorationQueueMaxSize"] = const.ExplorationQueueMaxSize
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ScannerQueueLarger",
        "Scan",
        "5 scans at a time...bulldiddy",
        "UI/Icons/Notifications/scan.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ScannerQueueDefault = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Scan/Scanner Queue Default",
    description = "Queue up to 5",
    action = function()
      const.ExplorationQueueMaxSize = 5
      ChoGGi.CheatMenuSettings["ExplorationQueueMaxSize"] = const.ExplorationQueueMaxSize
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ScannerQueueDefault",
        "Scan",
        "5 scans at a time...bulldiddy",
        "UI/Icons/Notifications/scan.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_MeteorHealthDamageZero = {
    menu = "Gameplay/Meteors/Damage = 0",
    description = "Stops Meteor damage (not sure to what)",
    action = function()
      Consts.MeteorHealthDamage = 0
      ChoGGi.CheatMenuSettings["MeteorHealthDamage"] = Consts.MeteorHealthDamage
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "MeteorHealthDamageZero",
        "Colonists",
        "Sticks and stones",
        "UI/Icons/Notifications/meteor_storm.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_MeteorHealthDamageDefault = {
    menu = "Gameplay/Meteors/Damage = Default",
    description = "Default Meteor damage",
    action = function()
      Consts.MeteorHealthDamage = 50000
      ChoGGi.CheatMenuSettings["MeteorHealthDamage"] = Consts.MeteorHealthDamage
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "MeteorHealthDamageDefault",
        "Colonists",
        "Take cover!",
        "UI/Icons/Notifications/meteor_storm.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsPerRocketIncrease = {
    menu = "Gameplay/Rocket/Colonists Per Rocket + 25",
    description = function()
      return Consts.MaxColonistsPerRocket .. " + 25 colonists can arrive on Mars in a single Rocket."
    end,
    action = function()
      Consts.MaxColonistsPerRocket = Consts.MaxColonistsPerRocket + 25
      ChoGGi.CheatMenuSettings["MaxColonistsPerRocket"] = Consts.MaxColonistsPerRocket
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsPerRocketIncrease",
        "Rocket",
        "Long pig sardines",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_ColonistsPerRocketDefault = {
    menu = "Gameplay/Rocket/Colonists Per Rocket Default",
    description = "Default colonists can arrive on Mars in a single Rocket.",
    action = function()
      local PerRocket = 12
      if UICity:IsTechDiscovered("CompactPassengerModule") then
        PerRocket = PerRocket + 10
      end
      if UICity:IsTechDiscovered("CryoSleep") then
        PerRocket = PerRocket + 20
      end
      Consts.MaxColonistsPerRocket = PerRocket
      ChoGGi.CheatMenuSettings["MaxColonistsPerRocket"] = Consts.MaxColonistsPerRocket
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "ColonistsPerRocket",
        "Rocket",
        "Long pig sardines",
        "UI/Icons/Notifications/colonist.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RocketCargoCapacityLarge = {
    icon = "EnrichTerrainEditor.tga",
    menu = "Gameplay/Rocket/Cargo Capacity Large",
    description = "+1,000,000,000",
    action = function()
      Consts.CargoCapacity = 1000000000
      ChoGGi.CheatMenuSettings["CargoCapacity"] = Consts.CargoCapacity
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RocketCargoCapacityLarge",
        "Rocket",
        "I can still see some space",
        "UI/Icons/Sections/spaceship.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RocketCargoCapacityDefault = {
    icon = "EnrichTerrainEditor.tga",
    menu = "Gameplay/Rocket/Cargo Capacity Default",
    action = function()
      local CargoCap = 50000
      if UICity:IsTechDiscovered("FuelCompression") then
        CargoCap = CargoCap + 10000
      end
      Consts.CargoCapacity = CargoCap
      ChoGGi.CheatMenuSettings["CargoCapacity"] = Consts.CargoCapacity
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RocketCargoCapacityDefault",
        "Rocket",
        "Feeling kind of tight",
        "UI/Icons/Sections/spaceship.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RocketTravelInstant = {
    icon = "place_particles.tga",
    menu = "Gameplay/Rocket/Travel Instant",
    description = "Instant travel between Earth and Mars.",
    action = function()
      Consts.TravelTimeEarthMars = 0
      Consts.TravelTimeMarsEarth = 0
      ChoGGi.CheatMenuSettings["TravelTimeEarthMars"] = Consts.TravelTimeEarthMars
      ChoGGi.CheatMenuSettings["TravelTimeMarsEarth"] = Consts.TravelTimeMarsEarth
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RocketTravelInstant",
        "Rocket",
        "88 MPH",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RocketTravelDefault = {
    icon = "place_particles.tga",
    menu = "Gameplay/Rocket/Travel Default",
    description = "Default travel between Earth and Mars.",
    action = function()
      local TravelTime = 750000
      if UICity:IsTechDiscovered("PlasmaRocket") then
        TravelTime = 375000
      end
      Consts.TravelTimeEarthMars = TravelTime
      Consts.TravelTimeMarsEarth = TravelTime
      ChoGGi.CheatMenuSettings["TravelTimeEarthMars"] = Consts.TravelTimeEarthMars
      ChoGGi.CheatMenuSettings["TravelTimeMarsEarth"] = Consts.TravelTimeMarsEarth
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RocketTravelDefault",
        "Rocket",
        "-88 MPH",
        "UI/Icons/Notifications/timer.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_HintRadius = {
    icon = "ReportBug.tga",
    menu = "Gameplay/Radius/[0]These don't really work for now",
    description = "keeps resetting...",
    action = function()
      return
    end
  },

  ChoGGi_RCRoverRadiusIncrease = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/RC Rover Radius + 25",
    description = "Increase drone radius of each Rover",
    action = function()
      for _,rcvehicle in ipairs(UICity.labels.RCRover or empty_table) do
        local prop_meta = rcvehicle:GetPropertyMetadata("UIWorkRadius")
        if prop_meta then
          local radius = rcvehicle:GetProperty(prop_meta.id)
          rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCRoverRadiusIncrease",
        "RC",
        "I Can See for Miles",
        "UI/Icons/Upgrades/service_bots_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_RCRoverRadiusDefault = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/RC Rover Radius Default",
    description = "Default drone radius to each Rover",
    action = function()
      for _,rcvehicle in ipairs(UICity.labels.RCRover or empty_table) do
        local prop_meta = rcvehicle:GetPropertyMetadata("UIWorkRadius")
        if prop_meta then
          local radius = rcvehicle:GetProperty(prop_meta.id)
          rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max,20))
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "RCRoverRadiusDefault",
        "RC",
        "I Can See for Miles",
        "UI/Icons/Upgrades/service_bots_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

--not working
  ChoGGi_CommandCenterRadiusIncrease = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Command Center Radius + 25",
    description = "Increase Drone radius of drone hubs",
    action = function()

      const.RCRoverDefaultRadius = const.RCRoverDefaultRadius + 25
      const.RCRoverMaxRadius = const.RCRoverDefaultRadius + 25
      const.RCRoverMinRadius = const.RCRoverMinRadius + 25

      local buildings = UICity.labels.Building
      for _,building in ipairs(buildings) do
        if IsKindOf(building,"DroneHub") then
          local prop_meta = building:GetPropertyMetadata("UIWorkRadius")
          if prop_meta then
            local radius = building:GetProperty(prop_meta.id)
            building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
            building:SetProperty(prop_meta.id, Default(prop_meta.default, radius + 25))
            building:SetProperty(prop_meta.id, Min(prop_meta.min, radius + 25))
          end
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "CommandCenterRadiusIncrease",
        "Buildings",
        "I see you there",
        "UI/Icons/Upgrades/polymer_blades_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_CommandCenterRadiusDefault = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Command Center Radius Default",
    description = "Default Drone radius of drone hubs",
    action = function()
      local buildings = UICity.labels.Building
      for _,building in ipairs(buildings) do
        if IsKindOf(building,"DroneHub") then
          local prop_meta = building:GetPropertyMetadata("UIWorkRadius")
          if prop_meta then
            local radius = building:GetProperty(prop_meta.id)
            building:SetProperty(prop_meta.id, Max(prop_meta.max, 35))
            building:SetProperty(prop_meta.id, Default(prop_meta.default, 35))
          end
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "CommandCenterRadiusDefault",
        "Buildings",
        "It's gettin' hard to see sonnyboy.",
        "UI/Icons/Upgrades/polymer_blades_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_TriboelectricScrubberRadiusIncrease = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Triboelectric Scrubber Radius + 25",
    description = "Increase radius of Triboelectric Scrubber",
    action = function()
      local buildings = UICity.labels.Building
      for _,building in ipairs(buildings) do
        if IsKindOf(building,"TriboelectricScrubber") then
          local prop_meta = building:GetPropertyMetadata("UIRange")
          if prop_meta then
            local radius = building:GetProperty(prop_meta.id)
            building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
          end
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "TriboelectricScrubberRadiusIncrease",
        "Buildings",
        "I see you there",
        "UI/Icons/Upgrades/polymer_blades_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_TriboelectricScrubberRadiusDefault = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Triboelectric Scrubber Radius Default",
    description = "Default radius of Triboelectric Scrubber",
    action = function()
      local buildings = UICity.labels.Building
      for _,building in ipairs(buildings) do
        if IsKindOf(building,"TriboelectricScrubber") then
          local prop_meta = building:GetPropertyMetadata("UIRange")
          if prop_meta then
            local radius = building:GetProperty(prop_meta.id)
            building:SetProperty(prop_meta.id, Max(prop_meta.max,5))
          end
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "TriboelectricScrubberRadiusDefault",
        "Buildings",
        "It's gettin' hard to see sonnyboy.",
        "UI/Icons/Upgrades/polymer_blades_04.tga",
        nil,
        {expiration=5000})
      )
    end
  },

})
