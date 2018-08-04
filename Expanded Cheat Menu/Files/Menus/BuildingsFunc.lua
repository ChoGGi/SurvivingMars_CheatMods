-- See LICENSE for terms

local default_icon = "UI/Icons/Upgrades/home_collective_04.tga"
local default_icon2 = "UI/Icons/Sections/storage.tga"
local default_icon3 = "UI/Icons/IPButtons/assign_residence.tga"

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings

local type,tostring,pairs = type,tostring,pairs

local Sleep = Sleep
local CreateRealTimeThread = CreateRealTimeThread
local SelectObj = SelectObj
local UnlockBuilding = UnlockBuilding
local GetBuildingTechsStatus = GetBuildingTechsStatus

function ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery()
  --make a list
  local ChoGGi = ChoGGi
  local DefaultSetting = 5
  local UserSettings = ChoGGi.UserSettings
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = Concat(S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 10,value = 10},
    {text = 15,value = 15},
    {text = 20,value = 20},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  --other hint type
  local hint = DefaultSetting
  if UserSettings.ServiceWorkplaceFoodStorage then
    hint = UserSettings.ServiceWorkplaceFoodStorage
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      value = value * r

      if value == DefaultSetting * r then
        UserSettings.ServiceWorkplaceFoodStorage = nil
      else
        UserSettings.ServiceWorkplaceFoodStorage = value
      end

      local function SetStor(cls)
        local objs = UICity.labels[cls] or ""
        for i = 1, #objs do
          objs[i].consumption_stored_resources = value
          objs[i].consumption_max_storage = value
        end
      end
      SetStor("Diner")
      SetStor("Grocery")

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        ChoGGi.ComFuncs.SettingState(choice[1].text,8830--[[Food Storage--]]),
        1022--[[Food--]],
        "UI/Icons/Sections/Food_1.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000105--[[Set Food Storage--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
    skip_sort = true,
  }
end

function ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.AlwaysDustyBuildings then
    ChoGGi.UserSettings.AlwaysDustyBuildings = nil
    --dust clean up
    local objs = UICity.labels.Building or ""
    for i = 1, #objs do
      objs[i].ChoGGi_AlwaysDust = nil
    end
  else
    ChoGGi.UserSettings.AlwaysDustyBuildings = true
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000107--[[%s: I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration.
I will face my fear. I will permit it to pass over me and through me,
and when it has gone past I will turn the inner eye to see its path.
Where the fear has gone there will be nothing. Only I will remain.--]]]:format(ChoGGi.UserSettings.AlwaysDustyBuildings),
    3980--[[Buildings--]],
    nil,
    true
  )
end

function ChoGGi.MenuFuncs.SetProtectionRadius()
  local ChoGGi = ChoGGi
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel or not sel.protect_range then
    MsgPopup(
      302535920000108--[[Select something with a protect_range (MDSLaser/DefenceTower).--]],
      302535920000109--[[Protect--]],
      default_icon
    )
    return
  end
  local id = sel.encyclopedia_id
  local DefaultSetting = _G[id]:GetDefaultPropertyValue("protect_range")
  local ItemList = {
    {text = Concat(S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 40,value = 40},
    {text = 80,value = 80},
    {text = 160,value = 160},
    {text = 320,value = 320,hint = 302535920000111--[[Cover the entire map from the centre.--]]},
    {text = 640,value = 640,hint = 302535920000112--[[Cover the entire map from a corner.--]]},
  }

  if not ChoGGi.UserSettings.BuildingSettings[id] then
    ChoGGi.UserSettings.BuildingSettings[id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[id]
  if setting and setting.protect_range then
    hint = tostring(setting.protect_range)
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then

      local tab = UICity.labels[id] or ""
      for i = 1, #tab do
        tab[i].protect_range = value
        tab[i].shoot_range = value * ChoGGi.Consts.guim
      end

      if value == DefaultSetting then
        ChoGGi.UserSettings.BuildingSettings[id].protect_range = nil
      else
        ChoGGi.UserSettings.BuildingSettings[id].protect_range = value
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000113--[[%s range is now %s.--]]]:format(RetName(sel),choice[1].text),
        302535920000109--[[Protect--]],
        default_icon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000114--[[Set Protection Radius--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint,"\n\n",S[302535920000115--[[Toggle selection to update visible hex grid.--]]]),
    skip_sort = true,
  }
end

function ChoGGi.MenuFuncs.UnlockLockedBuildings()
  local ChoGGi = ChoGGi
  local data = DataInstances.BuildingTemplate or empty_table
  local ItemList = {}
  for Key,_ in pairs(data) do
    if type(Key) == "string" and not GetBuildingTechsStatus(Key) then
      ItemList[#ItemList+1] = {
        text = T(data[Key].display_name),
        value = Key
      }
    end
  end

  local function CallBackFunc(choice)
     local value = choice[1].value
    if not value then
      return
    end
    for i = 1, #choice do
      UnlockBuilding(choice[i].value)
    end
    ChoGGi.CodeFuncs.BuildMenu_Toggle()
    MsgPopup(
      S[302535920000116--[[%s: Buildings unlocked.--]]]:format(#choice),
      8690--[[Protect--]],
      default_icon
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000117--[[Unlock Buildings--]],
    hint = 302535920000118--[[Pick the buildings you want to unlock (use Ctrl/Shift for multiple).--]],
    multisel = true,
  }
end

function ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("PipesPillarSpacing",ChoGGi.ComFuncs.ValueRetOpp(Consts.PipesPillarSpacing,1000,ChoGGi.Consts.PipesPillarSpacing))
  ChoGGi.ComFuncs.SetSavedSetting("PipesPillarSpacing",Consts.PipesPillarSpacing)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000119--[[%s: Is that a rocket in your pocket?--]]]:format(ChoGGi.UserSettings.PipesPillarSpacing),
    3980--[[Buildings--]]
  )
