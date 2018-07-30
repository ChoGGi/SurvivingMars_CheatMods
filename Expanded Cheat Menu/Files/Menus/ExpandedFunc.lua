--See LICENSE for terms
--funcs under Gameplay menu without a separate file

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings

local default_icon = "UI/Icons/Sections/storage.tga"
local default_icon2 = "UI/Icons/Upgrades/home_collective_04.tga"
local default_icon3 = "UI/Icons/IPButtons/rare_metals.tga"

local type,tostring = type,tostring

local PlaceObject = PlaceObject
local ChangeFunding = ChangeFunding
local RefreshXBuildMenu = RefreshXBuildMenu

do --ChangeResupplySettings
  local function CheckResupplySetting(cargo_val,name,value,meta)
    if ChoGGi.Tables.CargoPresets[name][cargo_val] == value then
      ChoGGi.UserSettings.CargoSettings[name][cargo_val] = nil
      meta[cargo_val] = value
    else
      ChoGGi.UserSettings.CargoSettings[name][cargo_val] = value
      meta[cargo_val] = value
    end
  end
  local function ShowResupplyList(name,meta)
    local ChoGGi = ChoGGi

    local ItemList = {
      {text = "pack",value = meta.pack,hint = 302535920001269--[[Amount Per Click--]]},
      {text = "kg",value = meta.kg,hint = 302535920001270--[[Weight Per Item--]]},
      {text = "price",value = meta.price,hint = 302535920001271--[[Price Per Item--]]},
      {text = "locked",value = meta.locked,hint = 302535920000126--[[Locked From Resupply View--]]},
    }

    local function CallBackFunc(choice)
      local value = choice[1].value
      if not value then
        return
      end

      if not ChoGGi.UserSettings.CargoSettings[name] then
        ChoGGi.UserSettings.CargoSettings[name] = {}
      end

      for i = 1, #choice do
        value = ChoGGi.ComFuncs.RetProperType(choice[i].value)
        local text = choice[i].text
        if text == "pack" and type(value) == "number" then
          CheckResupplySetting("pack",name,value,meta)
        elseif text == "kg" and type(value) == "number" then
          CheckResupplySetting("kg",name,value,meta)
        elseif text == "price" and type(value) == "number" then
          CheckResupplySetting("price",name,value,meta)
        elseif text == "locked" and type(value) == "boolean" then
          CheckResupplySetting("locked",name,value,meta)
        end
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        302535920000850--[[Change Resupply Settings--]],
        302535920001272--[[Updated--]],
        "UI/Icons/Sections/spaceship.tga"
      )
    end

    ChoGGi.ComFuncs.OpenInListChoice{
      callback = CallBackFunc,
      items = ItemList,
      title = Concat(S[302535920000850--[[Change Resupply Settings--]]],": ",name),
      hint = 302535920001121--[[Edit value for each setting you wish to change then press OK to save.--]],
      custom_type = 4,
    }
  end

  function ChoGGi.MenuFuncs.ChangeResupplySettings()
    local ChoGGi = ChoGGi
    local Cargo = ChoGGi.Tables.Cargo

    local ItemList = {}
    for i = 1, #Cargo do
      ItemList[i] = {
        text = T(Cargo[i].name),
        value = Cargo[i].id,
        meta = Cargo[i],
      }
    end

    local function CallBackFunc(choice)
      local value = choice[1].value
      if not value then
        return
      end
      ShowResupplyList(value,choice[1].meta)
    end

    ChoGGi.ComFuncs.OpenInListChoice{
      callback = CallBackFunc,
      items = ItemList,
      title = 302535920000850--[[Change Resupply Settings--]],
      hint = 302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]],
      custom_type = 7,
      custom_func = function(sel)
        ShowResupplyList(sel.value,sel.meta)
      end,
    }
  end
end

