-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

local SettingsFile = "AppData/CheatMenuModSettings.lua"

--functions to check for tech for default values
local function BuildingMaintenancePointsModifier()
  local BuildingMaintenance = 100
  if UICity and UICity:IsTechDiscovered("HullPolarization") then
    BuildingMaintenance = 75
  end
  return BuildingMaintenance
end
--
local function CargoCapacity()
  local CargoCap = 50000
  if UICity and UICity:IsTechDiscovered("FuelCompression") then
    CargoCap = CargoCap + 10000
  end
  return CargoCap
end
--
local function CommandCenterMaxDrones()
  local DroneAmount = 20
  if UICity and UICity:IsTechDiscovered("DroneSwarm") then
    DroneAmount = 80
  end
  return DroneAmount
end
--
local function DroneResourceCarryAmount()
  local CarryAmount = 1
  if UICity and UICity:IsTechDiscovered("ArtificialMuscles") then
    CarryAmount = 2
  end
  return CarryAmount
end
--
local function LowSanityNegativeTraitChance()
  local TraitChance = 30
  if UICity and UICity:IsTechDiscovered("SupportiveCommunity") then
    TraitChance = 7.5
  end
  return TraitChance
end
--
local function MaxColonistsPerRocket()
  local PerRocket = 12
  if UICity and UICity:IsTechDiscovered("CompactPassengerModule") then
    PerRocket = PerRocket + 10
  end
  if UICity and UICity:IsTechDiscovered("CryoSleep") then
    PerRocket = PerRocket + 20
  end
  return PerRocket
end
--
local function NonSpecialistPerformancePenalty()
  local PerformancePenalty = 50
  if UICity and UICity:IsTechDiscovered("GeneralTraining") then
    PerformancePenalty = 40
  end
  return PerformancePenalty
end
--
local function RCRoverMaxDrones()
  local DroneAmount = 8
  if UICity and UICity:IsTechDiscovered("RoverCommandAI") then
    DroneAmount = 12
  end
  return DroneAmount
end
--
local function RCTransportGatherResourceWorkTime()
  local ResourceWorkTime = 15000
  if UICity and UICity:IsTechDiscovered("TransportOptimization") then
    ResourceWorkTime = 7500
  end
  return ResourceWorkTime
end
--
local function TravelTimePlanets()
  local TravelTime = 750000
  if UICity and UICity:IsTechDiscovered("PlasmaRocket") then
    TravelTime = 375000
  end
  return TravelTime
end

--default game settings
local CheatMenuSettings = {
--Consts. Funcs
  BuildingMaintenancePointsModifier = BuildingMaintenancePointsModifier(),
  CargoCapacity = CargoCapacity(),
  CommandCenterMaxDrones = CommandCenterMaxDrones(),
  DroneResourceCarryAmount = DroneResourceCarryAmount(),
  LowSanityNegativeTraitChance = LowSanityNegativeTraitChance(),
  MaxColonistsPerRocket = MaxColonistsPerRocket(),
  NonSpecialistPerformancePenalty = NonSpecialistPerformancePenalty(),
  RCRoverMaxDrones = RCRoverMaxDrones(),
  RCTransportGatherResourceWorkTime = RCTransportGatherResourceWorkTime(),
  TravelTimeEarthMars = TravelTimePlanets(),
  TravelTimeMarsEarth = TravelTimePlanets(),
--Consts.
  AvoidWorkplaceSols = 5,
  ColdWaveSanityDamage = 300,
  Concrete_cost_modifier = 0,
  Concrete_dome_cost_modifier = 0,
  CrimeEventDestroyedBuildingsCount = 1,
  CrimeEventSabotageBuildingsCount = 1,
  DefaultOutsideWorkplacesRadius = 10,
  DroneBuildingRepairAmount = 5000,
  DroneBuildingRepairBatteryUse = 100,
  DroneCarryBatteryUse = 150,
  DroneConstructAmount = 100,
  DroneConstructBatteryUse = 300,
  DroneDeconstructBatteryUse = 100,
  DroneMeteorMalfunctionChance = 50,
  DroneMoveBatteryUse = 100,
  DroneRechargeTime = 40000,
  DroneRepairSupplyLeak = 180,
  DroneTransformWasteRockObstructorToStockpileBatteryUse = 100,
  DustStormSanityDamage = 300,
  Electronics_cost_modifier = 0,
  Electronics_dome_cost_modifier = 0,
  FoodPerRocketPassenger = 10000,
  HighStatLevel = 70000,
  HighStatMoraleEffect = 5000,
  LowSanitySuicideChance = 1,
  LowStatLevel = 30000,
  MachineParts_cost_modifier = 0,
  MachineParts_dome_cost_modifier = 0,
  Metals_cost_modifier = 0,
  Metals_dome_cost_modifier = 0,
  MeteorHealthDamage = 50000,
  MeteorSanityDamage = 12000,
  MysteryDreamSanityDamage = 500,
  OutsourceResearch = 1000,
  OutsourceResearchCost = 200000000,
  OxygenMaxOutsideTime = 120000,
  PipesPillarSpacing = 4,
  Polymers_cost_modifier = 0,
  Polymers_dome_cost_modifier = 0,
  positive_playground_chance = 100,
  PreciousMetals_cost_modifier = 0,
  PreciousMetals_dome_cost_modifier = 0,
  ProjectMorphiousPositiveTraitChance = 2,
  RCRoverDroneRechargeCost = 15000,
  RCRoverTransferResourceWorkTime = 1000,
  rebuild_cost_modifier = 100,
  TimeBeforeStarving = 1080000,
--const.
  ExplorationQueueMaxSize = 5,
  fastGameSpeed = 5,
  mediumGameSpeed = 3,
  MoistureVaporatorPenaltyPercent = 40,
  MoistureVaporatorRange = 5,
  ResearchQueueSize = 4,
}

--called everytime you set a setting
local function WriteSettings()
  AsyncStringToFile(SettingsFile,TupleToLuaCode(CheatMenuSettings))
end

--get custom settings from file
local function ReadSettings()
	if not SettingsFile then return end

	local file_error, code = AsyncFileToString(SettingsFile)
	if file_error then
		return file_error
	end

	local code_error, CheatMenuSettings = LuaCodeToTuple(code)
	if code_error then
		return code_error
	end

