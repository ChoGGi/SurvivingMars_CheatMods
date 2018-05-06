local UsualIcon = "UI/Icons/Upgrades/home_collective_04.tga"
local UsualIcon2 = "UI/Icons/Sections/storage.tga"
local UsualIcon3 = "UI/Icons/IPButtons/assign_residence.tga"

function ChoGGi.PipesPillarsSpacing_Toggle()
  ChoGGi.SetConstsG("PipesPillarSpacing",ChoGGi.ValueRetOpp(Consts.PipesPillarSpacing,1000,ChoGGi.Consts.PipesPillarSpacing))
  ChoGGi.SetSavedSetting("PipesPillarSpacing",Consts.PipesPillarSpacing)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.PipesPillarSpacing) .. ": Is that a rocket in your pocket?",
    "Buildings"
  )
end

function ChoGGi.UnlimitedConnectionLength_Toggle()
  ChoGGi.CheatMenuSettings.UnlimitedConnectionLength = not ChoGGi.CheatMenuSettings.UnlimitedConnectionLength
  if ChoGGi.CheatMenuSettings.UnlimitedConnectionLength then
    GridConstructionController.max_hex_distance_to_allow_build = 1000
  else
    GridConstructionController.max_hex_distance_to_allow_build = 20
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.UnlimitedConnectionLength) .. ": Is that a rocket in your pocket?",
    "Buildings"
  )

end

function ChoGGi.BuildingPower_Toggle()
  local sel = SelectedObj
  if not sel or not sel.electricity_consumption then
    ChoGGi.MsgPopup("You need to select something that uses electricity.",
      "Buildings",UsualIcon
    )
    return
  end
  local id = sel.encyclopedia_id

  if not ChoGGi.CheatMenuSettings.BuildingSettings[id] then
    ChoGGi.CheatMenuSettings.BuildingSettings[id] = {}
  end

  local setting = ChoGGi.CheatMenuSettings.BuildingSettings[id]
  local amount
  if setting.nopower then
    setting.nopower = nil
    amount = DataInstances.BuildingTemplate[id].electricity_consumption
  else
    setting.nopower = true
    amount = 0
  end

  for _,building in ipairs(UICity.labels[id] or empty_table) do
    building:SetBase("electricity_consumption", amount)
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(id .. " power consumption: " .. amount,"Buildings")
end

function ChoGGi.SetMaxChangeOrDischarge()
  local sel = SelectedObj
  if not sel or (not sel.base_air_capacity and not sel.base_water_capacity and not sel.base_capacity) then
    ChoGGi.MsgPopup("You need to select something that has capacity (air/water/elec).",
      "Buildings",UsualIcon
    )
    return
  end
  local id = sel.encyclopedia_id
  local r = ChoGGi.Consts.ResourceScale

  --get type of capacity
  local CapType
  if sel.base_air_capacity then
    CapType = "air"
  elseif sel.base_water_capacity then
    CapType = "water"
  elseif sel.electricity and sel.electricity.storage_capacity then
    CapType = "electricity"
  end
  --probably selected something with colonists
  if not CapType then
    return
  end

  --get default amount
  local template = DataInstances.BuildingTemplate[id]
  local DefaultSettingC = template["max_" .. CapType .. "_charge"] / r
  local DefaultSettingD = template["max_" .. CapType .. "_discharge"] / r

  local ItemList = {
    {text = " Defaults",value = 3.1415926535,hint = "Charge: " .. DefaultSettingC .. " / Discharge: " .. DefaultSettingD},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
  }

  --check if there's an entry for building
  if not ChoGGi.CheatMenuSettings.BuildingSettings[id] then
    ChoGGi.CheatMenuSettings.BuildingSettings[id] = {}
  end

  local hint = "charge: " .. DefaultSettingC .. " / discharge: " .. DefaultSettingD
  local setting = ChoGGi.CheatMenuSettings.BuildingSettings[id]
  if setting then
    if setting.charge and setting.discharge then
      hint = "charge: " .. tostring(setting.charge / r) .. " / discharge: " .. tostring(setting.discharge / r)
    elseif setting.charge then
      hint = tostring(setting.charge / r)
    elseif setting.discharge then
      hint = tostring(setting.discharge / r)
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    local check1 = choice[1].check1
    local check2 = choice[1].check2

    if not check1 and not check2 then
      ChoGGi.MsgPopup("Pick a checkbox or two next time...","Rate",UsualIcon2)
      return
    end

    if type(value) == "number" then
      local numberC = value * r
      local numberD = value * r

      if value == 3.1415926535 then
        if check1 then
          setting.charge = nil
          numberC = DefaultSettingC * r
        end
        if check2 then
          setting.discharge = nil
          numberD = DefaultSettingD * r
        end
      else
        if check1 then
          setting.charge = numberC
        end
        if check2 then
          setting.discharge = numberD
        end
      end

      --updating time
      if CapType == "electricity" then
        for _,building in ipairs(UICity.labels.Power or empty_table) do
          if building.encyclopedia_id == id then
            if check1 then
              building[CapType].max_charge = numberC
              building["max_" .. CapType .. "_charge"] = numberC
            end
            if check2 then
              building[CapType].max_discharge = numberD
              building["max_" .. CapType .. "_discharge"] = numberD
            end
            ChoGGi.ToggleWorking(building)
          end
        end

      else --water and air
        for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
          if building.encyclopedia_id == id then
            if check1 then
              building[CapType].max_charge = numberC
              building["max_" .. CapType .. "_charge"] = numberC
            end
            if check2 then
              building[CapType].max_discharge = numberD
              building["max_" .. CapType .. "_discharge"] = numberD
            end
            ChoGGi.ToggleWorking(building)
          end
        end
      end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(id .. " rate is now " .. choice[1].text,
        "Rate",UsualIcon2
      )
    end
  end

  hint = "Current rate: " .. hint
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. id .. " Dis/Charge Rates",hint,nil,"Charge","Change charge rate","Discharge","Change discharge rate")
end

