local cComFuncs = ChoGGi.ComFuncs
--stores default values and some tables

--useful lists
ChoGGi.Tables = {
  --for increasing school/sanatorium traits and adding/removing traits funcs
  NegativeTraits = {"Vegan","Alcoholic","Glutton","Lazy","Refugee","ChronicCondition","Infected","Idiot","Hypochondriac","Whiner","Renegade","Melancholic","Introvert","Coward","Tourist","Gambler"},
  PositiveTraits = {"Workaholic","Survivor","Sexy","Composed","Genius","Celebrity","Saint","Religious","Gamer","DreamerPostMystery","Empath","Nerd","Rugged","Fit","Enthusiast","Hippie","Extrovert","Martianborn"},
  --for mystery menu items
  MysteryDescription = {BlackCubeMystery = 1165,DiggersMystery = 1171,MirrorSphereMystery = 1185,DreamMystery = 1181,AIUprisingMystery = 1163,MarsgateMystery = 7306,WorldWar3 = 8073,TheMarsBug = 8068,UnitedEarthMystery = 8071,Mystery_1 = 1165,Mystery_2 = 1171,Mystery_3 = 1185,Mystery_4 = 1181,Mystery_5 = 1163,Mystery_6 = 7306,Mystery_7 = 8073,Mystery_8 = 8068,Mystery_9 = 8071},
  --name + diff
  MysteryDifficulty = {BlackCubeMystery = 1164,DiggersMystery = 1170,MirrorSphereMystery = 1184,DreamMystery = 1180,AIUprisingMystery = 1162,MarsgateMystery = 8063,WorldWar3 = 8072,TheMarsBug = 8067,UnitedEarthMystery = 8070,Mystery_1 = 1164,Mystery_2 = 1170,Mystery_3 = 1184,Mystery_4 = 1180,Mystery_5 = 1162,Mystery_6 = 8063,Mystery_7 = 8072,Mystery_8 = 8067,Mystery_9 = 8070},
  --it's stored as sometimes BlackCubeMystery or Mystery_1
  MysteryTrans = {Mystery_1 = "BlackCubeMystery",Mystery_2 = "DiggersMystery",Mystery_3 = "MirrorSphereMystery",Mystery_4 = "DreamMystery",Mystery_5 = "AIUprisingMystery",Mystery_6 = "MarsgateMystery",Mystery_7 = "WorldWar3",Mystery_8 = "TheMarsBug",Mystery_9 = "UnitedEarthMystery",BlackCubeMystery = "Mystery_1",DiggersMystery = "Mystery_2",MirrorSphereMystery = "Mystery_3",DreamMystery = "Mystery_4",AIUprisingMystery = "Mystery_5",MarsgateMystery = "Mystery_6",WorldWar3 = "Mystery_7",TheMarsBug = "Mystery_8",UnitedEarthMystery = "Mystery_9"},
  ColonistAges = {"Child","Youth","Adult","Middle Aged","Senior","Retiree"},
  ColonistGenders = {"OtherGender","Android","Clone","Male","Female"},
  ColonistSpecializations = {"scientist","engineer","security","geologist","botanist","medic"},
  --display names only! (stored as numbers, not names like the rest; which is why i guessed)
  ColonistRaces = {"White","Black","Asian","Indian","Southeast Asian"},
  --Some names need to be fixed when doing construction placement
  ConstructionNamesListFix = {
    RCRover = "RCRoverBuilding",
    RCDesireTransport = "RCDesireTransportBuilding",
    RCTransport = "RCTransportBuilding",
    ExplorerRover = "RCExplorerBuilding",
    Rocket = "SupplyRocket"
  },
  SchoolTraits = const.SchoolTraits,
  SanatoriumTraits = const.SanatoriumTraits,
}
local cTables = ChoGGi.Tables
if #const.SchoolTraits ~= 5 then
  cTables.SchoolTraits = {"Nerd","Composed","Enthusiast","Religious","Survivor"}
