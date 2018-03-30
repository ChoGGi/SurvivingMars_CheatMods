--[[
--retrieve list of building/vehicle names
local templates = DataInstances.BuildingTemplate
for i = 1, #templates do
  local building = templates[i]
	print(building.name)
  building.dome_forbidden = false
  building.dome_required = false
end

--loop through stuff
#UICity.labels.Colonist
People: Colonist,Homeless,Residence,Unemployed
bld: Building (all),BuildingNoDomes (skips domes, still includes bld inside)
drones/rc: Unit (all),Drone,Rover,RCRover

for _,object in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
  if IsKindOf(object,"Sanatorium") then
    for i = 1, #traits do
      object:SetTrait(i, traits[i])
    end
  end
end

for i = 1, #ChoGGi.PositiveTraits do
  colonist:RemoveTrait(ChoGGi.PositiveTraits[i])
end

function OnMsg.SelectionChange()
  local dome_to_select = IsKindOf(SelectedObj, "Dome") and SelectedObj or IsObjInDome(SelectedObj)
  UICity:SelectDome(dome_to_select, SelectedObj)
end

function OnMsg.ClassesPreprocess()
  --give a CheatFill cmd to concrete (well try to, it doesn't seem to have the cheat section...find out why)
  function TerrainDepositConcrete.CheatRefill()
    TerrainDepositConcrete.amount = TerrainDepositConcrete.max_amount
    TerrainDepositConcrete:NotifyNearbyExploiters()
    TerrainDepositConcrete:UpdateUI()
  end
end --OnMsg
--]]

function OnMsg.ClassesGenerate()

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
      building.instant_build = true
    end

    if ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id] then
      if building.base_air_production then
        building.air_production = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      elseif building.base_water_production then
        building.water_production = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      elseif building.base_electricity_production then
        building.electricity_production = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      end
    end
  end
end --OnMsg

function OnMsg.ClassesBuilt()

  --add HiddenX cat for Hidden items
  if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
    table.insert(BuildCategories,{id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",})
  end

  --build "Cheats/Start Mystery" menu
  --MysteryBase = { AIUprisingMystery, BlackCubeMystery, DiggersMystery, DreamMystery, MarsgateMystery, MirrorSphereMystery, TheMarsBug, UnitedEarthMystery, WorldWar3 }
  --type(g_Classes.DreamMystery.scenario_name)
  ClassDescendantsList("MysteryBase", function(class)
    ChoGGi.AddAction(
      "Cheats/[05]Start Mystery/" .. g_Classes[class].scenario_name .. " " .. _InternalTranslate(T({ChoGGi.MysteryDifficulty[class]})) or "Missing Name",
      function()
        return ChoGGi.StartMystery(class)
      end,
      nil,
      _InternalTranslate(T({ChoGGi.MysteryDescription[class]})) or "Missing Description",
      "DarkSideOfTheMoon.tga"
    )
  end)

  --add preset menuitems
  ClassDescendantsList("Preset", function(name, class)
    local preset_class = class.PresetClass or name
    Presets[preset_class] = Presets[preset_class] or {}
    local map = class.GlobalMap
    if map then
      rawset(_G, map, rawget(_G, map) or {})
    end
    UserActions.AddActions({
      [name] = {
        menu = "Presets/" .. name,
        key = class.EditorShortcut or nil,
        icon = class.EditorIcon or nil,
        action = function()
          OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
            PresetClass = name,
            SingleFile = class.SingleFile
          })
        end
      }
    })
  end)

end --OnMsg