function ChoGGi.UseLastOrientation_Toggle()
  ChoGGi.CheatMenuSettings.UseLastOrientation = not ChoGGi.CheatMenuSettings.UseLastOrientation

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.UseLastOrientation) .. " Building Orientation",
    "Buildings"
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
  ChoGGi.MsgPopup("Well, I been working in a coal mine\nGoing down, down\nWorking in a coal mine\nWhew, about to slip down",
    "Farms","UI/Icons/Sections/Food_2.tga",true
  )
end

function ChoGGi.SetProductionAmount()
  local sel = SelectedObj
  if not sel or (not sel.base_air_production and not sel.base_water_production and not sel.base_electricity_production and not sel.producers) then
    ChoGGi.MsgPopup("Select something that produces (air,water,electricity,other).",
      "Buildings",UsualIcon2
    )
    return
  end
  local id = sel.encyclopedia_id

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
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting
  if ProdType == "other" then
    DefaultSetting = sel.base_production_per_day1 / r
  else
    DefaultSetting = sel["base_" .. ProdType .. "_production"] / r
  end

  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
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

  --check if there's an entry for building
  if not ChoGGi.CheatMenuSettings.BuildingSettings[id] then
    ChoGGi.CheatMenuSettings.BuildingSettings[id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.CheatMenuSettings.BuildingSettings[id]
  if setting and setting.production then
    hint = tostring(setting.production / r)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      local amount = value * r
      if ProdType == "electricity" then
        --electricity
        for _,building in ipairs(UICity.labels.Power or empty_table) do
          if building.encyclopedia_id == id then
            --current prod
            building[ProdType]:SetProduction(amount)
            --when toggled on n off
            building[ProdType .. "_production"] = amount
          end
        end

      elseif ProdType == "water" or ProdType == "air" then
        --water/air
        for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
          if building.encyclopedia_id == id then
            building[ProdType]:SetProduction(amount)
            building[ProdType .. "_production"] = amount
          end
        end

      else --other prod
        --extractors/factories
        for _,building in ipairs(UICity.labels.Production or empty_table) do
          if building.encyclopedia_id == id then
            building.producers[1].production_per_day = amount
            building.production_per_day1 = amount
          end
        end
        --moholemine/theexvacator
        for _,building in ipairs(UICity.labels.Wonders or empty_table) do
          if building.encyclopedia_id == id then
            building.producers[1].production_per_day = amount
            building.production_per_day1 = amount
          end
        end
        --farms
        if id:find("Farm") then
          for _,building in ipairs(UICity.labels.BaseFarm or empty_table) do
            if building.encyclopedia_id == id then
              building.producers[1].production_per_day = amount
              building.production_per_day1 = amount
            end
          end
          for _,building in ipairs(UICity.labels.FungalFarm or empty_table) do
            if building.encyclopedia_id == id then
              building.producers[1].production_per_day = amount
              building.production_per_day1 = amount
            end
          end
        end
      end

      if value == DefaultSetting then
        --remove setting as we reset building type to default (we don't want to call it when we place a new building if nothing is going to be changed)
        ChoGGi.CheatMenuSettings.BuildingSettings[id].production = nil
      else
        --update/create saved setting
        ChoGGi.CheatMenuSettings.BuildingSettings[id].production = amount
      end
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(id .. " Production is now " .. choice[1].text,
      "Buildings",UsualIcon2
    )
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. id .. " Production Amount","Current production: " .. hint)
end

function ChoGGi.FullyAutomatedBuildings()

  --show list of options to pick
  local ItemList = {
    {text = " Disable",value = "disable"},
    {text = 100,value = 100},
    {text = 150,value = 150},
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
    local value = choice[1].value
    if type(value) == "number" then
      for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
        if building.base_max_workers then
          building.max_workers = 0
          building.automation = 1
          building.auto_performance = value
        end
      end
      ChoGGi.CheatMenuSettings.FullyAutomatedBuildings = value
    else
      for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
        if building.base_max_workers then
          building.max_workers = nil
          building.automation = nil
          building.auto_performance = nil
        end
      end
      ChoGGi.CheatMenuSettings.FullyAutomatedBuildings = false
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(choice[1].text .. "\nI presume the PM's in favour of the scheme because it'll reduce unemployment.",
      "Buildings",UsualIcon,true
    )
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Fully Automated Buildings: performance","Sets performance of all automated buildings")
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
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings) .. "\nI'm sorry, I'm simply not at liberty to say.",
    "Buildings","UI/Icons/Anomaly_Tech.tga",true
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
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SchoolTrainAll) .. "\nYou keep your work station so clean, Jerome.\nIt's next to godliness. Isn't that what they say?",
    "School",UsualIcon,true
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
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.SanatoriumCureAll) .. "\nThere's more vodka in this piss than there is piss.",
    "Sanatorium",UsualIcon,true
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

