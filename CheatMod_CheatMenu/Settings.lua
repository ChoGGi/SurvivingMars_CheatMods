--stores default values and some tables

--for increasing school/sanatorium traits and adding/removing traits funcs
ChoGGi.NegativeTraits = {"Clone","Alcoholic","Glutton","Lazy","Refugee","ChronicCondition","Infected","Idiot","Hypochondriac","Whiner","Renegade","Melancholic","Introvert","Coward","Tourist","Gambler"}
ChoGGi.PositiveTraits = {"Workaholic","Survivor","Sexy","Composed","Genius","Celebrity","Saint","Religious","Gamer","DreamerPostMystery","Empath","Nerd","Rugged","Fit","Enthusiast","Hippie","Extrovert","Martianborn"}
--for add Colonist Specializations func
ChoGGi.ColonistSpecializations = {"scientist","engineer","security","geologist","botanist","medic"}
--for mystery menu items
ChoGGi.MysteryDescription = {BlackCubeMystery = 1165,DiggersMystery = 1171,MirrorSphereMystery = 1185,DreamMystery = 1181,AIUprisingMystery = 1163,MarsgateMystery = 7306,WorldWar3 = 8073,TheMarsBug = 8068,UnitedEarthMystery = 8071}
ChoGGi.MysteryDifficulty = {
    BlackCubeMystery = 1164, --The Power of Three (Easy)
    DiggersMystery = 1170, --The Dredgers (Normal)
    MirrorSphereMystery = 1184, --Spheres (Normal)
    DreamMystery = 1180, --Inner Light (Easy)
    AIUprisingMystery = 1162, --Artificial Intelligence (Normal)
    MarsgateMystery = 8063, --Marsgate (Hard)
    WorldWar3 = 8072, --The Last War (Hard)
    TheMarsBug = 8067, --Wildfire (Hard)
    UnitedEarthMystery = 8070 --Beyond Earth (Easy)
  }
--Some names need to be fixed when doing construction placement
ChoGGi.ConstructionNamesListFix = {
  RCRover = "RCRoverBuilding",
  RCDesireTransport = "RCDesireTransportBuilding",
  RCTransport = "RCTransportBuilding",
  ExplorerRover = "RCExplorerBuilding",
  Rocket = "SupplyRocket"
  }
ChoGGi.ConstructionErrors = {}
ChoGGi.ConstructionErrors["Blocking objects"] = 1
ChoGGi.ConstructionErrors["Requires a Dome"] = 1
ChoGGi.ConstructionErrors["Unbuildable area"] = 1
ChoGGi.ConstructionErrors["Outside building"] = 1
ChoGGi.ConstructionErrors["Too tall"] = 1
ChoGGi.ConstructionErrors["Too long"] = 1
ChoGGi.ConstructionErrors["Too far from Domes"] = 1
ChoGGi.ConstructionErrors["Too far"] = 1
ChoGGi.ConstructionErrors["Can't Land"] = 1

