--stores default values and some tables

--for increasing school/sanatorium traits and adding/removing traits funcs
ChoGGi.NegativeTraits = {"Vegan","Alcoholic","Glutton","Lazy","Refugee","ChronicCondition","Infected","Idiot","Hypochondriac","Whiner","Renegade","Melancholic","Introvert","Coward","Tourist","Gambler"}
ChoGGi.PositiveTraits = {"Workaholic","Survivor","Sexy","Composed","Genius","Celebrity","Saint","Religious","Gamer","DreamerPostMystery","Empath","Nerd","Rugged","Fit","Enthusiast","Hippie","Extrovert","Martianborn"}
--for mystery menu items
ChoGGi.MysteryDescription = {BlackCubeMystery = 1165,DiggersMystery = 1171,MirrorSphereMystery = 1185,DreamMystery = 1181,AIUprisingMystery = 1163,MarsgateMystery = 7306,WorldWar3 = 8073,TheMarsBug = 8068,UnitedEarthMystery = 8071}
ChoGGi.MysteryDifficulty = {BlackCubeMystery = 1164,DiggersMystery = 1170,MirrorSphereMystery = 1184,DreamMystery = 1180,AIUprisingMystery = 1162,MarsgateMystery = 8063,WorldWar3 = 8072,TheMarsBug = 8067,UnitedEarthMystery = 8070}
ChoGGi.ColonistAges = {"Child","Youth","Adult","Middle Aged","Senior","Retiree"}
ChoGGi.ColonistGenders = {"OtherGender","Android","Clone","Male","Female"}
ChoGGi.ColonistSpecializations = {"scientist","engineer","security","geologist","botanist","medic"}
--display names only! (stored as numbers, not names like the rest; which is why i guessed)
ChoGGi.ColonistRaces = {"White","Black","Asian","Indian","Southeast Asian"}
--Some names need to be fixed when doing construction placement
ChoGGi.ConstructionNamesListFix = {
  RCRover = "RCRoverBuilding",
  RCDesireTransport = "RCDesireTransportBuilding",
  RCTransport = "RCTransportBuilding",
  ExplorerRover = "RCExplorerBuilding",
  Rocket = "SupplyRocket"
  }
if #const.SchoolTraits ~= 5 then
  ChoGGi.Defaults.SchoolTraits = {"Nerd","Composed","Enthusiast","Religious","Survivor"}
else
  ChoGGi.Defaults.SchoolTraits = const.SchoolTraits
