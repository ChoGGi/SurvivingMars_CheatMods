--[[
function ChoGGi.StorageDepotWasteSet(Bool,Amount)
  if Bool == true then
    ChoGGi.CheatMenuSettings.StorageWasteDepot = ChoGGi.CheatMenuSettings.StorageWasteDepot + (1000 * ChoGGi.Consts.ResourceScale)
  else
    ChoGGi.CheatMenuSettings.StorageWasteDepot = ChoGGi.Consts.StorageWasteDepot
  end

  if UICity.labels.Storages then
    local amount
    for _,building in ipairs(UICity.labels.Storages or empty_table) do
      if IsKindOf(building,"WasteRockDumpSite") then
        --amount = building:GetStoredAmount()
        building.max_amount_WasteRock = ChoGGi.CheatMenuSettings.StorageWasteDepot
        --building:SetStoredAmount(amount)
        --visual update
        building:SetCountFromRequest(amount)
      end
    end
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Waste + " .. Amount,
    "Storage","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.StorageDepotOtherSet(Bool,Amount)
  if Bool == true then
    ChoGGi.CheatMenuSettings.StorageOtherDepot = ChoGGi.CheatMenuSettings.StorageOtherDepot + (1000 * ChoGGi.Consts.ResourceScale)
  else
    ChoGGi.CheatMenuSettings.StorageOtherDepot = ChoGGi.Consts.StorageOtherDepot
  end

  if UICity.labels.Storages then
    for _,building in ipairs(UICity.labels.Storages or empty_table) do
      if IsKindOf(building,"UniversalStorageDepot") and building.encyclopedia_id ~= "UniversalStorageDepot" then
        building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot
        ChoGGi.UpdateResourceAmount(building,ChoGGi.CheatMenuSettings.StorageOtherDepot)
      end
    end
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Other + " .. Amount,
    "Storage","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.StorageDepotUniversalSet(Bool,Amount)
  if Bool == true then
    ChoGGi.CheatMenuSettings.StorageUniversalDepot = ChoGGi.CheatMenuSettings.StorageUniversalDepot + (1000 * ChoGGi.Consts.ResourceScale)
  else
    ChoGGi.CheatMenuSettings.StorageUniversalDepot = ChoGGi.Consts.StorageUniversalDepot
  end

  if UICity.labels.Storages then
    for _,building in ipairs(UICity.labels.Storages or empty_table) do
      if building.encyclopedia_id == "UniversalStorageDepot" then
        building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageUniversalDepot
        ChoGGi.UpdateResourceAmount(building,ChoGGi.CheatMenuSettings.StorageUniversalDepot)
      end
    end
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Universal + " .. Amount,
    "Storage","UI/Icons/Sections/basic.tga"
  )
end
--]]

function ChoGGi.SetCapacity(Bool,Which)
  if not SelectedObj and not SelectedObj.base_capacity or not UICity.labels.BuildingNoDomes then
    ChoGGi.MsgPopup("You need to select something that has capacity.",
      "Buildings","UI/Icons/Sections/storage.tga"
    )
    return
  end
  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    --if IsKindOf(building,SelectedObj.encyclopedia_id) then
    if building.encyclopedia_id == SelectedObj.encyclopedia_id then
      if Bool == true then
        if Which == 1 then
          building.capacity = building.capacity + ChoGGi.Consts.ResidenceAddAmount
        elseif Which == 2 then
          building.capacity = building.capacity + ChoGGi.Consts.BatteryAddAmount
        end
      else
        building.capacity = nil
      end
      if building.capacity ~= building.base_capacity then
        ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = building.capacity
      elseif building.capacity == building.base_capacity then
        ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = nil
      end
    end
  end
  ChoGGi.WriteSettings()

  ChoGGi.MsgPopup(SelectedObj.encyclopedia_id .. " Capacity is now " .. ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] or "default",
    "Buildings","UI/Icons/Sections/storage.tga"
  )
end

