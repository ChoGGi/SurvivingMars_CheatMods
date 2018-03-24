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

function OnMsg.ClassesBuilt()
  local win = Button:new(ExamineDesigner)
  win:SetId("idDump")
  win:SetPos(point(597, 191))
  win:SetSize(point(50, 24))
  win:SetHSizing("AnchorToLeft")
  win:SetText(Untranslated("Dump"))
  win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
end

function OnMsg.ClassesGenerate()
function OnMsg.ClassesPostprocess()

function OnMsg.ClassesPreprocess()
  function self.idDump.OnButtonPressed()
    ChoGGi.Dump(self.idFilter:GetText())
  end
--]]

--Edit new buildings
--function OnMsg.ConstructionComplete(building)
function OnMsg.BuildingPlaced(building)
  --increase UniversalStorageDepot to 1000
  if ChoGGi.CheatMenuSettings["StorageDepotSpace"] then
    if IsKindOf(building,"UniversalStorageDepot") then
      building.max_storage_per_resource = 1000 * const.ResourceScale
    elseif IsKindOf(building,"WasteRockDumpSite") then
      building.max_amount_WasteRock = 1000 * const.ResourceScale
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

  --show console log history
  if ChoGGi.CheatMenuSettings["ConsoleToggleHistory"] then
    ShowConsoleLog(true)
  end

  --add hidden category
  if ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] then
    BuildCategories = {
      {id = "Infrastructure", name = T({78, "Infrastructure"}), img = "UI/Icons/bmc_infrastructure.tga", highlight_img = "UI/Icons/bmc_infrastructure_shine.tga"},
      {id = "Power", name = T({79, "Power"}), img = "UI/Icons/bmc_power.tga", highlight_img = "UI/Icons/bmc_power_shine.tga"},
      {id = "Production", name = T({80, "Production"}), img = "UI/Icons/bmc_building_resources.tga", highlight_img = "UI/Icons/bmc_building_resources_shine.tga"},
      {id = "Life-Support", name = T({81, "Life Support"}), img = "UI/Icons/bmc_life_support.tga", highlight_img = "UI/Icons/bmc_life_support_shine.tga"},
      {id = "Storages", name = T({82, "Storages"}), img = "UI/Icons/bmc_building_storages.tga", highlight_img = "UI/Icons/bmc_building_storages_shine.tga"},
      {id = "Domes", name = T({83, "Domes"}), img = "UI/Icons/bmc_domes.tga", highlight_img = "UI/Icons/bmc_domes_shine.tga"},
      {id = "Habitats", name = T({84, "Homes, Education & Research"}), img = "UI/Icons/bmc_habitats.tga", highlight_img = "UI/Icons/bmc_habitats_shine.tga"},
      {id = "Dome Services", name = T({85, "Dome Services"}), img = "UI/Icons/bmc_dome_buildings.tga", highlight_img = "UI/Icons/bmc_dome_buildings_shine.tga"},
      {id = "Dome Spires", name = T({86, "Dome Spires"}), img = "UI/Icons/bmc_dome_spires.tga", highlight_img = "UI/Icons/bmc_dome_spires_shine.tga"},
      {id = "Decorations", name = T({87, "Decorations"}), img = "UI/Icons/bmc_decorations.tga", highlight_img = "UI/Icons/bmc_decorations_shine.tga"},
      {id = "Wonders", name = T({88, "Wonders"}), img = "UI/Icons/bmc_wonders.tga", highlight_img = "UI/Icons/bmc_wonders_shine.tga"},
      {id = "Hidden", name = T({1000155, "Hidden"}), img = "UI/Icons/bmc_placeholder.tga", highlight_img = "UI/Icons/bmc_placeholder_shine.tga"},
      {id = "HiddenX", name = T({1000155, "Hidden"}), img = "UI/Icons/bmc_placeholder.tga", highlight_img = "UI/Icons/bmc_placeholder_shine.tga"}
    }
  end

  --setup building template properties
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    if ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] then
      if building.build_category == "Hidden" and building.name ~= "RocketLandingSite" then
        building.build_category = "HiddenX"
      end
      if building.name ~= "LifesupportSwitch" and building.name ~= "ElectricitySwitch" then
        building.hide_from_build_menu = false
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
end