--saved game is loaded
function OnMsg.LoadGame(metadata)

  --limit height of colonists section
  XTemplates.sectionResidence[1]["MaxHeight"] = ChoGGi.Consts.ResidenceMaxHeight
  XTemplates.sectionResidence[1]["Clip"] = true

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
  if ChoGGi.CheatMenuSettings.ToggleInfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
    ShowConsoleLog(true)
  end

  if ChoGGi.CheatMenuSettings.ConsoleDim then
    config.ConsoleDim = 1
    function ShowConsoleLogBackground(bVisible, bImmediate)
      if dlgConsoleLog and config.ConsoleDim ~= 0 then
        DeleteThread(dlgConsoleLog.background_thread)
        if bVisible or bImmediate then
          dlgConsoleLog:SetBackgroundColor(RGBA(0, 0, 0, bVisible and 96 or 0))
        else
          dlgConsoleLog.background_thread = CreateRealTimeThread(function()
            --Sleep(3000)
            local r, g, b, a = GetRGBA(dlgConsoleLog:GetBackgroundColor())
            while a > 0 do
              a = Max(0, a - 5)
              dlgConsoleLog:SetBackgroundColor(RGBA(0, 0, 0, a))
              --Sleep(20)
            end
          end)
        end
      end
    end
  end

  --setup building template properties
  for _,building in ipairs(DataInstances.BuildingTemplate) do

    --switch hidden buildings to visible
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

  --Residence
  --XTemplates.sectionResidence[1]["MaxHeight"] = 200

  --change some default menu items
  UserActions.RemoveActions({
    --useless without developer tools?
    "BuildingEditor",
    --these will switch the map without asking to save
    "G_ModsEditor",
    "G_OpenPregameMenu",
    --added to toggles
    "G_ToggleInfopanelCheats",
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
    --move them to help menu
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
  })
  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

  --add trailblazer skins (fucking pre-order bonus bullshit)
  pcall(function()
    g_TrailblazerSkins.Drone = "Drone_Trailblazer"
    g_TrailblazerSkins.RCRover = "Rover_Trailblazer"
    g_TrailblazerSkins.RCTransport = "RoverTransport_Trailblazer"
    g_TrailblazerSkins.ExplorerRover = "RoverExplorer_Trailblazer"
    g_TrailblazerSkins.SupplyRocket = "Rocket_Trailblazer"
  end)

  --always show on my computer
	if ChoGGi.ChoGGiTest then
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
    --ShowConsole(true)
  end

end --OnMsg

--fired as late as we can
--function OnMsg.Resume()
function OnMsg.LoadingScreenPreClose()
  --toggle these so we don't have crazy scroll speed
  cameraFly.Activate(1)
  cameraRTS.Activate(1)
  ChoGGi.SetCameraSettings()
end --OnMsg

--function OnMsg.BuildingPlaced(building)

function OnMsg.ConstructionComplete(building)

  if IsKindOf(building,"Arcology") then
    building.capacity = ChoGGi.CheatMenuSettings.ArcologyCapacity

  elseif IsKindOf(building,"UniversalStorageDepot") then
    if building.encyclopedia_id ~= "UniversalStorageDepot" then
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot
    else
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageUniversalDepot
    end

  elseif IsKindOf(building,"WasteRockDumpSite") then
    building.max_amount_WasteRock = ChoGGi.CheatMenuSettings.StorageWasteDepot

  elseif IsKindOf(building,"RCTransportBuilding") and ChoGGi.CheatMenuSettings.RCTransportStorage > 45 then
    building.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorage

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
    building.maintenance_build_up_per_hr = 0
  end

  if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and building.base_max_workers then
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = 150
  end

  building.can_change_skin = true

  --saved settings for residence capacity
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id] then
    if building.base_capacity then
      building.capacity = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_max_visitors then
      building.max_visitors = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_air_capacity then
      building.air_capacity = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_water_capacity then
      building.water_capacity = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_max_shuttles then
      building.max_shuttles = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    end
  end

end --OnMsg

function OnMsg.ColonistArrived()
  if ChoGGi.CheatMenuSettings.NewColonistAge then
    colonist.age_trait = ChoGGi.CheatMenuSettings.NewColonistAge
  end

end --OnMsg

function OnMsg.ColonistBorn(colonist)
  if ChoGGi.CheatMenuSettings.NewColonistSex then
    colonist.gender = ChoGGi.CheatMenuSettings.NewColonistSex
  end

end --OnMsg

function OnMsg.SelectionAdded(Object)
  ChoGGi.SelectedObj = Object
end
function OnMsg.SelectedObjChange(Object)
  ChoGGi.SelectedObj = Object
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
    ChoGGi.MsgPopup(Outcome,"Mystery","UI/Icons/Logos/logo_13.tga")
  end
end

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"OnMsgs")
end