--central place for consts/default values, if updates change them
ChoGGi.Consts = {
  _VERSION = 0.0,
--custom
  BuildingsCapacity = {},
  BuildingsProduction = {},
  FirstRun = true,
  ConsoleToggleHistory = true,
  ToggleInfopanelCheats = true,
  ConsoleDim = true,
  HigherRenderDist = true,
  HigherShadowDist = true,
  WriteLogs = false,
  FullyAutomatedBuildings = false,
  AddMysteryBreakthroughBuildings = false,
  BorderScrollingToggle = false,
  CameraZoomToggle = false,
  Building_hide_from_build_menu = false,
  Building_wonder = false,
  Building_dome_spot = false,
  Building_dome_forbidden = false,
  Building_dome_required = false,
  Building_is_tall = false,
  Building_instant_build = false,
  NewColonistAge = false,
  NewColonistSex = false,
  SanatoriumCureAll = false,
  SchoolTrainAll = false,
  ShowAllTraits = false,
  ShowMysteryMsgs = false,
  RemoveBuildingLimits = false,
  RemoveMaintenanceBuildUp = false,
  developer = false,
  ShuttleSpeed = false,
  ShuttleStorage = false,
  GravityDrone = false,
  GravityRC = false,
  GravityColonist = false,
--custom Consts
  ProductionAddAmount = 25000,
  AirWaterAddAmount = 1000000,
  BatteryAddAmount = 1000000,
  ShuttleAddAmount = 25,
  TrainersAddAmount = 16,
  ResidenceAddAmount = 16,
  ResidenceMaxHeight = 256,
  RCTransportStorage = 30000,
  --StorageUniversalDepot = 30000,
  --StorageOtherDepot = 180000,
  --StorageWasteDepot = 70000,
  RCTransportResourceCapacity = 30,
--Consts.
  AvoidWorkplaceSols = 5,
  BirthThreshold = 1000000,
  CargoCapacity = 50000,
  ColdWaveSanityDamage = 300,
  CommandCenterMaxDrones = 20,
  Concrete_cost_modifier = 0,
  Concrete_dome_cost_modifier = 0,
  CrimeEventDestroyedBuildingsCount = 1,
  CrimeEventSabotageBuildingsCount = 1,
  DeepScanAvailable = 0,
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
  DroneResourceCarryAmount = 1,
  DroneTransformWasteRockObstructorToStockpileBatteryUse = 100,
  DustStormSanityDamage = 300,
  Electronics_cost_modifier = 0,
  Electronics_dome_cost_modifier = 0,
  FoodPerRocketPassenger = 10000,
  HighStatLevel = 70000,
  HighStatMoraleEffect = 5000,
  CropFailThreshold = 25,
  InstantCables = 0,
  InstantPipes = 0,
  IsDeepMetalsExploitable = 0,
  IsDeepPreciousMetalsExploitable = 0,
  IsDeepWaterExploitable = 0,
  LowSanityNegativeTraitChance = 30,
  LowSanitySuicideChance = 1,
  LowStatLevel = 30000,
  MachineParts_cost_modifier = 0,
  MachineParts_dome_cost_modifier = 0,
  MaxColonistsPerRocket = 12,
  Metals_cost_modifier = 0,
  Metals_dome_cost_modifier = 0,
  MeteorHealthDamage = 50000,
  MeteorSanityDamage = 12000,
  MinComfortBirth = 70000,
  MysteryDreamSanityDamage = 500,
  NonSpecialistPerformancePenalty = 50,
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
  RCRoverMaxDrones = 8,
  RCRoverTransferResourceWorkTime = 1000,
  RCTransportGatherResourceWorkTime = 15000,
  rebuild_cost_modifier = 100,
  RenegadeCreation = 70000,
  SeeDeadSanity = 15000,
  NoHomeComfort = 20000,
  TimeBeforeStarving = 1080000,
  TravelTimeEarthMars = 750000,
  TravelTimeMarsEarth = 750000,
  VisitFailPenalty = 10000,
--const.
  BreakThroughTechsPerGame = 13,
  ExplorationQueueMaxSize = 10,
  fastGameSpeed = 5,
  mediumGameSpeed = 3,
  MoistureVaporatorPenaltyPercent = 40,
  MoistureVaporatorRange = 5,
  ResearchQueueSize = 4,
  ResourceScale = 1000,
}

