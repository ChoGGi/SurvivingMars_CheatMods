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
  BirthThreshold = false,
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
  ChoGGi.SetConstsG("AvoidWorkplaceSols",ChoGGi.CheatMenuSettings.AvoidWorkplaceSols)
  ChoGGi.SetConstsG("BirthThreshold",ChoGGi.CheatMenuSettings.BirthThreshold)
  ChoGGi.SetConstsG("CargoCapacity",ChoGGi.CheatMenuSettings.CargoCapacity)
  ChoGGi.SetConstsG("ColdWaveSanityDamage",ChoGGi.CheatMenuSettings.ColdWaveSanityDamage)
  ChoGGi.SetConstsG("CommandCenterMaxDrones",ChoGGi.CheatMenuSettings.CommandCenterMaxDrones)
  ChoGGi.SetConstsG("Concrete_cost_modifier",ChoGGi.CheatMenuSettings.Concrete_cost_modifier)
  ChoGGi.SetConstsG("Concrete_dome_cost_modifier",ChoGGi.CheatMenuSettings.Concrete_dome_cost_modifier)
  ChoGGi.SetConstsG("CrimeEventDestroyedBuildingsCount",ChoGGi.CheatMenuSettings.CrimeEventDestroyedBuildingsCount)
  ChoGGi.SetConstsG("CrimeEventSabotageBuildingsCount ",ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount)
  ChoGGi.SetConstsG("CropFailThreshold",ChoGGi.CheatMenuSettings.CropFailThreshold)
  ChoGGi.SetConstsG("DeepScanAvailable",ChoGGi.CheatMenuSettings.DeepScanAvailable)
  ChoGGi.SetConstsG("DefaultOutsideWorkplacesRadius ",ChoGGi.CheatMenuSettings.DefaultOutsideWorkplacesRadius)
  ChoGGi.SetConstsG("DroneBuildingRepairAmount",ChoGGi.CheatMenuSettings.DroneBuildingRepairAmount)
  ChoGGi.SetConstsG("DroneBuildingRepairBatteryUse",ChoGGi.CheatMenuSettings.DroneBuildingRepairBatteryUse)
  ChoGGi.SetConstsG("DroneCarryBatteryUse",ChoGGi.CheatMenuSettings.DroneCarryBatteryUse)
  ChoGGi.SetConstsG("DroneConstructAmount",ChoGGi.CheatMenuSettings.DroneConstructAmount)
  ChoGGi.SetConstsG("DroneConstructBatteryUse",ChoGGi.CheatMenuSettings.DroneConstructBatteryUse)
  ChoGGi.SetConstsG("DroneDeconstructBatteryUse",ChoGGi.CheatMenuSettings.DroneDeconstructBatteryUse)
  ChoGGi.SetConstsG("DroneMeteorMalfunctionChance",ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance)
  ChoGGi.SetConstsG("DroneMoveBatteryUse",ChoGGi.CheatMenuSettings.DroneMoveBatteryUse)
  ChoGGi.SetConstsG("DroneRechargeTime",ChoGGi.CheatMenuSettings.DroneRechargeTime)
  ChoGGi.SetConstsG("DroneRepairSupplyLeak",ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak)
  ChoGGi.SetConstsG("DroneResourceCarryAmount",ChoGGi.CheatMenuSettings.DroneResourceCarryAmount)
  ChoGGi.SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse",ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileBatteryUse)
  ChoGGi.SetConstsG("DustStormSanityDamage",ChoGGi.CheatMenuSettings.DustStormSanityDamage)
  ChoGGi.SetConstsG("Electronics_cost_modifier",ChoGGi.CheatMenuSettings.Electronics_cost_modifier)
  ChoGGi.SetConstsG("Electronics_dome_cost_modifier",ChoGGi.CheatMenuSettings.Electronics_dome_cost_modifier)
  ChoGGi.SetConstsG("FoodPerRocketPassenger",ChoGGi.CheatMenuSettings.FoodPerRocketPassenger)
  ChoGGi.SetConstsG("HighStatLevel",ChoGGi.CheatMenuSettings.HighStatLevel)
  ChoGGi.SetConstsG("HighStatMoraleEffect",ChoGGi.CheatMenuSettings.HighStatMoraleEffect)
  ChoGGi.SetConstsG("InstantCables",ChoGGi.CheatMenuSettings.InstantCables)
  ChoGGi.SetConstsG("InstantPipes",ChoGGi.CheatMenuSettings.InstantPipes)
  ChoGGi.SetConstsG("IsDeepMetalsExploitable",ChoGGi.CheatMenuSettings.IsDeepMetalsExploitable)
  ChoGGi.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.CheatMenuSettings.IsDeepPreciousMetalsExploitable)
  ChoGGi.SetConstsG("IsDeepWaterExploitable",ChoGGi.CheatMenuSettings.IsDeepWaterExploitable)
  ChoGGi.SetConstsG("LowSanityNegativeTraitChance",ChoGGi.CheatMenuSettings.LowSanityNegativeTraitChance)
  ChoGGi.SetConstsG("LowSanitySuicideChance",ChoGGi.CheatMenuSettings.LowSanitySuicideChance)
  ChoGGi.SetConstsG("LowStatLevel",ChoGGi.CheatMenuSettings.LowStatLevel)
  ChoGGi.SetConstsG("MachineParts_cost_modifier",ChoGGi.CheatMenuSettings.MachineParts_cost_modifier)
  ChoGGi.SetConstsG("MachineParts_dome_cost_modifier",ChoGGi.CheatMenuSettings.MachineParts_dome_cost_modifier)
  ChoGGi.SetConstsG("MaxColonistsPerRocket",ChoGGi.CheatMenuSettings.MaxColonistsPerRocket)
  ChoGGi.SetConstsG("Metals_cost_modifier",ChoGGi.CheatMenuSettings.Metals_cost_modifier)
  ChoGGi.SetConstsG("Metals_dome_cost_modifier",ChoGGi.CheatMenuSettings.Metals_dome_cost_modifier)
  ChoGGi.SetConstsG("MeteorHealthDamage",ChoGGi.CheatMenuSettings.MeteorHealthDamage)
  ChoGGi.SetConstsG("MeteorSanityDamage",ChoGGi.CheatMenuSettings.MeteorSanityDamage)
  ChoGGi.SetConstsG("MinComfortBirth",ChoGGi.CheatMenuSettings.MinComfortBirth)
  ChoGGi.SetConstsG("MysteryDreamSanityDamage",ChoGGi.CheatMenuSettings.MysteryDreamSanityDamage)
  ChoGGi.SetConstsG("NoHomeComfort",ChoGGi.CheatMenuSettings.NoHomeComfort)
  ChoGGi.SetConstsG("NonSpecialistPerformancePenalty",ChoGGi.CheatMenuSettings.NonSpecialistPerformancePenalty)
  ChoGGi.SetConstsG("OutsourceResearch",ChoGGi.CheatMenuSettings.OutsourceResearch)
  ChoGGi.SetConstsG("OutsourceResearchCost",ChoGGi.CheatMenuSettings.OutsourceResearchCost)
  ChoGGi.SetConstsG("OxygenMaxOutsideTime",ChoGGi.CheatMenuSettings.OxygenMaxOutsideTime)
  ChoGGi.SetConstsG("PipesPillarSpacing",ChoGGi.CheatMenuSettings.PipesPillarSpacing)
  ChoGGi.SetConstsG("Polymers_cost_modifier",ChoGGi.CheatMenuSettings.Polymers_cost_modifier)
  ChoGGi.SetConstsG("Polymers_dome_cost_modifier",ChoGGi.CheatMenuSettings.Polymers_dome_cost_modifier)
  ChoGGi.SetConstsG("positive_playground_chance",ChoGGi.CheatMenuSettings.positive_playground_chance)
  ChoGGi.SetConstsG("PreciousMetals_cost_modifier",ChoGGi.CheatMenuSettings.PreciousMetals_cost_modifier)
  ChoGGi.SetConstsG("PreciousMetals_dome_cost_modifier",ChoGGi.CheatMenuSettings.PreciousMetals_dome_cost_modifier)
  ChoGGi.SetConstsG("ProjectMorphiousPositiveTraitChance",ChoGGi.CheatMenuSettings.ProjectMorphiousPositiveTraitChance)
  ChoGGi.SetConstsG("RCRoverDroneRechargeCost",ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost)
  ChoGGi.SetConstsG("RCRoverMaxDrones",ChoGGi.CheatMenuSettings.RCRoverMaxDrones)
  ChoGGi.SetConstsG("RCRoverTransferResourceWorkTime",ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime)
  ChoGGi.SetConstsG("RCTransportGatherResourceWorkTime",ChoGGi.CheatMenuSettings.RCTransportGatherResourceWorkTime)
  ChoGGi.SetConstsG("rebuild_cost_modifier",ChoGGi.CheatMenuSettings.rebuild_cost_modifier)
  ChoGGi.SetConstsG("RenegadeCreation",ChoGGi.CheatMenuSettings.RenegadeCreation)
  ChoGGi.SetConstsG("SeeDeadSanity",ChoGGi.CheatMenuSettings.SeeDeadSanity)
  ChoGGi.SetConstsG("TimeBeforeStarving",ChoGGi.CheatMenuSettings.TimeBeforeStarving)
  ChoGGi.SetConstsG("TravelTimeEarthMars",ChoGGi.CheatMenuSettings.TravelTimeEarthMars)
  ChoGGi.SetConstsG("TravelTimeMarsEarth",ChoGGi.CheatMenuSettings.TravelTimeMarsEarth)
  ChoGGi.SetConstsG("VisitFailPenalty",ChoGGi.CheatMenuSettings.VisitFailPenalty)
--const.
  const.BreakThroughTechsPerGame = ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame
  const.ExplorationQueueMaxSize = ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize
  const.fastGameSpeed = ChoGGi.CheatMenuSettings.fastGameSpeed
  const.mediumGameSpeed = ChoGGi.CheatMenuSettings.mediumGameSpeed
  const.MoistureVaporatorPenaltyPercent = ChoGGi.CheatMenuSettings.MoistureVaporatorPenaltyPercent
  const.MoistureVaporatorRange = ChoGGi.CheatMenuSettings.MoistureVaporatorRange
  const.ResearchQueueSize = ChoGGi.CheatMenuSettings.ResearchQueueSize
end

--called everytime we set a setting in menu
function ChoGGi.WriteSettings()

    local file = ChoGGi.SettingsFile
    local bak = file .. ".bak"

    ThreadLockKey(bak)
    AsyncCopyFile(file,bak)
    ThreadUnlockKey(bak)

    ThreadLockKey(file)
    local err = AsyncStringToFile(file,TableToLuaCode(ChoGGi.CheatMenuSettings))
    ThreadUnlockKey(file)
    if err then
      print("once", "Failed to save a settings to", file, ":", err)
      return false, err
    end

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
end