function ChoGGi.MoistureVaporatorPenalty_Toggle()
  const.MoistureVaporatorRange = ChoGGi.NumRetBool(const.MoistureVaporatorRange,0,ChoGGi.Consts.MoistureVaporatorRange)
  const.MoistureVaporatorPenaltyPercent = ChoGGi.NumRetBool(const.MoistureVaporatorPenaltyPercent,0,ChoGGi.Consts.MoistureVaporatorPenaltyPercent)
  ChoGGi.SetSavedSetting("MoistureVaporatorRange",const.MoistureVaporatorRange)
  ChoGGi.SetSavedSetting("MoistureVaporatorRange",const.MoistureVaporatorPenaltyPercent)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.MoistureVaporatorRange) .. ": All right, pussy, pussy, pussy! Come on in pussy lovers! Here at the Titty Twister we're slashing pussy in half! Give us an offer on our vast selection of pussy, this is a pussy blow out! All right, we got white pussy, black pussy, Spanish pussy, yellow pussy, we got hot pussy, cold pussy, we got wet pussy, we got... smelly pussy, we got hairy pussy, bloody pussy, we got snappin' pussy, we got silk pussy, velvet pussy, Naugahyde pussy, we even got horse pussy, dog pussy, chicken pussy! Come on, you want pussy, come on in, pussy lovers! If we don't got it, you don't want it! Come on in, pussy lovers!",
    "Buildings","UI/Icons/Upgrades/zero_space_04.tga",true
  )
end

function ChoGGi.CropFailThreshold_Toggle()
  Consts.CropFailThreshold = ChoGGi.NumRetBool(Consts.CropFailThreshold,0,ChoGGi.Consts.CropFailThreshold)
  ChoGGi.SetSavedSetting("CropFailThreshold",Consts.CropFailThreshold)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CropFailThreshold) .. "\nSo, er, we the crew of the Eagle 5, if we do encounter, make first contact with alien beings, it is a friendship greeting from the children of our small but great planet of Potatoho.",
    "Buildings","UI/Icons/Sections/Food_1.tga",true
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

  ChoGGi.SetSavedSetting("Metals_cost_modifier",Consts.Metals_cost_modifier)
  ChoGGi.SetSavedSetting("Metals_dome_cost_modifier",Consts.Metals_dome_cost_modifier)
  ChoGGi.SetSavedSetting("PreciousMetals_cost_modifier",Consts.PreciousMetals_cost_modifier)
  ChoGGi.SetSavedSetting("PreciousMetals_dome_cost_modifier",Consts.PreciousMetals_dome_cost_modifier)
  ChoGGi.SetSavedSetting("Concrete_cost_modifier",Consts.Concrete_cost_modifier)
  ChoGGi.SetSavedSetting("Concrete_dome_cost_modifier",Consts.Concrete_dome_cost_modifier)
  ChoGGi.SetSavedSetting("Polymers_cost_modifier",Consts.Polymers_cost_modifier)
  ChoGGi.SetSavedSetting("Polymers_dome_cost_modifier",Consts.Polymers_dome_cost_modifier)
  ChoGGi.SetSavedSetting("Electronics_cost_modifier",Consts.Electronics_cost_modifier)
  ChoGGi.SetSavedSetting("Electronics_dome_cost_modifier",Consts.Electronics_dome_cost_modifier)
  ChoGGi.SetSavedSetting("MachineParts_cost_modifier",Consts.MachineParts_cost_modifier)
  ChoGGi.SetSavedSetting("MachineParts_dome_cost_modifier",Consts.MachineParts_dome_cost_modifier)
  ChoGGi.SetSavedSetting("rebuild_cost_modifier",Consts.rebuild_cost_modifier)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Metals_cost_modifier) .. ": Get yourself a beautiful showhome (even if it falls apart after you move in)",
    "Buildings","UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.BuildingDamageCrime_Toggle()
  ChoGGi.SetConstsG("CrimeEventSabotageBuildingsCount",ChoGGi.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount))
  ChoGGi.SetConstsG("CrimeEventDestroyedBuildingsCount",ChoGGi.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount))

  ChoGGi.SetSavedSetting("CrimeEventSabotageBuildingsCount",Consts.CrimeEventSabotageBuildingsCount)
  ChoGGi.SetSavedSetting("CrimeEventDestroyedBuildingsCount",Consts.CrimeEventDestroyedBuildingsCount)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CrimeEventSabotageBuildingsCount) .. "\nWe were all feeling a bit shagged and fagged and fashed, it having been an evening of some small energy expenditure, O my brothers. So we got rid of the auto and stopped off at the Korova for a nightcap.",
    "Buildings","UI/Icons/Notifications/fractured_dome.tga",true
  )
