-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
local UsualIcon = "UI/Icons/Upgrades/home_collective_04.tga"
local UsualIcon2 = "UI/Icons/Sections/storage.tga"
local UsualIcon3 = "UI/Icons/IPButtons/assign_residence.tga"

local type,tostring,pairs,pcall = type,tostring,pairs,pcall

local Sleep = Sleep
local CreateRealTimeThread = CreateRealTimeThread
local SelectObj = SelectObj
local UnlockBuilding = UnlockBuilding
local GetObjects = GetObjects
local GetBuildingTechsStatus = GetBuildingTechsStatus

local g_Classes = g_Classes

function ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery()
  --make a list
  local ChoGGi = ChoGGi
  local DefaultSetting = 5
  local UserSettings = ChoGGi.UserSettings
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
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

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      value = value * r

      if value == DefaultSetting * r then
        UserSettings.ServiceWorkplaceFoodStorage = nil
      else
        UserSettings.ServiceWorkplaceFoodStorage = value
      end

      local function SetStor(Class)
        local objs = GetObjects({class = Class}) or empty_table
        for i = 1, #objs do
          objs[i].consumption_stored_resources = value
          objs[i].consumption_max_storage = value
        end
      end
      SetStor("Diner")
      SetStor("Grocery")

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(Concat(T(8830--[[Food Storage--]]),": ",choice[1].text),
        T(1022--[[Food--]])
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000105--[[Set Food Storage--]]),
    hint = Concat(T(302535920000106--[[Current--]]),": ",hint),
  })
end

function ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.AlwaysDustyBuildings = not ChoGGi.UserSettings.AlwaysDustyBuildings
  if not ChoGGi.UserSettings.AlwaysDustyBuildings then
    ChoGGi.UserSettings.AlwaysDustyBuildings = nil
    --dust clean up
    local objs = GetObjects({class = "Building"}) or empty_table
    for i = 1, #objs do
      objs[i].ChoGGi_AlwaysDust = nil
    end
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.AlwaysDustyBuildings),"\n",T(302535920000107--[[I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration.\nI will face my fear. I will permit it to pass over me and through me.\nAnd when it has gone past I will turn the inner eye to see its path.\nWhere the fear has gone there will be nothing. Only I will remain.--]])),
    T(3980--[[Buildings--]]),nil,true
  )
end

function ChoGGi.MenuFuncs.SetProtectionRadius()
  local ChoGGi = ChoGGi
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel or not sel.protect_range then
    ChoGGi.ComFuncs.MsgPopup(T(302535920000108,"Select something with a protect_range (MDSLaser/DefenceTower)."),
      T(302535920000109--[[Protect--]]),UsualIcon
    )
    return
  end
  local id = sel.encyclopedia_id
  local DefaultSetting = _G[id]:GetDefaultPropertyValue("protect_range")
  local ItemList = {
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
    {text = 40,value = 40},
    {text = 80,value = 80},
    {text = 160,value = 160},
    {text = 320,value = 320,hint = T(302535920000111--[[Cover the entire map from the centre.--]])},
    {text = 640,value = 640,hint = T(302535920000112--[[Cover the entire map from a corner.--]])},
  }

  if not ChoGGi.UserSettings.BuildingSettings[id] then
    ChoGGi.UserSettings.BuildingSettings[id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[id]
  if setting and setting.protect_range then
    hint = tostring(setting.protect_range)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      local tab = UICity.labels[id] or empty_table
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
      ChoGGi.ComFuncs.MsgPopup(Concat(id," ",T(302535920000113--[[range is now--]]),"",choice[1].text),
        T(302535920000109--[[Protect--]]),UsualIcon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000114--[[Set Protection Radius--]]),
    hint = Concat(T(302535920000106--[[Current--]]),": ",hint,"\n\n",T(302535920000115--[[Toggle selection to update visible hex grid.--]])),
  })
end

function ChoGGi.MenuFuncs.UnlockLockedBuildings()
  local ChoGGi = ChoGGi
  local data = DataInstances.BuildingTemplate
  local ItemList = {}
  for Key,_ in pairs(data) do
    if type(Key) == "string" and not GetBuildingTechsStatus(Key) then
      ItemList[#ItemList+1] = {
        text = T(data[Key].display_name),
        value = Key
      }
    end
  end

  local CallBackFunc = function(choice)
    for i = 1, #choice do
      pcall(function()
        UnlockBuilding(choice[i].value)
      end)
    end
    ChoGGi.CodeFuncs.BuildMenu_Toggle()
    ChoGGi.ComFuncs.MsgPopup(Concat(T(302535920000116--[[Buildings unlocked--]]),": ",#choice),
      T(8690--[[Protect--]]),UsualIcon
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000117--[[Unlock Buildings--]]),
    hint = T(302535920000118--[[Pick the buildings you want to unlock (use Ctrl/Shift for multiple).--]]),
    multisel = true,
  })
