
function OnMsg.ClassesGenerate()

  --i like keeping all my OnMsgs. in one file
  ChoGGi.ReplacedFunctions_ClassesGenerate()
  ChoGGi.InfoPaneCheats_ClassesGenerate()
  ChoGGi.UIDesignerData_ClassesGenerate()
  ChoGGi.ObjectManipulator_ClassesGenerate()

  --change some building template settings
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    if ChoGGi.CheatMenuSettings.Building_dome_spot then
      building.dome_spot = nil
    end
    if ChoGGi.CheatMenuSettings.Building_dome_forbidden then
      building.dome_spot = nil
    end
    if ChoGGi.CheatMenuSettings.Building_dome_required then
      building.dome_spot = nil
    end
    if ChoGGi.CheatMenuSettings.Building_is_tall then
      building.is_tall = nil
    end
    if ChoGGi.CheatMenuSettings.Building_instant_build then
      --instant_build on domes == missing ground textures
      if not (building.build_category == "Domes" or building.template_class == "GeoscapeDome") then
        building.instant_build = true
      end
    end
    --update depot storage amounts
    if building.template_class == "UniversalStorageDepot" then
      if building.max_storage_per_resource == 30000 then
        building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageUniversalDepot
      else
        building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot
      end
    elseif building.template_class == "WasteRockDumpSite" then
      building.max_amount_WasteRock = ChoGGi.CheatMenuSettings.StorageWasteDepot
    elseif building.template_class == "BlackCubeDumpSite" then
      building.max_amount_BlackCube = ChoGGi.CheatMenuSettings.StorageOtherDepot
    elseif building.template_class == "MysteryDepot" then
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot
    end

  end --BuildingTemplate

end --OnMsg

