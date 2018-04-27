
function ChoGGi.UseLastOrientation_Toggle()
  ChoGGi.CheatMenuSettings.UseLastOrientation = not ChoGGi.CheatMenuSettings.UseLastOrientation

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.UseLastOrientation) .. " Building Orientation",
   "Buildings"
  )
end

function ChoGGi.ChangeBuildingColour()
  local sel = SelectedObj or SelectionMouseObj()
  if not sel and not sel:IsKindOf("ColorizableObject") then
    ChoGGi.MsgPopup("Can't colour object","Colour")
    return
  end
  --SetPal(sel,i,Color,Roughness,Metallic)
  local SetPal = sel.SetColorizationMaterial
  local GetPal = sel.GetColorizationMaterial
  local pal = ChoGGi.GetPalette(sel)

  local ItemList = {}
  for i = 1, 4 do
    table.insert(ItemList,{
      text = "Colour " .. i,
      value = pal["Color" .. i],
      hint = "Use the colour picker.",
    })
    table.insert(ItemList,{
      text = "Metallic " .. i,
      value = pal["Metallic" .. i],
      hint = "Don't use the colour picker. Numbers range from -255 to 255?",
    })
    table.insert(ItemList,{
      text = "Roughness " .. i,
      value = pal["Roughness" .. i],
      hint = "Don't use the colour picker. Numbers range from -255 to 255?",
    })
  end

  --callback
  local CallBackFunc = function(choice)
    if #choice == 12 then
      --keep original colours as part of object
      local function saveold(obj)
        if not obj.ChoGGi_origcolors then
          obj.ChoGGi_origcolors = {}
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,1)})
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,2)})
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,3)})
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,4)})
        end
      end
      local function restoreold(obj)
        if obj.ChoGGi_origcolors then
          local c = obj.ChoGGi_origcolors
          local SetPal = obj.SetColorizationMaterial
          SetPal(obj,1, c[1][1], c[1][2], c[1][3])
          SetPal(obj,2, c[2][1], c[2][2], c[2][3])
          SetPal(obj,3, c[3][1], c[3][2], c[3][3])
          SetPal(obj,4, c[4][1], c[4][2], c[4][3])
        end
      end

      table.sort(choice,
        function(a,b)
          return ChoGGi.CompareTableNames(a,b,"text")
        end
      )

      if ChoGGi.ListChoiceCustomDialog_CheckBox1 then
        for _,building in ipairs(UICity.labels[sel.class] or empty_table) do
          if ChoGGi.ListChoiceCustomDialog_CheckBox2 then
            restoreold(building)
          else
            saveold(building)
            for i = 1, 4 do
              local Color = choice[i].value
              local Metallic = choice[i+4].value
              local Roughness = choice[i+8].value
              SetPal(building,i,Color,Roughness,Metallic)
            end
          end
        end
      else
        if ChoGGi.ListChoiceCustomDialog_CheckBox2 then
          restoreold(sel)
        else
          saveold(sel)
          for i = 1, 4 do
            local Color = choice[i].value
            local Metallic = choice[i+4].value
            local Roughness = choice[i+8].value
            SetPal(sel,i,Color,Roughness,Metallic)
          end
        end
      end

      ChoGGi.MsgPopup("Colour is set on " .. sel.encyclopedia_id,"Colour")
    end
  end
  local hint = "If number is 8421504 (0 for Metallic/Roughness) then you can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour (of some buildings)",hint,true,"All of type","Change all objects of the same type.","Default Colour","if they're there; resets to default colours.",2)
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

  local hint = DefaultSetting / r
  if ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] then
    hint = ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] / r
  end
  local CallBackFunc = function(choice)
    if type(value) == "number" then
      local value = choice[1].value * r
      if ProdType == "electricity" then
        --electricity
        for _,building in ipairs(UICity.labels.Power or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            --current prod
            building[ProdType]:SetProduction(value)
            --when toggled on n off
            building[ProdType .. "_production"] = value
          end
        end

      elseif ProdType == "water" or ProdType == "air" then
        --water/air
        for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building[ProdType]:SetProduction(value)
            building[ProdType .. "_production"] = value
          end
        end

      else --other prod
        --extractors/factories
        for _,building in ipairs(UICity.labels.Production or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building.producers[1].production_per_day = value
            building.production_per_day1 = value
          end
        end
        --moholemine/theexvacator
        for _,building in ipairs(UICity.labels.Wonders or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building.producers[1].production_per_day = value
            building.production_per_day1 = value
          end
        end
        --farms
        if sel.encyclopedia_id:find("Farm") then
          for _,building in ipairs(UICity.labels.BaseFarm or empty_table) do
            if building.encyclopedia_id == sel.encyclopedia_id then
              building.producers[1].production_per_day = value
              building.production_per_day1 = value
            end
          end
          for _,building in ipairs(UICity.labels.FungalFarm or empty_table) do
            if building.encyclopedia_id == sel.encyclopedia_id then
              building.producers[1].production_per_day = value
              building.production_per_day1 = value
            end
          end
        end
      end
      --update/create saved setting
      ChoGGi.CheatMenuSettings.BuildingsProduction[sel.encyclopedia_id] = value
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

function ChoGGi.FullyAutomatedBuildings()

  --show list of options to pick
  local ItemList = {
    {text = " Disable",value = 0},
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
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga",true
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
   "School","UI/Icons/Upgrades/home_collective_04.tga",true
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
   "Sanatorium","UI/Icons/Upgrades/home_collective_04.tga",true
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

function ChoGGi.Building_wonder_Toggle()
  ChoGGi.CheatMenuSettings.Building_wonder = not ChoGGi.CheatMenuSettings.Building_wonder

  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.wonder = false
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_wonder) .. " Unlimited Wonders\n(restart to disable)",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_dome_spot_Toggle()
  ChoGGi.CheatMenuSettings.Building_dome_spot = not ChoGGi.CheatMenuSettings.Building_dome_spot
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.dome_spot = "none"
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_dome_spot) .. " Freedom for spires!\n(restart to disable)",
   "Buildings","UI/Icons/IPButtons/assign_residence.tga"
  )
end

function ChoGGi.Building_instant_build_Toggle()
  ChoGGi.CheatMenuSettings.Building_instant_build = not ChoGGi.CheatMenuSettings.Building_instant_build
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    building.instant_build = true
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.Building_instant_build) .. " Building Instant Build\n(restart to disable).",
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
