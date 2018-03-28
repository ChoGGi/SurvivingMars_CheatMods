
--1=waste,2=other,3=uni, Bool true=add
function ChoGGi.StorageDepotSet(Type,Bool,Name,Which)
  if not UICity.labels.Building then
    if Type == 1 then
      ChoGGi.CheatMenuSettings.StorageWasteDepot = ChoGGi.CheatMenuSettings.StorageWasteDepot + (1024 * ChoGGi.Consts.ResourceScale)
    elseif Type == 2 then
      ChoGGi.CheatMenuSettings.StorageOtherDepot = ChoGGi.CheatMenuSettings.StorageOtherDepot + (1024 * ChoGGi.Consts.ResourceScale)
    elseif Type == 3 then
      ChoGGi.CheatMenuSettings.UniversalStorageDepot = ChoGGi.CheatMenuSettings.UniversalStorageDepot + (1024 * ChoGGi.Consts.ResourceScale)
    end
  else
    for _,building in ipairs(UICity.labels.Building or empty_table) do

      if IsKindOf(building,"WasteRockDumpSite") and Type == 1 then
        if Bool == true then
          building.max_amount_WasteRock = building.max_amount_WasteRock + (1024 * ChoGGi.Consts.ResourceScale)
          ChoGGi.CheatMenuSettings.StorageWasteDepot = building.max_amount_WasteRock
        else
          building.max_amount_WasteRock = ChoGGi.Consts.StorageWasteDepot
          ChoGGi.CheatMenuSettings.StorageWasteDepot = ChoGGi.Consts.StorageWasteDepot
        end

      elseif IsKindOf(building,"UniversalStorageDepot") and Type == 2 or Type == 3 then
        --Other storage
        if building.encyclopedia_id ~= "UniversalStorageDepot" then
          if Bool == true then
            building.max_storage_per_resource = building.max_storage_per_resource + (1024 * ChoGGi.Consts.ResourceScale)
            ChoGGi.CheatMenuSettings.StorageOtherDepot = building.max_storage_per_resource
          else
            building.max_storage_per_resource = ChoGGi.Consts.StorageOtherDepot
            ChoGGi.CheatMenuSettings.StorageOtherDepot = ChoGGi.Consts.StorageOtherDepot
          end
        --uni storage
        else
          if Bool == true then
            building.max_storage_per_resource = building.max_storage_per_resource + (1024 * ChoGGi.Consts.ResourceScale)
            ChoGGi.CheatMenuSettings.UniversalStorageDepot = building.max_storage_per_resource
          else
            building.max_storage_per_resource = ChoGGi.Consts.StorageUniversalDepot
            ChoGGi.CheatMenuSettings.UniversalStorageDepot = ChoGGi.Consts.StorageUniversalDepot
          end

        end
      end
    end
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(Name .. " + " .. Which,
   "Storage","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.ArcologyColonistsToggle(Bool,Which)
  if not UICity.labels.Building then
    if Bool == true then
      ChoGGi.CheatMenuSettings.ArcologyCapacity = ChoGGi.CheatMenuSettings.ArcologyCapacity + ChoGGi.Consts.ArcologyCapacity
    else
      ChoGGi.CheatMenuSettings.ArcologyCapacity = ChoGGi.Consts.ArcologyCapacity
    end
  else
    for _,building in ipairs(UICity.labels.Building or empty_table) do
      if IsKindOf(building,"Arcology") then
        if Bool == true then
          building.capacity = building.capacity + ChoGGi.Consts.ArcologyCapacity
        else
          building.capacity = ChoGGi.Consts.ArcologyCapacity
        end
        ChoGGi.CheatMenuSettings.ArcologyCapacity = building.capacity
      end
    end
  end

  if ChoGGi.CheatMenuSettings.ArcologyCapacity > 96 then
    XTemplates.sectionResidence[1]["MaxHeight"] = 128
    XTemplates.sectionResidence[1]["Clip"] = true
  else
    XTemplates.sectionResidence[1]["MaxHeight"] = nil
    XTemplates.sectionResidence[1]["Clip"] = false
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Capacity is now " .. ChoGGi.CheatMenuSettings.ArcologyCapacity,
   "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
  )
end