--Consts.
  Consts.AvoidWorkplaceSols = CheatMenuSettings["AvoidWorkplaceSols"]
  Consts.BuildingMaintenancePointsModifier = CheatMenuSettings["BuildingMaintenancePointsModifier"]
  Consts.CargoCapacity = CheatMenuSettings["CargoCapacity"]
  Consts.ColdWaveSanityDamage = CheatMenuSettings["ColdWaveSanityDamage"]
  Consts.CommandCenterMaxDrones = CheatMenuSettings["CommandCenterMaxDrones"]
  Consts.Concrete_cost_modifier = CheatMenuSettings["Concrete_cost_modifier"]
  Consts.Concrete_dome_cost_modifier = CheatMenuSettings["Concrete_dome_cost_modifier"]
  Consts.CrimeEventDestroyedBuildingsCount = CheatMenuSettings["CrimeEventDestroyedBuildingsCount"]
  Consts.CrimeEventSabotageBuildingsCount = CheatMenuSettings["CrimeEventSabotageBuildingsCount"]
  Consts.DefaultOutsideWorkplacesRadius = CheatMenuSettings["DefaultOutsideWorkplacesRadius"]
  Consts.DroneBuildingRepairAmount = CheatMenuSettings["DroneBuildingRepairAmount"]
  Consts.DroneBuildingRepairBatteryUse = CheatMenuSettings["DroneBuildingRepairBatteryUse"]
  Consts.DroneCarryBatteryUse = CheatMenuSettings["DroneCarryBatteryUse"]
  Consts.DroneConstructAmount = CheatMenuSettings["DroneConstructAmount"]
  Consts.DroneConstructBatteryUse = CheatMenuSettings["DroneConstructBatteryUse"]
  Consts.DroneDeconstructBatteryUse = CheatMenuSettings["DroneDeconstructBatteryUse"]
  Consts.DroneMeteorMalfunctionChance = CheatMenuSettings["DroneMeteorMalfunctionChance"]
  Consts.DroneMoveBatteryUse = CheatMenuSettings["DroneMoveBatteryUse"]
  Consts.DroneRechargeTime = CheatMenuSettings["DroneRechargeTime"]
  Consts.DroneRepairSupplyLeak = CheatMenuSettings["DroneRepairSupplyLeak"]
  Consts.DroneResourceCarryAmount = CheatMenuSettings["DroneResourceCarryAmount"]
  Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = CheatMenuSettings["DroneTransformWasteRockObstructorToStockpileBatteryUse"]
  Consts.DustStormSanityDamage = CheatMenuSettings["DustStormSanityDamage"]
  Consts.Electronics_cost_modifier = CheatMenuSettings["Electronics_cost_modifier"]
  Consts.Electronics_dome_cost_modifier = CheatMenuSettings["Electronics_dome_cost_modifier"]
  Consts.FoodPerRocketPassenger = CheatMenuSettings["FoodPerRocketPassenger"]
  Consts.HighStatLevel = CheatMenuSettings["HighStatLevel"]
  Consts.HighStatMoraleEffect = CheatMenuSettings["HighStatMoraleEffect"]
  Consts.LowSanityNegativeTraitChance = CheatMenuSettings["LowSanityNegativeTraitChance"]
  Consts.LowSanitySuicideChance = CheatMenuSettings["LowSanitySuicideChance"]
  Consts.LowStatLevel = CheatMenuSettings["LowStatLevel"]
  Consts.MachineParts_cost_modifier = CheatMenuSettings["MachineParts_cost_modifier"]
  Consts.MachineParts_dome_cost_modifier = CheatMenuSettings["MachineParts_dome_cost_modifier"]
  Consts.MaxColonistsPerRocket = CheatMenuSettings["MaxColonistsPerRocket"]
  Consts.Metals_cost_modifier = CheatMenuSettings["Metals_cost_modifier"]
  Consts.Metals_dome_cost_modifier = CheatMenuSettings["Metals_dome_cost_modifier"]
  Consts.MeteorHealthDamage = CheatMenuSettings["MeteorHealthDamage"]
  Consts.MeteorSanityDamage = CheatMenuSettings["MeteorSanityDamage"]
  Consts.MysteryDreamSanityDamage = CheatMenuSettings["MysteryDreamSanityDamage"]
  Consts.NonSpecialistPerformancePenalty = CheatMenuSettings["NonSpecialistPerformancePenalty"]
  Consts.OutsourceResearch = CheatMenuSettings["OutsourceResearch"]
  Consts.OutsourceResearchCost = CheatMenuSettings["OutsourceResearchCost"]
  Consts.OxygenMaxOutsideTime = CheatMenuSettings["OxygenMaxOutsideTime"]
  Consts.PipesPillarSpacing = CheatMenuSettings["PipesPillarSpacing"]
  Consts.Polymers_cost_modifier = CheatMenuSettings["Polymers_cost_modifier"]
  Consts.Polymers_dome_cost_modifier = CheatMenuSettings["Polymers_dome_cost_modifier"]
  Consts.positive_playground_chance = CheatMenuSettings["positive_playground_chance"]
  Consts.PreciousMetals_cost_modifier = CheatMenuSettings["PreciousMetals_cost_modifier"]
  Consts.PreciousMetals_dome_cost_modifier = CheatMenuSettings["PreciousMetals_dome_cost_modifier"]
  Consts.ProjectMorphiousPositiveTraitChance = CheatMenuSettings["ProjectMorphiousPositiveTraitChance"]
  Consts.RCRoverDroneRechargeCost = CheatMenuSettings["RCRoverDroneRechargeCost"]
  Consts.RCRoverMaxDrones = CheatMenuSettings["RCRoverMaxDrones"]
  Consts.RCRoverTransferResourceWorkTime = CheatMenuSettings["RCRoverTransferResourceWorkTime"]
  Consts.RCTransportGatherResourceWorkTime = CheatMenuSettings["RCTransportGatherResourceWorkTime"]
  Consts.rebuild_cost_modifier = CheatMenuSettings["rebuild_cost_modifier"]
  Consts.TimeBeforeStarving = CheatMenuSettings["TimeBeforeStarving"]
  Consts.TravelTimeEarthMars = CheatMenuSettings["TravelTimeEarthMars"]
  Consts.TravelTimeMarsEarth = CheatMenuSettings["TravelTimeMarsEarth"]