function ChoGGi.SetProduction(Bool)
  if not SelectedObj and not SelectedObj.base_air_production and not SelectedObj.base_water_production and not SelectedObj.base_electricity_production and not SelectedObj.producers or not UICity.labels.BuildingNoDomes  then
    ChoGGi.MsgPopup("Select something that produces (air,water,electricity,other).",
      "Buildings","UI/Icons/Sections/storage.tga"
    )
    return
  end

  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    if building.encyclopedia_id == SelectedObj.encyclopedia_id then

      if Bool == true then
        if building.air and building.air.production then
          building.air.production = building.air.production + ChoGGi.Consts.ProductionAddAmount
        elseif building.water and building.water.production then
          building.water.production = building.water.production + ChoGGi.Consts.ProductionAddAmount
        elseif building.electricity and building.electricity.production then
          building.electricity.production = building.electricity.production + ChoGGi.Consts.ProductionAddAmount
        elseif building.producers then
          building.producers[1].production_per_day = building.producers[1].production_per_day + ChoGGi.Consts.ProductionAddAmount
        end

      else --defaults
        if building.air and building.air.production then
          building.air.production = building.base_air_production
        elseif building.water and building.water.production then
          building.water.production = building.base_water_production
        elseif building.electricity and building.electricity.production then
          building.electricity.production = building.base_electricity_production
        elseif building.producers then
          building.producers[1].production_per_day = building.producers[1].base_production_per_day
        end
      end

      if building.air and building.air.production then
        if building.air.production ~= building.base_air_production then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = building.air_production
        elseif building.air.production == building.base_air_production then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = nil
        end
      elseif building.water and building.water.production then
        if building.water.production ~= building.base_water_production then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = building.water_production
        elseif building.water.production == building.base_water_production then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = nil
        end
      elseif building.electricity and building.electricity.production then
        if building.electricity.production ~= building.base_electricity_production then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = building.electricity_production
        elseif building.electricity.production == building.base_electricity_production then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = nil
        end
      elseif building.producers then
        if building.producers[1].production_per_day ~= building.producers[1].base_production_per_day then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = building.producers[1].production_per_day
        elseif building.producers[1].production_per_day == building.producers[1].base_production_per_day then
          ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = nil
        end
      end

    end
  end
  ChoGGi.WriteSettings()

  local amount = ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id]
  if amount then
    amount = ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] / ChoGGi.Consts.ResourceScale
  else
    amount = "default"
  end
  ChoGGi.MsgPopup(SelectedObj.encyclopedia_id .. " Production is now " .. amount,
    "Buildings","UI/Icons/Sections/storage.tga"
  )
end


function ChoGGi.AirWaterCapacity(Bool)
  if not SelectedObj and not SelectedObj.base_water_capacity and not SelectedObj.base_air_capacity or not UICity.labels.BuildingNoDomes  then
    ChoGGi.MsgPopup("You need to select something that has air or water capacity.",
      "Buildings","UI/Icons/Sections/storage.tga"
    )
    return
  end
  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    --if IsKindOf(building,SelectedObj.encyclopedia_id) then
    if building.encyclopedia_id == SelectedObj.encyclopedia_id then

      if Bool == true then
        if building.base_water_capacity then
          building.water_capacity = building.water_capacity + ChoGGi.Consts.AirWaterAddAmount
        elseif building.base_air_capacity then
          building.air_capacity = building.air_capacity + ChoGGi.Consts.AirWaterAddAmount
        end
      else
        if building.base_water_capacity then
          building.water_capacity = nil
        elseif building.base_air_capacity then
          building.air_capacity = nil
        end
      end

      if building.base_water_capacity then
        if building.water_capacity ~= building.base_water_capacity then
          ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = building.water_capacity
        elseif building.water_capacity == building.base_water_capacity then
          ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = nil
        end
      elseif building.base_air_capacity then
        if building.air_capacity ~= building.base_air_capacity then
          ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = building.air_capacity
        elseif building.air_capacity == building.base_air_capacity then
          ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = nil
        end
      end

    end
  end
  ChoGGi.WriteSettings()

  local amount = ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id]
  if amount then
    amount = ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] / ChoGGi.Consts.ResourceScale
  else
    amount = "default"
  end
  ChoGGi.MsgPopup(SelectedObj.encyclopedia_id .. " Capacity is now " .. amount,
    "Storage","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.VisitorCapacitySet(Bool)
  if not SelectedObj and not SelectedObj.base_max_visitors or not UICity.labels.BuildingNoDomes then
    ChoGGi.MsgPopup("You need to select something that has space for visitors.",
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
    )
    return
  end
  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    --if IsKindOf(building,SelectedObj.encyclopedia_id) then
    if building.encyclopedia_id == SelectedObj.encyclopedia_id then
      if Bool == true then
        building.max_visitors = building.max_visitors + ChoGGi.Consts.ResidenceAddAmount
      else
        building.max_visitors = nil
      end
      if building.max_visitors ~= building.base_max_visitors then
        ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = building.max_visitors
      elseif building.max_visitors == building.base_max_visitors then
        ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = nil
      end
    end
  end
  ChoGGi.WriteSettings()

  ChoGGi.MsgPopup(SelectedObj.encyclopedia_id .. " Capacity is now " .. ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] or "default",
   "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.FullyAutomatedBuildings_Toggle()
  ChoGGi.CheatMenuSettings.FullyAutomatedBuildings = not ChoGGi.CheatMenuSettings.FullyAutomatedBuildings

  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and building.base_max_workers then
      building.max_workers = 0
      building.automation = 1
      building.auto_performance = 150
    else
      building.max_workers = nil
      building.automation = nil
      building.auto_performance = nil
    end
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.FullyAutomatedBuildings) .. " I presume the PM's in favour of the scheme because it'll reduce unemployment.",
   "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.RepairBrokenShit(BrokenShit)
  while #BrokenShit > 0 do
    for i = 1, #BrokenShit do
      pcall(function()
        BrokenShit[i]:Repair()
      end)
    end
  end