function ChoGGi.ArcologyColonistsToggle(Bool)
  if UICity.labels.Building then
    for _,building in ipairs(UICity.labels.Building or empty_table) do
      if IsKindOf(building,"Arcology") then
        if Bool == true then
          building.capacity = building.capacity + ChoGGi.Consts.ArcologyCapacity
        else
          building.capacity = ChoGGi.Consts.ArcologyCapacity
        end
        ChoGGi.CheatMenuSettings.ArcologyCapacity = building.capacity
      end
    end
  else
    if Bool == true then
      ChoGGi.CheatMenuSettings.ArcologyCapacity = ChoGGi.CheatMenuSettings.ArcologyCapacity + ChoGGi.Consts.ArcologyCapacity
    else
      ChoGGi.CheatMenuSettings.ArcologyCapacity = ChoGGi.Consts.ArcologyCapacity
    end
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Capacity is now " .. ChoGGi.CheatMenuSettings.ArcologyCapacity,
   "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.FullyAutomatedBuildingsToggle()
  ChoGGi.CheatMenuSettings.FullyAutomatedBuildings = not ChoGGi.CheatMenuSettings.FullyAutomatedBuildings
  if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings then
    pcall(function()
      for _,building in ipairs(UICity.labels.Building or empty_table) do
        if building.max_workers >= 1 then
          ChoGGi.FullyAutomatedBuildingsSet(building)
        end
      end
    end)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.FullyAutomatedBuildings .. " I presume the PM's in favour of the scheme because it'll reduce unemployment.",
   "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.SanatoriumCureAllToggle()
  ChoGGi.CheatMenuSettings.SanatoriumCureAll = not ChoGGi.CheatMenuSettings.SanatoriumCureAll
  if ChoGGi.CheatMenuSettings.SanatoriumCureAll then
    ChoGGi.BuildingsSetAll_Traits("Sanatorium",ChoGGi.NegativeTraits)
  else
    ChoGGi.BuildingsSetAll_Traits("Sanatorium",ChoGGi.NegativeTraits,true)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.SanatoriumCureAll .. " You keep your work station so clean, Jerome.",
   "Sanatorium","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.AddMysteryBreakthroughBuildings()
  ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings = not ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings
  if ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings then
    UnlockBuilding("CloningVats")
    UnlockBuilding("BlackCubeDump")
    UnlockBuilding("BlackCubeSmallMonument")
    UnlockBuilding("BlackCubeLargeMonument")
    UnlockBuilding("PowerDecoy")
    UnlockBuilding("DomeOval")
  else
    LockBuilding("CloningVats")
    LockBuilding("BlackCubeDump")
    LockBuilding("BlackCubeSmallMonument")
    LockBuilding("BlackCubeLargeMonument")
    LockBuilding("PowerDecoy")
    LockBuilding("DomeOval")
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings .. " I'm sorry, I'm simply not at liberty to say.",
   "Buildings","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.SchoolTrainAllToggle()
  ChoGGi.CheatMenuSettings.SchoolTrainAll = not ChoGGi.CheatMenuSettings.SchoolTrainAll
  if ChoGGi.CheatMenuSettings.SchoolTrainAll then
    ChoGGi.BuildingsSetAll_Traits("School",ChoGGi.PositiveTraits)
  else
    ChoGGi.BuildingsSetAll_Traits("School",ChoGGi.PositiveTraits,true)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.SchoolTrainAll .. " You keep your work station so clean, Jerome.",
   "School","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.SanatoriumSchoolShowAll()
  if Sanatorium.max_traits == 16 then
    Sanatorium.max_traits = 3
    School.max_traits = 3
  else
    Sanatorium.max_traits = 16
    School.max_traits = 16
  end
  ChoGGi.MsgPopup(Sanatorium.max_traits .. " Good for what ails you",
   "Buildings","UI/Icons/Upgrades/superfungus_03.tga"
  )
end

function ChoGGi.MaintenanceBuildingsFreeToggle()
-- -100
  Consts.BuildingMaintenancePointsModifier = ChoGGi.NumRetBool(Consts.BuildingMaintenancePointsModifier,0,ChoGGi.Consts.BuildingMaintenancePointsModifier)
  ChoGGi.CheatMenuSettings.BuildingMaintenancePointsModifier = Consts.BuildingMaintenancePointsModifier
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.BuildingMaintenancePointsModifier .. " The spice must flow!",
    "Buildings",
    "UI/Icons/Sections/dust.tga"
  )