function ChoGGi.MenuFuncs.MonitorInfo()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = Concat(" ",S[302535920000936--[[Something you'd like to see added?--]]]),value = "New"},
    {text = Concat(S[302535920000035--[[Grids--]]],": ",S[891--[[Air--]]]),value = "Air"},
    {text = Concat(S[302535920000035--[[Grids--]]],": ",S[302535920000037--[[Electricity--]]]),value = "Electricity"},
    {text = Concat(S[302535920000035--[[Grids--]]],": ",S[681--[[Water--]]]),value = "Water"},
    {text = Concat(S[302535920000035--[[Grids--]]],": ",S[891--[[Air--]]],"/",S[302535920000037--[[Electricity--]]],"/",S[681--[[Water--]]]),value = "Grids"},
    {text = S[302535920000042--[[City--]]],value = "City"},
    {text = S[547--[[Colonists--]]],value = "Colonists",hint = 302535920000937--[[Laggy with lots of colonists.--]]},
    {text = S[5238--[[Rockets--]]],value = "Rockets"},
    --{text = "Research",value = "Research"}
  }
  if ChoGGi.Testing then
    ItemList[#ItemList+1] = {text = S[311--[[Research--]]],value = "Research"}
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if value == "New" then
      ChoGGi.ComFuncs.MsgWait(
        S[302535920000033--[[Post a request on Nexus or Github or send an email to: %s--]]]:format(ChoGGi.email),
        302535920000034--[[Request--]]
      )
    else
      ChoGGi.CodeFuncs.DisplayMonitorList(value)
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000555--[[Monitor Info--]],
    hint = 302535920000940--[[Select something to monitor.--]],
    custom_type = 7,
    custom_func = function(sel)
      ChoGGi.CodeFuncs.DisplayMonitorList(sel.value,sel.parentobj)
    end,
  }
end

function ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.StorageMechanizedDepotsTemp = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.StorageMechanizedDepotsTemp)

  local amount
  if not ChoGGi.UserSettings.StorageMechanizedDepotsTemp then
    amount = 5
  end
  local tab = UICity.labels.MechanizedDepots or ""
  for i = 1, #tab do
    ChoGGi.CodeFuncs.SetMechanizedDepotTempAmount(tab[i],amount)
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.StorageMechanizedDepotsTemp,302535920000565--[[Storage Mechanized Depots Temp--]]),
    519--[[Storage--]],
    default_icon
  )
end

function ChoGGi.MenuFuncs.LaunchEmptyRocket()
  local function CallBackFunc(answer)
    if answer then
      UICity:OrderLanding()
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    302535920000942--[[Are you sure you want to launch an empty rocket?--]],
    CallBackFunc,
    302535920000943--[[Launch rocket to Mars.--]],
    302535920000944--[[Yamato Hasshin!--]]
  )
end

function ChoGGi.MenuFuncs.SetRocketCargoCapacity()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.CodeFuncs.GetCargoCapacity()
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting," kg"),value = DefaultSetting},
    {text = "50 000 kg",value = 50000},
    {text = "100 000 kg",value = 100000},
    {text = "250 000 kg",value = 250000},
    {text = "500 000 kg",value = 500000},
    {text = "1 000 000 kg",value = 1000000},
    {text = "10 000 000 kg",value = 10000000},
    {text = "100 000 000 kg",value = 100000000},
    {text = "1 000 000 000 kg",value = 1000000000},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetConstsG("CargoCapacity",value)
      ChoGGi.ComFuncs.SetSavedSetting("CargoCapacity",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000945--[[%s: I can still see some space...--]]]:format(choice[1].text),
        5238--[[Rockets--]],
        "UI/Icons/Sections/spaceship.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000946--[[Set Rocket Cargo Capacity--]],
    hint = Concat(S[302535920000914--[[Current capacity--]]],": ",Consts.CargoCapacity),
  }
end