end

function ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("PipesPillarSpacing",ChoGGi.ComFuncs.ValueRetOpp(Consts.PipesPillarSpacing,1000,ChoGGi.Consts.PipesPillarSpacing))
  ChoGGi.ComFuncs.SetSavedSetting("PipesPillarSpacing",Consts.PipesPillarSpacing)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.PipesPillarSpacing),T(302535920000119,": Is that a rocket in your pocket?")),
    T(3980--[[Buildings--]])
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.UnlimitedConnectionLength),T(302535920000119,": Is that a rocket in your pocket?")),
    T(3980--[[Buildings--]])
  )
end

function ChoGGi.MenuFuncs.BuildingPower_Toggle()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or not sel.electricity_consumption then
    ChoGGi.ComFuncs.MsgPopup(T(302535920000120--[[You need to select something that uses electricity.--]]),
          T(3980--[[Buildings--]]),UsualIcon
    )
    return
  end
  local id = sel.encyclopedia_id
  local UserSettings = ChoGGi.UserSettings

  if not UserSettings.BuildingSettings[id] then
    UserSettings.BuildingSettings[id] = {}
  end

  local setting = UserSettings.BuildingSettings[id]
  local amount
  if setting.nopower then
    setting.nopower = nil
    amount = DataInstances.BuildingTemplate[id].electricity_consumption
  else
    setting.nopower = true
    amount = 0
  end

  local tab = UICity.labels[id] or empty_table
  for i = 1, #tab do
    local mods = tab[i].modifications
    if mods and mods.electricity_consumption then
      local mod = tab[i].modifications.electricity_consumption
      if mod and mod[1] then
        mod = mod[1]
      end

      if amount == 0 then
        tab[i].ChoGGi_mod_electricity_consumption = {
          amount = mod.amount,
          percent = mod.percent
        }
        if mod:IsKindOf("ObjectModifier") then
          mod:Change(0,0)
        end
      else
        local orig = tab[i].ChoGGi_mod_electricity_consumption
        if mod:IsKindOf("ObjectModifier") then
          mod:Change(orig.amount,orig.percent)
        else
          mod.amount = orig.amount
          mod.percent = orig.percent
        end
        tab[i].ChoGGi_mod_electricity_consumption = nil
      end

    end
    tab[i]:SetBase("electricity_consumption", amount)
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(id," ",T(302535920000121--[[power consumption--]]),": ",amount),
    T(3980--[[Buildings--]])
  )
end

function ChoGGi.MenuFuncs.SetMaxChangeOrDischarge()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or (not sel.base_air_capacity and not sel.base_water_capacity and not sel.base_capacity) then
    ChoGGi.ComFuncs.MsgPopup(T(302535920000122--[[You need to select something that has capacity (air/water/elec).--]]),
      T(3980--[[Buildings--]]),UsualIcon
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
    {text = Concat(" ",T(302535920000123--[[Defaults--]])),value = 3.1415926535,hint = Concat(T(302535920000124--[[Charge--]]),": ",DefaultSettingC," / ",T(302535920000125--[[Discharge--]]),": ",DefaultSettingD)},
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

  local hint = Concat(T(302535920000124--[[Charge--]]),": ",DefaultSettingC," / ",T(302535920000125--[[Discharge--]]) ": ",DefaultSettingD)
  local setting = ChoGGi.UserSettings.BuildingSettings[id]
  if setting then
    if setting.charge and setting.discharge then
      hint = Concat(T(302535920000124--[[Charge--]]),": ",tostring(setting.charge / r)," / ",T(302535920000125--[[Discharge--]]) ": ",tostring(setting.discharge / r))
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
      ChoGGi.ComFuncs.MsgPopup(T(302535920000126--[[Pick a checkbox or two next time...--]]),T(302535920000127--[[Rate--]]),UsualIcon2)
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
        local tab = UICity.labels.Power or empty_table
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
        local tab = UICity.labels["Life-Support"] or empty_table
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
      ChoGGi.ComFuncs.MsgPopup(Concat(id," ",T(302535920000128--[[rate is now--]])," ",choice[1].text),
        T(302535920000127--[[Rate--]]),UsualIcon2
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(T(302535920000129--[[Set--]])," ",name," ",T(302535920000130--[[Dis/Charge Rates--]])),
    hint = Concat(T(302535920000131--[[Current rate--]]),": ",hint),
    check1 = T(302535920000124--[[Charge--]]),
    check1_hint = T(302535920000132--[[Change charge rate--]]),
    check2 = T(302535920000125--[[Discharge--]]),
    check2_hint = T(302535920000133--[[Change discharge rate--]]),
  })