end
if #const.SanatoriumTraits ~= 7 then
  cTables.SanatoriumTraits = {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
end

--stores defaults and constants
ChoGGi.Defaults = {
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
  DebugGridSize = 10,
  DebugGridOpacity = 15,
--stores custom settings for each building
  BuildingSettings = {},
  Transparency = {},
--false
--[[
  DroneResourceCarryAmountFix = false,
  TransparencyToggle = false,
  StorageMechanizedDepotsTemp = false,
  UnlimitedConnectionLength = false,
  SpeedDrone = false,
  SpeedRC = false,
  SpeedColonist = false,
  DisableHints = false,
  BreakChanceCablePipe = false,
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
  --]]
}
local CDefaults = ChoGGi.Defaults

--and constants
ChoGGi.Consts = {
	LightmodelCustom = "PlaceObj('Lightmodel', {\n\t'name', \"ChoGGi_Custom\",\n\t'pp_bloom_strength', 100,\n\t'pp_bloom_threshold', 25,\n\t'pp_bloom_contrast', 75,\n\t'pp_bloom_colorization', 65,\n\t'pp_bloom_inner_tint', RGBA(187, 23, 146, 255),\n\t'pp_bloom_mip2_radius', 8,\n\t'pp_bloom_mip3_radius', 10,\n\t'pp_bloom_mip4_radius', 27,\n\t'exposure', -100,\n\t'gamma', RGBA(76, 76, 166, 255),\n})",

--const.* (I don't think these have default values in-game anywhere, so manually set them.) _GameConst.lua
  RCRoverMaxRadius = 20,
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
--Consts.* (Consts is a prop object, so we can get the defaults with ReadSettingsInGame below.) _const.lua
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
local cConsts = ChoGGi.Consts

--set game values to saved values
function ChoGGi.SettingFuncs.SetConstsToSaved()
  local UserSettings = ChoGGi.UserSettings
--Consts.
  local function SetConstsG(Name)
    cComFuncs.SetConstsG(Name,UserSettings[Name])
  end
  SetConstsG("AvoidWorkplaceSols")
  SetConstsG("BirthThreshold")
  SetConstsG("CargoCapacity")
  SetConstsG("ColdWaveSanityDamage")
  SetConstsG("CommandCenterMaxDrones")
  SetConstsG("Concrete_cost_modifier")
  SetConstsG("Concrete_dome_cost_modifier")
  SetConstsG("CrimeEventDestroyedBuildingsCount")
  SetConstsG("CrimeEventSabotageBuildingsCount ")
  SetConstsG("CropFailThreshold")
  SetConstsG("DeepScanAvailable")
  SetConstsG("DefaultOutsideWorkplacesRadius")
  SetConstsG("DroneBuildingRepairAmount")
  SetConstsG("DroneBuildingRepairBatteryUse")
  SetConstsG("DroneCarryBatteryUse")
  SetConstsG("DroneConstructAmount")
  SetConstsG("DroneConstructBatteryUse")
  SetConstsG("DroneDeconstructBatteryUse")
  SetConstsG("DroneMeteorMalfunctionChance")
  SetConstsG("DroneMoveBatteryUse")
  SetConstsG("DroneRechargeTime")
  SetConstsG("DroneRepairSupplyLeak")
  SetConstsG("DroneResourceCarryAmount")
  SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount")
  SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse")
  SetConstsG("DustStormSanityDamage")
  SetConstsG("Electronics_cost_modifier")
  SetConstsG("Electronics_dome_cost_modifier")
  SetConstsG("FoodPerRocketPassenger")
  SetConstsG("HighStatLevel")
  SetConstsG("HighStatMoraleEffect")
  SetConstsG("InstantCables")
  SetConstsG("InstantPipes")
  SetConstsG("IsDeepMetalsExploitable")
  SetConstsG("IsDeepPreciousMetalsExploitable")
  SetConstsG("IsDeepWaterExploitable")
  SetConstsG("LowSanityNegativeTraitChance")
  SetConstsG("LowSanitySuicideChance")
  SetConstsG("LowStatLevel")
  SetConstsG("MachineParts_cost_modifier")
  SetConstsG("MachineParts_dome_cost_modifier")
  SetConstsG("MaxColonistsPerRocket")
  SetConstsG("Metals_cost_modifier")
  SetConstsG("Metals_dome_cost_modifier")
  SetConstsG("MeteorHealthDamage")
  SetConstsG("MeteorSanityDamage")
  SetConstsG("MinComfortBirth")
  SetConstsG("MysteryDreamSanityDamage")
  SetConstsG("NoHomeComfort")
  SetConstsG("NonSpecialistPerformancePenalty")
  SetConstsG("OutsourceResearch")
  SetConstsG("OutsourceResearchCost")
  SetConstsG("OxygenMaxOutsideTime")
  SetConstsG("PipesPillarSpacing")
  SetConstsG("Polymers_cost_modifier")
  SetConstsG("Polymers_dome_cost_modifier")
  SetConstsG("positive_playground_chance")
  SetConstsG("PreciousMetals_cost_modifier")
  SetConstsG("PreciousMetals_dome_cost_modifier")
  SetConstsG("ProjectMorphiousPositiveTraitChance")
  SetConstsG("RCRoverDroneRechargeCost")
  SetConstsG("RCRoverMaxDrones")
  SetConstsG("RCRoverTransferResourceWorkTime")
  SetConstsG("RCTransportGatherResourceWorkTime")
  SetConstsG("rebuild_cost_modifier")
  SetConstsG("RenegadeCreation")
  SetConstsG("SeeDeadSanity")
  SetConstsG("TimeBeforeStarving")
  SetConstsG("TravelTimeEarthMars")
  SetConstsG("TravelTimeMarsEarth")
  SetConstsG("VisitFailPenalty")
--const.
  local const = const
  local function SetConst(Name)
    if UserSettings[Name] then
      const[Name] = UserSettings[Name]
    end
  end
  SetConst("BreakThroughTechsPerGame")
  SetConst("ExplorationQueueMaxSize")
  SetConst("fastGameSpeed")
  SetConst("mediumGameSpeed")
  SetConst("MoistureVaporatorPenaltyPercent")
  SetConst("MoistureVaporatorRange")
  SetConst("ResearchQueueSize")
  SetConst("RCRoverMaxRadius")
  SetConst("CommandCenterMaxRadius")
  SetConst("OmegaTelescopeBreakthroughsCount")
end

--called everytime we set a setting in menu
function ChoGGi.SettingFuncs.WriteSettings()

    local file = ChoGGi.SettingsFile
    local bak = file .. ".bak"

    ThreadLockKey(bak)
    AsyncCopyFile(file,bak)
    ThreadUnlockKey(bak)

    ThreadLockKey(file)
    table.sort(ChoGGi.UserSettings)
    local err = AsyncStringToFile(file,TableToLuaCode(ChoGGi.UserSettings))
    ThreadUnlockKey(file)
    if err then
      print("once", "Failed to save a settings to", file, ":", err)
      return false, err
    end

end

--read saved settings from file
function ChoGGi.SettingFuncs.ReadSettings()
  local errormsg = "\n\nCheatMod_CheatMenu: Problem loading AppData/Surviving Mars/CheatMenuModSettings.lua\nIf you can delete it and still get this error; please send it and this log to the author.\n\n"

	local file_error, Settings = AsyncFileToString(ChoGGi.SettingsFile)
	if file_error then
    file_error = ""
    --no settings file so make a new one
    ChoGGi.SettingFuncs.WriteSettings()
    file_error, Settings = AsyncFileToString(ChoGGi.SettingsFile)
    if file_error then
      DebugPrint(errormsg)
      return file_error
    end
	end

  local code_error
  code_error, ChoGGi.UserSettings = LuaCodeToTuple(Settings)
	if code_error then
    DebugPrint(errormsg)
		return code_error
	end

end

--OptionsApply is the earliest we can call Consts:GetProperties()
function ChoGGi.MsgFuncs.Settings_OptionsApply()
  local ChoGGi = ChoGGi
  local Consts = Consts

  --if setting doesn't exist then make it default
  for Key,Value in pairs(CDefaults) do
    if type(ChoGGi.UserSettings[Key]) == "nil" then
      ChoGGi.UserSettings[Key] = Value
    end
  end
  --[[
  --and add as false
  for Key,Value in pairs(cConsts) do
    if type(ChoGGi.UserSettings[Key]) == "nil" then
      ChoGGi.UserSettings[Key] = false
    end
  end
  --]]

  --get the default values for our Consts
  for SettingName,_ in pairs(cConsts) do
    local setting = Consts:GetDefaultPropertyValue(SettingName)
    if setting then
      cConsts[SettingName] = setting
    end
  end

  --get other defaults not stored in Consts
  cConsts.DroneFactoryBuildSpeed = DroneFactory:GetDefaultPropertyValue("performance")
  cConsts.StorageShuttle = CargoShuttle:GetDefaultPropertyValue("max_shared_storage")
  cConsts.SpeedShuttle = CargoShuttle:GetDefaultPropertyValue("max_speed")
  cConsts.ShuttleHubShuttleCapacity = ShuttleHub:GetDefaultPropertyValue("max_shuttles")
  cConsts.GravityColonist = 0
  cConsts.GravityDrone = 0
  cConsts.GravityRC = 0
  cConsts.SpeedDrone = Drone:GetDefaultPropertyValue("move_speed")
  cConsts.SpeedRC = RCRover:GetDefaultPropertyValue("move_speed")
  cConsts.SpeedColonist = Colonist:GetDefaultPropertyValue("move_speed")
  cConsts.RCTransportStorageCapacity = RCTransport:GetDefaultPropertyValue("max_shared_storage")
  cConsts.StorageUniversalDepot = UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource")
  --cConsts.StorageWasteDepot = WasteRockDumpSite:GetDefaultPropertyValue("max_amount_WasteRock")
  cConsts.StorageWasteDepot = 70 * cConsts.ResourceScale --^ that has 45000 as default...
  cConsts.StorageOtherDepot = 180 * cConsts.ResourceScale
  cConsts.StorageMechanizedDepot = 3950 * cConsts.ResourceScale
  --^ they're all UniversalStorageDepot

  cConsts.CameraZoomToggle = 8000
  cConsts.HigherRenderDist = 120 --hr.LODDistanceModifier
end

function ChoGGi.MsgFuncs.Settings_ModsLoaded()
  --remove empty entries in BuildingSettings
  if next(ChoGGi.UserSettings.BuildingSettings) then
    --remove any empty building tables
    for Key,_ in pairs(ChoGGi.UserSettings.BuildingSettings) do
      if not next(ChoGGi.UserSettings.BuildingSettings[Key]) then
        ChoGGi.UserSettings.BuildingSettings[Key] = nil
      end
    end
  --if empty table then new settings file or old settings
  else
    --used to add old lists to new combined list
    local function AddOldSettings(OldCat,NewName)
      --is there anthing in the table?
      if type(ChoGGi.UserSettings[OldCat]) == "table" and next(ChoGGi.UserSettings[OldCat]) then
        --then loop through it
        for BuildingName,Value in pairs(ChoGGi.UserSettings[OldCat]) do
          --it likely doesn't exist, but check first and add a blank table
          if not ChoGGi.UserSettings.BuildingSettings[BuildingName] then
            ChoGGi.UserSettings.BuildingSettings[BuildingName] = {}
          end
          --add it to vistors list?
          if NewName == "capacity" and DataInstances.BuildingTemplate[BuildingName].max_visitors then
            ChoGGi.UserSettings.BuildingSettings[BuildingName].visitors = Value
          else
            ChoGGi.UserSettings.BuildingSettings[BuildingName][NewName] = Value
          end
        end
      end
      --remove old settings
      ChoGGi.UserSettings[OldCat] = nil
      --if not then we'll give an error msg for users
      return true
    end
    --then we check if this is an older version still using the old way of storing building settings and convert over to new
    local StartupMsgs = ChoGGi.Temp.StartupMsgs
    local errormsg = "Error: Couldn't convert old settings to new settings: "
    if not AddOldSettings("BuildingsCapacity","capacity") then
      StartupMsgs[#StartupMsgs+1] = errormsg .. "BuildingsCapacity"
    end
    if not AddOldSettings("BuildingsProduction","production") then
      StartupMsgs[#StartupMsgs+1] = errormsg .. "BuildingsProduction"
    end
  end

end