--set game values to saved values
function ChoGGi.SetConstsToSaved()
--Consts.
  Consts.AvoidWorkplaceSols = ChoGGi.CheatMenuSettings.AvoidWorkplaceSols
  Consts.BirthThreshold = ChoGGi.CheatMenuSettings.BirthThreshold
  Consts.CargoCapacity = ChoGGi.CheatMenuSettings.CargoCapacity
  Consts.ColdWaveSanityDamage = ChoGGi.CheatMenuSettings.ColdWaveSanityDamage
  Consts.CommandCenterMaxDrones = ChoGGi.CheatMenuSettings.CommandCenterMaxDrones
  Consts.Concrete_cost_modifier = ChoGGi.CheatMenuSettings.Concrete_cost_modifier
  Consts.Concrete_dome_cost_modifier = ChoGGi.CheatMenuSettings.Concrete_dome_cost_modifier
  Consts.CrimeEventDestroyedBuildingsCount = ChoGGi.CheatMenuSettings.CrimeEventDestroyedBuildingsCount
  Consts.CrimeEventSabotageBuildingsCount = ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount
  Consts.DefaultOutsideWorkplacesRadius = ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius
  Consts.DeepScanAvailable = ChoGGi.CheatMenuSettings.DeepScanAvailable
  Consts.DroneBuildingRepairAmount = ChoGGi.CheatMenuSettings.DroneBuildingRepairAmount
  Consts.DroneBuildingRepairBatteryUse = ChoGGi.CheatMenuSettings.DroneBuildingRepairBatteryUse
  Consts.DroneCarryBatteryUse = ChoGGi.CheatMenuSettings.DroneCarryBatteryUse
  Consts.DroneConstructAmount = ChoGGi.CheatMenuSettings.DroneConstructAmount
  Consts.DroneConstructBatteryUse = ChoGGi.CheatMenuSettings.DroneConstructBatteryUse
  Consts.DroneDeconstructBatteryUse = ChoGGi.CheatMenuSettings.DroneDeconstructBatteryUse
  Consts.DroneMeteorMalfunctionChance = ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance
  Consts.DroneMoveBatteryUse = ChoGGi.CheatMenuSettings.DroneMoveBatteryUse
  Consts.DroneRechargeTime = ChoGGi.CheatMenuSettings.DroneRechargeTime
  Consts.DroneRepairSupplyLeak = ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak
  Consts.DroneResourceCarryAmount = ChoGGi.CheatMenuSettings.DroneResourceCarryAmount
  Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileBatteryUse
  Consts.DustStormSanityDamage = ChoGGi.CheatMenuSettings.DustStormSanityDamage
  Consts.Electronics_cost_modifier = ChoGGi.CheatMenuSettings.Electronics_cost_modifier
  Consts.Electronics_dome_cost_modifier = ChoGGi.CheatMenuSettings.Electronics_dome_cost_modifier
  Consts.FoodPerRocketPassenger = ChoGGi.CheatMenuSettings.FoodPerRocketPassenger
  Consts.HighStatLevel = ChoGGi.CheatMenuSettings.HighStatLevel
  Consts.HighStatMoraleEffect = ChoGGi.CheatMenuSettings.HighStatMoraleEffect
  Consts.CropFailThreshold = ChoGGi.CheatMenuSettings.CropFailThreshold
  Consts.InstantCables = ChoGGi.CheatMenuSettings.InstantCables
  Consts.InstantPipes = ChoGGi.CheatMenuSettings.InstantPipes
  Consts.IsDeepWaterExploitable = ChoGGi.CheatMenuSettings.IsDeepWaterExploitable
  Consts.IsDeepMetalsExploitable = ChoGGi.CheatMenuSettings.IsDeepMetalsExploitable
  Consts.IsDeepPreciousMetalsExploitable = ChoGGi.CheatMenuSettings.IsDeepPreciousMetalsExploitable
  Consts.LowSanityNegativeTraitChance = ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance
  Consts.LowSanitySuicideChance = ChoGGi.CheatMenuSettings.LowSanitySuicideChance
  Consts.LowStatLevel = ChoGGi.CheatMenuSettings.LowStatLevel
  Consts.MachineParts_cost_modifier = ChoGGi.CheatMenuSettings.MachineParts_cost_modifier
  Consts.MachineParts_dome_cost_modifier = ChoGGi.CheatMenuSettings.MachineParts_dome_cost_modifier
  Consts.MaxColonistsPerRocket = ChoGGi.CheatMenuSettings.MaxColonistsPerRocket
  Consts.Metals_cost_modifier = ChoGGi.CheatMenuSettings.Metals_cost_modifier
  Consts.Metals_dome_cost_modifier = ChoGGi.CheatMenuSettings.Metals_dome_cost_modifier
  Consts.MeteorHealthDamage = ChoGGi.CheatMenuSettings.MeteorHealthDamage
  Consts.MeteorSanityDamage = ChoGGi.CheatMenuSettings.MeteorSanityDamage
  Consts.MinComfortBirth = ChoGGi.CheatMenuSettings.MinComfortBirth
  Consts.MysteryDreamSanityDamage = ChoGGi.CheatMenuSettings.MysteryDreamSanityDamage
  Consts.NonSpecialistPerformancePenalty = ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty
  Consts.OutsourceResearch = ChoGGi.CheatMenuSettings.OutsourceResearch
  Consts.OutsourceResearchCost = ChoGGi.CheatMenuSettings.OutsourceResearchCost
  Consts.OxygenMaxOutsideTime = ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime
  Consts.PipesPillarSpacing = ChoGGi.CheatMenuSettings.PipesPillarSpacing
  Consts.Polymers_cost_modifier = ChoGGi.CheatMenuSettings.Polymers_cost_modifier
  Consts.Polymers_dome_cost_modifier = ChoGGi.CheatMenuSettings.Polymers_dome_cost_modifier
  Consts.positive_playground_chance = ChoGGi.CheatMenuSettings.positive_playground_chance
  Consts.PreciousMetals_cost_modifier = ChoGGi.CheatMenuSettings.PreciousMetals_cost_modifier
  Consts.PreciousMetals_dome_cost_modifier = ChoGGi.CheatMenuSettings.PreciousMetals_dome_cost_modifier
  Consts.ProjectMorphiousPositiveTraitChance = ChoGGi.CheatMenuSettings.ProjectMorphiousPositiveTraitChance
  Consts.RCRoverDroneRechargeCost = ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost
  Consts.RCRoverMaxDrones = ChoGGi.CheatMenuSettings.RCRoverMaxDrones
  Consts.RCRoverTransferResourceWorkTime = ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime
  Consts.RCTransportGatherResourceWorkTime = ChoGGi.CheatMenuSettings.RCTransportGatherResourceWorkTime
  Consts.rebuild_cost_modifier = ChoGGi.CheatMenuSettings.rebuild_cost_modifier
  Consts.RenegadeCreation = ChoGGi.CheatMenuSettings.RenegadeCreation
  Consts.SeeDeadSanity = ChoGGi.CheatMenuSettings.SeeDeadSanity
  Consts.NoHomeComfort = ChoGGi.CheatMenuSettings.NoHomeComfort
  Consts.CropFailThreshold = ChoGGi.Consts.CropFailThreshold
  Consts.TimeBeforeStarving = ChoGGi.CheatMenuSettings.TimeBeforeStarving
  Consts.TravelTimeEarthMars = ChoGGi.CheatMenuSettings.TravelTimeEarthMars
  Consts.TravelTimeMarsEarth = ChoGGi.CheatMenuSettings.TravelTimeMarsEarth
  Consts.VisitFailPenalty = ChoGGi.CheatMenuSettings.VisitFailPenalty
