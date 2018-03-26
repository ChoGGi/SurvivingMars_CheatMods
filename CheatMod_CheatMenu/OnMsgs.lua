--[[
--retrieve list of building/vehicle names
  local templates = DataInstances.BuildingTemplate
  for i = 1, #templates do
    local building_template = templates[i]
    building_template.name
    building_template.require_prefab
  end

available_prefabs = UICity:GetPrefabs(building_template.name)
City:AddPrefabs(bld, count)

--loop through all buildings
for _,building in ipairs(UICity.labels.Building) do
  if IsKindOf(building,"Sanatorium") then
    for i = 1, #traits do
      building:SetTrait(i, traits[i])
    end
  end
end

function OnMsg.SelectionChange()
  local dome_to_select = IsKindOf(SelectedObj, "Dome") and SelectedObj or IsObjInDome(SelectedObj)
  UICity:SelectDome(dome_to_select, SelectedObj)
end
--]]

function OnMsg.ConstructionComplete(building)
  if ChoGGi.CheatMenuSettings["FullyAutomatedBuildings"] and building.max_workers >= 1 then
    ChoGGi.FullyAutomatedBuildingsSet(building)
  end
  if ChoGGi.CheatMenuSettings["SanatoriumCureAll"] and IsKindOf(building,"Sanatorium") then
    for i = 1, #ChoGGi.BadTraits do
      building:SetTrait(i,ChoGGi.BadTraits[i])
    end
  end
end

function OnMsg.ColonistArrived()
  if ChoGGi.CheatMenuSettings["NewColonistAge"] then
    colonist.age_trait = ChoGGi.CheatMenuSettings["NewColonistAge"]
  end
end

function OnMsg.ColonistBorn(colonist)
  if ChoGGi.CheatMenuSettings["NewColonistSex"] then
    colonist.gender = ChoGGi.CheatMenuSettings["NewColonistSex"]
  end
end

--Edit new buildings
--function OnMsg.ConstructionComplete(building)
function OnMsg.BuildingPlaced(building)
  --increase UniversalStorageDepot to 1000
  if ChoGGi.CheatMenuSettings["StorageDepotSpace"] then
    if IsKindOf(building,"UniversalStorageDepot") then
      building.max_storage_per_resource = 1000 * ChoGGi.Consts["ResourceScale"]
    elseif IsKindOf(building,"WasteRockDumpSite") then
      building.max_amount_WasteRock = 1000 * ChoGGi.Consts["ResourceScale"]
    end
  end
end

--add preset menuitems
function OnMsg.ClassesBuilt()
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
end

--saved game is loaded
function OnMsg.LoadGame(metadata)

  --show all Mystery Breakthrough buildings
  if ChoGGi.CheatMenuSettings["AddMysteryBreakthroughBuildings"] then
    UnlockBuilding("DefenceTower")
    UnlockBuilding("CloningVats")
    UnlockBuilding("BlackCubeDump")
    UnlockBuilding("BlackCubeSmallMonument")
    UnlockBuilding("BlackCubeLargeMonument")
    UnlockBuilding("PowerDecoy")
    UnlockBuilding("DomeOval")
  end

  --for SanatoriumCureAll
  ChoGGi.BadTraits = {"Clone","Alcoholic","Glutton","Lazy","Refugee","ChronicCondition","Infected","Idiot","Hypochondriac","Whiner","Renegade","Melancholic","Introvert","Coward","Tourist","Gambler"}
  ChoGGi.GoodTraits = {"Workaholic","Survivor","Sexy","Composed","Genius","Celebrity","Saint","Religious","Gamer","DreamerPostMystery","Empath","Nerd","Rugged","Fit","Enthusiast","Hippie","Extrovert","Martianborn"}

  if ChoGGi.CheatMenuSettings["ShowAllTraits"] then
    g_SchoolTraits = ChoGGi.GoodTraits
    g_SanatoriumTraits = ChoGGi.BadTraits
  end

  if ChoGGi.CheatMenuSettings["ToggleBorderScrolling"] then
    --disable border scrolling
    cameraRTS.SetProperties(1,{ScrollBorder = 0})
  else
    --reduce ScrollBorder to the smallest we can (1 = can't scroll down)
    cameraRTS.SetProperties(1,{ScrollBorder = 2})
  end

  --zoom
  if ChoGGi.CheatMenuSettings["ToggleCameraZoom"] then
    cameraRTS.SetProperties(1,{
      MinHeight = 1,
      MaxHeight = 80,
      MinZoom = 1,
      MaxZoom = 24000,
    })
  end

  --faster zoom (I perfer instant, but make it too fast and it gets funky)
  if ChoGGi.CheatMenuSettings["ToggleCameraZoomSpeed"] then
    cameraRTS.SetProperties(1,{UpDownSpeed = 800})
  end

  --add trailblazer skins (fucking pre-order bonus bullshit)
  if not pcall(dbg_AddTrailBlazerSkins) then
    g_TrailblazerSkins.Drone = "Drone_Trailblazer"
    g_TrailblazerSkins.RCRover = "Rover_Trailblazer"
    g_TrailblazerSkins.RCTransport = "RoverTransport_Trailblazer"
    g_TrailblazerSkins.ExplorerRover = "RoverExplorer_Trailblazer"
    g_TrailblazerSkins.SupplyRocket = "Rocket_Trailblazer"
  end

  --show cheat pane?
  if ChoGGi.CheatMenuSettings["ToggleInfopanelCheats"] then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if ChoGGi.CheatMenuSettings["ConsoleToggleHistory"] then
    ShowConsoleLog(true)
  end

  --add HiddenX cat for Hidden items
  if ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] then
    BuildCategories[#BuildCategories+1] = {id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga"}
  end

  --setup building template properties
  for _,building in ipairs(DataInstances.BuildingTemplate) do

  --switch hidden buildings to visible
  if ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] then
    BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
    if building.name ~= "LifesupportSwitch" and building.name ~= "ElectricitySwitch" then
      building.hide_from_build_menu = false
    end
    if building.build_category == "Hidden" and building.name ~= "RocketLandingSite" then
      building.build_category = "HiddenX"
    end
  end

    if ChoGGi.CheatMenuSettings["Building_wonder"] then
      building.wonder = false
    end
--[[
    if ChoGGi.CheatMenuSettings["Building_dome_required"] then
      building.dome_required = false
    end
    if ChoGGi.CheatMenuSettings["Building_dome_forbidden"] then
      building.dome_forbidden = false
    end
    if ChoGGi.CheatMenuSettings["Building_dome_spot"] then
      building.dome_spot = "none"
    end
    if ChoGGi.CheatMenuSettings["Building_is_tall"] then
      building.is_tall = false
    end
    if ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] then
      building.hide_from_build_menu = false
    end
    if ChoGGi.CheatMenuSettings["Building_require_prefab"] then
      building.require_prefab = false
    end
    if ChoGGi.CheatMenuSettings["Building_instant_build"] then
      building.instant_build = true
    end
--]]
  end
  --always show on my comp
	if ChoGGi.ChoGGiComp then
    UAMenu.ToggleOpen()
    ShowConsole(true)
  end
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: OnMsgs.lua",true)
end