function ChoGGi.MenuFuncs.SetRocketTravelTime()
  local ChoGGi = ChoGGi
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.CodeFuncs.GetTravelTimeEarthMars() / r
  local ItemList = {
    {text = Concat(" ",S[302535920000947--[[Instant--]]]),value = 0},
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = Concat(" ",S[302535920000948--[[Original--]]],": ",750),value = 750},
    {text = Concat(" ",S[302535920000949--[[Half of Original--]]],": ",375),value = 375},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 150,value = 150},
    {text = 200,value = 200},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.TravelTimeEarthMars then
    hint = ChoGGi.UserSettings.TravelTimeEarthMars / r
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      local value = value * r
      ChoGGi.ComFuncs.SetConstsG("TravelTimeEarthMars",value)
      ChoGGi.ComFuncs.SetConstsG("TravelTimeMarsEarth",value)
      ChoGGi.ComFuncs.SetSavedSetting("TravelTimeEarthMars",value)
      ChoGGi.ComFuncs.SetSavedSetting("TravelTimeMarsEarth",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000950--[[%s: 88 MPH--]]]:format(choice[1].text),
        5238--[[Rockets--]],
        "UI/Upgrades/autoregulator_04/timer.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000951--[[Rocket Travel Time--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
  }
end

function ChoGGi.MenuFuncs.SetColonistsPerRocket()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.CodeFuncs.GetMaxColonistsPerRocket()
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetConstsG("MaxColonistsPerRocket",value)
      ChoGGi.ComFuncs.SetSavedSetting("MaxColonistsPerRocket",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000952--[[%s: Long pig sardines--]]]:format(choice[1].text),
        5238--[[Rockets--]],
        "UI/Icons/Notifications/colonist.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000953--[[Set Colonist Capacity--]],
    hint = Concat(S[302535920000914--[[Current capacity--]]],": ",Consts.MaxColonistsPerRocket),
  }
end

function ChoGGi.MenuFuncs.SetWorkerCapacity()
  if not SelectedObj or not SelectedObj.base_max_workers then
    MsgPopup(
      302535920000954--[[You need to select a building that has workers.--]],
      302535920000567--[[Worker Capacity--]],
      default_icon
    )
    return
  end
  local ChoGGi = ChoGGi
  local sel = SelectedObj
  local DefaultSetting = sel.base_max_workers
  local hint_toolarge = Concat(S[6779--[[Warning--]]]," ",S[302535920000956--[[for colonist capacity: Above a thousand is laggy (above 60K may crash).--]]])

  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000,hint = hint_toolarge},
    {text = 2000,value = 2000,hint = hint_toolarge},
    {text = 3000,value = 3000,hint = hint_toolarge},
    {text = 4000,value = 4000,hint = hint_toolarge},
    {text = 5000,value = 5000,hint = hint_toolarge},
    {text = 10000,value = 10000,hint = hint_toolarge},
    {text = 25000,value = 25000,hint = hint_toolarge},
  }

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] then
    ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id]
  if setting and setting.workers then
    hint = tostring(setting.workers)
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then

      local tab = UICity.labels.Workplace or ""
      for i = 1, #tab do
        if tab[i].encyclopedia_id == sel.encyclopedia_id then
          tab[i].max_workers = value
        end
      end

      if value == DefaultSetting then
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].workers = nil
      else
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].workers = value
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000957--[[%s capacity is now %s.--]]]:format(RetName(sel),choice[1].text),
        302535920000567--[[Worker Capacity--]],
        default_icon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",RetName(sel)," ",S[302535920000567--[[Worker Capacity--]]]),
    hint = Concat(S[302535920000914--[[Current capacity--]]],": ",hint,"\n\n",hint_toolarge),
  }
end