end

function ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.UnlimitedConnectionLength then
    ChoGGi.UserSettings.UnlimitedConnectionLength = nil
    GridConstructionController.max_hex_distance_to_allow_build = 20
  else
    ChoGGi.UserSettings.UnlimitedConnectionLength = true
    GridConstructionController.max_hex_distance_to_allow_build = 1000
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000119--[[%s: Is that a rocket in your pocket?--]]]:format(ChoGGi.UserSettings.UnlimitedConnectionLength),
    3980--[[Buildings--]]
  )
end

local function BuildingConsumption_Toggle(type1,str1,type2,func1,func2,str2)
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or not sel[type1] then
    MsgPopup(
      str1,
      3980--[[Buildings--]],
      default_icon
    )
    return
  end
  local id = sel.encyclopedia_id
  local UserSettings = ChoGGi.UserSettings

  if not UserSettings.BuildingSettings[id] then
    UserSettings.BuildingSettings[id] = {}
  end

  local setting = UserSettings.BuildingSettings[id]
  local which
  if setting[type2] then
    setting[type2] = nil
    which = func1
  else
    setting[type2] = true
    which = func2
  end

  local blds = UICity.labels[id] or ""
  for i = 1, #blds do
    ChoGGi.CodeFuncs[which](blds[i])
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    Concat(RetName(sel)," ",S[str2]),
    3980--[[Buildings--]],
    default_icon
  )
end

function ChoGGi.MenuFuncs.BuildingPower_Toggle()
  BuildingConsumption_Toggle(
    "electricity_consumption",
    302535920000120--[[You need to select a building that uses electricity.--]],
    "nopower",
    "AddBuildingElecConsump",
    "RemoveBuildingElecConsump",
    683--[[Power Consumption--]]
  )
end

function ChoGGi.MenuFuncs.BuildingWater_Toggle()
  BuildingConsumption_Toggle(
    "water_consumption",
    302535920000121--[[You need to select a building that uses water.--]],
    "nowater",
    "AddBuildingWaterConsump",
    "RemoveBuildingWaterConsump",
    656--[[Water consumption--]]
  )
end

function ChoGGi.MenuFuncs.BuildingAir_Toggle()
  BuildingConsumption_Toggle(
    "air_consumption",
    302535920001250--[[You need to select a building that uses oxygen.--]],
    "noair",
    "AddBuildingOxygenConsump",
    "RemoveBuildingOxygenConsump",
    657--[[Oxygen Consumption--]]
  )
end