function OnMsg.ClassesBuilt()

  ChoGGi.ReplacedFunctions_ClassesBuilt()
  ChoGGi.UIDesignerData_ClassesBuilt()
  ChoGGi.ObjectManipulator_ClassesBuilt()

  --add HiddenX cat for Hidden items
  if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
    table.insert(BuildCategories,{id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",})
  end

end --OnMsg

function OnMsg.OptionsApply()
  ChoGGi.Settings_OptionsApply()
end --OnMsg

--function OnMsg.ModsLoaded()

--saved game is loaded
function OnMsg.LoadGame()
  --so LoadingScreenPreClose gets fired only every load, rather than also everytime we save
  ChoGGi.IsGameLoaded = false
end

--for new games
function OnMsg.CityStart()
  ChoGGi.IsGameLoaded = false
end

--fired as late as we can
function OnMsg.LoadingScreenPreClose()
--function OnMsg.Resume()

  --for new games
  if not UICity then
    if ChoGGi.Testing then
      table.insert(ChoGGi.StartupMsgs,"not UICity")
    end
    return
  end

  if ChoGGi.IsGameLoaded == true then
    return
  else
    ChoGGi.IsGameLoaded = true
  end

  --late enough that I can set g_Consts.
  ChoGGi.SetConstsToSaved()
  --needed for DroneResourceCarryAmount
  UpdateDroneResourceUnits()

  ChoGGi.RenderSettings_LoadingScreenPreClose()
  ChoGGi.Keys_LoadingScreenPreClose()
  ChoGGi.SponsorsFunc_LoadingScreenPreClose()

  --remove any opened examine dialogs
  local win = terminal.desktop
  while ChoGGi.CheckForTypeInList(win,"Examine") do
    for i = 1, #win do
      if IsKindOf(win[i],"Examine") then
        win[i]:delete()
      end
    end
  end

  --not sure why this would be false on a dome
  for _,Object in ipairs(UICity.labels.Dome or empty_table) do
    if Object.achievement == "FirstDome" and type(Object.connected_domes) ~= "table" then
      Object.connected_domes = {}
    end
  end

  --remove any outside buildings i accidentally attached to domes ;)
  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    if building.dome_required == false and building.parent_dome then

      --remove it from the dome label
      local sType = false
      if building.closed_shifts then
        sType = "Residence"
      elseif building.colonists then
        sType = "Workplace"
      end

      if sType then --get a fucking continue lua
        if building.parent_dome.labels and building.parent_dome.labels[sType] then
          local dome = building.parent_dome.labels[sType]
          for i = 1, #dome do
            if dome[i].class == building.class then
              dome[i] = nil
            end
          end
        end
        --remove parent_dome
        building.parent_dome = nil
      end

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

  --make sure all buildings are using correct production
  ChoGGi.SetProductionToSavedAmt()

  --something messed up if storage is negative (usually setting an amount then lowering it)
  pcall(function()
    for _,building in ipairs(UICity.labels.Storages or empty_table) do
      if building:GetStoredAmount() < 0 then
        --we have to empty it first (just filling doesn't fix the issue)
        building:CheatEmpty()
        building:CheatFill()
      end
    end
  end)

  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity then
    for _,Object in ipairs(UICity.labels.RCTransport or empty_table) do
      Object.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity
    end
  end

  --drone gravity
  if ChoGGi.CheatMenuSettings.GravityDrone then
    for _,Object in ipairs(UICity.labels.Drone or empty_table) do
      Object:SetGravity(ChoGGi.CheatMenuSettings.GravityDrone)
    end
  end

  --so we can change the max_amount for concrete
  for Key,_ in ipairs(TerrainDepositConcrete.properties) do
    local prop = TerrainDepositConcrete.properties[Key]
    if prop.id == "max_amount" then
      prop.read_only = nil
    end
  end

  --override building templates
  for _,building in ipairs(DataInstances.BuildingTemplate) do

    --make hidden buildings visible
    if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      if building.name ~= "LifesupportSwitch" and building.name ~= "ElectricitySwitch" then
        building.hide_from_build_menu = nil
      end
      if building.build_category == "Hidden" and building.name ~= "RocketLandingSite" then
        building.build_category = "HiddenX"
      end
    end

    if ChoGGi.CheatMenuSettings.Building_wonder then
      building.wonder = nil
    end
  end

  --show all Mystery Breakthrough buildings
  if ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings then
    UnlockBuilding("DefenceTower")
    UnlockBuilding("CloningVats")
    UnlockBuilding("BlackCubeDump")
    UnlockBuilding("BlackCubeSmallMonument")
    UnlockBuilding("BlackCubeLargeMonument")
    UnlockBuilding("PowerDecoy")
    UnlockBuilding("DomeOval")
  end

  if ChoGGi.CheatMenuSettings.ShowAllTraits then
    g_SchoolTraits = ChoGGi.PositiveTraits
    g_SanatoriumTraits = ChoGGi.NegativeTraits
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

  -- This must return true for most (built-in) cheats to function
  function CheatsEnabled()
    return true
  end
  --add built-in cheat menu items
  AddCheatsUA()

  --remove some built-in menu items
  UserActions.RemoveActions({
    --useless without developer tools?
    "BuildingEditor",
    --these will switch the map without asking to save
    "G_ModsEditor",
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
    "G_ToggleInfopanelCheats",
    "G_UnlockAllBuildings",
    "G_AddFunding",
    "G_ResearchAll",
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

  if ChoGGi.Testing then
    --always show on my computer
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
    --ShowConsole(true)
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
    Sanatorium.max_traits = #ChoGGi.NegativeTraits
    School.max_traits = #ChoGGi.PositiveTraits
  end

  --unbreakable cables/pipes
  if ChoGGi.CheatMenuSettings.BreakChanceCablePipe then
    const.BreakChanceCable = 10000000
    const.BreakChancePipe = 10000000
  end

  if ChoGGi.CheatMenuSettings.DisableHints then
    mapdata.DisableHints = true
  end

  --print startup msgs to console log
  for i = 1, #ChoGGi.StartupMsgs do
    AddConsoleLog(ChoGGi.StartupMsgs[i],true)
    --ConsolePrint(ChoGGi.StartupMsgs[i])
  end

  --people will likely just copy new mod over old, and I moved stuff around
  ChoGGi._VERSION = _G.Mods.ChoGGi_CheatMenu.version
  if ChoGGi._VERSION ~= ChoGGi.CheatMenuSettings._VERSION then
    --clean up (in a seprate thread)
    ChoGGi.RemoveOldFiles()
    --update saved version
    ChoGGi.CheatMenuSettings._VERSION = ChoGGi._VERSION
    ChoGGi.WriteSettings()
  end

end --OnMsg

function OnMsg.BuildingPlaced(Object)
  ChoGGi.LastPlacedObject = Object
end --OnMsg

function OnMsg.ConstructionSitePlaced(Object)
  ChoGGi.LastPlacedObject = Object
end --OnMsg

function OnMsg.ConstructionComplete(building)

  --skip rockets
  if building.class == "RocketLandingSite" then
    return
  end

--  print("ConstructionComplete")

  --print(building.encyclopedia_id)
  if IsKindOf(building,"RCTransportBuilding") then
    if ChoGGi.CheatMenuSettings.GravityRC then
      building:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
    end

  elseif IsKindOf(building,"RCRoverBuilding") then
    if ChoGGi.CheatMenuSettings.GravityRC then
      building:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
    end

  elseif IsKindOf(building,"RCExplorerBuilding") then
    if ChoGGi.CheatMenuSettings.GravityRC then
      building:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
    end

  elseif IsKindOf(building,"DroneFactory") then
    if ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed then
      building.performance = ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed
    end

  elseif IsKindOf(building,"School") and ChoGGi.CheatMenuSettings.SchoolTrainAll then
    for i = 1, #ChoGGi.PositiveTraits do
      building:SetTrait(i,ChoGGi.PositiveTraits[i])
    end

  elseif IsKindOf(building,"Sanatorium") and ChoGGi.CheatMenuSettings.SanatoriumCureAll then
    for i = 1, #ChoGGi.NegativeTraits do
      building:SetTrait(i,ChoGGi.NegativeTraits[i])
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

  --saved settings for capacity, visitors, shuttles
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id] then
    local amount = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    if building.base_capacity then
      building.capacity = amount
    elseif building.base_max_visitors then
      building.max_visitors = amount
    elseif building.base_air_capacity then
      building.air_capacity = amount
    elseif building.base_water_capacity then
      building.water_capacity = amount
    elseif building.base_max_shuttles then
      building.max_shuttles = amount
    end
  end

  building.can_change_skin = true

end --OnMsg

function OnMsg.Demolished(building)
  --update our list of working domes for AttachToNearestDome (though I wonder why this isn't already a label)
  if building.achievement == "FirstDome" then
    UICity.labels.Domes_Working = {}
    for _,object in ipairs(UICity.labels.Dome) do
      table.insert(UICity.labels.Domes_Working,object)
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
end
--[[
function OnMsg.SelectedObjChange(Obj)
  s = Obj
end
--]]

function OnMsg.NewDay()

  --clean up my old notifications
  local shown = g_ShownOnScreenNotifications
  for Key,_ in pairs(shown) do
    if tostring(Key):find("ChoGGi_") then
      shown[Key] = nil
    end
  end

end

function OnMsg.NewHour()

  --make them lazy drones stop abusing electricity
  if ChoGGi.DronesOverride then
    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    for _,Value in ipairs(UICity.labels.ResourceProducer or empty_table) do
      ChoGGi.FuckingDrones(Value:GetProducerObj())
      if Value.wasterock_producer then
        ChoGGi.FuckingDrones(Value.wasterock_producer)
      end
    end
  end

  --make sure all buildings are using correct production
  ChoGGi.SetProductionToSavedAmt()

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

  --defaults goddamnit
  if ChoGGi.ResetSettings then
    return
  end

  --save any unsaved settings on exit
  if ChoGGi.Testing then
    return
  end

  ChoGGi.WriteSettings()
end

--custom OnMsgs, these aren't part of the base game, so without this mod they don't work
ChoGGi.AddMsgToFunc(CargoShuttle.GameInit,"CargoShuttle","GameInit","SpawnedShuttle")
ChoGGi.AddMsgToFunc(Drone.GameInit,"Drone","GameInit","SpawnedDrone")
ChoGGi.AddMsgToFunc(RCTransport.GameInit,"RCTransport","GameInit","SpawnedRCTransport")
ChoGGi.AddMsgToFunc(Residence.GameInit,"Residence","GameInit","SpawnedResidence")
ChoGGi.AddMsgToFunc(Workplace.GameInit,"Workplace","GameInit","SpawnedWorkplace")
ChoGGi.AddMsgToFunc(ElectricityProducer.CreateElectricityElement,"ElectricityProducer","CreateElectricityElement","SpawnedProducerElectricity")
ChoGGi.AddMsgToFunc(AirProducer.CreateLifeSupportElements,"AirProducer","CreateLifeSupportElements","SpawnedProducerAir")
ChoGGi.AddMsgToFunc(WaterProducer.CreateLifeSupportElements,"WaterProducer","CreateLifeSupportElements","SpawnedProducerWater")
ChoGGi.AddMsgToFunc(SingleResourceProducer.Init,"SingleResourceProducer","Init","SpawnedProducerSingle")

--shuttle comes out of a hub
function OnMsg.SpawnedShuttle(Obj)
  if ChoGGi.CheatMenuSettings.StorageShuttle then
    Obj.max_shared_storage = ChoGGi.CheatMenuSettings.StorageShuttle
  end
  if ChoGGi.CheatMenuSettings.SpeedShuttle then
    Obj.max_speed = ChoGGi.CheatMenuSettings.SpeedShuttle
  end
end

function OnMsg.SpawnedDrone(Obj)
  if ChoGGi.CheatMenuSettings.GravityDrone then
    Obj:SetGravity(ChoGGi.CheatMenuSettings.GravityDrone)
  end
end

function OnMsg.SpawnedRCTransport(Obj)
  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity then
    Obj.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity
  end
end

--if building placed outside of dome, attach it to nearest dome
function OnMsg.SpawnedResidence(Obj)
  ChoGGi.AttachToNearestDome(Obj)
end
function OnMsg.SpawnedWorkplace(Obj)
  ChoGGi.AttachToNearestDome(Obj)
end

--make sure they use with our new values
function OnMsg.SpawnedProducerElectricity(Obj)
  if ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.encyclopedia_id] then
    Obj.electricity_production = ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.encyclopedia_id]
  end
end
function OnMsg.SpawnedProducerAir(Obj)
  if ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.encyclopedia_id] then
    Obj.air_production = ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.encyclopedia_id]
  end
end
function OnMsg.SpawnedProducerWater(Obj)
  if ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.encyclopedia_id] then
    Obj.water_production = ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.encyclopedia_id]
  end
end
function OnMsg.SpawnedProducerSingle(Obj)
  if ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.parent.encyclopedia_id] then
    Obj.production_per_day = ChoGGi.CheatMenuSettings.BuildingsProduction[Obj.parent.encyclopedia_id]
  end
end
