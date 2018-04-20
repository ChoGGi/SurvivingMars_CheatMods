
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

function ChoGGi.SetProductionAmount()
  if not SelectedObj or (not SelectedObj.base_air_production and not SelectedObj.base_water_production and not SelectedObj.base_electricity_production and not SelectedObj.producers) then
    ChoGGi.MsgPopup("Select something that produces (air,water,electricity,other).",
      "Buildings","UI/Icons/Sections/storage.tga"
    )
    return
  end

  local sel = SelectedObj
  --get type of producer
  local ProdType
  if sel.base_air_production then
    ProdType = "air"
  elseif sel.base_water_production then
    ProdType = "water"
  elseif sel.base_electricity_production then
    ProdType = "electricity"
  elseif sel.producers then
    ProdType = "other"
  end

  --get base amount
  local DefaultSetting
  if ProdType == "other" then
    DefaultSetting = sel.base_production_per_day1
  else
    DefaultSetting = sel["base_" .. ProdType .. "_production"]
  end
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 75,value = 75 * r},
    {text = 100,value = 100 * r},
    {text = 250,value = 250 * r},
    {text = 500,value = 500 * r},
    {text = 1000,value = 1000 * r},
    {text = 2500,value = 2500 * r},
    {text = 5000,value = 5000 * r},
    {text = 10000,value = 10000 * r},
    {text = 25000,value = 25000 * r},
    {text = 50000,value = 50000 * r},
    {text = 100000,value = 100000 * r},
  }

  local hint = DefaultSetting / r
  if ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] then
    hint = ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] / r
  end
  local CallBackFunc = function(choice)

    local amount = choice[1].value
    if type(amount) == "number" then
      if ProdType == "electricity" then
        --electricity
        for _,building in ipairs(UICity.labels.Power or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            --current prod
            building[ProdType]:SetProduction(amount)
            --when toggled on n off
            building[ProdType .. "_production"] = amount
          end
        end

      elseif ProdType == "water" or ProdType == "air" then
        --water/air
        for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building[ProdType]:SetProduction(amount)
            building[ProdType .. "_production"] = amount
          end
        end

      else --other prod
        --extractors/factories
        for _,building in ipairs(UICity.labels.Production or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building.producers[1].production_per_day = amount
            building.production_per_day1 = amount
          end
        end
        --moholemine/theexvacator
        for _,building in ipairs(UICity.labels.Wonders or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building.producers[1].production_per_day = amount
            building.production_per_day1 = amount
          end
        end
        --farms
        if sel.encyclopedia_id:find("Farm") then
          for _,building in ipairs(UICity.labels.BaseFarm or empty_table) do
            if building.encyclopedia_id == sel.encyclopedia_id then
              building.producers[1].production_per_day = amount
              building.production_per_day1 = amount
            end
          end
          for _,building in ipairs(UICity.labels.FungalFarm or empty_table) do
            if building.encyclopedia_id == sel.encyclopedia_id then
              building.producers[1].production_per_day = amount
              building.production_per_day1 = amount
            end
          end
        end
      end
      --update/create saved setting
      ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] = amount
    else
      --remove setting as we reset building type to default (we don't want to call it when we place a new building if nothing is going to be changed)
      ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] = nil
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(sel.encyclopedia_id .. " Production is now " .. choice[1].text,
      "Buildings","UI/Icons/Sections/storage.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sel.encyclopedia_id .. " Production Amount","Current production: " .. hint)
end

function ChoGGi.FullyAutomatedBuildings_Toggle()
  ChoGGi.CheatMenuSettings.FullyAutomatedBuildings = not ChoGGi.CheatMenuSettings.FullyAutomatedBuildings

  if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings == false then
    for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
      if building.base_max_workers then
        building.max_workers = nil
        building.automation = nil
        building.auto_performance = nil
      end
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.FullyAutomatedBuildings) .. ": I presume the PM's in favour of the scheme because it'll reduce unemployment.",
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
    )
    --all done
    return
  end

  --show list of options to pick
  local DefaultSetting = ChoGGi.Consts.FullyAutomatedBuildingsPerf
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value

    if type(amount) == "number" then
      for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
        if building.base_max_workers then
          building.max_workers = 0
          building.automation = 1
          building.auto_performance = amount
        end
      end
      --for new buildings
      ChoGGi.CheatMenuSettings.FullyAutomatedBuildingsPerf = amount
    else
      for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
        if building.base_max_workers then
          building.max_workers = nil
          building.automation = nil
          building.auto_performance = nil
        end
      end
      --for new buildings
      ChoGGi.CheatMenuSettings.FullyAutomatedBuildingsPerf = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(choice[1].text .. ": I presume the PM's in favour of the scheme because it'll reduce unemployment.",
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
    )

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Fully Automated Buildings: performance","Sets performance of all automated buildings")
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

	Sanatorium.max_traits = ChoGGi.ValueRetOpp(Sanatorium.max_traits,3,#ChoGGi.NegativeTraits)
	School.max_traits = ChoGGi.ValueRetOpp(School.max_traits,3,#ChoGGi.PositiveTraits)

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
  Consts.CropFailThreshold = ChoGGi.NumRetBool(Consts.CropFailThreshold,0,ChoGGi.Consts.CropFailThreshold)
  ChoGGi.CheatMenuSettings.CropFailThreshold = Consts.CropFailThreshold
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CropFailThreshold) .. " The small but great planet of Potatoho",
   "Buildings","UI/Icons/Sections/Food_1.tga"
  )
end

function ChoGGi.CheapConstruction_Toggle()

  ChoGGi.SetConstsG("Metals_cost_modifier",ChoGGi.ValueRetOpp(Consts.Metals_cost_modifier,-100,ChoGGi.Consts.Metals_cost_modifier))
  ChoGGi.SetConstsG("Metals_dome_cost_modifier",ChoGGi.ValueRetOpp(Consts.Metals_dome_cost_modifier,-100,ChoGGi.Consts.Metals_dome_cost_modifier))
  ChoGGi.SetConstsG("PreciousMetals_cost_modifier",ChoGGi.ValueRetOpp(Consts.PreciousMetals_cost_modifier,-100,ChoGGi.Consts.PreciousMetals_cost_modifier))
  ChoGGi.SetConstsG("PreciousMetals_dome_cost_modifier",ChoGGi.ValueRetOpp(Consts.PreciousMetals_dome_cost_modifier,-100,ChoGGi.Consts.PreciousMetals_dome_cost_modifier))
  ChoGGi.SetConstsG("Concrete_cost_modifier",ChoGGi.ValueRetOpp(Consts.Concrete_cost_modifier,-100,ChoGGi.Consts.Concrete_cost_modifier))
  ChoGGi.SetConstsG("Concrete_dome_cost_modifier",ChoGGi.ValueRetOpp(Consts.Concrete_dome_cost_modifier,-100,ChoGGi.Consts.Concrete_dome_cost_modifier))
  ChoGGi.SetConstsG("Polymers_dome_cost_modifier",ChoGGi.ValueRetOpp(Consts.Polymers_dome_cost_modifier,-100,ChoGGi.Consts.Polymers_dome_cost_modifier))
  ChoGGi.SetConstsG("Polymers_cost_modifier",ChoGGi.ValueRetOpp(Consts.Polymers_cost_modifier,-100,ChoGGi.Consts.Polymers_cost_modifier))
  ChoGGi.SetConstsG("Electronics_cost_modifier",ChoGGi.ValueRetOpp(Consts.Electronics_cost_modifier,-100,ChoGGi.Consts.Electronics_cost_modifier))
  ChoGGi.SetConstsG("Electronics_dome_cost_modifier",ChoGGi.ValueRetOpp(Consts.Electronics_dome_cost_modifier,-100,ChoGGi.Consts.Electronics_dome_cost_modifier))
  ChoGGi.SetConstsG("MachineParts_cost_modifier",ChoGGi.ValueRetOpp(Consts.MachineParts_cost_modifier,-100,ChoGGi.Consts.MachineParts_cost_modifier))
  ChoGGi.SetConstsG("MachineParts_dome_cost_modifier",ChoGGi.ValueRetOpp(Consts.MachineParts_dome_cost_modifier,-100,ChoGGi.Consts.MachineParts_dome_cost_modifier))
  ChoGGi.SetConstsG("rebuild_cost_modifier",ChoGGi.ValueRetOpp(Consts.rebuild_cost_modifier,-100,ChoGGi.Consts.rebuild_cost_modifier))

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
  ChoGGi.SetConstsG("CrimeEventSabotageBuildingsCount",ChoGGi.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount))
  ChoGGi.SetConstsG("CrimeEventDestroyedBuildingsCount",ChoGGi.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount))

  ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount = Consts.CrimeEventSabotageBuildingsCount
  ChoGGi.CheatMenuSettings.CrimeEventDestroyedBuildingsCount = Consts.CrimeEventDestroyedBuildingsCount
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount .. " We were all feeling a bit shagged and fagged and fashed, it being a night of no small expenditure.",
   "Buildings","UI/Icons/Notifications/fractured_dome.tga"
  )
end

function ChoGGi.CablesAndPipesNoBreak_Toggle()
  ChoGGi.CheatMenuSettings.BreakChanceCablePipe = not ChoGGi.CheatMenuSettings.BreakChanceCablePipe

  const.BreakChanceCable = ChoGGi.ValueRetOpp(const.BreakChanceCable,600,10000000)
  const.BreakChancePipe = ChoGGi.ValueRetOpp(const.BreakChancePipe,600,10000000)

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
  ChoGGi.SetConstsG("InstantCables",ChoGGi.ToggleBoolNum(Consts.InstantCables))
  ChoGGi.SetConstsG("InstantPipes",ChoGGi.ToggleBoolNum(Consts.InstantPipes))

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
