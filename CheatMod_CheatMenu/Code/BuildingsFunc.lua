function ChoGGi.AttachBuildingsToNearestWorkingDome()
  for _,building in ipairs(UICity.labels.Residence or empty_table) do
    ChoGGi.AttachToNearestDome(building)
  end
  for _,building in ipairs(UICity.labels.Workplace or empty_table) do
    ChoGGi.AttachToNearestDome(building)
  end
  ChoGGi.MsgPopup("Buildings attached.",
    "Buildings","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.SetStorageDepotSize(Bool,Type)
  if Bool == true then
    ChoGGi.CheatMenuSettings[Type] = ChoGGi.CheatMenuSettings[Type] + (1000 * ChoGGi.Consts.ResourceScale)
  else
    ChoGGi.CheatMenuSettings[Type] = ChoGGi.Consts[Type]
  end

  --limit amounts so saving with a full load doesn't delete your game
  if Type == "StorageWasteDepot" and ChoGGi.CheatMenuSettings[Type] > 100000000 then
    ChoGGi.CheatMenuSettings[Type] = 100000000 --it's actually fine with a million, but I figured I'd stop somewhere
  elseif Type == "StorageOtherDepot" and ChoGGi.CheatMenuSettings[Type] > 20000000 then
    ChoGGi.CheatMenuSettings[Type] = 20000000
  elseif Type == "StorageUniversalDepot" and ChoGGi.CheatMenuSettings[Type] > 2500000 then
    ChoGGi.CheatMenuSettings[Type] = 2500000 --can go to 2900, but I got a crash, which may have been something else, but it's only 400 storage
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(Type .. " + " ..  ChoGGi.CheatMenuSettings[Type] / ChoGGi.Consts.ResourceScale,
    "Storage","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.FarmShiftsAllOn()
  for _,building in ipairs(UICity.labels.BaseFarm or empty_table) do
    building.closed_shifts[1] = false
    building.closed_shifts[2] = false
    building.closed_shifts[3] = false
  end
  --BaseFarm doesn't include FungalFarm...
  for _,building in ipairs(UICity.labels.FungalFarm or empty_table) do
    building.closed_shifts[1] = false
    building.closed_shifts[2] = false
    building.closed_shifts[3] = false
  end
  ChoGGi.MsgPopup("Well, I been working in a coal mine. Going down, down",
    "Farms","UI/Icons/Sections/Food_2.tga"
  )
end

function ChoGGi.SetProduction(Bool)
  if not SelectedObj and not SelectedObj.base_air_production and not SelectedObj.base_water_production and not SelectedObj.base_electricity_production and not SelectedObj.producers then
    ChoGGi.MsgPopup("Select something that produces (air,water,electricity,other).",
      "Buildings","UI/Icons/Sections/storage.tga"
    )
    return
  end
  --get type of producer
  local ProdType
  if SelectedObj.base_air_production then
    ProdType = "air"
  elseif SelectedObj.base_water_production then
    ProdType = "water"
  elseif SelectedObj.base_electricity_production then
    ProdType = "electricity"
  elseif SelectedObj.producers then
    ProdType = "other"
  end

  --get saved prod amount
  local SavedAmount = ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id]
  --get base amount
  local DefaultAmount
  if ProdType == "other" then
    DefaultAmount = SelectedObj.producers[1].base_production_per_day
  else
    DefaultAmount = SelectedObj["base_" .. ProdType .. "_production"]
  end

  --nothing saved so use defaults
  if not SavedAmount then
    SavedAmount = DefaultAmount
  end

  --get the saved or base prod amount
  if Bool == true then
    SavedAmount = SavedAmount + ChoGGi.Consts.ProductionAddAmount
  else --defaults
    SavedAmount = DefaultAmount
  end

  if ProdType == "electricity" then
    --electricity
    for _,building in ipairs(UICity.labels.Power or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        --current prod
        building[ProdType]:SetProduction(SavedAmount)
        --when toggled on n off
        building[ProdType .. "_production"] = SavedAmount
      end
    end

  elseif ProdType == "water" or ProdType == "air" then
    --water/air
    for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        building[ProdType]:SetProduction(SavedAmount)
        building[ProdType .. "_production"] = SavedAmount
      end
    end

  else --other prod
    --extractors/factories
    for _,building in ipairs(UICity.labels.Production or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        building.producers[1].production_per_day = SavedAmount
        building.production_per_day1 = SavedAmount
      end
    end
    --moholemine/theexvacator
    for _,building in ipairs(UICity.labels.Wonders or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        building.producers[1].production_per_day = SavedAmount
        building.production_per_day1 = SavedAmount
      end
    end
    --farms
    if SelectedObj.encyclopedia_id:find("Farm") then
      for _,building in ipairs(UICity.labels.BaseFarm or empty_table) do
        if building.encyclopedia_id == SelectedObj.encyclopedia_id then
          building.producers[1].production_per_day = SavedAmount
          building.production_per_day1 = SavedAmount
        end
      end
      for _,building in ipairs(UICity.labels.FungalFarm or empty_table) do
        if building.encyclopedia_id == SelectedObj.encyclopedia_id then
          building.producers[1].production_per_day = SavedAmount
          building.production_per_day1 = SavedAmount
        end
      end
    end

  end

  if Bool == true then
    --update/create saved setting
    ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = SavedAmount
  else
    --remove setting as we reset building type to default (we don't want to call it when we place a new building if nothing is going to be changed)
    ChoGGi.CheatMenuSettings.BuildingsProduction[SelectedObj.encyclopedia_id] = nil
  end

  ChoGGi.WriteSettings()

  ChoGGi.MsgPopup(SelectedObj.encyclopedia_id .. " Production is now " .. SavedAmount / ChoGGi.Consts.ResourceScale,
    "Buildings","UI/Icons/Sections/storage.tga"
  )
end

function ChoGGi.SetCapacity(Bool)
  if not SelectedObj and not SelectedObj.base_water_capacity and not SelectedObj.base_air_capacity and not SelectedObj.base_capacity then
    ChoGGi.MsgPopup("You need to select something that has capacity.",
      "Buildings","UI/Icons/Sections/storage.tga"
    )
    return
  end

  --get type of capacity
  local CapType
  if SelectedObj.base_air_capacity then
    CapType = "air"
  elseif SelectedObj.base_water_capacity then
    CapType = "water"
  elseif SelectedObj.electricity and SelectedObj.electricity.storage_capacity then
    CapType = "electricity"
  elseif SelectedObj.colonists then
    CapType = "colonist"
  end

  --get saved capacity amount
  local SavedAmount = ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id]
  --get base amount
  local DefaultAmount
  if CapType == "electricity" or CapType == "colonist" then
    DefaultAmount = SelectedObj.base_capacity
  else
    DefaultAmount = SelectedObj["base_" .. CapType .. "_capacity"]
  end

  --nothing saved so use defaults
  if not SavedAmount then
    SavedAmount = DefaultAmount
  end

  --get the saved or base prod amount
  local NewLabel
  if Bool == true then
    if CapType == "colonist" then
      SavedAmount = SavedAmount + ChoGGi.Consts.ResidenceAddAmount
    else
      SavedAmount = SavedAmount + ChoGGi.Consts.AirWaterBatteryAddAmount
    end
    NewLabel = "charging"
  else --defaults
    SavedAmount = DefaultAmount
    NewLabel = "full"
  end

  if CapType == "electricity" then
    for _,building in ipairs(UICity.labels.Power or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        building.capacity = SavedAmount
        building[CapType].storage_capacity = SavedAmount
        building[CapType].storage_mode = NewLabel
        ChoGGi.ToggleWorking(building)
      end
    end
  elseif CapType == "colonist" then
    for _,building in ipairs(UICity.labels.Residence or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        building.capacity = SavedAmount
      end
    end
  else
    for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
      if building.encyclopedia_id == SelectedObj.encyclopedia_id then
        building[CapType .. "_capacity"] = SavedAmount
        building[CapType].storage_capacity = SavedAmount
        building[CapType].storage_mode = NewLabel
        ChoGGi.ToggleWorking(building)
      end
    end
  end

  if Bool == true then
    ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = SavedAmount
  else
    ChoGGi.CheatMenuSettings.BuildingsCapacity[SelectedObj.encyclopedia_id] = nil
  end

  ChoGGi.WriteSettings()

  if CapType ~= "colonist" then
    SavedAmount = SavedAmount / ChoGGi.Consts.ResourceScale
  end

  ChoGGi.MsgPopup(SelectedObj.encyclopedia_id .. " Capacity is now " .. SavedAmount,
    "Buildings","UI/Icons/Sections/storage.tga"
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
      building.auto_performance = 100
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

--used to add or remove traits from schools/sanitariums
function ChoGGi.BuildingsSetAll_Traits(Building,Traits,Bool)
  local Buildings = UICity.labels[Building] or 0
  for i = 1,#Buildings do
    local Obj = Buildings[i]
    for j = 1,#Traits do
      if Bool == true then
        Obj:SetTrait(j,nil)
      else
        Obj:SetTrait(j,Traits[j])
      end
    end
  end
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

function ChoGGi.SanatoriumCureAll_Toggle()
  ChoGGi.CheatMenuSettings.SanatoriumCureAll = not ChoGGi.CheatMenuSettings.SanatoriumCureAll
  if ChoGGi.CheatMenuSettings.SanatoriumCureAll then
    ChoGGi.BuildingsSetAll_Traits("Sanatorium",ChoGGi.NegativeTraits)
  else
    ChoGGi.BuildingsSetAll_Traits("Sanatorium",ChoGGi.NegativeTraits,true)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SanatoriumCureAll) .. " There's more vodka in this piss than there is piss.",
   "Sanatorium","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.SanatoriumSchoolShowAll()
  ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll = not ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll

  if ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll then
    Sanatorium.max_traits = #ChoGGi.NegativeTraits
    School.max_traits = #ChoGGi.PositiveTraits
  else
    Sanatorium.max_traits = 3
    School.max_traits = 3
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll) .. " Good for what ails you",
   "Buildings","UI/Icons/Upgrades/superfungus_03.tga"
  )
end

function ChoGGi.MaintenanceBuildingsFree_Toggle()

  ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp = not ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp
  for _,object in ipairs(UICity.labels.Building or empty_table) do
    if object.base_maintenance_build_up_per_hr then
      if ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp then
        object.maintenance_build_up_per_hr = -10000
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

function ChoGGi.CablesAndPipesNoBreak_Toggle()
    ChoGGi.CheatMenuSettings.BreakChanceCablePipe = not ChoGGi.CheatMenuSettings.BreakChanceCablePipe

    if ChoGGi.CheatMenuSettings.BreakChanceCablePipe then
      const.BreakChanceCable = 10000000
      const.BreakChancePipe = 10000000
    else
      const.BreakChanceCable = 600
      const.BreakChancePipe = 600
    end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.BreakChanceCablePipe .. " Aliens? We gotta deal with aliens too?",
   "Cables & Pipes","UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.CablesAndPipesRepair()
  ChoGGi.RepairBrokenShit(g_BrokenSupplyGridElements.electricity)
  ChoGGi.RepairBrokenShit(g_BrokenSupplyGridElements.water)
end

function ChoGGi.CablesAndPipesInstant_Toggle()
  Consts.InstantCables = ChoGGi.ToggleBoolNum(Consts.InstantCables)
  Consts.InstantPipes = ChoGGi.ToggleBoolNum(Consts.InstantPipes)
  ChoGGi.CheatMenuSettings.InstantCables = Consts.InstantCables
  ChoGGi.CheatMenuSettings.InstantPipes = Consts.InstantPipes
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.InstantCables .. " Aliens? We gotta deal with aliens too?",
   "Cables & Pipes","UI/Icons/Notifications/timer.tga"
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