end

function ChoGGi.CablesAndPipesNoBreak_Toggle()
  ChoGGi.CheatMenuSettings.BreakChanceCablePipe = not ChoGGi.CheatMenuSettings.BreakChanceCablePipe

  const.BreakChanceCable = ChoGGi.ValueRetOpp(const.BreakChanceCable,600,10000000)
  const.BreakChancePipe = ChoGGi.ValueRetOpp(const.BreakChancePipe,600,10000000)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.BreakChanceCablePipe) .. " Aliens? We gotta deal with aliens too?",
    "Cables & Pipes","UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.RemoveBuildingLimits_Toggle()
  ChoGGi.CheatMenuSettings.RemoveBuildingLimits = not ChoGGi.CheatMenuSettings.RemoveBuildingLimits

  if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then
    ChoGGi.OverrideConstructionLimits = nil
    ChoGGi.OverrideConstructionLimits_Enable()
  else
    ChoGGi.OverrideConstructionLimits = nil
    ConstructionController.UpdateConstructionStatuses = ChoGGi.OrigFunc.CC_UpdateConstructionStatuses
    TunnelConstructionController.UpdateConstructionStatuses = ChoGGi.OrigFunc.TC_UpdateConstructionStatuses
    ChoGGi.OrigFunc.CC_UpdateConstructionStatuses = nil
    ChoGGi.OrigFunc.TC_UpdateConstructionStatuses = nil
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RemoveBuildingLimits) .. " No no I said over there.",
    "Buildings",
    "UI/Icons/Upgrades/zero_space_04.tga"
  )
end

function ChoGGi.Building_wonder_Toggle()
  ChoGGi.CheatMenuSettings.Building_wonder = not ChoGGi.CheatMenuSettings.Building_wonder
  if ChoGGi.CheatMenuSettings.Building_wonder then
    for _,building in ipairs(DataInstances.BuildingTemplate) do
      building.wonder = false
    end
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_wonder) .. " Unlimited Wonders\n(restart to set disabled)",
    "Buildings",UsualIcon3
  )
end

function ChoGGi.Building_dome_spot_Toggle()
  ChoGGi.CheatMenuSettings.Building_dome_spot = not ChoGGi.CheatMenuSettings.Building_dome_spot
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_dome_spot) .. " Freedom for spires!\n(restart to set disabled)",
    "Buildings",UsualIcon3
  )
end

function ChoGGi.Building_instant_build_Toggle()
  ChoGGi.CheatMenuSettings.Building_instant_build = not ChoGGi.CheatMenuSettings.Building_instant_build
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_instant_build) .. " Building Instant Build\n(restart to set disabled).",
    "Buildings",UsualIcon3
  )
end

function ChoGGi.Building_hide_from_build_menu_Toggle()
  ChoGGi.CheatMenuSettings.Building_hide_from_build_menu = not ChoGGi.CheatMenuSettings.Building_hide_from_build_menu
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_hide_from_build_menu) .. " Buildings hidden\n(restart to toggle).",
    "Buildings",UsualIcon3
  )
end