function ChoGGi.MenuFuncs.SetBuildingCapacity()
  local sel = SelectedObj
  if not sel or (type(sel.GetStoredWater) == "nil" and type(sel.GetStoredAir) == "nil" and type(sel.GetStoredPower) == "nil" and type(sel.GetUIResidentsCount) == "nil") then
    MsgPopup(
      302535920000958--[[You need to select a building that has capacity.--]],
      3980--[[Buildings--]],
      default_icon
    )
    return
  end
  local ChoGGi = ChoGGi
  local r = ChoGGi.Consts.ResourceScale
  local hint_toolarge = Concat(S[6779--[[Warning--]]]," ",S[302535920000956--[[for colonist capacity: Above a thousand is laggy (above 60K may crash).--]]])

  --get type of capacity
  local CapType
  if type(sel.GetStoredAir) == "function" then
    CapType = "air"
  elseif type(sel.GetStoredWater) == "function" then
    CapType = "water"
  elseif type(sel.GetStoredPower) == "function" then
    CapType = "electricity"
  elseif type(sel.GetUIResidentsCount) == "function" then
    CapType = "colonist"
  end

  --get default amount
  local DefaultSetting
  if CapType == "electricity" or CapType == "colonist" then
    DefaultSetting = sel.base_capacity
  else
    DefaultSetting = sel[Concat("base_",CapType,"_capacity")]
  end

  if CapType ~= "colonist" then
    DefaultSetting = DefaultSetting / r
  end

  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000,hint = hint_toolarge},
    {text = 2000,value = 2000,hint = hint_toolarge},
    {text = 3000,value = 3000,hint = hint_toolarge},
    {text = 4000,value = 4000,hint = hint_toolarge},
    {text = 5000,value = 5000,hint = hint_toolarge},
    {text = 10000,value = 10000,hint = hint_toolarge},
    {text = 25000,value = 25000,hint = hint_toolarge},
    {text = 50000,value = 50000,hint = hint_toolarge},
    {text = 100000,value = 100000,hint = hint_toolarge},
  }

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] then
    ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id]
  if setting and setting.capacity then
    if CapType ~= "colonist" then
      hint = tostring(setting.capacity / r)
    else
      hint = tostring(setting.capacity)
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then

      --colonist cap doesn't use res scale
      local amount
      if CapType == "colonist" then
        amount = value
      else
        amount = value * r
      end

      local function StoredAmount(prod,current)
        if prod:GetStoragePercent() == 0 then
          return "empty"
        elseif prod:GetStoragePercent() == 100 then
          return "full"
        elseif current == "discharging" then
          return "discharging"
        else
          return "charging"
        end
      end
      --updating time
      if CapType == "electricity" then
        local tab = UICity.labels.Power or ""
        for i = 1, #tab do
          if tab[i].encyclopedia_id == sel.encyclopedia_id then
            tab[i].capacity = amount
            tab[i][CapType].storage_capacity = amount
            tab[i][CapType].storage_mode = StoredAmount(tab[i][CapType],tab[i][CapType].storage_mode)
            ChoGGi.CodeFuncs.ToggleWorking(tab[i])
          end
        end

      elseif CapType == "colonist" then
        local tab = UICity.labels.Residence or ""
        for i = 1, #tab do
          if tab[i].encyclopedia_id == sel.encyclopedia_id then
            tab[i].capacity = amount
          end
        end

      else --water and air
        local tab = UICity.labels["Life-Support"] or ""
        for i = 1, #tab do
          if tab[i].encyclopedia_id == sel.encyclopedia_id then
            tab[i][Concat(CapType,"_capacity")] = amount
            tab[i][CapType].storage_capacity = amount
            tab[i][CapType].storage_mode = StoredAmount(tab[i][CapType],tab[i][CapType].storage_mode)
            ChoGGi.CodeFuncs.ToggleWorking(tab[i])
          end
        end
      end

      if value == DefaultSetting then
        setting.capacity = nil
      else
        setting.capacity = amount
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000957--[[%s capacity is now %s.--]]]:format(RetName(sel),choice[1].text),
        3980--[[Buildings--]],
        default_icon
      )
    end

  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",RetName(sel)," ",S[109035890389--[[Capacity--]]]),
    hint = Concat(S[302535920000914--[[Current capacity--]]],": ",hint,"\n\n",hint_toolarge),
  }
end