end

function ChoGGi.RepairPipesCables()
  ChoGGi.RepairBrokenShit(g_BrokenSupplyGridElements.electricity)
  ChoGGi.RepairBrokenShit(g_BrokenSupplyGridElements.water)
end

function ChoGGi.SanatoriumCureAll_Toggle()
  ChoGGi.CheatMenuSettings.SanatoriumCureAll = not ChoGGi.CheatMenuSettings.SanatoriumCureAll
  if ChoGGi.CheatMenuSettings.SanatoriumCureAll then
    ChoGGi.BuildingsSetAll_Traits("Sanatorium",ChoGGi.NegativeTraits)
  else
    ChoGGi.BuildingsSetAll_Traits("Sanatorium",ChoGGi.NegativeTraits,true)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SanatoriumCureAll) .. " You keep your work station so clean, Jerome.",
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
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings) .. " I'm sorry, I'm simply not at liberty to say.",
   "Buildings","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.SchoolTrainAll_Toggle()
  ChoGGi.CheatMenuSettings.SchoolTrainAll = not ChoGGi.CheatMenuSettings.SchoolTrainAll
  if ChoGGi.CheatMenuSettings.SchoolTrainAll then
    ChoGGi.BuildingsSetAll_Traits("School",ChoGGi.PositiveTraits)
  else
    ChoGGi.BuildingsSetAll_Traits("School",ChoGGi.PositiveTraits,true)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SchoolTrainAll) .. " You keep your work station so clean, Jerome.",
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

function ChoGGi.MaintenanceBuildingsFree_Toggle()

  ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp = not ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp
  for _,object in ipairs(UICity.labels.Building or empty_table) do
    if object.base_maintenance_build_up_per_hr then
      if ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp then
        object.maintenance_build_up_per_hr = 0
      else
        object.maintenance_build_up_per_hr = nil
      end
    end
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp) .. " The spice must flow!",
    "Buildings",
    "UI/Icons/Sections/dust.tga"
  )
end

function ChoGGi.RemoveBuildingLimits_Toggle()
  ChoGGi.CheatMenuSettings.RemoveBuildingLimits = not ChoGGi.CheatMenuSettings.RemoveBuildingLimits

--[[gives error when you don't restart
  if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then
    ConstructionController.UpdateConstructionStatuses = ChoGGi.ReplacedFunc.CC_UpdateConstructionStatuses
    TunnelConstructionController.UpdateConstructionStatuses = ChoGGi.ReplacedFunc.TC_UpdateConstructionStatuses
  else
    ConstructionController.UpdateConstructionStatuses = ChoGGi.OrigFunc.CC_UpdateConstructionStatuses
    TunnelConstructionController.UpdateConstructionStatuses = ChoGGi.OrigFunc.TC_UpdateConstructionStatuses
  end
--]]
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RemoveBuildingLimits) .. " No no I said over there (restart to toggle).",
    "Buildings",
    "UI/Icons/Upgrades/zero_space_04.tga"
  )