function ChoGGi.MenuFuncs.SetMaxChangeOrDischarge()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or (not sel.base_air_capacity and not sel.base_water_capacity and not sel.base_capacity) then
    MsgPopup(
      302535920000122--[[You need to select something that has capacity (air/water/elec).--]],
      3980--[[Buildings--]],
      default_icon
    )
    return
  end
  local id = sel.encyclopedia_id
  local name = T(sel.display_name)
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
  local DefaultSettingC = template[Concat("max_",CapType,"_charge")] / r
  local DefaultSettingD = template[Concat("max_",CapType,"_discharge")] / r

  local ItemList = {
    {text = Concat(S[1000121--[[Default--]]]),value = S[1000121--[[Default--]]],hint = Concat(S[302535920000124--[[Charge--]]],": ",DefaultSettingC," / ",S[302535920000125--[[Discharge--]]],": ",DefaultSettingD)},
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
  if not ChoGGi.UserSettings.BuildingSettings[id] then
    ChoGGi.UserSettings.BuildingSettings[id] = {}
  end

  local hint = Concat(S[302535920000124--[[Charge--]]],": ",DefaultSettingC," / ",S[302535920000125--[[Discharge--]]],": ",DefaultSettingD)
  local setting = ChoGGi.UserSettings.BuildingSettings[id]
  if setting then
    if setting.charge and setting.discharge then
      hint = Concat(S[302535920000124--[[Charge--]]],": ",setting.charge / r," / ",S[302535920000125--[[Discharge--]]],": ",setting.discharge / r)
    elseif setting.charge then
      hint = setting.charge / r
    elseif setting.discharge then
      hint = setting.discharge / r
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local check1 = choice[1].check1
    local check2 = choice[1].check2

    if not check1 and not check2 then
      MsgPopup(
        302535920000038--[[Pick a checkbox next time...--]],
        302535920000127--[[Rate--]],
        default_icon2
      )
      return
    end

    if type(value) == "number" then
      local numberC = value * r
      local numberD = value * r

      if value == S[1000121--[[Default--]]] then
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
        local tab = UICity.labels.Power or ""
        for i = 1, #tab do
          if tab[i].encyclopedia_id == id then
            if check1 then
              tab[i][CapType].max_charge = numberC
              tab[i][Concat("max_",CapType,"_charge")] = numberC
            end
            if check2 then
              tab[i][CapType].max_discharge = numberD
              tab[i][Concat("max_",CapType,"_discharge")] = numberD
            end
            ChoGGi.CodeFuncs.ToggleWorking(tab[i])
          end
        end
      else --water and air
        local tab = UICity.labels["Life-Support"] or ""
        for i = 1, #tab do
          if tab[i].encyclopedia_id == id then
            if check1 then
              tab[i][CapType].max_charge = numberC
              tab[i][Concat("max_",CapType,"_charge")] = numberC
            end
            if check2 then
              tab[i][CapType].max_discharge = numberD
              tab[i][Concat("max_",CapType,"_discharge")] = numberD
            end
            ChoGGi.CodeFuncs.ToggleWorking(tab[i])
          end
        end
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000128--[[%s rate is now: %s--]]]:format(RetName(sel),choice[1].text),
        302535920000127--[[Rate--]],
        default_icon2
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",name," ",S[302535920000130--[[Dis/Charge Rates--]]]),
    hint = Concat(S[302535920000131--[[Current rate--]]],": ",hint),
    check1 = 302535920000124--[[Charge--]],
    check1_hint = 302535920000132--[[Change charge rate--]],
    check2 = 302535920000125--[[Discharge--]],
    check2_hint = 302535920000133--[[Change discharge rate--]],
    skip_sort = true,
  }
end

function ChoGGi.MenuFuncs.UseLastOrientation_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.UseLastOrientation = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.UseLastOrientation)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.UseLastOrientation,302535920000134--[[Building Orientation--]]),
    3980--[[Buildings--]]
  )
end

function ChoGGi.MenuFuncs.FarmShiftsAllOn()
  local UICity = UICity
  local tab = UICity.labels.BaseFarm or ""
  for i = 1, #tab do
    tab[i].closed_shifts[1] = false
    tab[i].closed_shifts[2] = false
    tab[i].closed_shifts[3] = false
  end
  --BaseFarm doesn't include FungalFarm...
  tab = UICity.labels.FungalFarm or ""
  for i = 1, #tab do
    tab[i].closed_shifts[1] = false
    tab[i].closed_shifts[2] = false
    tab[i].closed_shifts[3] = false
  end

  MsgPopup(
    302535920000135--[[Well, I been working in a coal mine
Going down, down
Working in a coal mine
Whew, about to slip down--]],
    5068--[[Farms--]],
    "UI/Icons/Sections/Food_2.tga",
    true
  )
