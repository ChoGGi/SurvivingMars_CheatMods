-- See LICENSE for terms

-- stores default values and some tables

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans

local next,pairs,print,type,table,string = next,pairs,print,type,table,string

local AsyncCopyFile = AsyncCopyFile
local AsyncFileToString = AsyncFileToString
local AsyncStringToFile = AsyncStringToFile
local ClassDescendantsList = ClassDescendantsList
local LuaCodeToTuple = LuaCodeToTuple
local TableToLuaCode = TableToLuaCode
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey

local g_Classes = g_Classes

--useful lists
do
  local ChoGGi = ChoGGi
  local const = const

  ChoGGi.Tables = {
    --display names only! (stored as numbers, not names like the rest; which is why i guessed)
    ColonistRaces = {"White","Black","Asian","Indian","Southeast Asian",White = true,Black = true,Asian = true,Indian = true,["Southeast Asian"] = true},
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
    --for mystery menu items (added below after mods load)
    Mystery = {}
  }

  --genders/ages/traits/specs/birthplaces
  ChoGGi.ComFuncs.UpdateColonistsTables()

  --maybe if a mod removed them?
  if #const.SchoolTraits < 5 then
    ChoGGi.Tables.SchoolTraits = {"Nerd","Composed","Enthusiast","Religious","Survivor"}
  end
  if #const.SanatoriumTraits < 7 then
    ChoGGi.Tables.SanatoriumTraits = {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
  end
end

-- stores defaults
ChoGGi.Defaults = {
  -- oh we'll change it
  _VERSION = 0,
  --dark background for the console log
  ConsoleDim = true,
  -- shows the console log on screen
  ConsoleToggleHistory = true,
  -- shows a msg in the console log (maybe a popup would be better)
  FirstRun = true,
  -- show Cheats pane in the selection panel
  InfopanelCheats = true,
  -- removes some useless shit from the Cheats pane (unless you're doing the tutorial then not as useless it seems)
  CleanupCheatsInfoPane = true,
  -- maybe you don't want to see the interface in screenshots
  ShowInterfaceInScreenshots = true,
  -- 1-0 + shift+ 1-0 shows the build menus
  NumberKeysBuildMenu = true,
  -- keep orientation of last placed building
  UseLastOrientation = true,
  -- show the cheats menu...
  ShowCheatsMenu = true,
  -- dumps the log to disk on startup, and every new Sol (good for some crashes)
  FlushLog = true,
  -- dumps log to disk every in-game minute
  FlushLogConstantly = false,
  -- okay, maybe some people don't want a mod to change the title of their game
  ChangeWindowTitle = true,
  -- msg that shows in the console after tabbing back to the game and "heaven forbid" you have the cheats menu open
  HideuiWindowErrorMsg = true,
  -- how wide the starting radius, how much to step per press
  FlattenGround_Radius = 2500,
  FlattenGround_HeightDiff = 100,
  FlattenGround_RadiusDiff = 100,
  -- the build/passibility grid in debug menu
  DebugGridSize = 10,
  DebugGridOpacity = 15,
  -- how long to wait before hiding the cheats pane in the selection panel
  CheatsInfoPanelHideDelay = 1500,
  -- how wide the text for the history menu in the Console is
  ConsoleHistoryMenuLength = 50,
  -- shows how many ticks it takes between the start of ECM and when the game loads
  ShowStartupTicks = false,
  -- if mod added work/res and user removed removed mod without removing buildings then inf loop
  MissingWorkplacesResidencesFix = false,
  -- Mod Editor shows the help page every single time you open it.
  SkipModHelpPage = true,
  -- stores custom settings for each building
  BuildingSettings = {},
  -- transparent UI stored here
	Transparency = {},
  -- shortcut keys
  KeyBindings = {
    -- Keys.lua
    ClearConsoleLog = "F9",
    ObjectColourRandom = "Shift-F6",
    ObjectColourDefault = "Ctrl-F6",
    ShowConsoleTilde = "~",
    ShowConsoleEnter = "Enter",
    ConsoleRestart = "Ctrl-Alt-Shift-R",
    LastConstructedBuilding = "Ctrl-Space",
    LastPlacedObject = "Ctrl-Shift-Space",
    -- Buildings.lua
    SetMaxChangeOrDischarge = "Ctrl-Shift-R",
    SetProductionAmount = "Ctrl-Shift-P",
    -- CheatsMenu.lua
    CheatCompleteAllConstructions = "Alt-B",
    -- ColonistsMenu.lua
    TheSoylentOption = "Ctrl-Alt-Numpad 1",
    -- DebugMenu.lua
    FlattenTerrain_Toggle = "Shift-F",
    MeasureTool_Toggle = "Ctrl-M",
    MeasureTool_Clear = "Ctrl-Shift-M",
    ObjectCloner = "Shift-Q",
    SetPathMarkersGameTime = "Ctrl-Numpad .",
    SetPathMarkersVisible = "Ctrl-Numpad 0",
    OpenInObjectManipulator = "F5",
    ObjectSpawner = "Ctrl-Shift-S",
    Editor_Toggle = "Ctrl-Shift-E",
    DeleteObject = "Ctrl-Alt-Shift-D",
    ObjExaminer = "F4",
    ToggleTerrainDepositGrid = "Ctrl-F4",
    debug_build_grid_both = "Shift-F1",
    debug_build_grid_pass = "Shift-F2",
    debug_build_grid_build = "Shift-F3",
    -- DronesAndRCMenu.lua
    SetDroneAmountDroneHub = "Shift-D",
    -- ExpandedMenu
    SetWorkerCapacity = "Ctrl-Shift-W",
    SetBuildingCapacity = "Ctrl-Shift-C",
    SetVisitorCapacity = "Ctrl-Shift-V",
    SetFunding = "Ctrl-Shift-0",
    FillResource = "Ctrl-F",
    -- GameMenu.lua
    SetTransparencyUI = "Ctrl-F3",
    CameraFree_Toggle = "Shift-C",
    CameraFollow_Toggle = "Ctrl-Shift-F",
    CursorVisible_Toggle = "Ctrl-Alt-F",
    -- HelpMenu.lua
    TakeScreenshot = "-PrtScr",
    TakeScreenshotUpsampled = "-Ctrl-PrtScr",
    ToggleInterface = "Ctrl-Alt-I",
    SignsInterface_Toggle = "Ctrl-Alt-S",
    ReportBugDlg = "Ctrl-F1",
    CheatsMenu_Toggle = "F2",
    -- MiscMenu.lua
    CreateObjectListAndAttaches = "F6",
    SetObjectOpacity = "F3",
    InfopanelCheats_Toggle = "Ctrl-F2",
  },

  -- if transport on a route has a broked route then lag happens (can't set faster game speeds)
  CheckForBrokedTransportPath = true,
}
if ChoGGi.Testing then
  local ChoGGi = ChoGGi
  -- add extra debugging defaults for me
  ChoGGi.Defaults.ShowStartupTicks = true
  ChoGGi.Defaults.WriteLogs = true
  ChoGGi.Defaults.MissingWorkplacesResidencesFix = true
  -- and maybe a bit of class
  ChoGGi.Defaults.Transparency = {
		HUD = 50,
		PinsDlg = 50,
		UAMenu = 150,
  }
  -- probably not useful for anyone who isn't loading up broked saves to test
  ChoGGi.Defaults.SkipMissingMods = true
  ChoGGi.Defaults.SkipMissingDLC = true
end

-- and constants
ChoGGi.Consts = {
	LightmodelCustom = "PlaceObj('Lightmodel', {\n\t'name', \"ChoGGi_Custom\",\n\t'pp_bloom_strength', 100,\n\t'pp_bloom_threshold', 25,\n\t'pp_bloom_contrast', 75,\n\t'pp_bloom_colorization', 65,\n\t'pp_bloom_inner_tint', RGBA(187, 23, 146, 255),\n\t'pp_bloom_mip2_radius', 8,\n\t'pp_bloom_mip3_radius', 10,\n\t'pp_bloom_mip4_radius', 27,\n\t'exposure', -100,\n\t'gamma', RGBA(76, 76, 166, 255),\n})",

-- const.* (I don't think these have default values in-game anywhere, so manually set them.) _GameConst.lua
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
  AutosavePeriod = 5,
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

--set game values to saved values
function ChoGGi.SettingFuncs.SetConstsToSaved()
  local ChoGGi = ChoGGi
  local const = const
--Consts.
  local function SetConstsG(Name)
    ChoGGi.ComFuncs.SetConstsG(Name,ChoGGi.UserSettings[Name])
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
  local function SetConst(Name)
    if ChoGGi.UserSettings[Name] then
      const[Name] = ChoGGi.UserSettings[Name]
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
function ChoGGi.SettingFuncs.WriteSettings(settings)
  local ChoGGi = ChoGGi
  settings = settings or ChoGGi.UserSettings

  local bak = Concat(ChoGGi.SettingsFile,".bak")
  --locks the file while we write (i mean it says thread, ah well can't hurt)?
  ThreadLockKey(bak)
  AsyncCopyFile(ChoGGi.SettingsFile,bak)
  ThreadUnlockKey(bak)

  ThreadLockKey(ChoGGi.SettingsFile)
  table.sort(settings)
  --and write it to disk
  local DoneFuckedUp = AsyncStringToFile(ChoGGi.SettingsFile,TableToLuaCode(settings))
  ThreadUnlockKey(ChoGGi.SettingsFile)

  if DoneFuckedUp then
    print(string.format(T(302535920000006--[[Failed to save settings to %s : %s--]]),ChoGGi.SettingsFile,DoneFuckedUp))
    return false, DoneFuckedUp
  end
end

-- read saved settings from file
function ChoGGi.SettingFuncs.ReadSettings(settings_str)
  local ChoGGi = ChoGGi
  local errormsg = Concat("\n\n",T(302535920000000--[[Expanded Cheat Menu--]]),": ",T(302535920000007--[[Problem loading AppData/Surviving Mars/CheatMenuModSettings.lua
If you can delete it and still get this error; please send it and this log to the author.--]]),"\n\n")

  -- try to read settings
  if not settings_str then
    local file_error
    file_error, settings_str = AsyncFileToString(ChoGGi.SettingsFile)
    if file_error then
      -- no settings file so make a new one
      ChoGGi.SettingFuncs.WriteSettings()
      file_error, settings_str = AsyncFileToString(ChoGGi.SettingsFile)
      -- something is definitely wrong so just abort
      if file_error then
        return file_error
      end
    end
  end
  -- and convert it to lua / update in-game settings
  local code_error
  code_error, ChoGGi.UserSettings = LuaCodeToTuple(settings_str)
	if code_error then
    print(errormsg)
		return code_error
	end

  return settings_str
end

--OptionsApply is the earliest we can call Consts:GetProperties()
function ChoGGi.MsgFuncs.Defaults_OptionsApply()
  local ChoGGi = ChoGGi
  local Consts = Consts

  --if setting doesn't exist then add default
  for Key,Value in pairs(ChoGGi.Defaults) do
    if type(ChoGGi.UserSettings[Key]) == "nil" then
      ChoGGi.UserSettings[Key] = Value
    end
  end

  --get the default values for our Consts
  for SettingName,_ in pairs(ChoGGi.Consts) do
    local setting = Consts:GetDefaultPropertyValue(SettingName)
    if setting then
      ChoGGi.Consts[SettingName] = setting
    end
  end

  --get other defaults not stored in Consts
  ChoGGi.Consts.DroneFactoryBuildSpeed = g_Classes.DroneFactory:GetDefaultPropertyValue("performance")
  ChoGGi.Consts.StorageShuttle = g_Classes.CargoShuttle:GetDefaultPropertyValue("max_shared_storage")
  ChoGGi.Consts.SpeedShuttle = g_Classes.CargoShuttle:GetDefaultPropertyValue("max_speed")
  ChoGGi.Consts.ShuttleHubShuttleCapacity = g_Classes.ShuttleHub:GetDefaultPropertyValue("max_shuttles")
  ChoGGi.Consts.GravityColonist = 0
  ChoGGi.Consts.GravityDrone = 0
  ChoGGi.Consts.GravityRC = 0
  ChoGGi.Consts.SpeedDrone = g_Classes.Drone:GetDefaultPropertyValue("move_speed")
  ChoGGi.Consts.SpeedRC = g_Classes.RCRover:GetDefaultPropertyValue("move_speed")
  ChoGGi.Consts.SpeedColonist = g_Classes.Colonist:GetDefaultPropertyValue("move_speed")
  ChoGGi.Consts.RCTransportStorageCapacity = g_Classes.RCTransport:GetDefaultPropertyValue("max_shared_storage")
  ChoGGi.Consts.StorageUniversalDepot = g_Classes.UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource")
  --ChoGGi.Consts.StorageWasteDepot = WasteRockDumpSite:GetDefaultPropertyValue("max_amount_WasteRock")
  ChoGGi.Consts.StorageWasteDepot = 70 * ChoGGi.Consts.ResourceScale --^ that has 45000 as default...
  ChoGGi.Consts.StorageOtherDepot = 180 * ChoGGi.Consts.ResourceScale
  ChoGGi.Consts.StorageMechanizedDepot = 3950 * ChoGGi.Consts.ResourceScale
  --^ they're all UniversalStorageDepot

  ChoGGi.Consts.CameraZoomToggle = 8000
  ChoGGi.Consts.HigherRenderDist = 120 --hr.LODDistanceModifier
end

function ChoGGi.MsgFuncs.Defaults_ModsLoaded()
  local ChoGGi = ChoGGi
  local DataInstances = DataInstances
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
        for Key,Value in pairs(ChoGGi.UserSettings[OldCat]) do
          --it likely doesn't exist, but check first and add a blank table
          if not ChoGGi.UserSettings.BuildingSettings[Key] then
            ChoGGi.UserSettings.BuildingSettings[Key] = {}
          end
          --add it to vistors list?
          if NewName == "capacity" and DataInstances.BuildingTemplate[Key].max_visitors then
            ChoGGi.UserSettings.BuildingSettings[Key].visitors = Value
          else
            ChoGGi.UserSettings.BuildingSettings[Key][NewName] = Value
          end
        end
      end
      --remove old settings
      ChoGGi.UserSettings[OldCat] = nil
      --if not then we'll give an error msg for users
      return true
    end
    --then we check if this is an older version still using the old way of storing building settings and convert over to new
    local errormsg = Concat(T(302535920000008--[[Error: Couldn't convert old settings to new settings--]]),": ")
    if not AddOldSettings("BuildingsCapacity","capacity") then
      ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat(errormsg,"BuildingsCapacity")
    end
    if not AddOldSettings("BuildingsProduction","production") then
      ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat(errormsg,"BuildingsProduction")
    end
  end

  --build mysteries list (sometimes we need to reference Mystery_1, sometimes BlackCubeMystery
  ClassDescendantsList("MysteryBase",function(class)
    local scenario_name = g_Classes[class].scenario_name or T(302535920000009--[[Missing Scenario Name--]])
    local display_name = T(g_Classes[class].display_name) or T(302535920000010--[[Missing Name--]])
    local description = T(g_Classes[class].rollover_text) or T(302535920000011--[[Missing Description--]])

    local temptable = {
      class = class,
      number = scenario_name,
      name = display_name,
      description = description
    }
    --we want to be able to access by for loop, Mystery 7, and WorldWar3
    ChoGGi.Tables.Mystery[scenario_name] = temptable
    ChoGGi.Tables.Mystery[class] = temptable
    ChoGGi.Tables.Mystery[#ChoGGi.Tables.Mystery+1] = temptable
  end)

end