end

function ChoGGi.MenuFuncs.UseLastOrientation_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.UseLastOrientation = not ChoGGi.UserSettings.UseLastOrientation

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.UseLastOrientation)," ",T(302535920000134--[[Building Orientation--]])),
    T(3980--[[Buildings--]])
  )
end

function ChoGGi.MenuFuncs.FarmShiftsAllOn()
  local ChoGGi = ChoGGi
  local tab = UICity.labels.BaseFarm or empty_table
  for i = 1, #tab do
    tab[i].closed_shifts[1] = false
    tab[i].closed_shifts[2] = false
    tab[i].closed_shifts[3] = false
  end
  --BaseFarm doesn't include FungalFarm...
  tab = UICity.labels.FungalFarm or empty_table
  for i = 1, #tab do
    tab[i].closed_shifts[1] = false
    tab[i].closed_shifts[2] = false
    tab[i].closed_shifts[3] = false
  end

  ChoGGi.ComFuncs.MsgPopup(T(302535920000135--[[Well, I been working in a coal mine\nGoing down, down\nWorking in a coal mine\nWhew, about to slip down--]]),
    T(5068--[[Farms--]]),"UI/Icons/Sections/Food_2.tga",true
  )
end

function ChoGGi.MenuFuncs.SetProductionAmount()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or (not sel.base_air_production and not sel.base_water_production and not sel.base_electricity_production and not sel.producers) then
    ChoGGi.ComFuncs.MsgPopup(T(302535920000136--[[Select something that produces (air,water,electricity,other).--]]),
      T(3980--[[Buildings--]]),UsualIcon2
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
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
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

  local CallBackFunc = function(choice)
    local value = choice[1].value
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
        local tab = UICity.labels[Label] or empty_table
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
          local tab = UICity.labels[Label] or empty_table
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
    ChoGGi.ComFuncs.MsgPopup(Concat(id," ",T(302535920000137--[[Production is now--]])," ",choice[1].text),
      T(3980--[[Buildings--]]),UsualIcon2
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(T(302535920000129--[[Set--]])," ",name," ",T(302535920000139--[[Production Amount--]])),
    hint = Concat(T(302535920000140--[[Current production--]]),": ",hint),
  })
end

function ChoGGi.MenuFuncs.SetFullyAutomatedBuildings()
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  if not sel or sel and not sel:IsKindOf("Workplace") then
    ChoGGi.ComFuncs.MsgPopup(T(302535920000141--[[Select a building with workers.--]]),
      T(3980--[[Buildings--]]),UsualIcon2
    )
    return
  end
  local id = sel.encyclopedia_id
  local name = T(sel.display_name)

  local ItemList = {
    {text = Concat(" ",T(302535920000142--[[Disable--]])),value = "disable"},
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
    local function SetPerf(a,b)
      if choice[1].check then
        sel.max_workers = a
        sel.automation = b
        sel.auto_performance = value
        ChoGGi.CodeFuncs.ToggleWorking(sel)
      else
        local tab = UICity.labels.BuildingNoDomes or empty_table
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

    if type(value) == "number" then
      SetPerf(0,1)
    elseif value == "disable" then
      SetPerf()
    end

    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.ComFuncs.MsgPopup(Concat(choice[1].text,"\n",T(302535920000143--[[\nI presume the PM's in favour of the scheme because it'll reduce unemployment.--]])),
      T(3980--[[Buildings--]]),UsualIcon,true
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

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(name,": ",T(302535920000144--[[Automated Performance--]])),
    hint = Concat(T(302535920000145--[[Sets performance of all automated buildings\nCurrent--]]),": ",hint),
    check1 = T(302535920000769--[[Selected--]]),
    check1_hint = Concat(T(302535920000147--[[Only apply to selected object instead of all--]])," ",name),
  })
end