function ChoGGi.MenuFuncs.SetVisitorCapacity()
  local sel = SelectedObj
  if not sel or (sel and not sel.base_max_visitors) then
    MsgPopup(
      302535920000959--[[You need to select something that has space for visitors.--]],
      3980--[[Buildings--]],
      default_icon2
    )
    return
  end
  local ChoGGi = ChoGGi
  local DefaultSetting = sel.base_max_visitors
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] then
    ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id]
  if setting and setting.visitors then
    hint = tostring(setting.visitors)
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      local tab = UICity.labels.BuildingNoDomes or ""
      for i = 1, #tab do
        if tab[i].encyclopedia_id == sel.encyclopedia_id then
          tab[i].max_visitors = value
        end
      end

      if value == DefaultSetting then
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].visitors = nil
      else
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].visitors = value
      end

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920000960--[[%s visitor capacity is now %s.--]]]:format(RetName(sel),choice[1].text),
        3980--[[Buildings--]],
        default_icon2
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",RetName(sel)," ",S[302535920000961--[[Visitor Capacity--]]]),
    hint = Concat(S[302535920000914--[[Current capacity--]]],": ",hint),
  }
end

function ChoGGi.MenuFuncs.SetStorageDepotSize(sType)
  local ChoGGi = ChoGGi
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts[sType] / r
  local hint_max = S[302535920000962--[[Max capacity limited to:
Universal: 2,500
Other: 20,000
Waste: 1,000,000
Mechanized: 1,000,000--]]]
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500,hint = hint_max},
    {text = 5000,value = 5000,hint = hint_max},
    {text = 10000,value = 10000,hint = hint_max},
    {text = 20000,value = 20000,hint = hint_max},
    {text = 100000,value = 100000,hint = hint_max},
    {text = 1000000,value = 1000000,hint = hint_max},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings[sType] then
    hint = ChoGGi.UserSettings[sType] / r
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then

      local value = value * r
      if sType == "StorageWasteDepot" then
        --limit amounts so saving with a full load doesn't delete your game
        if value > 1000000000 then
          value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
        end
        --loop through and change all existing

        local tab = UICity.labels.WasteRockDumpSite or ""
        for i = 1, #tab do
          tab[i].max_amount_WasteRock = value
          if tab[i]:GetStoredAmount() < 0 then
            tab[i]:CheatEmpty()
            tab[i]:CheatFill()
          end
        end
      elseif sType == "StorageOtherDepot" then
        if value > 20000000 then
          value = 20000000
        end
        local tab = UICity.labels.UniversalStorageDepot or ""
        for i = 1, #tab do
          if tab[i].entity ~= "StorageDepot" then
            tab[i].max_storage_per_resource = value
          end
        end
        local function OtherDepot(label,res)
          local tab = UICity.labels[label] or ""
          for i = 1, #tab do
            tab[i][res] = value
          end
        end
        OtherDepot("MysteryResource","max_storage_per_resource")
        OtherDepot("BlackCubeDumpSite","max_amount_BlackCube")
      elseif sType == "StorageUniversalDepot" then
        if value > 2500000 then
          value = 2500000 --can go to 2900, but I got a crash; which may have been something else, but it's only 400
        end
        local tab = UICity.labels.UniversalStorageDepot or ""
        for i = 1, #tab do
          if tab[i].entity == "StorageDepot" then
            tab[i].max_storage_per_resource = value
          end
        end
      elseif sType == "StorageMechanizedDepot" then
        if value > 1000000000 then
          value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
        end
        local tab = UICity.labels.MechanizedDepots or ""
        for i = 1, #tab do
          tab[i].max_storage_per_resource = value
        end
      end
      --for new buildings
      ChoGGi.ComFuncs.SetSavedSetting(sType,value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        Concat(choice[1].text,": ",sType),
        519--[[Storage--]],
        "UI/Icons/Sections/basic.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]],": ",sType," ",S[302535920000963--[[Size--]]]),
    hint = Concat(S[302535920000914--[[Current capacity--]]],": ",hint,"\n\n",hint_max),
  }
end