end


function ChoGGi.MoistureVaporatorPenaltyToggle()
  Consts.MoistureVaporatorRange = ChoGGi.NumRetBool(Consts.MoistureVaporatorRange,0,ChoGGi.Consts.MoistureVaporatorRange)
  Consts.MoistureVaporatorPenaltyPercent = ChoGGi.NumRetBool(Consts.MoistureVaporatorPenaltyPercent,0,ChoGGi.Consts.MoistureVaporatorPenaltyPercent)
  ChoGGi.CheatMenuSettings.MoistureVaporatorRange = const.MoistureVaporatorRange
  ChoGGi.CheatMenuSettings.MoistureVaporatorPenaltyPercent = const.MoistureVaporatorPenaltyPercent
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.MoistureVaporatorRange .. " Here at the Titty Twister we're slashing pussy in half!",
   "Buildings","UI/Icons/Upgrades/zero_space_04.tga"
  )
end

function ChoGGi.ConstructionForFreeToggle()
  if Consts.Metals_cost_modifier == -100 then
    Consts.Metals_cost_modifier = ChoGGi.Consts.Metals_cost_modifier
    Consts.Metals_dome_cost_modifier = ChoGGi.Consts.Metals_dome_cost_modifier
    Consts.PreciousMetals_cost_modifier = ChoGGi.Consts.PreciousMetals_cost_modifier
    Consts.PreciousMetals_dome_cost_modifier = ChoGGi.Consts.PreciousMetals_dome_cost_modifier
    Consts.Concrete_cost_modifier = ChoGGi.Consts.Concrete_cost_modifier
    Consts.Concrete_dome_cost_modifier = ChoGGi.Consts.Concrete_dome_cost_modifier
    Consts.Polymers_dome_cost_modifier = ChoGGi.Consts.Polymers_dome_cost_modifier
    Consts.Polymers_cost_modifier = ChoGGi.Consts.Polymers_cost_modifier
    Consts.Electronics_cost_modifier = ChoGGi.Consts.Electronics_cost_modifier
    Consts.Electronics_dome_cost_modifier = ChoGGi.Consts.Electronics_dome_cost_modifier
    Consts.MachineParts_cost_modifier = ChoGGi.Consts.MachineParts_cost_modifier
    Consts.MachineParts_dome_cost_modifier = ChoGGi.Consts.MachineParts_dome_cost_modifier
    Consts.rebuild_cost_modifier = ChoGGi.Consts.rebuild_cost_modifier
  else
    Consts.Metals_cost_modifier = -100
    Consts.Metals_dome_cost_modifier = -100
    Consts.PreciousMetals_cost_modifier = -100
    Consts.PreciousMetals_dome_cost_modifier = -100
    Consts.Concrete_cost_modifier = -100
    Consts.Concrete_dome_cost_modifier = -100
    Consts.Polymers_dome_cost_modifier = -100
    Consts.Polymers_cost_modifier = -100
    Consts.Electronics_cost_modifier = -100
    Consts.Electronics_dome_cost_modifier = -100
    Consts.MachineParts_cost_modifier = -100
    Consts.MachineParts_dome_cost_modifier = -100
    Consts.rebuild_cost_modifier = -100
  end
  ChoGGi.CheatMenuSettings.Metals_cost_modifier = Consts.Metals_cost_modifier
  ChoGGi.CheatMenuSettings.Metals_dome_cost_modifier = Consts.Metals_dome_cost_modifier
  ChoGGi.CheatMenuSettings.PreciousMetals_cost_modifier = Consts.PreciousMetals_cost_modifier
  ChoGGi.CheatMenuSettings.PreciousMetals_dome_cost_modifier = Consts.PreciousMetals_dome_cost_modifier
  ChoGGi.CheatMenuSettings.Concrete_cost_modifier = Consts.Concrete_cost_modifier
  ChoGGi.CheatMenuSettings.Concrete_dome_cost_modifier = Consts.Concrete_dome_cost_modifier
  ChoGGi.CheatMenuSettings.Polymers_cost_modifier = Consts.Polymers_cost_modifier
  ChoGGi.CheatMenuSettings.Polymers_dome_cost_modifier = Consts.Polymers_dome_cost_modifier
  ChoGGi.CheatMenuSettings.Electronics_cost_modifier = Consts.Electronics_cost_modifier
  ChoGGi.CheatMenuSettings.Electronics_dome_cost_modifier = Consts.Electronics_dome_cost_modifier
  ChoGGi.CheatMenuSettings.MachineParts_cost_modifier = Consts.MachineParts_cost_modifier
  ChoGGi.CheatMenuSettings.MachineParts_dome_cost_modifier = Consts.MachineParts_dome_cost_modifier
  ChoGGi.CheatMenuSettings.rebuild_cost_modifier = Consts.rebuild_cost_modifier
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Metals_cost_modifier .. " Get yourself a beautiful showhome (even if it'll fall apart after you move in)",
   "Buildings","UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.BuildingDamageCrimeToggle()
  Consts.CrimeEventSabotageBuildingsCount = ChoGGi.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount)
  Consts.CrimeEventDestroyedBuildingsCount = ChoGGi.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount)
  ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount = Consts.CrimeEventSabotageBuildingsCount
  ChoGGi.CheatMenuSettings.CrimeEventDestroyedBuildingsCount = Consts.CrimeEventDestroyedBuildingsCount
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount .. " We were all feeling a bit shagged and fagged and fashed, it being a night of no small expenditure.",
   "Buildings","UI/Icons/Notifications/fractured_dome.tga"
  )