end
if #const.SanatoriumTraits ~= 7 then
  ChoGGi.Defaults.SanatoriumTraits = {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
else
  ChoGGi.Defaults.SanatoriumTraits = const.SanatoriumTraits
end
if ChoGGi.Testing then
  local startT = "<color 255 0 0>"
  local endT = " is different length</color>"
  if #const.SchoolTraits ~= 5 then
    table.insert(ChoGGi.StartupMsgs,startT .. "SchoolTraits" .. endT)
  end
  if #const.SanatoriumTraits ~= 7 then
    table.insert(ChoGGi.StartupMsgs,startT .. "SanatoriumTraits" .. endT)
  end
  local fulllist = TraitsCombo()
  if #fulllist ~= 55 then
    table.insert(ChoGGi.StartupMsgs,startT .. "TraitsCombo" .. endT)
  end
end

--stores defaults and constants
ChoGGi.Consts = {
  --defaults:
  _VERSION = 0,
  ConsoleDim = true,
  ConsoleToggleHistory = true,
  FirstRun = true,
  InfopanelCheats = true,
  CleanupCheatsInfoPane = true,
  ShowInterfaceInScreenshots = true,
  NumberKeysBuildMenu = true,
  UseLastOrientation = true,
  ShowCheatsMenu = true,
--stores custom settings for each building
  BuildingSettings = {},
  Transparency = {},
--false
  DroneResourceCarryAmountFix = false,
  TransparencyToggle = false,
  StorageMechanizedDepotsTemp = false,
  UnlimitedConnectionLength = false,
  SpeedDrone = false,
  SpeedRC = false,
  SpeedColonist = false,
  DisableHints = false,
  BreakChanceCablePipe = false,
  SanatoriumSchoolShowAll = false,
  BorderScrollingArea = false,
  Building_dome_spot = false,
  Building_hide_from_build_menu = false,
  Building_instant_build = false,
  Building_wonder = false,
  CameraZoomToggle = false,
  FullyAutomatedBuildings = false,
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
  ShowMysteryMsgs = false,
  WriteLogs = false,
--const. (I don't think these have default values in-game anywhere, so manually set them.) _GameConst.lua
  RCRoverDefaultRadius = 20,
  RCRoverMaxRadius = 20,
  CommandCenterDefaultRadius = 35,
  CommandCenterMaxRadius = 35,
  BreakThroughTechsPerGame = 13,
  OmegaTelescopeBreakthroughsCount = 3,
  ExplorationQueueMaxSize = 10,
  fastGameSpeed = 5,
  mediumGameSpeed = 3,
  MoistureVaporatorPenaltyPercent = 40,
  MoistureVaporatorRange = 5,
  ResearchQueueSize = 4,
  ResourceScale = 1000,
  ResearchPointsScale = 1000,
  guim = 100,
--Consts. (Consts. is a prop object, so we get the default with ReadSettingsInGame). _const.lua
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
  DroneTransformWasteRockObstructorToStockpileAmount = false,
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
  ChoGGi.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileAmount)
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
  local function setconst(con)
    if ChoGGi.CheatMenuSettings[con] then
      const[con] = ChoGGi.CheatMenuSettings[con]
    end
  end
  setconst("BreakThroughTechsPerGame")
  setconst("ExplorationQueueMaxSize")
  setconst("fastGameSpeed")
  setconst("mediumGameSpeed")
  setconst("MoistureVaporatorPenaltyPercent")
  setconst("MoistureVaporatorRange")
  setconst("ResearchQueueSize")
  setconst("RCRoverMaxRadius")
  setconst("CommandCenterMaxRadius")
  setconst("OmegaTelescopeBreakthroughsCount")
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

  --if our setting doesn't exist then make it false
  for Key,Value in pairs(ChoGGi.Consts) do
    if type(ChoGGi.CheatMenuSettings[Key]) == "nil" then
      ChoGGi.CheatMenuSettings[Key] = Value
    end
  end

  --then get the default values for our Consts
  for SettingName,_ in pairs(ChoGGi.Consts) do
    local setting = Consts:GetDefaultPropertyValue(SettingName)
    if setting then
      ChoGGi.Consts[SettingName] = setting
    end
  end

  --get other defaults not stored in Consts
  ChoGGi.Consts.DroneFactoryBuildSpeed = DroneFactory:GetDefaultPropertyValue("performance")
  ChoGGi.Consts.StorageShuttle = CargoShuttle:GetDefaultPropertyValue("max_shared_storage")
  ChoGGi.Consts.SpeedShuttle = CargoShuttle:GetDefaultPropertyValue("max_speed")
  ChoGGi.Consts.ShuttleHubCapacity = ShuttleHub:GetDefaultPropertyValue("max_shuttles")
  ChoGGi.Consts.GravityColonist = 0
  ChoGGi.Consts.GravityDrone = 0
  ChoGGi.Consts.GravityRC = 0
  ChoGGi.Consts.SpeedDrone = Drone:GetDefaultPropertyValue("move_speed")
  ChoGGi.Consts.SpeedRC = RCRover:GetDefaultPropertyValue("move_speed")
  ChoGGi.Consts.SpeedColonist = Colonist:GetDefaultPropertyValue("move_speed")
  ChoGGi.Consts.RCTransportStorageCapacity = RCTransport:GetDefaultPropertyValue("max_shared_storage")
  ChoGGi.Consts.StorageUniversalDepot = UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource")
  --ChoGGi.Consts.StorageWasteDepot = WasteRockDumpSite:GetDefaultPropertyValue("max_amount_WasteRock")
  ChoGGi.Consts.StorageWasteDepot = 70 * ChoGGi.Consts.ResourceScale --^ that has 45000 as default...
  ChoGGi.Consts.StorageOtherDepot = 180 * ChoGGi.Consts.ResourceScale
  ChoGGi.Consts.StorageMechanizedDepot = 3950 * ChoGGi.Consts.ResourceScale
  --^ they're all UniversalStorageDepot

  ChoGGi.Consts.CameraZoomToggle = 8000
  ChoGGi.Consts.HigherRenderDist = 120 --hr.LODDistanceModifier
end

function ChoGGi.Settings_ModsLoaded()

  --remove empty entries in BuildingSettings
  if next(ChoGGi.CheatMenuSettings.BuildingSettings) then
    --remove any empty building tables
    for Key,_ in pairs(ChoGGi.CheatMenuSettings.BuildingSettings) do
      if not next(ChoGGi.CheatMenuSettings.BuildingSettings[Key]) then
        ChoGGi.CheatMenuSettings.BuildingSettings[Key] = nil
      end
    end
  --if empty table then new settings file or old settings
  else
    --used to add old lists to new combined list
    local function AddOldSettings(OldCat,NewName)
      --is there anthing in the table?
      if type(ChoGGi.CheatMenuSettings[OldCat]) == "table" and next(ChoGGi.CheatMenuSettings[OldCat]) then
        --then loop through it
        for BuildingName,Value in pairs(ChoGGi.CheatMenuSettings[OldCat]) do
          --it likely doesn't exist, but check first and add a blank table
          if not ChoGGi.CheatMenuSettings.BuildingSettings[BuildingName] then
            ChoGGi.CheatMenuSettings.BuildingSettings[BuildingName] = {}
          end
          --add it to vistors list?
          if NewName == "capacity" and DataInstances.BuildingTemplate[BuildingName].max_visitors then
            ChoGGi.CheatMenuSettings.BuildingSettings[BuildingName].visitors = Value
          else
            ChoGGi.CheatMenuSettings.BuildingSettings[BuildingName][NewName] = Value
          end
        end
      end
      --remove old settings
      ChoGGi.CheatMenuSettings[OldCat] = nil
      --if not then we'll give an error msg for users
      return true
    end
    --then we check if this is an older version still using the old way of storing building settings and convert over to new
    local errormsg = "Error: Couldn't convert old settings to new settings: "
    if not AddOldSettings("BuildingsCapacity","capacity") then
      table.insert(ChoGGi.StartupMsgs,errormsg .. "BuildingsCapacity")
    end
    if not AddOldSettings("BuildingsProduction","production") then
      table.insert(ChoGGi.StartupMsgs,errormsg .. "BuildingsProduction")
    end
  end
  --only write for testing, as IO is probably slower then having to redo again
  if ChoGGi.Testing then
    ChoGGi.WriteSettings()
  end

end
