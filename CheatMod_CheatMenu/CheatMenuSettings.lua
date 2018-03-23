SettingsFile = "AppData/CheatMenuModSettings.lua"

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
CheatMenuSettings = {
--Custom
  StorageDepotSpace = false,
  developer = false,
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
  MinComfortBirth = 70000,
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
  RenegadeCreation = 70000,
  TimeBeforeStarving = 1080000,
  VisitFailPenalty = 10000,
--const.
  ExplorationQueueMaxSize = 5,
  fastGameSpeed = 5,
  mediumGameSpeed = 3,
  MoistureVaporatorPenaltyPercent = 40,
  MoistureVaporatorRange = 5,
  ResearchQueueSize = 4,
}

--called everytime you set a setting
function WriteSettings()
  AsyncStringToFile(SettingsFile,TupleToLuaCode(CheatMenuSettings))
end

--get custom settings from file
function ReadSettings()
	if not SettingsFile then return end

	local file_error, code = AsyncFileToString(SettingsFile)
	if file_error then
		return file_error
	end

	local code_error
  code_error, CheatMenuSettings = LuaCodeToTuple(code)
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
  Consts.MinComfortBirth = CheatMenuSettings["MinComfortBirth"]
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
  Consts.RenegadeCreation = CheatMenuSettings["RenegadeCreation"]
  Consts.TimeBeforeStarving = CheatMenuSettings["TimeBeforeStarving"]
  Consts.TravelTimeEarthMars = CheatMenuSettings["TravelTimeEarthMars"]
  Consts.TravelTimeMarsEarth = CheatMenuSettings["TravelTimeMarsEarth"]
  Consts.VisitFailPenalty = CheatMenuSettings["VisitFailPenalty"]
--const.
  const.ExplorationQueueMaxSize = CheatMenuSettings["ExplorationQueueMaxSize"]
  const.fastGameSpeed = CheatMenuSettings["fastGameSpeed"]
  const.mediumGameSpeed = CheatMenuSettings["mediumGameSpeed"]
  const.MoistureVaporatorPenaltyPercent = CheatMenuSettings["MoistureVaporatorPenaltyPercent"]
  const.MoistureVaporatorRange = CheatMenuSettings["MoistureVaporatorRange"]
  const.ResearchQueueSize = CheatMenuSettings["ResearchQueueSize"]
end
