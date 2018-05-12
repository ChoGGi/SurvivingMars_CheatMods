
function OnMsg.ClassesGenerate()
  --i like keeping all my OnMsgs. in one file
  ChoGGi.MsgFuncs.ReplacedFunctions_ClassesGenerate()
  ChoGGi.MsgFuncs.InfoPaneCheats_ClassesGenerate()
  ChoGGi.MsgFuncs.ListChoiceCustom_ClassesGenerate()
  ChoGGi.MsgFuncs.ObjectManipulator_ClassesGenerate()
end --OnMsg

function OnMsg.ClassesBuilt()

  ChoGGi.MsgFuncs.ReplacedFunctions_ClassesBuilt()
  ChoGGi.MsgFuncs.ListChoiceCustom_ClassesBuilt()
  ChoGGi.MsgFuncs.ObjectManipulator_ClassesBuilt()

  --add HiddenX cat for Hidden items
  if ChoGGi.UserSettings.Building_hide_from_build_menu then
    BuildCategories[#BuildCategories+1] = {id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",}
  end

end --OnMsg

function OnMsg.OptionsApply()
  ChoGGi.MsgFuncs.Settings_OptionsApply()
end --OnMsg

function OnMsg.ModsLoaded()
  ChoGGi.MsgFuncs.Settings_ModsLoaded()
end

--earlist on-ground objects are loaded?
--function OnMsg.PersistLoad()

--saved game is loaded
function OnMsg.LoadGame()
  --so LoadingScreenPreClose gets fired only every load, rather than also everytime we save
  ChoGGi.IsGameLoaded = false
end

--for new games
--OnMsg.NewMapLoaded()
function OnMsg.CityStart()
  ChoGGi.IsGameLoaded = false
  --reset my mystery msgs to hidden
  ChoGGi.UserSettings.ShowMysteryMsgs = nil
end

--fired as late as we can
--function OnMsg.Resume()
function OnMsg.LoadingScreenPreClose()

  --for new games
  if not UICity then
    return
  end

  if ChoGGi.IsGameLoaded == true then
    return
  end
  ChoGGi.IsGameLoaded = true

  --late enough that I can set g_Consts.
  ChoGGi.Funcs.SetConstsToSaved()
  --needed for DroneResourceCarryAmount?
  UpdateDroneResourceUnits()

  ChoGGi.MsgFuncs.Keys_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.MissionFunc_LoadingScreenPreClose()

  --menu actions
  ChoGGi.MsgFuncs.MissionMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.CheatsMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.ColonistsMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.DebugMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.DronesAndRCMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.HelpMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  ChoGGi.MsgFuncs.ResourcesMenu_LoadingScreenPreClose()

  --default only saved 20 items in console history
  const.nConsoleHistoryMaxSize = 100

  --long arsed cables
  if ChoGGi.UserSettings.UnlimitedConnectionLength then
    GridConstructionController.max_hex_distance_to_allow_build = 1000
  end

  --on by default, you know all them martian trees (might make a cpu difference, probably not)
  hr.TreeWind = 0

  if ChoGGi.UserSettings.DisableTextureCompression then
    --uses more vram (1 toggles it, not sure what 0 does...)
    hr.TR_ToggleTextureCompression = 1
  end

  if ChoGGi.UserSettings.ShadowmapSize then
    hr.ShadowmapSize = ChoGGi.UserSettings.ShadowmapSize
  end

  if ChoGGi.UserSettings.HigherRenderDist then
    --lot of lag for some small rocks in distance
    --hr.DistanceModifier = 260 --default 130
    --hr.AutoFadeDistanceScale = 2200 --def 2200
    --render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
    if type(ChoGGi.UserSettings.HigherRenderDist) == "number" then
      hr.LODDistanceModifier = ChoGGi.UserSettings.HigherRenderDist
    else
      hr.LODDistanceModifier = 600 --def 120
    end
  end

  if ChoGGi.UserSettings.HigherShadowDist then
    if type(ChoGGi.UserSettings.HigherShadowDist) == "number" then
      hr.ShadowRangeOverride = ChoGGi.UserSettings.HigherShadowDist
    else
    --shadow cutoff dist
    hr.ShadowRangeOverride = 1000000 --def 0
    end
    --no shadow fade out when zooming
    hr.ShadowFadeOutRangePercent = 0 --def 30
  end

  --gets used a couple times
  local tab

  --not sure why this would be false on a dome
  tab = UICity.labels.Dome or empty_table
  for i = 1, #tab do
    if tab[i].achievement == "FirstDome" and type(tab[i].connected_domes) ~= "table" then
      tab[i].connected_domes = {}
    end
  end

  --add preset menu items
  ClassDescendantsList("Preset", function(name, class)
    local preset_class = class.PresetClass or name
    Presets[preset_class] = Presets[preset_class] or {}
    local map = class.GlobalMap
    if map then
      rawset(_G, map, rawget(_G, map) or {})
    end
    ChoGGi.Funcs.AddAction(
      "Presets/" .. name,
      function()
        OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
          PresetClass = name,
          SingleFile = class.SingleFile
        })
      end,
      class.EditorShortcut or nil,
      "Open a preset in the editor.",
      class.EditorIcon or "CollectionsEditor.tga"
    )
  end)

  --something messed up if storage is negative (usually setting an amount then lowering it)
  tab = UICity.labels.Storages or empty_table
  pcall(function()
    for i = 1, #tab do
      if tab[i]:GetStoredAmount() < 0 then
        --we have to empty it first (just filling doesn't fix the issue)
        tab[i]:CheatEmpty()
        tab[i]:CheatFill()
      end
    end
  end)

--[[
  local cap = ChoGGi.UserSettings.RCTransportStorageCapacity
  if cap then
    tab = UICity.labels.RCTransport or empty_table
    for i = 1, #tab do
      tab[i].max_shared_storage = cap
    end
  end

  --drone gravity
  local gravity = ChoGGi.UserSettings.GravityDrone
  if gravity then
    tab = UICity.labels.Drone or empty_table
    for i = 1, #tab do
      tab[i]:SetGravity(gravity)
    end
  end
--]]

  --so we can change the max_amount for concrete
  tab = TerrainDepositConcrete.properties
  for i = 1, #tab do
    if tab[i].id == "max_amount" then
      tab[i].read_only = nil
    end
  end

  --override building templates
  tab = DataInstances.BuildingTemplate
  for i = 1, #tab do
    --make hidden buildings visible
    if ChoGGi.UserSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      if tab[i].name ~= "LifesupportSwitch" and tab[i].name ~= "ElectricitySwitch" then
        tab[i].hide_from_build_menu = nil
      end
      if tab[i].build_category == "Hidden" and tab[i].name ~= "RocketLandingSite" then
        tab[i].build_category = "HiddenX"
      end
    end

    if ChoGGi.UserSettings.Building_wonder then
      tab[i].wonder = nil
    end
  end

  --show cheat pane?
  if ChoGGi.UserSettings.InfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if ChoGGi.UserSettings.ConsoleToggleHistory then
    ShowConsoleLog(true)
  end

  --dim that console bg
  if ChoGGi.UserSettings.ConsoleDim then
    config.ConsoleDim = 1
  end

  -- This must return true for most (built-in) cheats to function
  --function CheatsEnabled()
  --  return true
  --end

  --remove some built-in menu items
  UserActions.RemoveActions({
    --useless without developer tools?
    "BuildingEditor",
    --will switch the map without asking to save
    "G_OpenPregameMenu",
    --empty maps
    "ChangeMapEmpty",
    "ChangeMapPocMapAlt1",
    "ChangeMapPocMapAlt2",
    "ChangeMapPocMapAlt3",
    "ChangeMapPocMapAlt4",
    --broken, I've re-added them
    "StartMysteryAIUprisingMystery",
    "StartMysteryBlackCubeMystery",
    "StartMysteryDiggersMystery",
    "StartMysteryDreamMystery",
    "StartMysteryMarsgateMystery",
    "StartMysteryMirrorSphereMystery",
    "StartMysteryTheMarsBug",
    "StartMysteryUnitedEarthMystery",
    "StartMysteryWorldWar3",
    --moved them to help menu
    "DE_Screenshot",
    "UpsampledScreenshot",
    "DE_UpsampledScreenshot",
    "DE_ToggleScreenshotInterface",
    "DisableUIL",
    "G_ToggleInGameInterface",
    "FreeCamera",
    "G_ToggleSigns",
    "G_ToggleOnScreenHints",
    "G_ResetOnScreenHints",
    "DE_BugReport",
    --re-added
    "TriggerDisasterColdWave",
    "TriggerDisasterDustDevil",
    "TriggerDisasterDustDevilMajor",
    "TriggerDisasterDustStormElectrostatic",
    "TriggerDisasterDustStormGreat",
    "TriggerDisasterDustStormNormal",
    "TriggerDisasterMeteorsMultiSpawn",
    "TriggerDisasterMeteorsSingle",
    "TriggerDisasterMeteorsStorm",
    "TriggerDisasterStop",
    "G_ToggleAllShifts",
    "G_CheatUpdateAllWorkplaces",
    "G_CheatClearForcedWorkplaces",
    "G_UnpinAll",
    "G_ModsEditor",
    "G_ToggleInfopanelCheats",
    "G_UnlockAllBuildings",
    "G_AddFunding",
    "G_ResearchAll",
    "G_ResearchCurrent",
    "G_CompleteWiresPipes",
    "G_CompleteConstructions",
    "G_Unlock\208\144ll\208\162ech",
    "UnlockAllBreakthroughs",
    "SpawnColonist1",
    "SpawnColonist10",
    "SpawnColonist100",
    "MapExplorationScan",
    "MapExplorationDeepScan",
  })

  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

  if ChoGGi.UserSettings.ShowCheatsMenu or ChoGGi.Testing then
    --always show on my computer
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
  end

  --remove some uselessish Cheats to clear up space
  if ChoGGi.UserSettings.CleanupCheatsInfoPane then
    ChoGGi.Funcs.InfopanelCheatsCleanup()
  end

  --default to showing interface in ss
  if ChoGGi.UserSettings.ShowInterfaceInScreenshots then
    hr.InterfaceInScreenshot = 1
  end

  --set zoom/border scrolling
  ChoGGi.Funcs.SetCameraSettings()

  --show all traits
  if ChoGGi.UserSettings.SanatoriumSchoolShowAll then
    Sanatorium.max_traits = #ChoGGi.Tables.NegativeTraits
    School.max_traits = #ChoGGi.Tables.PositiveTraits
  end

  --unbreakable cables/pipes
  if ChoGGi.UserSettings.BreakChanceCablePipe then
    const.BreakChanceCable = 10000000
    const.BreakChancePipe = 10000000
  end

  if ChoGGi.UserSettings.DisableHints then
    mapdata.DisableHints = true
    HintsEnabled = false
  end

  --print startup msgs to console log
  local msgs = ChoGGi.StartupMsgs
  for i = 1, #msgs do
    AddConsoleLog(msgs[i],true)
    --ConsolePrint(ChoGGi.StartupMsgs[i])
  end

  --people will likely just copy new mod over old, and I moved stuff around
  if ChoGGi._VERSION ~= ChoGGi.UserSettings._VERSION then
    --clean up
    ChoGGi.Funcs.NewThread(ChoGGi.Funcs.RemoveOldFiles)
    --update saved version
    ChoGGi.UserSettings._VERSION = ChoGGi._VERSION
    ChoGGi.Funcs.WriteSettings()
  end

  ChoGGi.Funcs.NewThread(function()

      --add some custom labels for cables/pipes
    if type(UICity.labels.GridElements) ~= "table" then
      UICity.labels.GridElements = {}
    else
      --remove any broken objects
      ChoGGi.Funcs.RemoveMissingLabelObjects("GridElements")
    end
    if type(UICity.labels.ElectricityGridElement) ~= "table" then
      UICity.labels.ElectricityGridElement = {}
    else
      ChoGGi.Funcs.RemoveMissingLabelObjects("ElectricityGridElement")
    end
    if type(UICity.labels.LifeSupportGridElement) ~= "table" then
      UICity.labels.LifeSupportGridElement = {}
    else
      ChoGGi.Funcs.RemoveMissingLabelObjects("LifeSupportGridElement")
    end
    local function NewGridLabels(Label)
      if not next(UICity.labels[Label]) then
        local objs = GetObjects({class=Label}) or empty_table
        for i = 1, #objs do
          UICity.labels[Label][#UICity.labels[Label]+1] = objs[i]
          UICity.labels.GridElements[#UICity.labels.GridElements+1] = objs[i]
        end
      end
    end
    NewGridLabels("ElectricityGridElement")
    NewGridLabels("LifeSupportGridElement")

    --clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
    local shown = g_ShownOnScreenNotifications
    for Key,_ in pairs(shown) do
      if type(Key) == "number" or tostring(Key):find("ChoGGi_")then
        shown[Key] = nil
      end
    end

    --remove any dialogs we opened
    ChoGGi.Funcs.CloseDialogsECM()

    --remove any outside buildings i accidentally attached to domes ;)
    tab = UICity.labels.BuildingNoDomes or empty_table
    local sType
    for i = 1, #tab do
      if tab[i].dome_required == false and tab[i].parent_dome then

        sType = false
        --remove it from the dome label
        if tab[i].closed_shifts then
          sType = "Residence"
        elseif tab[i].colonists then
          sType = "Workplace"
        end

        if sType then --get a fucking continue lua
          if tab[i].parent_dome.labels and tab[i].parent_dome.labels[sType] then
            local dome = tab[i].parent_dome.labels[sType]
            for j = 1, #dome do
              if dome[j].class == tab[i].class then
                dome[j] = nil
              end
            end
          end
          --remove parent_dome
          tab[i].parent_dome = nil
        end

      end
    end

  end)

end --OnMsg

function OnMsg.BuildingPlaced(Obj)
  ChoGGi.LastPlacedObject = Obj
end --OnMsg

function OnMsg.ConstructionSitePlaced(Obj)
  ChoGGi.LastPlacedObject = Obj
end --OnMsg

--this gets called before buildings are completely initialized (no air/water/elec attached)
function OnMsg.ConstructionComplete(building)

  --skip rockets
  if building.class == "RocketLandingSite" then
    return
  end

  --print(building.encyclopedia_id) print(building.class)
  local StorageMechanizedDepot = ChoGGi.UserSettings.StorageMechanizedDepot
  local StorageUniversalDepot = ChoGGi.UserSettings.StorageUniversalDepot
  local StorageOtherDepot = ChoGGi.UserSettings.StorageOtherDepot
  local StorageWasteDepot = ChoGGi.UserSettings.StorageWasteDepot
  local DroneFactoryBuildSpeed = ChoGGi.UserSettings.DroneFactoryBuildSpeed
  local ShuttleHubFuelStorage = ChoGGi.UserSettings.ShuttleHubFuelStorage

  if building.class == "UniversalStorageDepot" then
    if StorageUniversalDepot and building.entity == "StorageDepot" then
      building.max_storage_per_resource = StorageUniversalDepot
    --other
    elseif StorageOtherDepot and building.entity ~= "StorageDepot" then
      building.max_storage_per_resource = StorageOtherDepot
    end

  elseif StorageMechanizedDepot and building.class:find("MechanizedDepot") then
    building.max_storage_per_resource = StorageMechanizedDepot

  elseif StorageWasteDepot and building.class == "WasteRockDumpSite" then
    building.max_amount_WasteRock = StorageWasteDepot
    if building:GetStoredAmount() < 0 then
      building:CheatEmpty()
      building:CheatFill()
    end

  elseif StorageOtherDepot and building.class == "MysteryDepot" then
    building.max_storage_per_resource = StorageOtherDepot

  elseif StorageOtherDepot and building.class == "BlackCubeDumpSite" then
    building.max_amount_BlackCube = StorageOtherDepot

  elseif DroneFactoryBuildSpeed and building.class == "DroneFactory" then
    building.performance = DroneFactoryBuildSpeed

  elseif ShuttleHubFuelStorage and building.class:find("ShuttleHub") then
    building.consumption_max_storage = ShuttleHubFuelStorage

  elseif ChoGGi.UserSettings.SchoolTrainAll and building.class == "School" then
    for i = 1, #ChoGGi.Tables.PositiveTraits do
      building:SetTrait(i,ChoGGi.Tables.PositiveTraits[i])
    end

  elseif ChoGGi.UserSettings.SanatoriumCureAll and building.class == "Sanatorium" then
    for i = 1, #ChoGGi.Tables.NegativeTraits do
      building:SetTrait(i,ChoGGi.Tables.NegativeTraits[i])
    end

  end --end of elseifs

  if ChoGGi.UserSettings.RemoveMaintenanceBuildUp and building.base_maintenance_build_up_per_hr then
    building.maintenance_build_up_per_hr = -10000
  end

  local FullyAutomatedBuildings = ChoGGi.UserSettings.FullyAutomatedBuildings
  if FullyAutomatedBuildings and building.base_max_workers then
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = FullyAutomatedBuildings
  end

  --saved building settings
  local setting = ChoGGi.UserSettings.BuildingSettings[building.encyclopedia_id]
  if setting then
    --saved settings for capacity, shuttles
    if setting.capacity then
      if building.base_capacity then
        building.capacity = setting.capacity
      elseif building.base_air_capacity then
        building.air_capacity = setting.capacity
      elseif building.base_water_capacity then
        building.water_capacity = setting.capacity
      elseif building.base_max_shuttles then
        building.max_shuttles = setting.capacity
      end
    end
    --max visitors
    if setting.visitors and building.base_max_visitors then
      building.max_visitors = setting.visitors
    end
    --max workers
    if setting.workers then
      building.max_workers = setting.workers
    end
    --no power needed
    if setting.nopower then
      if building.modifications.electricity_consumption then
        local mod = building.modifications.electricity_consumption[1]
        building.ChoGGi_mod_electricity_consumption = {
          amount = mod.amount,
          percent = mod.percent
        }
        mod:Change(0,0)
      end
      building:SetBase("electricity_consumption", 0)
    end
    --large protect_range for defence buildings
    if setting.protect_range then
      building.protect_range = setting.protect_range
      building.shoot_range = setting.protect_range * ChoGGi.Consts.guim
    end
  end

end --OnMsg

function OnMsg.Demolished(building)
  --update our list of working domes for AttachToNearestDome (though I wonder why this isn't already a label)
  if building.achievement == "FirstDome" then
    UICity.labels.Domes_Working = {}
    local tab = UICity.labels.Dome or empty_table
    for i = 1, #tab do
      UICity.labels.Domes_Working[#UICity.labels.Domes_Working+1] = tab[i]
    end
  end
end --OnMsg

local function ColonistCreated(Obj)
  local GravityColonist = ChoGGi.UserSettings.GravityColonist
  if GravityColonist then
    Obj:SetGravity(GravityColonist)
  end
  local NewColonistGender = ChoGGi.UserSettings.NewColonistGender
  if NewColonistGender then
    ChoGGi.Funcs.ColonistUpdateGender(Obj,NewColonistGender)
  end
  local NewColonistAge = ChoGGi.UserSettings.NewColonistAge
  if NewColonistAge then
    ChoGGi.Funcs.ColonistUpdateAge(Obj,NewColonistAge)
  end
  local NewColonistSpecialization = ChoGGi.UserSettings.NewColonistSpecialization
  if NewColonistSpecialization then
    ChoGGi.Funcs.ColonistUpdateSpecialization(Obj,NewColonistSpecialization)
  end
  local NewColonistRace = ChoGGi.UserSettings.NewColonistRace
  if NewColonistRace then
    ChoGGi.Funcs.ColonistUpdateRace(Obj,NewColonistRace)
  end
  local NewColonistTraits = ChoGGi.UserSettings.NewColonistTraits
  if NewColonistTraits then
    ChoGGi.Funcs.ColonistUpdateTraits(Obj,true,NewColonistTraits)
  end
  local SpeedColonist = ChoGGi.UserSettings.SpeedColonist
  if SpeedColonist then
    Obj:SetMoveSpeed(SpeedColonist)
  end
end

function OnMsg.ColonistArrived(Obj)
  ColonistCreated(Obj)
end --OnMsg

function OnMsg.ColonistBorn(Obj)
  ColonistCreated(Obj)
end --OnMsg

function OnMsg.SelectionAdded(Obj)
  --update selection shortcut
  s = Obj
  --
  ChoGGi.LastPlacedObject = Obj
end

function OnMsg.SelectionRemoved()
  s = false
end

function OnMsg.NewHour()

  --make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
  if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    local tab = UICity.labels.ResourceProducer or empty_table
    for i = 1, #tab do
      ChoGGi.Funcs.FuckingDrones(tab[i]:GetProducerObj())
      if tab[i].wasterock_producer then
        ChoGGi.Funcs.FuckingDrones(tab[i].wasterock_producer)
      end
    end
  end

end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    ChoGGi.Funcs.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryChosen()
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    ChoGGi.Funcs.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryEnd(Outcome)
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    ChoGGi.Funcs.MsgPopup(tostring(Outcome),"Mystery","UI/Icons/Logos/logo_13.tga")
  end
end

function OnMsg.ApplicationQuit()

  --my comp or if we're resetting settings
  if ChoGGi.Testing or ChoGGi.ResetSettings then
    return
  end

  --save any unsaved settings on exit
  ChoGGi.Funcs.WriteSettings()
end

--custom OnMsgs, these aren't part of the base game, so without this mod they don't work
ChoGGi.Funcs.AddMsgToFunc("CargoShuttle","GameInit","SpawnedShuttle")
ChoGGi.Funcs.AddMsgToFunc("Drone","GameInit","SpawnedDrone")
ChoGGi.Funcs.AddMsgToFunc("RCTransport","GameInit","SpawnedRCTransport")
ChoGGi.Funcs.AddMsgToFunc("RCRover","GameInit","SpawnedRCRover")
ChoGGi.Funcs.AddMsgToFunc("ExplorerRover","GameInit","SpawnedExplorerRover")
ChoGGi.Funcs.AddMsgToFunc("Residence","GameInit","SpawnedResidence")
ChoGGi.Funcs.AddMsgToFunc("Workplace","GameInit","SpawnedWorkplace")
ChoGGi.Funcs.AddMsgToFunc("GridObject","ApplyToGrids","CreatedGridObject")
ChoGGi.Funcs.AddMsgToFunc("GridObject","RemoveFromGrids","RemovedGridObject")
ChoGGi.Funcs.AddMsgToFunc("ElectricityProducer","CreateElectricityElement","SpawnedProducerElectricity")
ChoGGi.Funcs.AddMsgToFunc("AirProducer","CreateLifeSupportElements","SpawnedProducerAir")
ChoGGi.Funcs.AddMsgToFunc("WaterProducer","CreateLifeSupportElements","SpawnedProducerWater")
ChoGGi.Funcs.AddMsgToFunc("SingleResourceProducer","Init","SpawnedProducerSingle")
ChoGGi.Funcs.AddMsgToFunc("ElectricityStorage","GameInit","SpawnedElectricityStorage")
ChoGGi.Funcs.AddMsgToFunc("LifeSupportGridObject","GameInit","SpawnedLifeSupportGridObject")
ChoGGi.Funcs.AddMsgToFunc("PinnableObject","TogglePin","TogglePinnableObject")
ChoGGi.Funcs.AddMsgToFunc("ResourceStockpileLR","GameInit","SpawnedResourceStockpileLR")
ChoGGi.Funcs.AddMsgToFunc("DroneHub","GameInit","SpawnedDroneHub")

--attached temporary resource depots
function OnMsg.SpawnedResourceStockpileLR(Obj)
  if ChoGGi.UserSettings.StorageMechanizedDepotsTemp and Obj.parent.class:find("MechanizedDepot") then
    ChoGGi.Funcs.SetMechanizedDepotTempAmount(Obj.parent)
  end
end

function OnMsg.TogglePinnableObject(Obj)
  local UnpinObjects = ChoGGi.UserSettings.UnpinObjects
  if type(UnpinObjects) == "table" and next(UnpinObjects) then
    local tab = UnpinObjects or empty_table
    for i = 1, #tab do
      if Obj.class == tab[i] and Obj:IsPinned() then
        Obj:TogglePin()
        break
      end
    end
  end
end

--custom UICity.labels lists
function OnMsg.CreatedGridObject(Obj)
  local city = UICity.labels
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    city.GridElements[#city.GridElements+1] = Obj
    city[Obj.class][#city[Obj.class]+1] = Obj
  end
end
function OnMsg.RemovedGridObject(Obj)
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    ChoGGi.Funcs.RemoveFromLabel("GridElements",Obj)
    ChoGGi.Funcs.RemoveFromLabel(Obj.class,Obj)
  end
end

--shuttle comes out of a hub
function OnMsg.SpawnedShuttle(Obj)

  local StorageShuttle = ChoGGi.UserSettings.StorageShuttle
  if StorageShuttle then
    Obj.max_shared_storage = StorageShuttle
  end
  local SpeedShuttle = ChoGGi.UserSettings.SpeedShuttle
  if SpeedShuttle then
    Obj.max_speed = SpeedShuttle
  end
end

function OnMsg.SpawnedDrone(Obj)
  local GravityDrone = ChoGGi.UserSettings.GravityDrone
  if GravityDrone then
    Obj:SetGravity(GravityDrone)
  end
  local SpeedDrone = ChoGGi.UserSettings.SpeedDrone
  if SpeedDrone then
    Obj:SetMoveSpeed(SpeedDrone)
  end
end

local function RCCreated(Obj)
  local SpeedRC = ChoGGi.UserSettings.SpeedRC
  if SpeedRC then
    Obj:SetMoveSpeed(SpeedRC)
  end
  local GravityRC = ChoGGi.UserSettings.GravityRC
  if GravityRC then
    Obj:SetGravity(GravityRC)
  end
end
function OnMsg.SpawnedRCTransport(Obj)
  local RCTransportStorageCapacity = ChoGGi.UserSettings.RCTransportStorageCapacity
  if RCTransportStorageCapacity then
    Obj.max_shared_storage = RCTransportStorageCapacity
  end
  RCCreated(Obj)
end
function OnMsg.SpawnedRCRover(Obj)
  if ChoGGi.UserSettings.RCRoverMaxRadius then
    Obj:SetWorkRadius() -- I override the func so no need to send a value here
  end
  RCCreated(Obj)
end
function OnMsg.SpawnedExplorerRover(Obj)
  RCCreated(Obj)
end

function OnMsg.SpawnedDroneHub(Obj)
  if ChoGGi.UserSettings.CommandCenterMaxRadius then
    Obj:SetWorkRadius()
  end
end

--if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
function OnMsg.SpawnedResidence(Obj)
  ChoGGi.Funcs.AttachToNearestDome(Obj)
end
function OnMsg.SpawnedWorkplace(Obj)
  ChoGGi.Funcs.AttachToNearestDome(Obj)
end

--make sure they use with our new values
local function SetProd(Obj,sType)
  local prod = ChoGGi.UserSettings.BuildingSettings[Obj.encyclopedia_id]
  if prod and prod.production then
    Obj[sType] = prod.production
  end
end
function OnMsg.SpawnedProducerElectricity(Obj)
  SetProd(Obj,"electricity_production")
end
function OnMsg.SpawnedProducerAir(Obj)
  SetProd(Obj,"air_production")
end
function OnMsg.SpawnedProducerWater(Obj)
  SetProd(Obj,"water_production")
end
function OnMsg.SpawnedProducerSingle(Obj)
  SetProd(Obj,"production_per_day")
end

--water/air tanks
function OnMsg.SpawnedLifeSupportGridObject(Obj)
  CheckForRate(Obj)
end
--battery
function OnMsg.SpawnedElectricityStorage(Obj)
  CheckForRate(Obj)
end

local function CheckForRate(Obj)

  --charge/discharge
  local value = ChoGGi.UserSettings.BuildingSettings[Obj.encyclopedia_id]

  if value then
    local function SetValue(sType)
      if value.charge then
        Obj[sType].max_charge = value.charge
        Obj["max_" .. sType .. "_charge"] = value.charge
      end
      if value.discharge then
        Obj[sType].max_discharge = value.discharge
        Obj["max_" .. sType .. "_discharge"] = value.discharge
      end
    end

    if type(Obj.GetStoredAir) == "function" then
      SetValue("air")
    elseif type(Obj.GetStoredWater) == "function" then
      SetValue("water")
    elseif type(Obj.GetStoredPower) == "function" then
      SetValue("electricity")
    end

  end
end
