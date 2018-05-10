
function OnMsg.ClassesGenerate()
  --i like keeping all my OnMsgs. in one file
  ChoGGi.ReplacedFunctions_ClassesGenerate()
  ChoGGi.InfoPaneCheats_ClassesGenerate()
  ChoGGi.ListChoiceCustom_ClassesGenerate()
  ChoGGi.ObjectManipulator_ClassesGenerate()
end --OnMsg

function OnMsg.ClassesBuilt()

  ChoGGi.ReplacedFunctions_ClassesBuilt()
  ChoGGi.ListChoiceCustom_ClassesBuilt()
  ChoGGi.ObjectManipulator_ClassesBuilt()

  --add HiddenX cat for Hidden items
  if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
    table.insert(BuildCategories,{id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",})
  end

end --OnMsg

function OnMsg.OptionsApply()
  ChoGGi.Settings_OptionsApply()
end --OnMsg

function OnMsg.ModsLoaded()
  ChoGGi.Settings_ModsLoaded()
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
  ChoGGi.CheatMenuSettings.ShowMysteryMsgs = nil
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
  ChoGGi.SetConstsToSaved()
  --needed for DroneResourceCarryAmount?
  UpdateDroneResourceUnits()

  ChoGGi.RenderSettings_LoadingScreenPreClose()
  ChoGGi.Keys_LoadingScreenPreClose()
  ChoGGi.SponsorsFunc_LoadingScreenPreClose()

  --long arsed cables
  if ChoGGi.CheatMenuSettings.UnlimitedConnectionLength then
    GridConstructionController.max_hex_distance_to_allow_build = 1000
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
    ChoGGi.AddAction(
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
  local cap = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity
  if cap then
    tab = UICity.labels.RCTransport or empty_table
    for i = 1, #tab do
      tab[i].max_shared_storage = cap
    end
  end

  --drone gravity
  local gravity = ChoGGi.CheatMenuSettings.GravityDrone
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
    if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      if tab[i].name ~= "LifesupportSwitch" and tab[i].name ~= "ElectricitySwitch" then
        tab[i].hide_from_build_menu = nil
      end
      if tab[i].build_category == "Hidden" and tab[i].name ~= "RocketLandingSite" then
        tab[i].build_category = "HiddenX"
      end
    end

    if ChoGGi.CheatMenuSettings.Building_wonder then
      tab[i].wonder = nil
    end
  end

  --show cheat pane?
  if ChoGGi.CheatMenuSettings.InfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
    ShowConsoleLog(true)
  end

  --dim that console bg
  if ChoGGi.CheatMenuSettings.ConsoleDim then
    config.ConsoleDim = 1
  end

  --load up my menu actions
  ChoGGi.SponsorsMenu_LoadingScreenPreClose()
  ChoGGi.BuildingsMenu_LoadingScreenPreClose()
  ChoGGi.CheatsMenu_LoadingScreenPreClose()
  ChoGGi.ColonistsMenu_LoadingScreenPreClose()
  ChoGGi.DebugMenu_LoadingScreenPreClose()
  ChoGGi.DronesAndRCMenu_LoadingScreenPreClose()
  ChoGGi.ExpandedMenu_LoadingScreenPreClose()
  ChoGGi.HelpMenu_LoadingScreenPreClose()
  ChoGGi.MiscMenu_LoadingScreenPreClose()
  ChoGGi.ResourcesMenu_LoadingScreenPreClose()

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

  if ChoGGi.CheatMenuSettings.ShowCheatsMenu or ChoGGi.Testing then
    --always show on my computer
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
  end

  --remove some uselessish Cheats to clear up space
  if ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane then
    ChoGGi.InfopanelCheatsCleanup()
  end

  --default to showing interface in ss
  if ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots then
    hr.InterfaceInScreenshot = 1
  end

  --set zoom/border scrolling
  ChoGGi.SetCameraSettings()

  --show all traits
  if ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll then
    Sanatorium.max_traits = #ChoGGi.Tables.NegativeTraits
    School.max_traits = #ChoGGi.Tables.PositiveTraits
  end

  --unbreakable cables/pipes
  if ChoGGi.CheatMenuSettings.BreakChanceCablePipe then
    const.BreakChanceCable = 10000000
    const.BreakChancePipe = 10000000
  end

  if ChoGGi.CheatMenuSettings.DisableHints then
    mapdata.DisableHints = true
    HintsEnabled = false
  end

  --print startup msgs to console log
  for i = 1, #ChoGGi.StartupMsgs do
    AddConsoleLog(ChoGGi.StartupMsgs[i],true)
    --ConsolePrint(ChoGGi.StartupMsgs[i])
  end

  --people will likely just copy new mod over old, and I moved stuff around
  if ChoGGi._VERSION ~= ChoGGi.CheatMenuSettings._VERSION then
    --clean up
    ChoGGi.NewThread(ChoGGi.RemoveOldFiles)
    --update saved version
    ChoGGi.CheatMenuSettings._VERSION = ChoGGi._VERSION
    ChoGGi.WriteSettings()
  end

  ChoGGi.NewThread(function()

      --add some custom labels for cables/pipes
    if type(UICity.labels.GridElements) ~= "table" then
      UICity.labels.GridElements = {}
    else
      --remove any broken objects
      ChoGGi.RemoveMissingLabelObjects("GridElements")
    end
    if type(UICity.labels.ElectricityGridElement) ~= "table" then
      UICity.labels.ElectricityGridElement = {}
    else
      ChoGGi.RemoveMissingLabelObjects("ElectricityGridElement")
    end
    if type(UICity.labels.LifeSupportGridElement) ~= "table" then
      UICity.labels.LifeSupportGridElement = {}
    else
      ChoGGi.RemoveMissingLabelObjects("LifeSupportGridElement")
    end
    local function NewGridLabels(Label)
      if not next(UICity.labels[Label]) then
        local objs = GetObjects({class=Label}) or empty_table
        for i = 1, #objs do
          table.insert(UICity.labels[Label],objs[i])
          table.insert(UICity.labels.GridElements,objs[i])
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
    ChoGGi.CloseDialogsECM()

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
  if ChoGGi.CheatMenuSettings.StorageMechanizedDepot and building.class:find("MechanizedDepot") then
    building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageMechanizedDepot

  elseif building.class == "UniversalStorageDepot" then
    if ChoGGi.CheatMenuSettings.StorageUniversalDepot and building.entity == "StorageDepot" then
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageUniversalDepot
    --other
    elseif ChoGGi.CheatMenuSettings.StorageOtherDepot and building.entity ~= "StorageDepot" then
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot
    end

  elseif ChoGGi.CheatMenuSettings.StorageWasteDepot and building.class == "WasteRockDumpSite" then
    building.max_amount_WasteRock = ChoGGi.CheatMenuSettings.StorageWasteDepot
    if building:GetStoredAmount() < 0 then
      building:CheatEmpty()
      building:CheatFill()
    end

  elseif building.class == "MysteryDepot" and ChoGGi.CheatMenuSettings.StorageOtherDepot then
    building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot

  elseif building.class == "BlackCubeDumpSite" and ChoGGi.CheatMenuSettings.StorageOtherDepot then
    building.max_amount_BlackCube = ChoGGi.CheatMenuSettings.StorageOtherDepot

  elseif ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed and building.class == "DroneFactory" then
    building.performance = ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed

  elseif ChoGGi.CheatMenuSettings.SchoolTrainAll and building.class == "School" then
    for i = 1, #ChoGGi.Tables.PositiveTraits do
      building:SetTrait(i,ChoGGi.Tables.PositiveTraits[i])
    end

  elseif ChoGGi.CheatMenuSettings.SanatoriumCureAll and building.class == "Sanatorium" then
    for i = 1, #ChoGGi.Tables.NegativeTraits do
      building:SetTrait(i,ChoGGi.Tables.NegativeTraits[i])
    end
  end

  if ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp and building.base_maintenance_build_up_per_hr then
    building.maintenance_build_up_per_hr = -10000
  end

  if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and building.base_max_workers then
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings
  end

  --saved building settings
  local setting = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
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
      table.insert(UICity.labels.Domes_Working,tab[i])
    end
  end
end --OnMsg

local function ColonistCreated(Obj)
  if ChoGGi.CheatMenuSettings.GravityColonist then
    Obj:SetGravity(ChoGGi.CheatMenuSettings.GravityColonist)
  end
  if ChoGGi.CheatMenuSettings.NewColonistGender then
    ChoGGi.ColonistUpdateGender(Obj,ChoGGi.CheatMenuSettings.NewColonistGender)
  end
  if ChoGGi.CheatMenuSettings.NewColonistAge then
    ChoGGi.ColonistUpdateAge(Obj,ChoGGi.CheatMenuSettings.NewColonistAge)
  end
  if ChoGGi.CheatMenuSettings.NewColonistSpecialization then
    ChoGGi.ColonistUpdateSpecialization(Obj,ChoGGi.CheatMenuSettings.NewColonistSpecialization)
  end
  if ChoGGi.CheatMenuSettings.NewColonistRace then
    ChoGGi.ColonistUpdateRace(Obj,ChoGGi.CheatMenuSettings.NewColonistRace)
  end
  if ChoGGi.CheatMenuSettings.NewColonistTraits then
    ChoGGi.ColonistUpdateTraits(Obj,true,ChoGGi.CheatMenuSettings.NewColonistTraits)
  end
  if ChoGGi.CheatMenuSettings.SpeedColonist then
    Obj:SetMoveSpeed(ChoGGi.CheatMenuSettings.SpeedColonist)
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

function OnMsg.NewHour()

  --make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
  if ChoGGi.CheatMenuSettings.DroneResourceCarryAmountFix then
    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    local tab = UICity.labels.ResourceProducer or empty_table
    for i = 1, #tab do
      ChoGGi.FuckingDrones(tab[i]:GetProducerObj())
      if tab[i].wasterock_producer then
        ChoGGi.FuckingDrones(tab[i].wasterock_producer)
      end
    end
  end

end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  if ChoGGi.CheatMenuSettings.ShowMysteryMsgs then
    ChoGGi.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryChosen()
  if ChoGGi.CheatMenuSettings.ShowMysteryMsgs then
    ChoGGi.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryEnd(Outcome)
  if ChoGGi.CheatMenuSettings.ShowMysteryMsgs then
    ChoGGi.MsgPopup(tostring(Outcome),"Mystery","UI/Icons/Logos/logo_13.tga")
  end
end

function OnMsg.ApplicationQuit()

  --my comp or if we're resetting settings
  if ChoGGi.Testing or ChoGGi.ResetSettings then
    return
  end

  --save any unsaved settings on exit
  ChoGGi.WriteSettings()
end

--custom OnMsgs, these aren't part of the base game, so without this mod they don't work
ChoGGi.AddMsgToFunc("CargoShuttle","GameInit","SpawnedShuttle")
ChoGGi.AddMsgToFunc("Drone","GameInit","SpawnedDrone")
ChoGGi.AddMsgToFunc("RCTransport","GameInit","SpawnedRCTransport")
ChoGGi.AddMsgToFunc("RCRover","GameInit","SpawnedRCRover")
ChoGGi.AddMsgToFunc("ExplorerRover","GameInit","SpawnedExplorerRover")
ChoGGi.AddMsgToFunc("Residence","GameInit","SpawnedResidence")
ChoGGi.AddMsgToFunc("Workplace","GameInit","SpawnedWorkplace")
ChoGGi.AddMsgToFunc("GridObject","ApplyToGrids","CreatedGridObject")
ChoGGi.AddMsgToFunc("GridObject","RemoveFromGrids","RemovedGridObject")
ChoGGi.AddMsgToFunc("ElectricityProducer","CreateElectricityElement","SpawnedProducerElectricity")
ChoGGi.AddMsgToFunc("AirProducer","CreateLifeSupportElements","SpawnedProducerAir")
ChoGGi.AddMsgToFunc("WaterProducer","CreateLifeSupportElements","SpawnedProducerWater")
ChoGGi.AddMsgToFunc("SingleResourceProducer","Init","SpawnedProducerSingle")
ChoGGi.AddMsgToFunc("ElectricityStorage","GameInit","SpawnedElectricityStorage")
ChoGGi.AddMsgToFunc("LifeSupportGridObject","GameInit","SpawnedLifeSupportGridObject")
ChoGGi.AddMsgToFunc("PinnableObject","TogglePin","TogglePinnableObject")
ChoGGi.AddMsgToFunc("ResourceStockpileLR","GameInit","SpawnedResourceStockpileLR")
ChoGGi.AddMsgToFunc("DroneHub","GameInit","SpawnedDroneHub")

--attached temporary resource depots
function OnMsg.SpawnedResourceStockpileLR(Obj)
  if ChoGGi.CheatMenuSettings.StorageMechanizedDepotsTemp and Obj.parent.class:find("MechanizedDepot") then
    ChoGGi.SetMechanizedDepotTempAmount(Obj.parent)
  end
end

function OnMsg.TogglePinnableObject(Obj)
  local unpin = ChoGGi.CheatMenuSettings.UnpinObjects
  if type(unpin) == "table" and next(unpin) then
    local tab = unpin or empty_table
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
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    table.insert(UICity.labels.GridElements,Obj)
  end
  if Obj.class == "ElectricityGridElement" then
    table.insert(UICity.labels.ElectricityGridElement,Obj)
  elseif Obj.class == "LifeSupportGridElement" then
    table.insert(UICity.labels.LifeSupportGridElement,Obj)
  end
end

function OnMsg.RemovedGridObject(Obj)
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    ChoGGi.RemoveFromLabel("GridElements",Obj)
  end
  if Obj.class == "ElectricityGridElement" then
    ChoGGi.RemoveFromLabel("ElectricityGridElement",Obj)
  elseif Obj.class == "LifeSupportGridElement" then
    ChoGGi.RemoveFromLabel("LifeSupportGridElement",Obj)
  end
end

--shuttle comes out of a hub
function OnMsg.SpawnedShuttle(Obj)
  local storage = ChoGGi.CheatMenuSettings.StorageShuttle
  if storage then
    Obj.max_shared_storage = storage
  end
  local speed = ChoGGi.CheatMenuSettings.SpeedShuttle
  if speed then
    Obj.max_speed = speed
  end
end

function OnMsg.SpawnedDrone(Obj)
  local gravity = ChoGGi.CheatMenuSettings.GravityDrone
  if gravity then
    Obj:SetGravity(gravity)
  end
  local speed = ChoGGi.CheatMenuSettings.SpeedDrone
  if speed then
    Obj:SetMoveSpeed(speed)
  end
end

local function RCCreated(Obj)
  if ChoGGi.CheatMenuSettings.SpeedRC then
    Obj:SetMoveSpeed(ChoGGi.CheatMenuSettings.SpeedRC)
  end
  if ChoGGi.CheatMenuSettings.GravityRC then
    Obj:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
  end
end
function OnMsg.SpawnedRCTransport(Obj)
  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity then
    Obj.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity
  end
  RCCreated(Obj)
end
function OnMsg.SpawnedRCRover(Obj)
  if ChoGGi.CheatMenuSettings.RCRoverDefaultRadius then
    Obj:SetWorkRadius()
  end
  RCCreated(Obj)
end
function OnMsg.SpawnedExplorerRover(Obj)
  RCCreated(Obj)
end

function OnMsg.SpawnedDroneHub(Obj)
  if ChoGGi.CheatMenuSettings.CommandCenterDefaultRadius then
    Obj:SetWorkRadius()
  end
end

--if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
function OnMsg.SpawnedResidence(Obj)
  ChoGGi.AttachToNearestDome(Obj)
end
function OnMsg.SpawnedWorkplace(Obj)
  ChoGGi.AttachToNearestDome(Obj)
end

--make sure they use with our new values
local function SetProd(Obj,sType)
  local prod = ChoGGi.CheatMenuSettings.BuildingSettings[Obj.encyclopedia_id]
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

--fired below
local function CheckForRate(Obj)

  --charge/discharge
  local value = ChoGGi.CheatMenuSettings.BuildingSettings[Obj.encyclopedia_id]

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

    if Obj.base_air_capacity then
      SetValue("air")
    elseif Obj.base_water_capacity then
      SetValue("water")
    elseif Obj.electricity and Obj.electricity.storage_capacity then
      SetValue("electricity")
    end

  end
end

--waterair tanks, etc
function OnMsg.SpawnedLifeSupportGridObject(Obj)
  CheckForRate(Obj)
end
--battery
function OnMsg.SpawnedElectricityStorage(Obj)
  CheckForRate(Obj)
end