end

function ChoGGi.MenuFuncs.SetProductionAmount()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or (not sel.base_air_production and not sel.base_water_production and not sel.base_electricity_production and not sel.producers) then
    MsgPopup(
      302535920000136--[[Select something that produces (air,water,electricity,other).--]],
      3980--[[Buildings--]],
      default_icon2
    )
    return
  end
  local id = sel.encyclopedia_id
  local name = T(sel.display_name)

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
    DefaultSetting = sel[Concat("base_",ProdType,"_production")] / r
  end

  local ItemList = {
    {text = Concat(S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
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
  if not ChoGGi.UserSettings.BuildingSettings[id] then
    ChoGGi.UserSettings.BuildingSettings[id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[id]
  if setting and setting.production then
    hint = tostring(setting.production / r)
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      local amount = value * r

      --setting we use to actually update prod
      if value == DefaultSetting then
        --remove setting as we reset building type to default (we don't want to call it when we place a new building if nothing is going to be changed)
        ChoGGi.UserSettings.BuildingSettings[id].production = nil
      else
        --update/create saved setting
        ChoGGi.UserSettings.BuildingSettings[id].production = amount
      end

      --all this just to update the displayed amount :)
      local function SetProd(Label)
        local tab = UICity.labels[Label] or ""
        for i = 1, #tab do
          if tab[i].encyclopedia_id == id then
            tab[i][ProdType]:SetProduction(amount)
          end
        end
      end
      if ProdType == "electricity" then
        --electricity
        SetProd("Power")
      elseif ProdType == "water" or ProdType == "air" then
        --water/air
        SetProd("Life-Support")
      else --other prod

        local function SetProdOther(Label)
          local tab = UICity.labels[Label] or ""
          for i = 1, #tab do
            if tab[i].encyclopedia_id == id then
              tab[i]:GetProducerObj().production_per_day = amount
              tab[i]:GetProducerObj():Produce(amount)
            end
          end
        end
        --extractors/factories
        SetProdOther("Production")
        --moholemine/theexvacator
        SetProdOther("Wonders")
        --farms
        if id:find("Farm") then
          SetProdOther("BaseFarm")
          SetProdOther("FungalFarm")
        end
      end

    end

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      S[302535920000137--[[%s production is now: %s--]]]:format(RetName(sel),choice[1].text),
      3980--[[Buildings--]],
      default_icon2
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",name," ",S[302535920000139--[[Production Amount--]]]),
    hint = Concat(S[302535920000140--[[Current production--]]],": ",hint),
    skip_sort = true,
  }
end

function ChoGGi.MenuFuncs.SetFullyAutomatedBuildings()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or sel and not sel:IsKindOf("Workplace") then
    MsgPopup(
      302535920000141--[[Select a building with workers.--]],
      3980--[[Buildings--]],
      default_icon2
    )
    return
  end
  local id = sel.encyclopedia_id
  local name = T(sel.display_name)

  local ItemList = {
    {text = Concat(S[302535920000142--[[Disable--]]]),value = "disable"},
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

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local function SetPerf(a,b)
      if choice[1].check then
        sel.max_workers = a
        sel.automation = b
        sel.auto_performance = value
        ChoGGi.CodeFuncs.ToggleWorking(sel)
      else
        local tab = UICity.labels.BuildingNoDomes or ""
        for i = 1, #tab do
          if tab[i].base_max_workers then
            tab[i].max_workers = a
            tab[i].automation = b
            tab[i].auto_performance = value
            ChoGGi.CodeFuncs.ToggleWorking(tab[i])
         end
        end
      end

      ChoGGi.UserSettings.BuildingSettings[id].performance = value
    end

    if value == "disable" then
      SetPerf()
    elseif type(value) == "number" then
      SetPerf(0,1)
    end

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      S[302535920000143--[["%s
I presume the PM's in favour of the scheme because it'll reduce unemployment."--]]]:format(choice[1].text),
      3980--[[Buildings--]],
      default_icon,
      true
    )
  end

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[id] then
    ChoGGi.UserSettings.BuildingSettings[id] = {}
  end

  local hint = "none"
  local setting = ChoGGi.UserSettings.BuildingSettings[id]
  if setting and setting.performance then
    hint = tostring(setting.performance)
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(name,": ",S[302535920000144--[[Automated Performance--]]]),
    hint = S[302535920000145--[["Sets performance of all automated buildings of this type
Current: %s"--]]]:format(hint),
    check1 = 302535920000769--[[Selected--]],
    check1_hint = Concat(S[302535920000147--[[Only apply to selected object instead of all--]]]," ",name),
    skip_sort = true,
  }
end

--used to add or remove traits from schools/sanitariums
function ChoGGi.MenuFuncs.BuildingsSetAll_Traits(Building,traits,bool)
  local objs = UICity.labels[Building] or ""
  for i = 1, #objs do
    local obj = objs[i]
    for j = 1,#traits do
      if bool == true then
        obj:SetTrait(j,nil)
      else
        obj:SetTrait(j,traits[j])
      end
    end
  end
end

function ChoGGi.MenuFuncs.SchoolTrainAll_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.SchoolTrainAll then
    ChoGGi.UserSettings.SchoolTrainAll = nil
    ChoGGi.MenuFuncs.BuildingsSetAll_Traits("School",ChoGGi.Tables.PositiveTraits,true)
  else
    ChoGGi.UserSettings.SchoolTrainAll = true
    ChoGGi.MenuFuncs.BuildingsSetAll_Traits("School",ChoGGi.Tables.PositiveTraits)
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000148--[["%s:
You keep your work station so clean, Jerome.
It's next to godliness. Isn't that what they say?"--]]]:format(ChoGGi.UserSettings.SchoolTrainAll),
    5247--[[School--]],
    default_icon,
    true
  )
end

function ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.SanatoriumCureAll then
    ChoGGi.UserSettings.SanatoriumCureAll = nil
    ChoGGi.MenuFuncs.BuildingsSetAll_Traits("Sanatorium",ChoGGi.Tables.NegativeTraits,true)
  else
    ChoGGi.UserSettings.SanatoriumCureAll = true
    ChoGGi.MenuFuncs.BuildingsSetAll_Traits("Sanatorium",ChoGGi.Tables.NegativeTraits)
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000149--[[%s:
There's more vodka in this piss than there is piss.--]]]:format(ChoGGi.UserSettings.SanatoriumCureAll),
    3540--[[Sanatorium--]],
    default_icon,
    true
  )
end

function ChoGGi.MenuFuncs.ShowAllTraits_Toggle()
  local ChoGGi = ChoGGi
  local g_SchoolTraits = g_SchoolTraits

  if #g_SchoolTraits == 18 then
    g_SchoolTraits = ChoGGi.Tables.SchoolTraits
    g_SanatoriumTraits = ChoGGi.Tables.SanatoriumTraits
  else
    g_SchoolTraits = ChoGGi.Tables.PositiveTraits
    g_SanatoriumTraits = ChoGGi.Tables.NegativeTraits
  end

  MsgPopup(
    S[302535920000150--[[%s: Good for what ails you--]]]:format(#g_SchoolTraits),
    235--[[Traits--]],
    "UI/Icons/Upgrades/factory_ai_04.tga"
  )
end

function ChoGGi.MenuFuncs.SanatoriumSchoolShowAll()
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes
  ChoGGi.UserSettings.SanatoriumSchoolShowAll = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.SanatoriumSchoolShowAll)

	g_Classes.Sanatorium.max_traits = ChoGGi.ComFuncs.ValueRetOpp(g_Classes.Sanatorium.max_traits,3,#ChoGGi.Tables.NegativeTraits)
	g_Classes.School.max_traits = ChoGGi.ComFuncs.ValueRetOpp(g_Classes.School.max_traits,3,#ChoGGi.Tables.PositiveTraits)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000150--[[%s: Good for what ails you--]]]:format(ChoGGi.UserSettings.SanatoriumSchoolShowAll),
    3980--[[Buildings--]],
    "UI/Icons/Upgrades/superfungus_03.tga"
  )
end

function ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.InsideBuildingsNoMaintenance = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.InsideBuildingsNoMaintenance)

  local tab = UICity.labels.InsideBuildings or ""
  for i = 1, #tab do
    if tab[i].base_maintenance_build_up_per_hr then

      if ChoGGi.UserSettings.InsideBuildingsNoMaintenance then
        tab[i].ChoGGi_InsideBuildingsNoMaintenance = true
        tab[i].maintenance_build_up_per_hr = -10000
      else
        if not tab[i].ChoGGi_RemoveMaintenanceBuildUp then
          tab[i].maintenance_build_up_per_hr = nil
        end
        tab[i].ChoGGi_InsideBuildingsNoMaintenance = nil
      end

    end
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000151--[[%s: The spice must flow!--]]]:format(ChoGGi.UserSettings.InsideBuildingsNoMaintenance),
    3980--[[Buildings--]],
    "UI/Icons/Sections/dust.tga"
  )
end

function ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.RemoveMaintenanceBuildUp = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.RemoveMaintenanceBuildUp)

  local tab = UICity.labels.Building or ""
  for i = 1, #tab do
    if tab[i].base_maintenance_build_up_per_hr then
      if ChoGGi.UserSettings.RemoveMaintenanceBuildUp then
        tab[i].ChoGGi_RemoveMaintenanceBuildUp = true
        tab[i].maintenance_build_up_per_hr = -10000
      elseif not tab[i].ChoGGi_InsideBuildingsNoMaintenance then
        tab[i].ChoGGi_RemoveMaintenanceBuildUp = nil
        tab[i].maintenance_build_up_per_hr = nil
      end
    end
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000151--[[%s: The spice must flow!--]]]:format(ChoGGi.UserSettings.RemoveMaintenanceBuildUp),
    3980--[[Buildings--]],
    "UI/Icons/Sections/dust.tga"
  )
end

function ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle()
  local ChoGGi = ChoGGi
  local const = const
  const.MoistureVaporatorRange = ChoGGi.ComFuncs.NumRetBool(const.MoistureVaporatorRange,0,ChoGGi.Consts.MoistureVaporatorRange)
  const.MoistureVaporatorPenaltyPercent = ChoGGi.ComFuncs.NumRetBool(const.MoistureVaporatorPenaltyPercent,0,ChoGGi.Consts.MoistureVaporatorPenaltyPercent)
  ChoGGi.ComFuncs.SetSavedSetting("MoistureVaporatorRange",const.MoistureVaporatorRange)
  ChoGGi.ComFuncs.SetSavedSetting("MoistureVaporatorRange",const.MoistureVaporatorPenaltyPercent)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000152--[["%s: Pussy, pussy, pussy! Come on in Pussy lovers! Here at the Titty Twister we’re slashing pussy in half! Give us an offer on our vast selection of pussy! This is a pussy blow out!
Alright, we got white pussy, black pussy, spanish pussy, yellow pussy. We got hot pussy, cold pussy. We got wet pussy. We got smelly pussy. We got hairy pussy, bloody pussy. We got snapping pussy. We got silk pussy, velvet pussy, naugahyde pussy. We even got horse pussy, dog pussy, chicken pussy.
C'mon, you want pussy, come on in Pussy Lovers! If we don’t got it, you don't want it! Come on in Pussy lovers!Attention pussy shoppers!
Take advantage of our penny pussy sale! If you buy one piece of pussy at the regular price, you get another piece of pussy of equal or lesser value for only a penny!
Try and beat pussy for a penny! If you can find cheaper pussy anywhere, fuck it!"--]]]:format(ChoGGi.UserSettings.MoistureVaporatorRange),
    3980--[[Buildings--]],
    "UI/Icons/Upgrades/zero_space_04.tga",
    true
  )
end

function ChoGGi.MenuFuncs.CropFailThreshold_Toggle()
  local ChoGGi = ChoGGi
  local Consts = Consts
  Consts.CropFailThreshold = ChoGGi.ComFuncs.NumRetBool(Consts.CropFailThreshold,0,ChoGGi.Consts.CropFailThreshold)
  ChoGGi.ComFuncs.SetSavedSetting("CropFailThreshold",Consts.CropFailThreshold)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000153--[["%s:
So, er, we the crew of the Eagle 5, if we do encounter, make first contact with alien beings,
it is a friendship greeting from the children of our small but great planet of Potatoho."--]]]:format(ChoGGi.UserSettings.CropFailThreshold),
    3980--[[Buildings--]],
    "UI/Icons/Sections/Food_1.tga",
    true
  )
end

function ChoGGi.MenuFuncs.CheapConstruction_Toggle()
  local ChoGGi = ChoGGi
  local Consts = Consts
  ChoGGi.ComFuncs.SetConstsG("Metals_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Metals_cost_modifier,-100,ChoGGi.Consts.Metals_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Metals_dome_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Metals_dome_cost_modifier,-100,ChoGGi.Consts.Metals_dome_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("PreciousMetals_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.PreciousMetals_cost_modifier,-100,ChoGGi.Consts.PreciousMetals_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("PreciousMetals_dome_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.PreciousMetals_dome_cost_modifier,-100,ChoGGi.Consts.PreciousMetals_dome_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Concrete_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Concrete_cost_modifier,-100,ChoGGi.Consts.Concrete_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Concrete_dome_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Concrete_dome_cost_modifier,-100,ChoGGi.Consts.Concrete_dome_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Polymers_dome_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Polymers_dome_cost_modifier,-100,ChoGGi.Consts.Polymers_dome_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Polymers_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Polymers_cost_modifier,-100,ChoGGi.Consts.Polymers_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Electronics_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Electronics_cost_modifier,-100,ChoGGi.Consts.Electronics_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("Electronics_dome_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.Electronics_dome_cost_modifier,-100,ChoGGi.Consts.Electronics_dome_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("MachineParts_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.MachineParts_cost_modifier,-100,ChoGGi.Consts.MachineParts_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("MachineParts_dome_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.MachineParts_dome_cost_modifier,-100,ChoGGi.Consts.MachineParts_dome_cost_modifier))
  ChoGGi.ComFuncs.SetConstsG("rebuild_cost_modifier",ChoGGi.ComFuncs.ValueRetOpp(Consts.rebuild_cost_modifier,-100,ChoGGi.Consts.rebuild_cost_modifier))

  ChoGGi.ComFuncs.SetSavedSetting("Metals_cost_modifier",Consts.Metals_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Metals_dome_cost_modifier",Consts.Metals_dome_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("PreciousMetals_cost_modifier",Consts.PreciousMetals_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("PreciousMetals_dome_cost_modifier",Consts.PreciousMetals_dome_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Concrete_cost_modifier",Consts.Concrete_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Concrete_dome_cost_modifier",Consts.Concrete_dome_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Polymers_cost_modifier",Consts.Polymers_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Polymers_dome_cost_modifier",Consts.Polymers_dome_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Electronics_cost_modifier",Consts.Electronics_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("Electronics_dome_cost_modifier",Consts.Electronics_dome_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("MachineParts_cost_modifier",Consts.MachineParts_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("MachineParts_dome_cost_modifier",Consts.MachineParts_dome_cost_modifier)
  ChoGGi.ComFuncs.SetSavedSetting("rebuild_cost_modifier",Consts.rebuild_cost_modifier)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000154--[[%s:
Your home will not be a hut on some swampy outback planet your home will be the entire universe.--]]]:format(ChoGGi.UserSettings.Metals_cost_modifier),
    3980--[[Buildings--]],
    "UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("CrimeEventSabotageBuildingsCount",ChoGGi.ComFuncs.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount))
  ChoGGi.ComFuncs.SetConstsG("CrimeEventDestroyedBuildingsCount",ChoGGi.ComFuncs.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount))
  ChoGGi.ComFuncs.SetSavedSetting("CrimeEventSabotageBuildingsCount",Consts.CrimeEventSabotageBuildingsCount)
  ChoGGi.ComFuncs.SetSavedSetting("CrimeEventDestroyedBuildingsCount",Consts.CrimeEventDestroyedBuildingsCount)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000155--[[%s:
We were all feeling a bit shagged and fagged and fashed,
it having been an evening of some small energy expenditure, O my brothers.
So we got rid of the auto and stopped off at the Korova for a nightcap.--]]]:format(ChoGGi.UserSettings.CrimeEventSabotageBuildingsCount),
    3980--[[Buildings--]],
    "UI/Icons/Notifications/fractured_dome.tga",
    true
  )
end

function ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle()
  local ChoGGi = ChoGGi
  local const = const
  ChoGGi.UserSettings.BreakChanceCablePipe = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.BreakChanceCablePipe)

  const.BreakChanceCable = ChoGGi.ComFuncs.ValueRetOpp(const.BreakChanceCable,600,10000000)
  const.BreakChancePipe = ChoGGi.ComFuncs.ValueRetOpp(const.BreakChancePipe,600,10000000)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000156--[[%s: Aliens? We gotta deal with aliens too?--]]]:format(ChoGGi.UserSettings.BreakChanceCablePipe),
    302535920000157--[[Cables & Pipes--]],
    "UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("InstantCables",ChoGGi.ComFuncs.ToggleBoolNum(Consts.InstantCables))
  ChoGGi.ComFuncs.SetConstsG("InstantPipes",ChoGGi.ComFuncs.ToggleBoolNum(Consts.InstantPipes))
  ChoGGi.ComFuncs.SetSavedSetting("InstantCables",Consts.InstantCables)
  ChoGGi.ComFuncs.SetSavedSetting("InstantPipes",Consts.InstantPipes)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000156--[[%s: Aliens? We gotta deal with aliens too?--]]]:format(ChoGGi.UserSettings.InstantCables),
    302535920000157--[[Cables & Pipes--]],
    "UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.RemoveBuildingLimits = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.RemoveBuildingLimits)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000158--[[%s: No no I said over there.--]]]:format(ChoGGi.UserSettings.RemoveBuildingLimits),
    3980--[[Buildings--]],
    "UI/Icons/Upgrades/zero_space_04.tga"
  )
end

function ChoGGi.MenuFuncs.Building_wonder_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.Building_wonder then
    ChoGGi.UserSettings.Building_wonder = nil
    --go through and reset to defaults?
  else
    ChoGGi.UserSettings.Building_wonder = true
    local tab = DataInstances.BuildingTemplate or ""
    for i = 1, #tab do
      tab[i].wonder = false
    end
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000159--[[%s: Unlimited Wonders
(restart to set disabled)--]]]:format(ChoGGi.UserSettings.Building_wonder),
    3980--[[Buildings--]],
    default_icon3
  )
end

function ChoGGi.MenuFuncs.Building_dome_spot_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.Building_dome_spot = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.Building_dome_spot)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000160--[[%s: Freedom for spires!
(restart to set disabled)--]]]:format(ChoGGi.UserSettings.Building_dome_spot),
    3980--[[Buildings--]],
    default_icon3
  )