--used to add or remove traits from schools/sanitariums
function ChoGGi.MenuFuncs.BuildingsSetAll_Traits(Building,Traits,Bool)
  local Buildings = UICity.labels[Building] or empty_table
  for i = 1, #Buildings do
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.SchoolTrainAll),"\n",T(302535920000148,"You keep your work station so clean, Jerome.\nIt's next to godliness. Isn't that what they say?")),
    T(5247--[[School--]]),UsualIcon,true
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.SanatoriumCureAll),"\n",T(302535920000149--[[There's more vodka in this piss than there is piss.--]])),
    T(3540--[[Sanatorium--]]),UsualIcon,true
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

  ChoGGi.ComFuncs.MsgPopup(Concat(#g_SchoolTraits,T(302535920000150--[[: Good for what ails you--]])),
    T(235--[[Traits--]]),"UI/Icons/Upgrades/factory_ai_04.tga"
  )
end

function ChoGGi.MenuFuncs.SanatoriumSchoolShowAll()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.SanatoriumSchoolShowAll = not ChoGGi.UserSettings.SanatoriumSchoolShowAll

	g_Classes.Sanatorium.max_traits = ChoGGi.ComFuncs.ValueRetOpp(g_Classes.Sanatorium.max_traits,3,#ChoGGi.Tables.NegativeTraits)
	g_Classes.School.max_traits = ChoGGi.ComFuncs.ValueRetOpp(g_Classes.School.max_traits,3,#ChoGGi.Tables.PositiveTraits)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.SanatoriumSchoolShowAll),T(302535920000150--[[ Good for what ails you--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Upgrades/superfungus_03.tga"
  )
end

function ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.InsideBuildingsNoMaintenance = not ChoGGi.UserSettings.InsideBuildingsNoMaintenance

  local tab = UICity.labels.InsideBuildings or empty_table
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.InsideBuildingsNoMaintenance),T(302535920000151--[[: The spice must flow!--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Sections/dust.tga"
  )
end

function ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.RemoveMaintenanceBuildUp = not ChoGGi.UserSettings.RemoveMaintenanceBuildUp
  local tab = UICity.labels.Building or empty_table
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.RemoveMaintenanceBuildUp),T(302535920000151--[[: The spice must flow!--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Sections/dust.tga"
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.MoistureVaporatorRange),T(302535920000152--[[: All right, pussy, pussy, pussy! Come on in pussy lovers! Here at the Titty Twister we're slashing pussy in half! Give us an offer on our vast selection of pussy, this is a pussy blow out! All right, we got white pussy, black pussy, Spanish pussy, yellow pussy, we got hot pussy, cold pussy, we got wet pussy, we got... smelly pussy, we got hairy pussy, bloody pussy, we got snappin' pussy, we got silk pussy, velvet pussy, Naugahyde pussy, we even got horse pussy, dog pussy, chicken pussy! Come on, you want pussy, come on in, pussy lovers! If we don't got it, you don't want it! Come on in, pussy lovers!--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Upgrades/zero_space_04.tga",true
  )
end

function ChoGGi.MenuFuncs.CropFailThreshold_Toggle()
  local ChoGGi = ChoGGi
  local Consts = Consts
  Consts.CropFailThreshold = ChoGGi.ComFuncs.NumRetBool(Consts.CropFailThreshold,0,ChoGGi.Consts.CropFailThreshold)
  ChoGGi.ComFuncs.SetSavedSetting("CropFailThreshold",Consts.CropFailThreshold)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.CropFailThreshold),"\n",T(302535920000153,"So, er, we the crew of the Eagle 5, if we do encounter, make first contact with alien beings, it is a friendship greeting from the children of our small but great planet of Potatoho.")),
    T(3980--[[Buildings--]]),"UI/Icons/Sections/Food_1.tga",true
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
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.Metals_cost_modifier),T(302535920000154--[[: Get yourself a beautiful showhome (even if it falls apart after you move in)--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("CrimeEventSabotageBuildingsCount",ChoGGi.ComFuncs.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount))
  ChoGGi.ComFuncs.SetConstsG("CrimeEventDestroyedBuildingsCount",ChoGGi.ComFuncs.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount))

  ChoGGi.ComFuncs.SetSavedSetting("CrimeEventSabotageBuildingsCount",Consts.CrimeEventSabotageBuildingsCount)
  ChoGGi.ComFuncs.SetSavedSetting("CrimeEventDestroyedBuildingsCount",Consts.CrimeEventDestroyedBuildingsCount)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.CrimeEventSabotageBuildingsCount),"\n",T(302535920000155--[[We were all feeling a bit shagged and fagged and fashed, it having been an evening of some small energy expenditure, O my brothers. So we got rid of the auto and stopped off at the Korova for a nightcap.--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Notifications/fractured_dome.tga",true
  )
end

function ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle()
  local ChoGGi = ChoGGi
  local const = const
  ChoGGi.UserSettings.BreakChanceCablePipe = not ChoGGi.UserSettings.BreakChanceCablePipe

  const.BreakChanceCable = ChoGGi.ComFuncs.ValueRetOpp(const.BreakChanceCable,600,10000000)
  const.BreakChancePipe = ChoGGi.ComFuncs.ValueRetOpp(const.BreakChancePipe,600,10000000)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.BreakChanceCablePipe)," ",T(302535920000156,"Aliens? We gotta deal with aliens too?")),
    T(302535920000157,"Cables & Pipes"),"UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("InstantCables",ChoGGi.ComFuncs.ToggleBoolNum(Consts.InstantCables))
  ChoGGi.ComFuncs.SetConstsG("InstantPipes",ChoGGi.ComFuncs.ToggleBoolNum(Consts.InstantPipes))

  ChoGGi.ComFuncs.SetSavedSetting("InstantCables",Consts.InstantCables)
  ChoGGi.ComFuncs.SetSavedSetting("InstantPipes",Consts.InstantPipes)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.InstantCables),T(302535920000156,": Aliens? We gotta deal with aliens too?")),
    T(302535920000157,"Cables & Pipes"),"UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.RemoveBuildingLimits = not ChoGGi.UserSettings.RemoveBuildingLimits

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.RemoveBuildingLimits)," ",T(302535920000158--[[: No no I said over there.--]])),
    T(3980--[[Buildings--]]),"UI/Icons/Upgrades/zero_space_04.tga"
  )
end

function ChoGGi.MenuFuncs.Building_wonder_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.Building_wonder then
    ChoGGi.UserSettings.Building_wonder = nil
    --go through and reset to defaults?
  else
    ChoGGi.UserSettings.Building_wonder = true
    local tab = DataInstances.BuildingTemplate or empty_table
    for i = 1, #tab do
      tab[i].wonder = false
    end
  end


  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.Building_wonder),T(302535920000159--[[: Unlimited Wonders\n(restart to set disabled)--]])),
    T(3980--[[Buildings--]]),UsualIcon3
  )