end

function ChoGGi.MoistureVaporatorPenalty_Toggle()
  const.MoistureVaporatorRange = ChoGGi.NumRetBool(const.MoistureVaporatorRange,0,ChoGGi.Consts.MoistureVaporatorRange)
  const.MoistureVaporatorPenaltyPercent = ChoGGi.NumRetBool(const.MoistureVaporatorPenaltyPercent,0,ChoGGi.Consts.MoistureVaporatorPenaltyPercent)
  ChoGGi.CheatMenuSettings.MoistureVaporatorRange = const.MoistureVaporatorRange
  ChoGGi.CheatMenuSettings.MoistureVaporatorPenaltyPercent = const.MoistureVaporatorPenaltyPercent
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.MoistureVaporatorRange) .. " Here at the Titty Twister we're slashing pussy in half!",
   "Buildings","UI/Icons/Upgrades/zero_space_04.tga"
  )
end

function ChoGGi.CropFailThreshold_Toggle()
  const.CropFailThreshold = ChoGGi.NumRetBool(const.CropFailThreshold,0,ChoGGi.Consts.CropFailThreshold)
  ChoGGi.CheatMenuSettings.CropFailThreshold = const.CropFailThreshold
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CropFailThreshold) .. " The small but great planet of Potatoho",
   "Buildings","UI/Icons/Sections/Food_1.tga"
  )
end

function ChoGGi.CheapConstruction_Toggle()
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

function ChoGGi.BuildingDamageCrime_Toggle()
  Consts.CrimeEventSabotageBuildingsCount = ChoGGi.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount)
  Consts.CrimeEventDestroyedBuildingsCount = ChoGGi.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount)
  ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount = Consts.CrimeEventSabotageBuildingsCount
  ChoGGi.CheatMenuSettings.CrimeEventDestroyedBuildingsCount = Consts.CrimeEventDestroyedBuildingsCount
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount .. " We were all feeling a bit shagged and fagged and fashed, it being a night of no small expenditure.",
   "Buildings","UI/Icons/Notifications/fractured_dome.tga"
  )
end

function ChoGGi.CablesAndPipes_Toggle()
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

function ChoGGi.Building_wonder_Toggle()
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.wonder = false
    --building.wonderSet = true
  end
  ChoGGi.CheatMenuSettings.Building_wonder = not ChoGGi.CheatMenuSettings.Building_wonder
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_wonder) .. " Unlimited Wonders",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_spot_Toggle()
  ChoGGi.CheatMenuSettings.Building_dome_spot = not ChoGGi.CheatMenuSettings.Building_dome_spot
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_dome_spot) .. " Freedom for spires!\n(restart to toggle)",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_hide_from_build_menu_Toggle()
  ChoGGi.CheatMenuSettings.Building_hide_from_build_menu = not ChoGGi.CheatMenuSettings.Building_hide_from_build_menu
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_hide_from_build_menu) .. " Buildings hidden\n(restart to toggle).",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_forbidden_Toggle()
  ChoGGi.CheatMenuSettings.Building_dome_forbidden = not ChoGGi.CheatMenuSettings.Building_dome_forbidden
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_dome_forbidden) .. " Buildings dome forbidden\n(restart to toggle).",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_required_Toggle()
  ChoGGi.CheatMenuSettings.Building_dome_required = not ChoGGi.CheatMenuSettings.Building_dome_required
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_dome_required) .. " Buildings dome required\n(restart to toggle).",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_is_tall_Toggle()
  ChoGGi.CheatMenuSettings.Building_is_tall = not ChoGGi.CheatMenuSettings.Building_is_tall
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_is_tall) .. " Building tall under pipes\n(restart to toggle).",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_instant_build_Toggle()
  ChoGGi.CheatMenuSettings.Building_instant_build = not ChoGGi.CheatMenuSettings.Building_instant_build
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_instant_build) .. " Building Instant Build\n(restart to toggle).",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"MenuBuildingFunc")
end