end

function ChoGGi.CablesAndPipesToggle()
  Consts.InstantCables = ChoGGi.ToggleBoolNum(Consts.InstantCables)
  Consts.InstantPipes = ChoGGi.ToggleBoolNum(Consts.InstantPipes)
  --GrantTech("SuperiorCables")
  --GrantTech("SuperiorPipes")
  ChoGGi.CheatMenuSettings.InstantCables = Consts.InstantCables
  ChoGGi.CheatMenuSettings.InstantPipes = Consts.InstantPipes
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.InstantCables .. " Aliens? We gotta deal with aliens too?",
   "Buildings","UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.Building_wonder()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.wonder = false
    building.wonderSet = true
  end
  ChoGGi.CheatMenuSettings.Building_wonder = not ChoGGi.CheatMenuSettings.Building_wonder
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_wonder .. " Building_Wonder",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end


function ChoGGi.Building_hide_from_build_menu()
  ChoGGi.CheatMenuSettings.Building_hide_from_build_menu = not ChoGGi.CheatMenuSettings.Building_hide_from_build_menu
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_hide_from_build_menu .. " Building_hide_from_build_menu",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_required()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.dome_required = false
  end
  ChoGGi.CheatMenuSettings.Building_dome_required = not ChoGGi.CheatMenuSettings.Building_dome_required
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_dome_required .. " Building_dome_required",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_forbidden()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.dome_forbidden = false
  end
  ChoGGi.CheatMenuSettings.Building_dome_forbidden = not ChoGGi.CheatMenuSettings.Building_dome_forbidden
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_dome_forbidden .. " Building_dome_forbidden",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_spot()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.dome_spot = "none"
  end
  ChoGGi.CheatMenuSettings.Building_dome_spot = not ChoGGi.CheatMenuSettings.Building_dome_spot
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_dome_spot .. " Building_dome_spot",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_is_tall()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.is_tall = false
  end
  ChoGGi.CheatMenuSettings.Building_is_tall = not ChoGGi.CheatMenuSettings.Building_is_tall
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_is_tall .. " Building_is_tall",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_instant_build()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.instant_build = true
  end
  ChoGGi.CheatMenuSettings.Building_instant_build = not ChoGGi.CheatMenuSettings.Building_instant_build
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_instant_build .. " Building_instant_build",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_require_prefab()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.require_prefab = false
  end
  ChoGGi.CheatMenuSettings.Building_require_prefab = not ChoGGi.CheatMenuSettings.Building_require_prefab
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.Building_require_prefab .. " Building_require_prefab",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuBuildingsFunc.lua",true)
end