--const.
  const.ExplorationQueueMaxSize = CheatMenuSettings["ExplorationQueueMaxSize"]
  const.fastGameSpeed = CheatMenuSettings["fastGameSpeed"]
  const.mediumGameSpeed = CheatMenuSettings["mediumGameSpeed"]
  const.MoistureVaporatorPenaltyPercent = CheatMenuSettings["MoistureVaporatorPenaltyPercent"]
  const.MoistureVaporatorRange = CheatMenuSettings["MoistureVaporatorRange"]
  const.ResearchQueueSize = CheatMenuSettings["ResearchQueueSize"]
end


function OnMsg.LoadGame()
  ReadSettings()
end

--[[retrieve list of building/vehicle names
  local templates = DataInstances.BuildingTemplate
  for i = 1, #templates do
    local building_template = templates[i]
    building_template.name
    building_template.require_prefab
  end
available_prefabs = UICity:GetPrefabs(building_template.name)
City:AddPrefabs(bld, count)

--]]

local function InitCheats()

  -- Turn on editor mode (this is required for cheats to work) and then add the editor commands
  Platform.editor = true
  Platform.dev = true
  AddCheatsUA()

  -- Add a command to show/hide the cheats menu and demo how to add a whole new menu and menu item
  UserActions.AddActions({

--[[
    ["TESTING"] = {
      mode = "Game",
      menu = "[999]TEST/TEST",
      action = function()
        CreateRealTimeThread(WaitCustomPopupNotification,
          VAR,
          "blah",
          { "OK" }
        )
      end
    },
--]]
    ["G_ToggleCheatsMenu"] = {
      mode = "Game",
      key = "F2",
      action = function()
        UAMenu.ToggleOpen()
        -- Also toggle the infopanel cheats to show/hide with the menu
        config.BuildingInfopanelCheats = not not dlgUAMenu
        ReopenSelectionXInfopanel()
      end
    },
    ["G_AboutCheatsMenu"] = {
      mode = "Game",
      menu = "[998]Help/[1]About",
      action = function()
        CreateRealTimeThread(WaitCustomPopupNotification,
          "About Cheats",
          "This mod enables the built-in cheats menu. Take a look at the mod code to see how to add additional menus and menu items like this about dialog.",
          { "OK" }
        )
      end
    },
--Cheats
    ["ResearchAllBreakthroughs"] = {
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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

--Resources
    ["10FoodPerRocketPassenger"] = {
      mode = "Game",
      menu = "Resources/Passengers/[1]10 Food Per Rocket Passenger",
      description = "The amount of Food supplied with each Colonist arrival.",
      action = function()
        Consts.FoodPerRocketPassenger = 10000
        CheatMenuSettings["FoodPerRocketPassenger"] = 10000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "10FoodPerRocketPassenger",
          "Passengers",
          "om nom nom",
          "UI/Icons/Sections/Food_4.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["25FoodPerRocketPassenger"] = {
      mode = "Game",
      menu = "Resources/Passengers/[2]25 Food Per Rocket Passenger",
      description = "The amount of Food supplied with each Colonist arrival.",
      action = function()
        Consts.FoodPerRocketPassenger = 25000
        CheatMenuSettings["FoodPerRocketPassenger"] = 25000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "25FoodPerRocketPassenger",
          "Passengers",
          "om nom nom",
          "UI/Icons/Sections/Food_4.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["50FoodPerRocketPassenger"] = {
      mode = "Game",
      menu = "Resources/Passengers/[3]50 Food Per Rocket Passenger",
      description = "The amount of Food supplied with each Colonist arrival.",
      action = function()
        Consts.FoodPerRocketPassenger = 50000
        CheatMenuSettings["FoodPerRocketPassenger"] = 50000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "50FoodPerRocketPassenger",
          "Passengers",
          "om nom nom",
          "UI/Icons/Sections/Food_4.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["100FoodPerRocketPassenger"] = {
      mode = "Game",
      menu = "Resources/Passengers/[4]100 Food Per Rocket Passenger",
      description = "The amount of Food supplied with each Colonist arrival.",
      action = function()
        Consts.FoodPerRocketPassenger = 100000
        CheatMenuSettings["FoodPerRocketPassenger"] = 100000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "100FoodPerRocketPassenger",
          "Passengers",
          "om nom nom",
          "UI/Icons/Sections/Food_4.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["1000FoodPerRocketPassenger"] = {
      mode = "Game",
      menu = "Resources/Passengers/[5]1000 Food Per Rocket Passenger",
      description = "The amount of Food supplied with each Colonist arrival.",
      action = function()
        Consts.FoodPerRocketPassenger = 1000000
        CheatMenuSettings["FoodPerRocketPassenger"] = 1000000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "1000FoodPerRocketPassenger",
          "Passengers",
          "om nom nom",
          "UI/Icons/Sections/Food_4.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["Add100PrefabsDrone"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 100 Drones",
      action = function()
        UICity.drone_prefabs = UICity.drone_prefabs + 100
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add100PrefabsDrone",
          "Prefabs",
          "100 Drone Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["Add10PrefabsDroneHub"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 DroneHub",
      action = function()
        UICity:AddPrefabs("DroneHub", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsDroneHub",
          "Prefabs",
          "10 DroneHub Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsStirlingGenerator"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 StirlingGenerator",
      action = function()
        UICity:AddPrefabs("StirlingGenerator", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsStirlingGenerator",
          "Prefabs",
          "10 StirlingGenerator Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsElectronicsFactory"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 ElectronicsFactory",
      action = function()
        UICity:AddPrefabs("ElectronicsFactory", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsElectronicsFactory",
          "Prefabs",
          "10 ElectronicsFactory Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsFuelFactory"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 FuelFactory",
      action = function()
        UICity:AddPrefabs("FuelFactory", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsFuelFactory",
          "Prefabs",
          "10 FuelFactory Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsMachinePartsFactory"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 MachinePartsFactory",
      action = function()
        UICity:AddPrefabs("MachinePartsFactory", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsMachinePartsFactory",
          "Prefabs",
          "10 MachinePartsFactory Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsMoistureVaporator"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 MoistureVaporator",
      action = function()
        UICity:AddPrefabs("MoistureVaporator", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsMoistureVaporator",
          "Prefabs",
          "10 MoistureVaporator Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsPolymerPlant"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 PolymerPlant",
      action = function()
        UICity:AddPrefabs("PolymerPlant", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsPolymerPlant",
          "Prefabs",
          "10 PolymerPlant Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsStirlingGenerator"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 StirlingGenerator",
      action = function()
        UICity:AddPrefabs("StirlingGenerator", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsStirlingGenerator",
          "Prefabs",
          "10 StirlingGenerator Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsWaterReclamationSystem"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Add 10 WaterReclamationSystem",
      action = function()
        UICity:AddPrefabs("WaterReclamationSystem", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsWaterReclamationSystem",
          "Prefabs",
          "10 WaterReclamationSystem Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["Add10PrefabsArcology"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Spire/Add 10 Arcology",
      action = function()
        UICity:AddPrefabs("Arcology", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsArcology",
          "Prefabs",
          "10 Arcology Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsSanatorium"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Spire/Add 10 Sanatorium",
      action = function()
        UICity:AddPrefabs("Sanatorium", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsSanatorium",
          "Prefabs",
          "10 Sanatorium Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsNetworkNode"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Spire/Add 10 NetworkNode",
      action = function()
        UICity:AddPrefabs("NetworkNode", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsNetworkNode",
          "Prefabs",
          "10 NetworkNode Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsMedicalCenter"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Spire/Add 10 MedicalCenter",
      action = function()
        UICity:AddPrefabs("MedicalCenter", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsMedicalCenter",
          "Prefabs",
          "10 MedicalCenter Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsHangingGardens"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Spire/Add 10 HangingGardens",
      action = function()
        UICity:AddPrefabs("HangingGardens", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsHangingGardens",
          "Prefabs",
          "10 HangingGardens Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["Add10PrefabsCloningVats"] = {
      mode = "Game",
      menu = "Resources/Prefabs/Spire/Add 10 CloningVats",
      action = function()
        UICity:AddPrefabs("CloningVats", 10)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "Add10PrefabsCloningVats",
          "Prefabs",
          "10 CloningVats Prefabs Added",
          "UI/Icons/Sections/storage.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["FundsAdded10000M"] = {
      mode = "Game",
      menu = "Resources/Add Funding/[3]Add 10,000 M",
      action = function()
        ChangeFunding(10000)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "FundsAdded10000M",
          "Add Funding",
          "10,000 M Added",
          "UI/Icons/IPButtons/rare_metals.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["FundsAdded1000M"] = {
      mode = "Game",
      menu = "Resources/Add Funding/[2]Add 1,000 M",
      action = function()
        ChangeFunding(1000)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "FundsAdded1000M",
          "Add Funding",
          "1,000 M Added",
          "UI/Icons/IPButtons/rare_metals.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["FundsAdded25M"] = {
      mode = "Game",
      menu = "Resources/Add Funding/[1]Add 25 M",
      action = function()
        ChangeFunding(25)
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "FundsAdded25M",
          "Add Funding",
          "25 M Added",
          "UI/Icons/IPButtons/rare_metals.tga",
          nil,
          {expiration=5000})
        )
      end
    },
--Gameplay
    ["ResearchQueueLarger"] = {
      mode = "Game",
      menu = "Gameplay/Research/Research Queue Larger",
      description = "Add up to 25 items to queue.",
      action = function()
        const.ResearchQueueSize = 25
        CheatMenuSettings["ResearchQueueSize"] = 25
        WriteSettings()
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
    ["ResearchQueueDefault"] = {
      mode = "Game",
      menu = "Gameplay/Research/Research Queue Default",
      description = "Add up to 4 items to queue.",
      action = function()
        const.ResearchQueueSize = 4
        CheatMenuSettings["ResearchQueueSize"] = 4
        WriteSettings()
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
    ["OutsourcingFree"] = {
      mode = "Game",
      menu = "Gameplay/Research/Outsourcing Free",
      description = "Outsourcing is free to purchase (over n over).",
      action = function()
        Consts.OutsourceResearchCost = 0
        CheatMenuSettings["OutsourceResearchCost"] = 0
        WriteSettings()
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
    ["OutsourcingDefault"] = {
      mode = "Game",
      menu = "Gameplay/Research/Outsourcing Default",
      description = "Outsourcing is the usual cost.",
      action = function()
        Consts.OutsourceResearchCost = 200000000
        CheatMenuSettings["OutsourceResearchCost"] = 200000000
        WriteSettings()
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
    ["OutsourcePoints1000000"] = {
      mode = "Game",
      menu = "Gameplay/Research/Outsource Points (1,000,000)",
      description = "Gives a crapload of research points (almost instant research)",
      action = function()
        Consts.OutsourceResearch = 9999900
        CheatMenuSettings["OutsourceResearch"] = 9999900
        WriteSettings()
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
    ["OutsourcePointsDefault"] = {
      mode = "Game",
      menu = "Gameplay/Research/Outsource Points Default",
      description = "Gives regular amount of research points",
      action = function()
        Consts.OutsourceResearch = 1000
        CheatMenuSettings["OutsourceResearch"] = 1000
        WriteSettings()
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

    ["GameSpeedDefault"] = {
      mode = "Game",
      menu = "Gameplay/Speed/[1]GameSpeed Default",
      description = "Default speed",
      action = function()
        const.mediumGameSpeed = 3
        const.fastGameSpeed = 5
        CheatMenuSettings["mediumGameSpeed"] = 3
        CheatMenuSettings["fastGameSpeed"] = 5
        WriteSettings()
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
    ["GameSpeedDouble"] = {
      mode = "Game",
      menu = "Gameplay/Speed/[2]GameSpeed Double",
      description = "Doubles the speed of the game (at medium/fast)",
      action = function()
        const.mediumGameSpeed = 6
        const.fastGameSpeed = 10
        CheatMenuSettings["mediumGameSpeed"] = 6
        CheatMenuSettings["fastGameSpeed"] = 10
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "GameSpeedDouble",
          "Speed",
          "｡ﾁndale! ｡ﾁndale! ｡Arriba! ｡Arriba! ｡Epa! ｡Epa! ｡Epa! Yeehaw!",
          "UI/Icons/Notifications/timer.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["GameSpeedTriple"] = {
      mode = "Game",
      menu = "Gameplay/Speed/[3]GameSpeed Triple",
      description = "Triples the speed of the game (at medium/fast)",
      action = function()
        const.mediumGameSpeed = 9
        const.fastGameSpeed = 15
        CheatMenuSettings["mediumGameSpeed"] = 9
        CheatMenuSettings["fastGameSpeed"] = 15
        WriteSettings()
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
    ["GameSpeedQuad"] = {
      mode = "Game",
      menu = "Gameplay/Speed/[4]GameSpeed Quad",
      description = "Quadruples the speed of the game (at medium/fast)",
      action = function()
        const.mediumGameSpeed = 12
        const.fastGameSpeed = 20
        CheatMenuSettings["mediumGameSpeed"] = 12
        CheatMenuSettings["fastGameSpeed"] = 20
        WriteSettings()
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

    ["RCTransportStorage1024"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Transport Storage 1024",
      description = "I laugh at your 30 spaces.",
      action = function()
        local rcrovers = UICity.labels.RCTransport or empty_table
        for _,rcrover in ipairs(rcrovers) do
          rcrover.max_shared_storage = 1024 * const.ResourceScale
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCTransportStorage1024",
          "RC & Drones",
          "More than enough space...",
          "UI/Icons/bmc_building_storages_shine.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["RCTransportStorage256"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Transport Storage 256",
      description = "I chuckle at your 30 spaces",
      action = function()
        local rcrovers = UICity.labels.RCTransport or empty_table
        for _,rcrover in ipairs(rcrovers) do
          rcrover.max_shared_storage = 256 * const.ResourceScale
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCTransportStorage256",
          "RC & Drones",
          "Enough space?",
          "UI/Icons/bmc_building_storages_shine.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["RCTransportStorageDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Transport Storage Default",
      description = "I miss 30 spaces",
      action = function()
        local rcrovers = UICity.labels.RCTransport or empty_table
        local TransportSpace = 30
        if UICity:IsTechDiscovered("TransportOptimization") then
          TransportSpace = 45
        end
        for _,rcrover in ipairs(rcrovers) do
          rcrover.max_shared_storage = TransportSpace * const.ResourceScale
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCTransportStorageDefault",
          "RC & Drones",
          "Default space",
          "UI/Icons/bmc_building_storages_shine.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneBatteryInfinite"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Battery Infinite",
      action = function()
        Consts.DroneMoveBatteryUse = 0
        Consts.DroneCarryBatteryUse = 0
        Consts.DroneConstructBatteryUse = 0
        Consts.DroneBuildingRepairBatteryUse = 0
        Consts.DroneDeconstructBatteryUse = 0
        Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = 0
        CheatMenuSettings["DroneMoveBatteryUse"] = 0
        CheatMenuSettings["DroneCarryBatteryUse"] = 0
        CheatMenuSettings["DroneConstructBatteryUse"] = 0
        CheatMenuSettings["DroneBuildingRepairBatteryUse"] = 0
        CheatMenuSettings["DroneDeconstructBatteryUse"] = 0
        CheatMenuSettings["DroneTransformWasteRockObstructorToStockpileBatteryUse"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneBatteryInfinite",
          "RC & Drones",
          "What happens when the drones get into your Jolt Cola supply...",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneBatteryDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Battery Default",
      action = function()
        Consts.DroneMoveBatteryUse = 100
        Consts.DroneCarryBatteryUse = 150
        Consts.DroneConstructBatteryUse = 300
        Consts.DroneBuildingRepairBatteryUse = 100
        Consts.DroneDeconstructBatteryUse = 100
        Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = 100
        CheatMenuSettings["DroneMoveBatteryUse"] = 100
        CheatMenuSettings["DroneCarryBatteryUse"] = 100
        CheatMenuSettings["DroneConstructBatteryUse"] = 100
        CheatMenuSettings["DroneBuildingRepairBatteryUse"] = 100
        CheatMenuSettings["DroneDeconstructBatteryUse"] = 100
        CheatMenuSettings["DroneTransformWasteRockObstructorToStockpileBatteryUse"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneBatteryDefault",
          "RC & Drones",
          "What happens when the drones get into your Jolt Cola supply...",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneCarryAmount10"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Carry Amount 10",
      action = function()
        Consts.DroneResourceCarryAmount = 10
        CheatMenuSettings["DroneResourceCarryAmount"] = 10
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneCarryAmount10",
          "RC & Drones",
          "What happens when the drones get into your Jolt Cola supply...",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneCarryAmount25"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Carry Amount 25",
      action = function()
        Consts.DroneResourceCarryAmount = 25
        CheatMenuSettings["DroneResourceCarryAmount"] = 25
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneCarryAmount25",
          "RC & Drones",
          "What happens when the drones get into your Jolt Cola supply...",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneCarryAmount100"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Carry Amount 100",
      action = function()
        Consts.DroneResourceCarryAmount = 100
        CheatMenuSettings["DroneResourceCarryAmount"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneCarryAmount100",
          "RC & Drones",
          "What happens when the drones get into your Jolt Cola supply...",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneCarryAmountDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Carry Amount Default",
      action = function()
        local CarryAmount = 1
        if UICity:IsTechDiscovered("ArtificialMuscles") then
          CarryAmount = 2
        end
        Consts.DroneResourceCarryAmount = CarryAmount
        CheatMenuSettings["DroneResourceCarryAmount"] = CarryAmount
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneCarryAmountDefault",
          "RC & Drones",
          "What happens when the drones don't get into your Jolt Cola supply...",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneBuildSpeedInstant"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Build Speed Instant",
      description = "Instant build/repair when resources are ready.",
      action = function()
        Consts.DroneConstructAmount = 999900
        Consts.DroneBuildingRepairAmount = 999900
        CheatMenuSettings["DroneConstructAmount"] = 999900
        CheatMenuSettings["DroneBuildingRepairAmount"] = 999900
        WriteSettings()
        --Consts.DroneConstrutionTime = 0
        --Consts.AndroidConstrutionTime = 0
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneBuildSpeedInstant",
          "RC & Drones",
          "What happens when the drones get into your Jolt Cola supply... and drink it",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneBuildSpeedDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Build Speed Default",
      description = "Default build/repair when resources are ready.",
      action = function()
        Consts.DroneConstructAmount = 100
        Consts.DroneBuildingRepairAmount = 5000
        CheatMenuSettings["DroneConstructAmount"] = 100
        CheatMenuSettings["DroneBuildingRepairAmount"] = 5000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneBuildSpeedDefault",
          "RC & Drones",
          "What happens when the drones don't get into your Jolt Cola supply... and don't drink it",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DronesPerDroneHub200"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drones Per Drone Hub (200)",
      description = "Command 200 drones with each hub",
      action = function()
        Consts.CommandCenterMaxDrones = 200
        CheatMenuSettings["CommandCenterMaxDrones"] = 200
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DronesPerDroneHub200",
          "RC & Drones",
          "AI's taking over",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DronesPerDroneHub100"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drones Per Drone Hub (100)",
      description = "Command 100 drones with each hub",
      action = function()
        Consts.CommandCenterMaxDrones = 100
        CheatMenuSettings["CommandCenterMaxDrones"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DronesPerDroneHub100",
          "RC & Drones",
          "AI's taking over",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DronesPerDroneHubDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drones Per Drone Hub (Default)",
      description = "Command Default drones with each hub",
      action = function()
        local DroneAmount = 20
        if UICity:IsTechDiscovered("DroneSwarm") then
          DroneAmount = 80
        end
        Consts.CommandCenterMaxDrones = DroneAmount
        CheatMenuSettings["CommandCenterMaxDrones"] = DroneAmount
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DronesPerDroneHubDefault",
          "RC & Drones",
          "AI stopped taking over",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DronesPerRCRover200"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drones Per RC Rover 200",
      description = "Command 200 drones with each rover",
      action = function()
        Consts.RCRoverMaxDrones = 200
        CheatMenuSettings["RCRoverMaxDrones"] = 200
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DronesPerRCRover200",
          "RC & Drones",
          "AI took over",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DronesPerRCRover100"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drones Per RC Rover 100",
      description = "Command 100 drones with each rover",
      action = function()
        Consts.RCRoverMaxDrones = 100
        CheatMenuSettings["RCRoverMaxDrones"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DronesPerRCRover100",
          "RC & Drones",
          "AI took over",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DronesPerRCRoverDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drones Per RC Rover Default",
      description = "Command Default drones with each rover",
      action = function()
        local DroneAmount = 8
        if UICity:IsTechDiscovered("RoverCommandAI") then
          DroneAmount = 12
        end
        Consts.RCRoverMaxDrones = DroneAmount
        CheatMenuSettings["RCRoverMaxDrones"] = DroneAmount
        WriteSettings()
         CreateRealTimeThread(AddCustomOnScreenNotification(
          "DronesPerRCRoverDefault",
          "RC & Drones",
          "AI lost",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["RCRoverDroneRechargeFree"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Rover Drone Recharge Free",
      description = "No more draining Rover Battery when recharging drones",
      action = function()
        Consts.RCRoverDroneRechargeCost = 0
        CheatMenuSettings["RCRoverDroneRechargeCost"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCRoverDroneRechargeFree",
          "RC & Drones",
          "More where that came from",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["RCRoverDroneRechargeDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Rover Drone Recharge Default",
      description = "Default draining Rover Battery when recharging drones",
      action = function()
        Consts.RCRoverDroneRechargeCost = 15000
        CheatMenuSettings["RCRoverDroneRechargeCost"] = 15000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCRoverDroneRechargeDefault",
          "RC & Drones",
          "More where that came from",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["RCTransportResourceFast"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Transport Resource Fast",
      description = "The time it takes for an RC Rover to Transfer/Gather resources (0 seconds).",
      action = function()
        Consts.RCRoverTransferResourceWorkTime = 0
        Consts.RCTransportGatherResourceWorkTime = 0
        CheatMenuSettings["RCRoverTransferResourceWorkTime"] = 0
        CheatMenuSettings["RCTransportGatherResourceWorkTime"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCTransportResourceFast",
          "RC & Drones",
          "Slight of hand",
          "UI/Icons/IPButtons/resources_section.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["RCTransportResourceDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/RC Transport Resource Default",
      description = "The time it takes for an RC Rover to Transfer/Gather resources (Default).",
      action = function()
        Consts.RCRoverTransferResourceWorkTime = 1000
        local ResourceWorkTime = 15000
        if UICity:IsTechDiscovered("TransportOptimization") then
          ResourceWorkTime = 7500
        end
        Consts.RCTransportGatherResourceWorkTime = ResourceWorkTime
        CheatMenuSettings["RCRoverTransferResourceWorkTime"] = 1000
        CheatMenuSettings["RCTransportGatherResourceWorkTime"] = ResourceWorkTime
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "RCTransportResourceDefault",
          "RC & Drones",
          "Slight of hand",
          "UI/Icons/IPButtons/resources_section.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneMeteorMalfunctionDisable"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Meteor Malfunction Disable",
      description = "Drones will not malfunction when close to a meteor impact site.",
      action = function()
        Consts.DroneMeteorMalfunctionChance = 0
        CheatMenuSettings["DroneMeteorMalfunctionChance"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneMeteorMalfunctionDisable",
          "RC & Drones",
          "I'm singing in the rain. Just singin' in the rain. What a glorious feeling",
          "UI/Icons/Notifications/meteor_storm.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneMeteorMalfunctionDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Meteor Malfunction Default",
      description = "Drones may malfunction when close to a meteor impact site.",
      action = function()
        Consts.DroneMeteorMalfunctionChance = 50
        CheatMenuSettings["DroneMeteorMalfunctionChance"] = 50
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneMeteorMalfunctionDefault",
          "RC & Drones",
          "Off to a rocky start...",
          "UI/Icons/Notifications/meteor_storm.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["DroneRechargeTimeFast"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Recharge Time Fast",
      description = "The time it takes for a Drone to be fully recharged (0 seconds).",
      action = function()
        Consts.DroneRechargeTime = 0
        CheatMenuSettings["DroneRechargeTime"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneRechargeTimeFast",
          "RC & Drones",
          "Well, if jacking on'll make strangers think I'm cool, I'll do it!",
          "UI/Icons/Notifications/low_battery.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["DroneRechargeTimeDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Recharge Time Default",
      description = "The time it takes for a Drone to be fully recharged (Default).",
      action = function()
        Consts.DroneRechargeTime = 40000
        CheatMenuSettings["DroneRechargeTime"] = 40000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneRechargeTimeDefault",
          "RC & Drones",
          "Well, if jacking on'll make strangers think I'm cool, I'll do it!",
          "UI/Icons/Notifications/low_battery.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["DroneRepairSupplyLeakFast"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Repair Supply Leak Fast",
      description = "The amount of time in seconds it takes a Drone to fix a supply leak (0 seconds).",
      action = function()
        Consts.DroneRepairSupplyLeak = 0
        CheatMenuSettings["DroneRepairSupplyLeak"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneRepairSupplyLeakFast",
          "RC & Drones",
          "You know what they say about leaky pipes",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["DroneRepairSupplyLeakDefault"] = {
      mode = "Game",
      menu = "Gameplay/RC & Drones/Drone Repair Supply Leak Default",
      description = "The amount of time in seconds it takes a Drone to fix a supply leak (Default).",
      action = function()
        Consts.DroneRepairSupplyLeak = 180
        CheatMenuSettings["DroneRepairSupplyLeak"] = 180
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "DroneRepairSupplyLeakDefault",
          "RC & Drones",
          "You know what they say about leaky pipes",
          "UI/Icons/IPButtons/drone.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["EnableDeepScan"] = {
      mode = "Game",
      menu = "Gameplay/Scan/Enable Deep Scan",
      description = "Enable deep scan and make deep resources exploitable. Also deep scanning probes.",
      action = function()
      --[[
        Consts.DeepScanAvailable = 1
        Consts.IsDeepWaterExploitable = 1
        Consts.IsDeepMetalsExploitable = 1
        Consts.IsDeepPreciousMetalsExploitable = 1
        --]]
        GrantTech("AdaptedProbes")
        GrantTech("DeepScanning")
        GrantTech("DeepWaterExtraction")
        GrantTech("DeepMetalExtraction")
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "EnableDeepScan",
          "Scan",
          "Down the rabbit hole",
          "UI/Icons/Notifications/scan.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["EnableDeeperScan"] = {
      mode = "Game",
      menu = "Gameplay/Scan/Enable Deeper Scan",
      description = "Uncovers extremely rich underground deposits",
      action = function()
        GrantTech("CoreMetals")
        GrantTech("CoreWater")
        GrantTech("CoreRareMetals")
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "EnableDeeperScan",
          "Scan",
          "Further down the rabbit hole",
          "UI/Icons/Notifications/scan.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ScannerQueueLarger"] = {
      mode = "Game",
      menu = "Gameplay/Scan/Scanner Queue Larger",
      description = "Queue up to 100 squares instead of 5",
      action = function()
        const.ExplorationQueueMaxSize = 100
        CheatMenuSettings["ExplorationQueueMaxSize"] = 100
        WriteSettings()
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
    ["ScannerQueueDefault"] = {
      mode = "Game",
      menu = "Gameplay/Scan/Scanner Queue Default",
      description = "Queue up to 5",
      action = function()
        const.ExplorationQueueMaxSize = 5
        CheatMenuSettings["ExplorationQueueMaxSize"] = 5
        WriteSettings()
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

    ["ColonistsMaxMoraleAlways"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Max Morale Always",
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
          "ColonistsMaxMoraleAlways",
          "Colonists",
          "Happy as a pig in shit",
          "UI/Icons/Sections/morale.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsMaxMoraleDefault"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Morale Default",
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
          "ColonistsMaxMoraleDefault",
          "Colonists",
          "Happy as a pig in shit",
          "UI/Icons/Sections/morale.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["ColonistsAddSpecializationToAll"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/[3]Stats/Add Specialization To All",
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

    ["ColonistsSetMoraleHigh"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/[3]Stats/Set Morale 100",
      description = "Set all Colonists Morale to 100",
      action = function()
        for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
          colonist.stat_morale = 100000
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsSetMoraleHigh",
          "Colonists",
          "Happy days are here again",
          "UI/Icons/Upgrades/home_collective_04.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsSetSanityHigh"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/[3]Stats/Set Sanity 100",
      description = "Set all Colonists Sanity to 100",
      action = function()
        for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
          colonist.stat_sanity = 100000
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsSetSanityHigh",
          "Colonists",
          "No need for shrinks",
          "UI/Icons/Upgrades/home_collective_04.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsSetComfortHigh"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/[3]Stats/Set Comfort 100",
      description = "Set all Colonists Comfort to 100",
      action = function()
        for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
          colonist.stat_comfort = 100000
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsSetComfortHigh",
          "Colonists",
          "Happy days are here again",
          "UI/Icons/Upgrades/home_collective_04.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsSetHealthHigh"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/[3]Stats/Set Health 100",
      description = "Set all Colonists Health to 100",
      action = function()
        for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
          colonist.stat_health = 100000
        end
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsSetHealthHigh",
          "Colonists",
          "Healthy!",
          "UI/Icons/Upgrades/home_collective_04.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["ColonistsSetAgesToChild"] = {
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Chance Of Sanity Damage Never",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Chance Of Sanity Damage Default",
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

    ["MeteorHealthDamage0"] = {
      mode = "Game",
      menu = "Gameplay/Meteors/Damage = 0",
      description = "Stops Meteor damage (not sure to what)",
      action = function()
        Consts.MeteorHealthDamage = 0
        CheatMenuSettings["MeteorHealthDamage"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "MeteorHealthDamage0",
          "Colonists",
          "Sticks and stones",
          "UI/Icons/Notifications/meteor_storm.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["MeteorHealthDamageDefault"] = {
      mode = "Game",
      menu = "Gameplay/Meteors/Damage = Default",
      description = "Default Meteor damage",
      action = function()
        Consts.MeteorHealthDamage = 50000
        CheatMenuSettings["MeteorHealthDamage"] = 50000
        WriteSettings()
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

    ["ColonistsChanceOfNegativeTraitNever"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Chance Of Negative Trait Never",
      description = "0% Chance of getting a negative trait when Sanity reaches zero.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.LowSanityNegativeTraitChance = 0
        CheatMenuSettings["LowSanityNegativeTraitChance"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsChanceOfNegativeTraitNever",
          "Colonists",
          "Stupid and happy",
          "UI/Icons/Sections/morale.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsChanceOfNegativeTraitDefault"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Chance Of Negative Trait Default",
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
          "Colonists",
          "Stupid and happy",
          "UI/Icons/Sections/morale.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsChanceOfSuicideNever"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Chance Of Suicide Never",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Chance Of Suicide Default",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Won't Suffocate",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Will Suffocate",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Won't Starve",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Will Starve",
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

    ["AvoidWorkplaceTrue"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Avoid Fired Workplace True",
      description = "After being fired, Colonists won't avoid that Workplace searching for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.AvoidWorkplaceSols = 0
        CheatMenuSettings["AvoidWorkplaceSols"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "AvoidWorkplaceTrue",
          "Colonists",
          "No Shame",
          "UI/Icons/Notifications/colonist.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["AvoidWorkplaceDefault"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Colonists Avoid Fired Workplace Default",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Positive Playground 100%",
      description = "100% Chance to get a perk when grown if colonist has visited a playground as a child.",
      action = function()
        Consts.positive_playground_chance = 1000
        CheatMenuSettings["positive_playground_chance"] = 1000
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "PositivePlayground100",
          "Colonists",
          "We've all seen them, on the playground, at the store, walking on the streets.",
          "UI/Icons/Upgrades/home_collective_02.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["PositivePlaygroundDefault"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Positive Playground Default",
      description = "Default Chance to get a perk when grown if colonist has visited a playground as a child.",
      action = function()
        Consts.positive_playground_chance = 100
        CheatMenuSettings["positive_playground_chance"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "PositivePlaygroundDefault",
          "Colonists",
          "We've all seen them, on the playground, at the store, walking on the streets.",
          "UI/Icons/Upgrades/home_collective_02.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ProjectMorpheusPositiveTrait100"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Project Morpheus Positive Trait 100%",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Project Morpheus Positive Trait Default",
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
      mode = "Game",
      menu = "Gameplay/Colonists/Performance Penalty Non-Specialist Never",
      description = "Performance penalty for non-Specialists = 0.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.NonSpecialistPerformancePenalty = 0
        --Consts.FounderPerformancePenalty = 0
        CheatMenuSettings["NonSpecialistPerformancePenalty"] = 0
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "PerformancePenaltyNonSpecialistNever",
          "Colonists",
          "You never know what you're gonna get.",
          "UI/Icons/Notifications/colonist.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["PerformancePenaltyNonSpecialistDefault"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Performance Penalty Non-Specialist Default",
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
          "Colonists",
          "You know what you're gonna get.",
          "UI/Icons/Notifications/colonist.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["OutsideWorkplaceRadiusLarge"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Outside Workplace Radius Large",
      description = "Colonists search 256 hexes outside their Dome when looking for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.DefaultOutsideWorkplacesRadius = 256
        CheatMenuSettings["DefaultOutsideWorkplacesRadius"] = 256
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "OutsideWorkplaceRadiusLarge",
          "Colonists",
          "Maybe tomorrow, I値l find what I call home. Until tomorrow, you know I知 free to roam.",
          "UI/Icons/Sections/dome.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["OutsideWorkplaceRadiusDefault"] = {
      mode = "Game",
      menu = "Gameplay/Colonists/Outside Workplace Radius Default",
      description = "Colonists search 10 hexes outside their Dome when looking for a Workplace.    Only works on colonists that have yet to spawn (maybe).",
      action = function()
        Consts.DefaultOutsideWorkplacesRadius = 10
        CheatMenuSettings["DefaultOutsideWorkplacesRadius"] = 10
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "OutsideWorkplaceRadiusDefault",
          "Colonists",
          "Maybe tomorrow, I値l find what I call home. Until tomorrow, you know I知 free to roam.",
          "UI/Icons/Sections/dome.tga",
          nil,
          {expiration=5000})
        )
      end
    },

    ["ColonistsPerRocket100"] = {
      mode = "Game",
      menu = "Gameplay/Rocket/Colonists Per Rocket 100",
      description = "100 colonists can arrive on Mars in a single Rocket.",
      action = function()
        Consts.MaxColonistsPerRocket = 100
        CheatMenuSettings["MaxColonistsPerRocket"] = 100
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsPerRocket100",
          "Rocket",
          "Long pig sardines",
          "UI/Icons/Notifications/colonist.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsPerRocket50"] = {
      mode = "Game",
      menu = "Gameplay/Rocket/Colonists Per Rocket 50",
      description = "50 colonists can arrive on Mars in a single Rocket.",
      action = function()
        Consts.MaxColonistsPerRocket = 50
        CheatMenuSettings["MaxColonistsPerRocket"] = 50
        WriteSettings()
        CreateRealTimeThread(AddCustomOnScreenNotification(
          "ColonistsPerRocket50",
          "Rocket",
          "Long pig sardines",
          "UI/Icons/Notifications/colonist.tga",
          nil,
          {expiration=5000})
        )
      end
    },
    ["ColonistsPerRocketDefault"] = {
      mode = "Game",
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
        CheatMenuSettings["MaxColonistsPerRocket"] = PerRocket
        WriteSettings()
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
    ["RocketCargoCapacityLarge"] = {
      mode = "Game",
      menu = "Gameplay/Rocket/Cargo Capacity Large",
      description = "+1,000,000,000",
      action = function()
        Consts.CargoCapacity = 1000000000
        CheatMenuSettings["CargoCapacity"] = 1000000000
        WriteSettings()
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
    ["RocketCargoCapacityDefault"] = {
      mode = "Game",
      menu = "Gameplay/Rocket/Cargo Capacity Default",
      action = function()
        local CargoCap = 50000
        if UICity:IsTechDiscovered("FuelCompression") then
          CargoCap = CargoCap + 10000
        end
        Consts.CargoCapacity = CargoCap
        CheatMenuSettings["CargoCapacity"] = CargoCap
        WriteSettings()
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

    ["RocketTravelInstant"] = {
      mode = "Game",
      menu = "Gameplay/Rocket/Travel Instant",
      description = "Instant travel between Earth and Mars.",
      action = function()
        Consts.TravelTimeEarthMars = 0
        Consts.TravelTimeMarsEarth = 0
        CheatMenuSettings["TravelTimeEarthMars"] = 0
        CheatMenuSettings["TravelTimeMarsEarth"] = 0
        WriteSettings()
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
    ["RocketTravelDefault"] = {
      mode = "Game",
      menu = "Gameplay/Rocket/Travel Default",
      description = "Default travel between Earth and Mars.",
      action = function()
        local TravelTime = 750000
        if UICity:IsTechDiscovered("PlasmaRocket") then
          TravelTime = 375000
        end
        Consts.TravelTimeEarthMars = TravelTime
        Consts.TravelTimeMarsEarth = TravelTime
        CheatMenuSettings["TravelTimeEarthMars"] = TravelTime
        CheatMenuSettings["TravelTimeMarsEarth"] = TravelTime
        WriteSettings()
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

    ["MaintenanceBuildingsFree"] = {
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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
      mode = "Game",
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

    ["PositiveTraitsAddAll"] = {
      mode = "Game",
      menu = "Gameplay/Traits/Positive Traits Add All",
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
      mode = "Game",
      menu = "Gameplay/Traits/Positive Traits Remove All",
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
        mode = "Game",
        menu = "Gameplay/Traits/Negative Traits Remove All",
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
        mode = "Game",
        menu = "Gameplay/Traits/Negative Traits Add All",
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

--bottom of menu
  })
end

-- Call init at the right time
function OnMsg.DataLoaded()
  --ReadSettings()
  InitCheats()
end
if not FirstLoad then
  InitCheats()
end