end

function ChoGGi.MenuFuncs.Building_dome_spot_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.Building_dome_spot = not ChoGGi.UserSettings.Building_dome_spot
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.Building_dome_spot),T(302535920000160--[[: Freedom for spires!\n(restart to set disabled)--]])),
    T(3980--[[Buildings--]]),UsualIcon3
  )
end

function ChoGGi.MenuFuncs.Building_instant_build_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.Building_instant_build = not ChoGGi.UserSettings.Building_instant_build
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.Building_instant_build),T(302535920000161--[[: Building Instant Build\n(restart to set disabled).--]])),
    T(3980--[[Buildings--]]),UsualIcon3
  )
end

function ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.Building_hide_from_build_menu = not ChoGGi.UserSettings.Building_hide_from_build_menu
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(Concat(tostring(ChoGGi.UserSettings.Building_hide_from_build_menu),T(302535920000162--[[: Buildings hidden\n(restart to toggle).--]])),
    T(3980--[[Buildings--]]),UsualIcon3
  )
end

function ChoGGi.MenuFuncs.SetUIRangeBuildingRadius(id,msgpopup)
  local ChoGGi = ChoGGi
  local DefaultSetting = _G[id]:GetDefaultPropertyValue("UIRange")
  local ItemList = {
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
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

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then

      if value == DefaultSetting then
        UserSettings.BuildingSettings[id].uirange = nil
      else
        UserSettings.BuildingSettings[id].uirange = value
      end

      --find a better way to update radius...
      local sel = SelectedObj
      CreateRealTimeThread(function()
        local objs = UICity.labels[id] or empty_table
        for i = 1, #objs do
          objs[i]:SetUIRange(value)
          SelectObj(objs[i])
          Sleep(1)
        end
        SelectObj(sel)
      end)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(Concat(T(302535920000163--[[Radius--]]),": ",choice[1].text,msgpopup),
        id,"UI/Icons/Upgrades/polymer_blades_04.tga",true
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(T(302535920000129--[[Set--]])," ",id," ",T(302535920000163--[[Radius--]])),
    hint = Concat(T(302535920000106--[[Current--]]),": ",hint),
  })
end