end

function ChoGGi.MenuFuncs.Building_instant_build_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.Building_instant_build = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.Building_instant_build)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000161--[[%s: Building Instant Build
(restart to set disabled)--]]]:format(ChoGGi.UserSettings.Building_instant_build),
    3980--[[Buildings--]],
    default_icon3
  )
end

function ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.Building_hide_from_build_menu = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.Building_hide_from_build_menu)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    S[302535920000162--[[%s: Hidden Buildings
(restart to set disabled)--]]]:format(ChoGGi.UserSettings.Building_hide_from_build_menu),
    3980--[[Buildings--]],
    default_icon3
  )
end

function ChoGGi.MenuFuncs.SetUIRangeBuildingRadius(id,msgpopup)
  local ChoGGi = ChoGGi
  local DefaultSetting = _G[id]:GetDefaultPropertyValue("UIRange")
  local ItemList = {
    {text = Concat(S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 10,value = 10},
    {text = 15,value = 15},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }
  local UserSettings = ChoGGi.UserSettings

  if not UserSettings.BuildingSettings[id] then
    UserSettings.BuildingSettings[id] = {}
  end

  local hint = DefaultSetting
  if UserSettings.BuildingSettings[id].uirange then
    hint = UserSettings.BuildingSettings[id].uirange
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then

      if value == DefaultSetting then
        UserSettings.BuildingSettings[id].uirange = nil
      else
        UserSettings.BuildingSettings[id].uirange = value
      end

      --find a better way to update radius...
      local sel = SelectedObj
      CreateRealTimeThread(function()
        local objs = UICity.labels[id] or ""
        for i = 1, #objs do
          objs[i]:SetUIRange(value)
          SelectObj(objs[i])
          Sleep(1)
        end
        SelectObj(sel)
      end)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        Concat(choice[1].text,":\n",Strings[msgpopup]),
        id,
        "UI/Icons/Upgrades/polymer_blades_04.tga",
        true
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",id," ",S[302535920000163--[[Radius--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
    skip_sort = true,
  }
end
