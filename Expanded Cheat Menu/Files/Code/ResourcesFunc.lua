--See LICENSE for terms

local UsualIcon = "UI/Icons/Sections/storage.tga"
local UsualIcon2 = "UI/Icons/IPButtons/rare_metals.tga"

function ChoGGi.MenuFuncs.AddOrbitalProbes()
  local ItemList = {
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 200,value = 200},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      for _ = 1, value do
        PlaceObject("OrbitalProbe",{city = UICity})
      end
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Add Probes",
  })
end

function ChoGGi.MenuFuncs.SetFoodPerRocketPassenger()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.FoodPerRocketPassenger / r
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
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

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      ChoGGi.ComFuncs.SetConstsG("FoodPerRocketPassenger",value)
      ChoGGi.ComFuncs.SetSavedSetting("FoodPerRocketPassenger",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": om nom nom nom nom",
        "Passengers","UI/Icons/Sections/Food_4.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Food Per Rocket Passenger",
    hint = "Current: " .. hint,
  })
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
    {text = "Network Node",value = 10},
    {text = "Medical Center",value = 10},
    {text = "Hanging Garden",value = 10},
    {text = "Cloning Vat",value = 10},
  }

  local CallBackFunc = function(choice)
    local text = choice[1].text
    local value = choice[1].value

    if type(value) == "number" then
      if text == "Drone" then
        UICity.drone_prefabs = UICity.drone_prefabs + value
      else
        UICity:AddPrefabs(text,value)
      end
      RefreshXBuildMenu()
      ChoGGi.ComFuncs.MsgPopup(value .. " " .. text .. " prefabs have been added.",
        "Prefabs",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Add Prefabs",
    hint = "Use edit box to enter amount of prefabs to add.",
    custom_type = 3,
  })
end

function ChoGGi.MenuFuncs.SetFunding()
  --list to display and list with values
  local DefaultSetting = "(Reset to 500 M)"
  local hint = "If your funds are a negative value, then you added too much.\n\nFix with: " .. DefaultSetting
  local ItemList = {
    {text = DefaultSetting,value = 500},
    {text = "100 M",value = 100,hint = hint},
    {text = "1 000 M",value = 1000,hint = hint},
    {text = "10 000 M",value = 10000,hint = hint},
    {text = "100 000 M",value = 100000,hint = hint},
    {text = "1 000 000 000 M",value = 1000000000,hint = hint},
    {text = "90 000 000 000 M",value = 90000000000,hint = hint},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      if value == 500 then
        --reset money back to 0
        UICity.funding = 0
      end
      --and add the new amount
      ChangeFunding(value)

      ChoGGi.ComFuncs.MsgPopup(choice[1].text,
        "Funding",UsualIcon2
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Add Funding",
    hint = hint,
  })
end

function ChoGGi.MenuFuncs.FillResource()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    return
  end

  --need the msg here, as i made it return if it succeeds
  ChoGGi.ComFuncs.MsgPopup("Resouce Filled",
    "Resource",UsualIcon2
  )

  if pcall(function()
    sel:CheatFill()
  end) then return --needed to put something for then

  elseif pcall(function()
    sel:CheatRefill()
  end) then return end

end
