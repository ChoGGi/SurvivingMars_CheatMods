local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cMsgFuncs = ChoGGi.MsgFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables
local cTesting = ChoGGi.Temp.Testing

--fired as early as possible (excluding Init.lua of course, but i like to keep that simple)
if ChoGGi.UserSettings.DisableHints then
  mapdata.DisableHints = true
  HintsEnabled = false
end

function OnMsg.ClassesGenerate()
  --i like keeping all my OnMsgs. in one file
  cMsgFuncs.ReplacedFunctions_ClassesGenerate()
  cMsgFuncs.InfoPaneCheats_ClassesGenerate()
  cMsgFuncs.ListChoiceCustom_ClassesGenerate()
  cMsgFuncs.ObjectManipulator_ClassesGenerate()
  if cTesting then
    cMsgFuncs.Testing_ClassesGenerate()
  end
end --OnMsg

function OnMsg.ClassesPreprocess()
  if cTesting then
    cMsgFuncs.Testing_ClassesPreprocess()
  end
end

--where we add new BuildingTemplates
function OnMsg.ClassesPostprocess()
  if cTesting then
    cMsgFuncs.Testing_ClassesPostprocess()
  end
end

function OnMsg.ClassesBuilt()
  cMsgFuncs.ReplacedFunctions_ClassesBuilt()
  cMsgFuncs.ListChoiceCustom_ClassesBuilt()
  cMsgFuncs.ObjectManipulator_ClassesBuilt()
  if cTesting then
    cMsgFuncs.Testing_ClassesBuilt()
  end

  --add HiddenX cat for Hidden items
  if ChoGGi.UserSettings.Building_hide_from_build_menu then
    BuildCategories[#BuildCategories+1] = {id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",}
  end

end --OnMsg

function OnMsg.OptionsApply()
  cMsgFuncs.Settings_OptionsApply()
end --OnMsg

function OnMsg.ModsLoaded()
  cMsgFuncs.Settings_ModsLoaded()
end

--earlist on-ground objects are loaded?
--function OnMsg.PersistLoad()

--saved game is loaded
function OnMsg.LoadGame()
  --so LoadingScreenPreClose gets fired only every load, rather than also everytime we save
  ChoGGi.Temp.IsGameLoaded = false
end

--for new games
--OnMsg.NewMapLoaded()
function OnMsg.CityStart()
  ChoGGi.Temp.IsGameLoaded = false
  --reset my mystery msgs to hidden
  ChoGGi.UserSettings.ShowMysteryMsgs = nil
end

--fired as late as we can
--function OnMsg.Resume()
function OnMsg.LoadingScreenPreClose()
  local city = UICity

  --for new games
  if not city then
    return
  end

  local ChoGGi = ChoGGi
  local Temp = ChoGGi.Temp
  local UserSettings = ChoGGi.UserSettings

  if Temp.IsGameLoaded == true then
    return
  end
  Temp.IsGameLoaded = true

  --late enough that I can set g_Consts.
  cSettingFuncs.SetConstsToSaved()
  --needed for DroneResourceCarryAmount?
  UpdateDroneResourceUnits()

  --remove all built-in actions
  UserActions.ClearGlobalTables()
  UserActions.Actions = {}
  UserActions.RejectedActions = {}

  cMsgFuncs.Keys_LoadingScreenPreClose()
  cMsgFuncs.MissionFunc_LoadingScreenPreClose()
  if cTesting then
    cMsgFuncs.Testing_LoadingScreenPreClose()
  end

  --add custom actions
  cMsgFuncs.MissionMenu_LoadingScreenPreClose()
  cMsgFuncs.BuildingsMenu_LoadingScreenPreClose()
  cMsgFuncs.CheatsMenu_LoadingScreenPreClose()
  cMsgFuncs.ColonistsMenu_LoadingScreenPreClose()
  cMsgFuncs.DebugMenu_LoadingScreenPreClose()
  cMsgFuncs.DronesAndRCMenu_LoadingScreenPreClose()
  cMsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  cMsgFuncs.HelpMenu_LoadingScreenPreClose()
  cMsgFuncs.MiscMenu_LoadingScreenPreClose()
  cMsgFuncs.ResourcesMenu_LoadingScreenPreClose()

  --add preset menu items
  ClassDescendantsList("Preset", function(name, class)
    local preset_class = class.PresetClass or name
    Presets[preset_class] = Presets[preset_class] or {}
    local map = class.GlobalMap
    if map then
      rawset(_G, map, rawget(_G, map) or {})
    end
    cComFuncs.AddAction(
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

  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

  --add custom lightmodel
  local data = DataInstances.Lightmodel
  if data.ChoGGi_Custom then
    data.ChoGGi_Custom:delete()
  end
  local _,LightmodelCustom = LuaCodeToTuple(UserSettings.LightmodelCustom)
  if not LightmodelCustom then
    _,LightmodelCustom = LuaCodeToTuple(cConsts.LightmodelCustom)
  end

  if LightmodelCustom then
    data.ChoGGi_Custom = LightmodelCustom
  else
    LightmodelCustom = cConsts.LightmodelCustom
    UserSettings.LightmodelCustom = LightmodelCustom
    data.ChoGGi_Custom = LightmodelCustom
    Temp.WriteSettings = true
  end
  Temp.LightmodelCustom = LightmodelCustom

  --if there's a lightmodel name saved
  local LightModel = UserSettings.LightModel
  if LightModel then
    SetLightmodelOverride(1,LightModel)
  end

  --default only saved 20 items in console history
  const.nConsoleHistoryMaxSize = 100

  --long arsed cables
  if UserSettings.UnlimitedConnectionLength then
    GridConstructionController.max_hex_distance_to_allow_build = 1000
  end

  --on by default, you know all them martian trees (might make a cpu difference, probably not)
  hr.TreeWind = 0

  if UserSettings.DisableTextureCompression then
    --uses more vram (1 toggles it, not sure what 0 does...)
    hr.TR_ToggleTextureCompression = 1
  end

  if UserSettings.ShadowmapSize then
    hr.ShadowmapSize = UserSettings.ShadowmapSize
  end

  if UserSettings.HigherRenderDist then
    --lot of lag for some small rocks in distance
    --hr.DistanceModifier = 260 --default 130
    --hr.AutoFadeDistanceScale = 2200 --def 2200
    --render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
    if type(UserSettings.HigherRenderDist) == "number" then
      hr.LODDistanceModifier = UserSettings.HigherRenderDist
    else
      hr.LODDistanceModifier = 600 --def 120
    end
  end

  if UserSettings.HigherShadowDist then
    if type(UserSettings.HigherShadowDist) == "number" then
      hr.ShadowRangeOverride = UserSettings.HigherShadowDist
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
  tab = city.labels.Dome or empty_table
  for i = 1, #tab do
    if tab[i].achievement == "FirstDome" and type(tab[i].connected_domes) ~= "table" then
      tab[i].connected_domes = {}
    end
  end

  --something messed up if storage is negative (usually setting an amount then lowering it)
  tab = city.labels.Storages or empty_table
  pcall(function()
    for i = 1, #tab do
      if tab[i]:GetStoredAmount() < 0 then
        --we have to empty it first (just filling doesn't fix the issue)
        tab[i]:CheatEmpty()
        tab[i]:CheatFill()
      end
    end
  end)

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
    if UserSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      BuildMenuPrerequisiteOverrides["MechanizedDepotMysteryResource"] = true
      if tab[i].name ~= "LifesupportSwitch" and tab[i].name ~= "ElectricitySwitch" then
        tab[i].hide_from_build_menu = nil
      end
      if tab[i].build_category == "Hidden" and tab[i].name ~= "RocketLandingSite" then
        tab[i].build_category = "HiddenX"
      end
    end

    if UserSettings.Building_wonder then
      tab[i].wonder = nil
    end
  end

  --show cheat pane?
  if UserSettings.InfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if UserSettings.ConsoleToggleHistory then
    ShowConsoleLog(true)
  end

  --dim that console bg
  if UserSettings.ConsoleDim then
    config.ConsoleDim = 1
  end

  if UserSettings.ShowCheatsMenu or cTesting then
    --always show on my computer
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
  end

  --remove some uselessish Cheats to clear up space
  if UserSettings.CleanupCheatsInfoPane then
    cInfoFuncs.InfopanelCheatsCleanup()
  end

  --default to showing interface in ss
  if UserSettings.ShowInterfaceInScreenshots then
    hr.InterfaceInScreenshot = 1
  end

  --set zoom/border scrolling
  cCodeFuncs.SetCameraSettings()

  --show all traits
  if UserSettings.SanatoriumSchoolShowAll then
    Sanatorium.max_traits = #cTables.NegativeTraits
    School.max_traits = #cTables.PositiveTraits
  end

  --unbreakable cables/pipes
  if UserSettings.BreakChanceCablePipe then
    const.BreakChanceCable = 10000000
    const.BreakChancePipe = 10000000
  end

  --people will likely just copy new mod over old, and I moved stuff around (not as important now that most everything is stored in .hpk)
  if ChoGGi._VERSION ~= UserSettings._VERSION then
    --clean up
    cCodeFuncs.NewThread(cCodeFuncs.RemoveOldFiles)
    --update saved version
    UserSettings._VERSION = ChoGGi._VERSION
    Temp.WriteSettings = true
  end

  cCodeFuncs.NewThread(function()
    --add custom labels for cables/pipes
    local labels = city.labels
    local function CheckLabel(Label)
      if not labels[Label] then
        city:InitEmptyLabel(Label)
        if Label == "ChoGGi_ElectricityGridElement" or Label == "ChoGGi_LifeSupportGridElement" then
          local objs = GetObjects({class=Label:gsub("ChoGGi_","")}) or empty_table
          for i = 1, #objs do
            labels[Label][#labels[Label]+1] = objs[i]
            labels.ChoGGi_GridElements[#labels.ChoGGi_GridElements+1] = objs[i]
          end
        end
      end
    end
    CheckLabel("ChoGGi_GridElements")
    CheckLabel("ChoGGi_ElectricityGridElement")
    CheckLabel("ChoGGi_LifeSupportGridElement")

    --clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
    local shown = g_ShownOnScreenNotifications
    for Key,_ in pairs(shown) do
      if type(Key) == "number" or tostring(Key):find("ChoGGi_")then
        shown[Key] = nil
      end
    end

    --remove any dialogs we opened
    ChoGGi.CodeFuncs.CloseDialogsECM()

    --remove any outside buildings i accidentally attached to domes ;)
    tab = city.labels.BuildingNoDomes or empty_table
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

    --make the change map dialog movable
    DataInstances.UIDesignerData.MapSettingsDialog.parent_control.Movable = true
    DataInstances.UIDesignerData.MessageQuestionBox.parent_control.Movable = true
  end)

  --make sure to save anything we changed above
  if Temp.WriteSettings then
    cSettingFuncs.WriteSettings()
    Temp.WriteSettings = nil
  end

  --print startup msgs to console log
  local msgs = Temp.StartupMsgs
  for i = 1, #msgs do
    AddConsoleLog(msgs[i],true)
    --ConsolePrint(ChoGGi.Temp.StartupMsgs[i])
  end

end --OnMsg

function OnMsg.BuildingPlaced(Obj)
  if IsKindOf(Obj,"Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end --OnMsg

function OnMsg.ConstructionSitePlaced(Obj)
  if IsKindOf(Obj,"Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end --OnMsg

--this gets called before buildings are completely initialized (no air/water/elec attached)
function OnMsg.ConstructionComplete(building)

  --skip rockets
  if building.class == "RocketLandingSite" then
    return
  end
  local UserSettings = ChoGGi.UserSettings

  --print(building.encyclopedia_id) print(building.class)
  if building.class == "UniversalStorageDepot" then
    if UserSettings.StorageUniversalDepot and building.entity == "StorageDepot" then
      building.max_storage_per_resource = UserSettings.StorageUniversalDepot
    --other
    elseif UserSettings.StorageOtherDepot and building.entity ~= "StorageDepot" then
      building.max_storage_per_resource = UserSettings.StorageOtherDepot
    end

  elseif UserSettings.StorageMechanizedDepot and building.class:find("MechanizedDepot") then
    building.max_storage_per_resource = UserSettings.StorageMechanizedDepot

  elseif UserSettings.StorageWasteDepot and building.class == "WasteRockDumpSite" then
    building.max_amount_WasteRock = UserSettings.StorageWasteDepot
    if building:GetStoredAmount() < 0 then
      building:CheatEmpty()
      building:CheatFill()
    end

  elseif UserSettings.StorageOtherDepot and building.class == "MysteryDepot" then
    building.max_storage_per_resource = UserSettings.StorageOtherDepot

  elseif UserSettings.StorageOtherDepot and building.class == "BlackCubeDumpSite" then
    building.max_amount_BlackCube = UserSettings.StorageOtherDepot

  elseif UserSettings.DroneFactoryBuildSpeed and building.class == "DroneFactory" then
    building.performance = UserSettings.DroneFactoryBuildSpeed

  elseif UserSettings.ShuttleHubFuelStorage and building.class:find("ShuttleHub") then
    building.consumption_max_storage = UserSettings.ShuttleHubFuelStorage

  elseif UserSettings.SchoolTrainAll and building.class == "School" then
    for i = 1, #cTables.PositiveTraits do
      building:SetTrait(i,cTables.PositiveTraits[i])
    end

  elseif UserSettings.SanatoriumCureAll and building.class == "Sanatorium" then
    for i = 1, #cTables.NegativeTraits do
      building:SetTrait(i,cTables.NegativeTraits[i])
    end

  end --end of elseifs

  if UserSettings.RemoveMaintenanceBuildUp and building.base_maintenance_build_up_per_hr then
    building.maintenance_build_up_per_hr = -10000
  end

  local FullyAutomatedBuildings = UserSettings.FullyAutomatedBuildings
  if FullyAutomatedBuildings and building.base_max_workers then
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = FullyAutomatedBuildings
  end

  --saved building settings
  local setting = UserSettings.BuildingSettings[building.encyclopedia_id]
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
      building.shoot_range = setting.protect_range * cConsts.guim
    end
  end

end --OnMsg

function OnMsg.Demolished(building)
  --update our list of working domes for AttachToNearestDome (though I wonder why this isn't already a label)
  if building.achievement == "FirstDome" then
    local city = building.city or UICity
    city.labels.Domes_Working = nil
    city:InitEmptyLabel("Domes_Working")
    local tab = city.labels.Dome or empty_table
    for i = 1, #tab do
      city.labels.Domes_Working[#city.labels.Domes_Working+1] = tab[i]
    end
  end
end --OnMsg

local function ColonistCreated(Obj)
  local UserSettings = ChoGGi.UserSettings

  if UserSettings.GravityColonist then
    Obj:SetGravity(UserSettings.GravityColonist)
  end
  if UserSettings.NewColonistGender then
    cCodeFuncs.ColonistUpdateGender(Obj,UserSettings.NewColonistGender)
  end
  if UserSettings.NewColonistAge then
    cCodeFuncs.ColonistUpdateAge(Obj,UserSettings.NewColonistAge)
  end
  if UserSettings.NewColonistSpecialization then
    cCodeFuncs.ColonistUpdateSpecialization(Obj,UserSettings.NewColonistSpecialization)
  end
  if UserSettings.NewColonistRace then
    cCodeFuncs.ColonistUpdateRace(Obj,UserSettings.NewColonistRace)
  end
  if UserSettings.NewColonistTraits then
    cCodeFuncs.ColonistUpdateTraits(Obj,true,UserSettings.NewColonistTraits)
  end
  if UserSettings.SpeedColonist then
    Obj:SetMoveSpeed(UserSettings.SpeedColonist)
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
  if IsKindOf(Obj,"Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end

function OnMsg.SelectionRemoved()
  s = false
end

function OnMsg.NewDay() --newsol

  --sorts cc list by dist to building
  if ChoGGi.UserSettings.SortCommandCenterDist then
    local blds = GetObjects({class="Building"})
    for i = 1, #blds do
      table.sort(blds[i].command_centers,
        function(a,b)
          return cComFuncs.CompareTableFuncs(a,b,"GetDist2D",blds[i])
        end
      )
    end
  end

  --GridObject.RemoveFromGrids doesn't fire for all elements? (it leaves one from the end of each grid (or grid line?), so we remove them here)
  local labels = UICity.labels
  if UICity.labels.ChoGGi_GridElements then
    local function ValidGridElements(Label)
      local Table = labels[Label]
      for i = #Table, 1, -1 do
        if not IsValid(Table[i]) then
          table.remove(Table,i)
        end
      end
    end
    ValidGridElements("ChoGGi_GridElements")
    ValidGridElements("ChoGGi_LifeSupportGridElement")
    ValidGridElements("ChoGGi_ElectricityGridElement")
  end

end

function OnMsg.NewHour()
  --make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
  if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    local tab = UICity.labels.ResourceProducer or empty_table
    for i = 1, #tab do
      cCodeFuncs.FuckingDrones(tab[i]:GetProducerObj())
      if tab[i].wasterock_producer then
        cCodeFuncs.FuckingDrones(tab[i].wasterock_producer)
      end
    end
  end

end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    cComFuncs.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryChosen()
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    cComFuncs.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryEnd(Outcome)
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    cComFuncs.MsgPopup(tostring(Outcome),"Mystery","UI/Icons/Logos/logo_13.tga")
  end
end

function OnMsg.ApplicationQuit()

  --my comp or if we're resetting settings
  if ChoGGi.Temp.ResetSettings or cTesting then
    return
  end

  --save any unsaved settings on exit
  cSettingFuncs.WriteSettings()
end

--custom OnMsgs
cComFuncs.AddMsgToFunc("CargoShuttle","GameInit","ChoGGi_SpawnedShuttle")
cComFuncs.AddMsgToFunc("Drone","GameInit","ChoGGi_SpawnedDrone")
cComFuncs.AddMsgToFunc("RCTransport","GameInit","ChoGGi_SpawnedRCTransport")
cComFuncs.AddMsgToFunc("RCRover","GameInit","ChoGGi_SpawnedRCRover")
cComFuncs.AddMsgToFunc("ExplorerRover","GameInit","ChoGGi_SpawnedExplorerRover")
cComFuncs.AddMsgToFunc("Residence","GameInit","ChoGGi_SpawnedResidence")
cComFuncs.AddMsgToFunc("Workplace","GameInit","ChoGGi_SpawnedWorkplace")
cComFuncs.AddMsgToFunc("GridObject","ApplyToGrids","ChoGGi_CreatedGridObject")
cComFuncs.AddMsgToFunc("GridObject","RemoveFromGrids","ChoGGi_RemovedGridObject")
cComFuncs.AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducerElectricity")
cComFuncs.AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerAir")
cComFuncs.AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerWater")
cComFuncs.AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducerSingle")
cComFuncs.AddMsgToFunc("ElectricityStorage","GameInit","ChoGGi_SpawnedElectricityStorage")
cComFuncs.AddMsgToFunc("LifeSupportGridObject","GameInit","ChoGGi_SpawnedLifeSupportGridObject")
cComFuncs.AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")
cComFuncs.AddMsgToFunc("ResourceStockpileLR","GameInit","ChoGGi_SpawnedResourceStockpileLR")
cComFuncs.AddMsgToFunc("DroneHub","GameInit","ChoGGi_SpawnedDroneHub")

--attached temporary resource depots
function OnMsg.ChoGGi_SpawnedResourceStockpileLR(Obj)
  if ChoGGi.UserSettings.StorageMechanizedDepotsTemp and Obj.parent.class:find("MechanizedDepot") then
    cCodeFuncs.SetMechanizedDepotTempAmount(Obj.parent)
  end
end

function OnMsg.ChoGGi_TogglePinnableObject(Obj)
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
function OnMsg.ChoGGi_CreatedGridObject(Obj)
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    local labels = UICity.labels
    labels.ChoGGi_GridElements[#labels.ChoGGi_GridElements+1] = Obj
    local label = labels["ChoGGi_" .. Obj.class]
    label[#label+1] = Obj
  end
end
function OnMsg.ChoGGi_RemovedGridObject(Obj)
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    cComFuncs.RemoveFromLabel("ChoGGi_GridElements",Obj)
    cComFuncs.RemoveFromLabel("ChoGGi_" .. Obj.class,Obj)
  end
end

--shuttle comes out of a hub
function OnMsg.ChoGGi_SpawnedShuttle(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.StorageShuttle then
    Obj.max_shared_storage = UserSettings.StorageShuttle
  end
  if UserSettings.SpeedShuttle then
    Obj.max_speed = UserSettings.SpeedShuttle
  end
end

function OnMsg.ChoGGi_SpawnedDrone(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.GravityDrone then
    Obj:SetGravity(UserSettings.GravityDrone)
  end
  if UserSettings.SpeedDrone then
    Obj:SetMoveSpeed(UserSettings.SpeedDrone)
  end
end

local function RCCreated(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.SpeedRC then
    Obj:SetMoveSpeed(UserSettings.SpeedRC)
  end
  if UserSettings.GravityRC then
    Obj:SetGravity(UserSettings.GravityRC)
  end
end
function OnMsg.ChoGGi_SpawnedRCTransport(Obj)
  local RCTransportStorageCapacity = ChoGGi.UserSettings.RCTransportStorageCapacity
  if RCTransportStorageCapacity then
    Obj.max_shared_storage = RCTransportStorageCapacity
  end
  RCCreated(Obj)
end
function OnMsg.ChoGGi_SpawnedRCRover(Obj)
  if ChoGGi.UserSettings.RCRoverMaxRadius then
    Obj:SetWorkRadius() -- I override the func so no need to send a value here
  end
  RCCreated(Obj)
end
function OnMsg.ChoGGi_SpawnedExplorerRover(Obj)
  RCCreated(Obj)
end

function OnMsg.ChoGGi_SpawnedDroneHub(Obj)
  if ChoGGi.UserSettings.CommandCenterMaxRadius then
    Obj:SetWorkRadius()
  end
end

--if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
function OnMsg.ChoGGi_SpawnedResidence(Obj)
  cCodeFuncs.AttachToNearestDome(Obj)
end
function OnMsg.ChoGGi_SpawnedWorkplace(Obj)
  cCodeFuncs.AttachToNearestDome(Obj)
end

--make sure they use with our new values
local function SetProd(Obj,sType)
  local prod = ChoGGi.UserSettings.BuildingSettings[Obj.encyclopedia_id]
  if prod and prod.production then
    Obj[sType] = prod.production
  end
end
function OnMsg.ChoGGi_SpawnedProducerElectricity(Obj)
  SetProd(Obj,"electricity_production")
end
function OnMsg.ChoGGi_SpawnedProducerAir(Obj)
  SetProd(Obj,"air_production")
end
function OnMsg.ChoGGi_SpawnedProducerWater(Obj)
  SetProd(Obj,"water_production")
end
function OnMsg.ChoGGi_SpawnedProducerSingle(Obj)
  SetProd(Obj,"production_per_day")
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

--water/air tanks
function OnMsg.ChoGGi_SpawnedLifeSupportGridObject(Obj)
  CheckForRate(Obj)
end
--battery
function OnMsg.ChoGGi_SpawnedElectricityStorage(Obj)
  CheckForRate(Obj)
end