function ChoGGi.MenuFuncs.AddOrbitalProbes()
  local ItemList = {
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 200,value = 200},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local UICity = UICity
    if type(value) == "number" then
      for _ = 1, value do
        PlaceObject("OrbitalProbe",{city = UICity})
      end
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001187--[[Add Probes--]],
  }
end

function ChoGGi.MenuFuncs.SetFoodPerRocketPassenger()
  local ChoGGi = ChoGGi
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.FoodPerRocketPassenger / r
  local ItemList = {
    {text = Concat(" ",S[1000121--[[Default--]]],": ",DefaultSetting),value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local hint = DefaultSetting
  local FoodPerRocketPassenger = ChoGGi.UserSettings.FoodPerRocketPassenger
  if FoodPerRocketPassenger then
    hint = FoodPerRocketPassenger / r
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      local value = value * r
      ChoGGi.ComFuncs.SetConstsG("FoodPerRocketPassenger",value)
      ChoGGi.ComFuncs.SetSavedSetting("FoodPerRocketPassenger",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(
        S[302535920001188--[[%s: om nom nom nom nom--]]]:format(choice[1].text),
        302535920001189--[[Passengers--]],
        "UI/Icons/Sections/Food_4.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001190--[[Set Food Per Rocket Passenger--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",hint),
  }
end

function ChoGGi.MenuFuncs.AddPrefabs()
  local ItemList = {
    {text = "Drone",value = 10},
    {text = "DroneHub",value = 10},
    {text = "ElectronicsFactory",value = 10},
    {text = "FuelFactory",value = 10},
    {text = "MachinePartsFactory",value = 10},
    {text = "MoistureVaporator",value = 10},
    {text = "PolymerPlant",value = 10},
    {text = "StirlingGenerator",value = 10},
    {text = "WaterReclamationSystem",value = 10},
    {text = "Arcology",value = 10},
    {text = "Sanatorium",value = 10},
    {text = "NetworkNode",value = 10},
    {text = "MedicalCenter",value = 10},
    {text = "HangingGardens",value = 10},
    {text = "CloningVat",value = 10},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local text = choice[1].text

    if type(value) == "number" then
      if text == "Drone" then
        UICity.drone_prefabs = UICity.drone_prefabs + value
      else
        UICity:AddPrefabs(text,value)
      end
      RefreshXBuildMenu()
      MsgPopup(
        S[302535920001191--[[%s %s prefabs have been added.--]]]:format(value,text),
        302535920001192--[[Prefabs--]],
        default_icon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000723--[[Add Prefabs--]],
    hint = 302535920001194--[[Use edit box to enter amount of prefabs to add.--]],
    custom_type = 3,
  }
end

function ChoGGi.MenuFuncs.SetFunding()
  local DefaultSetting = S[302535920001195--[[(Reset to 500 M)--]]]
  local hint = S[302535920001196--[[If your funds are a negative value, then you added too much.

Fix with: %s--]]]:format(DefaultSetting)
  local ItemList = {
    {text = DefaultSetting,value = 500},
    {text = "100 M",value = 100,hint = hint},
    {text = "1 000 M",value = 1000,hint = hint},
    {text = "10 000 M",value = 10000,hint = hint},
    {text = "100 000 M",value = 100000,hint = hint},
    {text = "1 000 000 000 M",value = 1000000000,hint = hint},
    {text = "90 000 000 000 M",value = 90000000000,hint = hint},
  }

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if type(value) == "number" then
      if value == 500 then
        --reset money back to 0
        UICity.funding = 0
      end
      --and add the new amount
      ChangeFunding(value)

      MsgPopup(
        choice[1].text,
        3613--[[Funding--]],
        default_icon3
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000725--[[Add Funding--]],
    hint = hint,
  }
end

function ChoGGi.MenuFuncs.FillResource()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end

  if type(sel.CheatFill) == "function" then
    sel:CheatFill()
  end
  if type(sel.CheatRefill) == "function" then
    sel:CheatRefill()
  end

  MsgPopup(
    302535920001198--[[Resource Filled--]],
    15--[[Resource--]],
    default_icon3
  )

end