--const.
  const.ExplorationQueueMaxSize = ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize
  const.fastGameSpeed = ChoGGi.CheatMenuSettings.fastGameSpeed
  const.mediumGameSpeed = ChoGGi.CheatMenuSettings.mediumGameSpeed
  const.MoistureVaporatorPenaltyPercent = ChoGGi.CheatMenuSettings.MoistureVaporatorPenaltyPercent
  const.MoistureVaporatorRange = ChoGGi.CheatMenuSettings.MoistureVaporatorRange
  const.ResearchQueueSize = ChoGGi.CheatMenuSettings.ResearchQueueSize
end

--called everytime we set a setting in menu
function ChoGGi.WriteSettings()
  AsyncStringToFile(ChoGGi.SettingsFile,TupleToLuaCode(ChoGGi.CheatMenuSettings))
end

--read saved settings from file
function ChoGGi.ReadSettings()
  local errormsg = "\n\nCheatMod_CheatMenu: Problem loading AppData/Surviving Mars/CheatMenuModSettings.lua\nIf you can delete it and still get this error; please send it and this log to the author.\n\n"

	local file_error, Settings = AsyncFileToString(ChoGGi.SettingsFile)
	if file_error then
    file_error = ""
    --no settings file so make a new one
    ChoGGi.WriteSettings()
    file_error, Settings = AsyncFileToString(ChoGGi.SettingsFile)
    if file_error then
      DebugPrint(errormsg)
      return file_error
    end
	end

  local code_error
  code_error, ChoGGi.CheatMenuSettings = LuaCodeToTuple(Settings)
	if code_error then
    DebugPrint(errormsg)
		return code_error
	end

  --if we have new settings not yet in SettingsFile, check for nil
  for Key,Value in pairs(ChoGGi.Consts) do
    if type(ChoGGi.CheatMenuSettings[Key]) == "nil" then
      --DebugPrint(tostring(Key) .. ": " .. tostring(Value) .. "\n")
      ChoGGi.CheatMenuSettings[Key] = Value
    end
  end

  --set consts to saved ones
  ChoGGi.SetConstsToSaved()
end

if ChoGGi.Testing then
  table.insert(ChoGGi.FilesCount,"Settings")
end
