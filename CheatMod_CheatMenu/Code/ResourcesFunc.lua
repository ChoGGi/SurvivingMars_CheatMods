local UsualIcon = "UI/Icons/Sections/storage.tga"
local UsualIcon2 = "UI/Icons/IPButtons/rare_metals.tga"

function ChoGGi.AddOrbitalProbes()
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

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Probes")
end

function ChoGGi.SetFoodPerRocketPassenger()
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
  if ChoGGi.CheatMenuSettings.FoodPerRocketPassenger then
    hint = ChoGGi.CheatMenuSettings.FoodPerRocketPassenger / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      ChoGGi.SetConstsG("FoodPerRocketPassenger",value)
      ChoGGi.SetSavedSetting("FoodPerRocketPassenger",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": om nom nom nom nom",
        "Passengers","UI/Icons/Sections/Food_4.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Food Per Rocket Passenger","Current: " .. hint)
end

function ChoGGi.AddPrefabs()
  local hint = "Use custom value to enter amount of prefabs to add."
  local ItemList = {
    {text = "Drone",value = "Drone",hint = hint},
    {text = "Drone Hub",value = "DroneHub",hint = hint},
    {text = "Electronics Factory",value = "ElectronicsFactory",hint = hint},
    {text = "Fuel Factory",value = "FuelFactory",hint = hint},
    {text = "Machine Parts Factory",value = "MachinePartsFactory",hint = hint},
    {text = "Moisture Vaporator",value = "MoistureVaporator",hint = hint},
    {text = "Polymer Plant",value = "PolymerPlant",hint = hint},
    {text = "Stirling Generator",value = "StirlingGenerator",hint = hint},
    {text = "Spire: Water Reclamation System",value = "WaterReclamationSystem",hint = hint},
    {text = "Spire: Arcology",value = "Arcology",hint = hint},
    {text = "Spire: Sanatorium",value = "Sanatorium",hint = hint},
    {text = "Spire: Network Node",value = "NetworkNode",hint = hint},
    {text = "Spire: Medical Center",value = "MedicalCenter",hint = hint},
    {text = "Spire: Hanging Garden",value = "HangingGardens",hint = hint},
    {text = "Spire: Cloning Vat",value = "CloningVats",hint = hint},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value --name
    local custom = choice[1].custom --num

    if type(custom) ~= "number" then
      ChoGGi.MsgPopup("Prefab number is missing from custom value box.",
        "Error",UsualIcon
      )
    else
      if value == "Drone" then
        UICity.drone_prefabs = UICity.drone_prefabs + custom
      else
        UICity:AddPrefabs(value,custom)
      end
      RefreshXBuildMenu()
      ChoGGi.MsgPopup(custom .. " " .. choice[1].text .. " prefabs have been added.",
        "Prefabs",UsualIcon
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Prefabs")

end

function ChoGGi.SetFunding()
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
      --reset money back to 0
      UICity.funding = 0
      --and add the new amount
      ChangeFunding(value)

      ChoGGi.MsgPopup(choice[1].text,
        "Funding",UsualIcon2
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Funding",hint)
end

function ChoGGi.FillResource()
  local sel = SelectedObj or SelectionMouseObj()
  if not sel then
    return
  end

  --need the msg here, as i made it return if it succeeds
  ChoGGi.MsgPopup("Resouce Filled",
    "Resource",UsualIcon2
  )

  if pcall(function()
    sel:CheatFill()
  end) then return --needed to put something for then

  elseif pcall(function()
    sel:CheatRefill()
  end) then return end

end
