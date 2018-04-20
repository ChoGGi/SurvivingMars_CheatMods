--stores default values and some tables

--for increasing school/sanatorium traits and adding/removing traits funcs
ChoGGi.NegativeTraits = {"Alcoholic","Glutton","Lazy","Refugee","ChronicCondition","Infected","Idiot","Hypochondriac","Whiner","Renegade","Melancholic","Introvert","Coward","Tourist","Gambler"}
ChoGGi.PositiveTraits = {"Workaholic","Survivor","Sexy","Composed","Genius","Celebrity","Saint","Religious","Gamer","DreamerPostMystery","Empath","Nerd","Rugged","Fit","Enthusiast","Hippie","Extrovert","Martianborn"}
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
ChoGGi.ColonistAges = {"Child","Youth","Adult","Middle Aged","Senior","Retiree"}
ChoGGi.ColonistGenders = {"OtherGender","Android","Clone","Male","Female"}
ChoGGi.ColonistSpecializations = {"scientist","engineer","security","geologist","botanist","medic"}
--display names only!
ChoGGi.ColonistRaces = {"White","Black","Asian","Indian","Southeast Asian"}

--stores defaults and constants
ChoGGi.Consts = {

  --defaults:
  _VERSION = 0,
  BuildingsCapacity = {},
  BuildingsProduction = {},
  ConsoleDim = true,
  ConsoleToggleHistory = true,
  FirstRun = true,
  InfopanelCheats = true,
  CleanupCheatsInfoPane = true,
  ShowInterfaceInScreenshots = true,
  NumberKeysBuildMenu = true,
--false
  DroneFactoryBuildSpeed = false,
  DisableHints = false,
  BreakChanceCablePipe = false,
  SanatoriumSchoolShowAll = false,
  AddMysteryBreakthroughBuildings = false,
  BorderScrollingArea = false,
  BorderScrollingToggle = false,
  Building_dome_forbidden = false,
  Building_dome_required = false,
  Building_dome_spot = false,
  Building_hide_from_build_menu = false,
  Building_instant_build = false,
  Building_is_tall = false,
  Building_wonder = false,
  CameraZoomToggle = false,
  FullyAutomatedBuildings = false,
  GravityColonist = false,
  GravityDrone = false,
  GravityRC = false,
  DisableTextureCompression = false,
  ShadowmapSize = false,
  HigherRenderDist = false,
  HigherShadowDist = false,
  NewColonistAge = false,
  NewColonistGender = false,
  NewColonistRace = false,
  NewColonistSpecialization = false,
  NewColonistTraits = false,
  RemoveBuildingLimits = false,
  RemoveMaintenanceBuildUp = false,
  SanatoriumCureAll = false,
  SchoolTrainAll = false,
  ShowAllTraits = false,
  ShowMysteryMsgs = false,
  SpeedShuttle = false,
  SpeedDrone = false,
  CapacityShuttle = false,
  WriteLogs = false,
--sponsor/commander bonuses
  CommanderInventor = false,
  CommanderOligarch = false,
  CommanderHydroEngineer = false,
  CommanderDoctor = false,
  CommanderPolitician = false,
  CommanderAuthor = false,
  CommanderEcologist = false,
  CommanderAstrogeologist = false,
  SponsorNASA = false,
  SponsorBlueSun = false,
  SponsorCNSA = false,
  SponsorISRO = false,
  SponsorESA = false,
  SponsorSpaceY = false,
  SponsorNewArk = false,
  SponsorRoscosmos = false,
  SponsorParadox = false,

--constants:
  FullyAutomatedBuildingsPerf = 100,
  RCTransportStorageCapacity = 30000,
  StorageUniversalDepot = 30000,
  StorageOtherDepot = 180000,
  StorageWasteDepot = 70000,
  ResidenceMaxHeight = 256,
--const. (I don't think these have default values in-game anywhere, so I can't get the defaults)
  BreakThroughTechsPerGame = 13,
  ExplorationQueueMaxSize = 10,
  fastGameSpeed = 5,
  mediumGameSpeed = 3,
  MoistureVaporatorPenaltyPercent = 40,
  MoistureVaporatorRange = 5,
  ResearchQueueSize = 4,
  ResourceScale = 1000,
  ResearchPointsScale = 1000,
--Consts. (Consts. is a prop object, so we get the default with ReadSettingsInGame).
  AvoidWorkplaceSols = false,
  CargoCapacity = false,
  ColdWaveSanityDamage = false,
  CommandCenterMaxDrones = false,
  Concrete_cost_modifier = false,
  Concrete_dome_cost_modifier = false,
  CrimeEventDestroyedBuildingsCount = false,
  CrimeEventSabotageBuildingsCount = false,
  CropFailThreshold = false,
  DeepScanAvailable = false,
  DefaultOutsideWorkplacesRadius = false,
  DroneBuildingRepairAmount = false,
  DroneBuildingRepairBatteryUse = false,
  DroneCarryBatteryUse = false,
  DroneConstructAmount = false,
  DroneConstructBatteryUse = false,
  DroneDeconstructBatteryUse = false,
  DroneMeteorMalfunctionChance = false,
  DroneMoveBatteryUse = false,
  DroneRechargeTime = false,
  DroneRepairSupplyLeak = false,
  DroneResourceCarryAmount = false,
  DroneTransformWasteRockObstructorToStockpileBatteryUse = false,
  DustStormSanityDamage = false,
  Electronics_cost_modifier = false,
  Electronics_dome_cost_modifier = false,
  FoodPerRocketPassenger = false,
  HighStatLevel = false,
  HighStatMoraleEffect = false,
  InstantCables = false,
  InstantPipes = false,
  IsDeepMetalsExploitable = false,
  IsDeepPreciousMetalsExploitable = false,
  IsDeepWaterExploitable = false,
  LowSanityNegativeTraitChance = false,
  LowSanitySuicideChance = false,
  LowStatLevel = false,
  MachineParts_cost_modifier = false,
  MachineParts_dome_cost_modifier = false,
  MaxColonistsPerRocket = false,
  Metals_cost_modifier = false,
  Metals_dome_cost_modifier = false,
  MeteorHealthDamage = false,
  MeteorSanityDamage = false,
  MinComfortBirth = false,
  MysteryDreamSanityDamage = false,
  NoHomeComfort = false,
  NonSpecialistPerformancePenalty = false,
  OutsourceResearch = false,
  OutsourceResearchCost = false,
  OxygenMaxOutsideTime = false,
  PipesPillarSpacing = false,
  Polymers_cost_modifier = false,
  Polymers_dome_cost_modifier = false,
  positive_playground_chance = false,
  PreciousMetals_cost_modifier = false,
  PreciousMetals_dome_cost_modifier = false,
  ProjectMorphiousPositiveTraitChance = false,
  RCRoverDroneRechargeCost = false,
  RCRoverMaxDrones = false,
  RCRoverTransferResourceWorkTime = false,
  RCTransportGatherResourceWorkTime = false,
  rebuild_cost_modifier = false,
  RenegadeCreation = false,
  SeeDeadSanity = false,
  TimeBeforeStarving = false,
  TravelTimeEarthMars = false,
  TravelTimeMarsEarth = false,
  VisitFailPenalty = false,
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
  Consts.CrimeEventSabotageBuildingsCount  = ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount
  Consts.CropFailThreshold = ChoGGi.CheatMenuSettings.CropFailThreshold
  Consts.DeepScanAvailable = ChoGGi.CheatMenuSettings.DeepScanAvailable
  Consts.DefaultOutsideWorkplacesRadius  = ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius
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
  Consts.InstantCables = ChoGGi.CheatMenuSettings.InstantCables
  Consts.InstantPipes = ChoGGi.CheatMenuSettings.InstantPipes
  Consts.IsDeepMetalsExploitable = ChoGGi.CheatMenuSettings.IsDeepMetalsExploitable
  Consts.IsDeepPreciousMetalsExploitable = ChoGGi.CheatMenuSettings.IsDeepPreciousMetalsExploitable
  Consts.IsDeepWaterExploitable = ChoGGi.CheatMenuSettings.IsDeepWaterExploitable
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
  Consts.NoHomeComfort = ChoGGi.CheatMenuSettings.NoHomeComfort
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
  Consts.TimeBeforeStarving = ChoGGi.CheatMenuSettings.TimeBeforeStarving
  Consts.TravelTimeEarthMars = ChoGGi.CheatMenuSettings.TravelTimeEarthMars
  Consts.TravelTimeMarsEarth = ChoGGi.CheatMenuSettings.TravelTimeMarsEarth
  Consts.VisitFailPenalty = ChoGGi.CheatMenuSettings.VisitFailPenalty
--const.
  const.BreakThroughTechsPerGame = ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame
  const.ExplorationQueueMaxSize = ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize
  const.fastGameSpeed = ChoGGi.CheatMenuSettings.fastGameSpeed
  const.mediumGameSpeed = ChoGGi.CheatMenuSettings.mediumGameSpeed
  const.MoistureVaporatorPenaltyPercent = ChoGGi.CheatMenuSettings.MoistureVaporatorPenaltyPercent
  const.MoistureVaporatorRange = ChoGGi.CheatMenuSettings.MoistureVaporatorRange
  const.ResearchQueueSize = ChoGGi.CheatMenuSettings.ResearchQueueSize
end

--g_Consts. (sometimes it uses these instead, setting both just to be sure...also lazy)
function ChoGGi.SetGConstsToSaved()
  g_Consts.AvoidWorkplaceSols = ChoGGi.CheatMenuSettings.AvoidWorkplaceSols
  g_Consts.BirthThreshold = ChoGGi.CheatMenuSettings.BirthThreshold
  g_Consts.CargoCapacity = ChoGGi.CheatMenuSettings.CargoCapacity
  g_Consts.ColdWaveSanityDamage = ChoGGi.CheatMenuSettings.ColdWaveSanityDamage
  g_Consts.CommandCenterMaxDrones = ChoGGi.CheatMenuSettings.CommandCenterMaxDrones
  g_Consts.Concrete_cost_modifier = ChoGGi.CheatMenuSettings.Concrete_cost_modifier
  g_Consts.Concrete_dome_cost_modifier = ChoGGi.CheatMenuSettings.Concrete_dome_cost_modifier
  g_Consts.CrimeEventDestroyedBuildingsCount = ChoGGi.CheatMenuSettings.CrimeEventDestroyedBuildingsCount
  g_Consts.CrimeEventSabotageBuildingsCount  = ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount
  g_Consts.CropFailThreshold = ChoGGi.CheatMenuSettings.CropFailThreshold
  g_Consts.DeepScanAvailable = ChoGGi.CheatMenuSettings.DeepScanAvailable
  g_Consts.DefaultOutsideWorkplacesRadius  = ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius
  g_Consts.DroneBuildingRepairAmount = ChoGGi.CheatMenuSettings.DroneBuildingRepairAmount
  g_Consts.DroneBuildingRepairBatteryUse = ChoGGi.CheatMenuSettings.DroneBuildingRepairBatteryUse
  g_Consts.DroneCarryBatteryUse = ChoGGi.CheatMenuSettings.DroneCarryBatteryUse
  g_Consts.DroneConstructAmount = ChoGGi.CheatMenuSettings.DroneConstructAmount
  g_Consts.DroneConstructBatteryUse = ChoGGi.CheatMenuSettings.DroneConstructBatteryUse
  g_Consts.DroneDeconstructBatteryUse = ChoGGi.CheatMenuSettings.DroneDeconstructBatteryUse
  g_Consts.DroneMeteorMalfunctionChance = ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance
  g_Consts.DroneMoveBatteryUse = ChoGGi.CheatMenuSettings.DroneMoveBatteryUse
  g_Consts.DroneRechargeTime = ChoGGi.CheatMenuSettings.DroneRechargeTime
  g_Consts.DroneRepairSupplyLeak = ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak
  g_Consts.DroneResourceCarryAmount = ChoGGi.CheatMenuSettings.DroneResourceCarryAmount
  g_Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse = ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileBatteryUse
  g_Consts.DustStormSanityDamage = ChoGGi.CheatMenuSettings.DustStormSanityDamage
  g_Consts.Electronics_cost_modifier = ChoGGi.CheatMenuSettings.Electronics_cost_modifier
  g_Consts.Electronics_dome_cost_modifier = ChoGGi.CheatMenuSettings.Electronics_dome_cost_modifier
  g_Consts.FoodPerRocketPassenger = ChoGGi.CheatMenuSettings.FoodPerRocketPassenger
  g_Consts.HighStatLevel = ChoGGi.CheatMenuSettings.HighStatLevel
  g_Consts.HighStatMoraleEffect = ChoGGi.CheatMenuSettings.HighStatMoraleEffect
  g_Consts.InstantCables = ChoGGi.CheatMenuSettings.InstantCables
  g_Consts.InstantPipes = ChoGGi.CheatMenuSettings.InstantPipes
  g_Consts.IsDeepMetalsExploitable = ChoGGi.CheatMenuSettings.IsDeepMetalsExploitable
  g_Consts.IsDeepPreciousMetalsExploitable = ChoGGi.CheatMenuSettings.IsDeepPreciousMetalsExploitable
  g_Consts.IsDeepWaterExploitable = ChoGGi.CheatMenuSettings.IsDeepWaterExploitable
  g_Consts.LowSanityNegativeTraitChance = ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance
  g_Consts.LowSanitySuicideChance = ChoGGi.CheatMenuSettings.LowSanitySuicideChance
  g_Consts.LowStatLevel = ChoGGi.CheatMenuSettings.LowStatLevel
  g_Consts.MachineParts_cost_modifier = ChoGGi.CheatMenuSettings.MachineParts_cost_modifier
  g_Consts.MachineParts_dome_cost_modifier = ChoGGi.CheatMenuSettings.MachineParts_dome_cost_modifier
  g_Consts.MaxColonistsPerRocket = ChoGGi.CheatMenuSettings.MaxColonistsPerRocket
  g_Consts.Metals_cost_modifier = ChoGGi.CheatMenuSettings.Metals_cost_modifier
  g_Consts.Metals_dome_cost_modifier = ChoGGi.CheatMenuSettings.Metals_dome_cost_modifier
  g_Consts.MeteorHealthDamage = ChoGGi.CheatMenuSettings.MeteorHealthDamage
  g_Consts.MeteorSanityDamage = ChoGGi.CheatMenuSettings.MeteorSanityDamage
  g_Consts.MinComfortBirth = ChoGGi.CheatMenuSettings.MinComfortBirth
  g_Consts.MysteryDreamSanityDamage = ChoGGi.CheatMenuSettings.MysteryDreamSanityDamage
  g_Consts.NoHomeComfort = ChoGGi.CheatMenuSettings.NoHomeComfort
  g_Consts.NonSpecialistPerformancePenalty = ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty
  g_Consts.OutsourceResearch = ChoGGi.CheatMenuSettings.OutsourceResearch
  g_Consts.OutsourceResearchCost = ChoGGi.CheatMenuSettings.OutsourceResearchCost
  g_Consts.OxygenMaxOutsideTime = ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime
  g_Consts.PipesPillarSpacing = ChoGGi.CheatMenuSettings.PipesPillarSpacing
  g_Consts.Polymers_cost_modifier = ChoGGi.CheatMenuSettings.Polymers_cost_modifier
  g_Consts.Polymers_dome_cost_modifier = ChoGGi.CheatMenuSettings.Polymers_dome_cost_modifier
  g_Consts.positive_playground_chance = ChoGGi.CheatMenuSettings.positive_playground_chance
  g_Consts.PreciousMetals_cost_modifier = ChoGGi.CheatMenuSettings.PreciousMetals_cost_modifier
  g_Consts.PreciousMetals_dome_cost_modifier = ChoGGi.CheatMenuSettings.PreciousMetals_dome_cost_modifier
  g_Consts.ProjectMorphiousPositiveTraitChance = ChoGGi.CheatMenuSettings.ProjectMorphiousPositiveTraitChance
  g_Consts.RCRoverDroneRechargeCost = ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost
  g_Consts.RCRoverMaxDrones = ChoGGi.CheatMenuSettings.RCRoverMaxDrones
  g_Consts.RCRoverTransferResourceWorkTime = ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime
  g_Consts.RCTransportGatherResourceWorkTime = ChoGGi.CheatMenuSettings.RCTransportGatherResourceWorkTime
  g_Consts.rebuild_cost_modifier = ChoGGi.CheatMenuSettings.rebuild_cost_modifier
  g_Consts.RenegadeCreation = ChoGGi.CheatMenuSettings.RenegadeCreation
  g_Consts.SeeDeadSanity = ChoGGi.CheatMenuSettings.SeeDeadSanity
  g_Consts.TimeBeforeStarving = ChoGGi.CheatMenuSettings.TimeBeforeStarving
  g_Consts.TravelTimeEarthMars = ChoGGi.CheatMenuSettings.TravelTimeEarthMars
  g_Consts.TravelTimeMarsEarth = ChoGGi.CheatMenuSettings.TravelTimeMarsEarth
  g_Consts.TravelTimeMarsEarth = ChoGGi.CheatMenuSettings.TravelTimeMarsEarth
  g_Consts.VisitFailPenalty = ChoGGi.CheatMenuSettings.VisitFailPenalty
  --needed for DroneResourceCarryAmount
  UpdateDroneResourceUnits()
end

--called everytime we set a setting in menu
function ChoGGi.WriteSettings()
  AsyncCopyFile(ChoGGi.SettingsFile,ChoGGi.SettingsFile .. ".bak")
  AsyncStringToFile(ChoGGi.SettingsFile,TableToLuaCode(ChoGGi.CheatMenuSettings))
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

end

--OptionsApply is the earliest we can call Consts:GetProperties()
function ChoGGi.Settings_OptionsApply()

  --get the default values for our Consts
  for _,DefaultValue in ipairs(Consts:GetProperties()) do
    for SettingName,_ in pairs(ChoGGi.Consts) do
      if SettingName == DefaultValue.id then
        ChoGGi.Consts[SettingName] = DefaultValue.default
      end
    end
  end

  --nil means we need to give it the default value (or errors eventuate)
  for Key,Value in pairs(ChoGGi.Consts) do
    if type(ChoGGi.CheatMenuSettings[Key]) == "nil" then
      ChoGGi.CheatMenuSettings[Key] = Value
    end
  end

  ChoGGi.SetConstsToSaved()
end
