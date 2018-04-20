
function ChoGGi.AddOrbitalProbes()
  if not UICity then
    return
  end

  local ItemList = {
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 200,value = 200},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      for i = 1, amount do
        PlaceObject("OrbitalProbe",{city = UICity})
      end
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Probes")
end

function ChoGGi.DeepScanToggle()
  ChoGGi.SetConstsG("DeepScanAvailable",ChoGGi.ToggleBoolNum(Consts.DeepScanAvailable))
  ChoGGi.SetConstsG("IsDeepWaterExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepWaterExploitable))
  ChoGGi.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
  ChoGGi.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))

  ChoGGi.CheatMenuSettings.DeepScanAvailable = Consts.DeepScanAvailable
  ChoGGi.CheatMenuSettings.IsDeepWaterExploitable = Consts.IsDeepWaterExploitable
  ChoGGi.CheatMenuSettings.IsDeepMetalsExploitable = Consts.IsDeepMetalsExploitable
  ChoGGi.CheatMenuSettings.IsDeepPreciousMetalsExploitable = Consts.IsDeepPreciousMetalsExploitable
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.DeepScanAvailable .. ": Alice thought to herself 'Now you will see a film... made for children... perhaps... ' But, I nearly forgot... you must... close your eyes... otherwise... you won't see anything.",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

function ChoGGi.DeeperScanEnable()
  GrantTech("CoreMetals")
  GrantTech("CoreWater")
  GrantTech("CoreRareMetals")
  ChoGGi.MsgPopup("Further down the rabbit hole",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

function ChoGGi.SetFoodPerRocketPassenger()
  local DefaultSetting = ChoGGi.Consts.FoodPerRocketPassenger
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
    {text = 10000,value = 10000 * r},
  }

  local hint = DefaultSetting / r
  if ChoGGi.CheatMenuSettings.FoodPerRocketPassenger then
    hint = ChoGGi.CheatMenuSettings.FoodPerRocketPassenger / r
  end

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      ChoGGi.SetConstsG("FoodPerRocketPassenger",amount)
      ChoGGi.CheatMenuSettings.FoodPerRocketPassenger = amount
    else
      ChoGGi.SetConstsG("FoodPerRocketPassenger",DefaultSetting)
      ChoGGi.CheatMenuSettings.FoodPerRocketPassenger = false
    end
    --save setting
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(choice[1].text .. ": om nom nom nom nom",
     "Passengers","UI/Icons/Sections/Food_4.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Food Per Rocket Passenger","Current: " .. hint)
end

function ChoGGi.AddPrefabsDrone()
  local ItemList = {
    {text = 1,value = 1},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      UICity.drone_prefabs = UICity.drone_prefabs + amount
      ChoGGi.MsgPopup(choice[1].text .. " Drone prefabs added.",
        "Prefabs","UI/Icons/Sections/storage.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Prefabs: Drone")
end

function ChoGGi.AddPrefabs(Type,Msg)

  local ItemList = {
    {text = 1,value = 1},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      UICity:AddPrefabs(Type,amount)
      ChoGGi.MsgPopup(choice[1].text .. Msg,
        "Prefabs","UI/Icons/Sections/storage.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Prefabs: " .. Type)
end

function ChoGGi.SetFunding()
  --list to display and list with values
  local DefaultSetting = "(Reset to 500 M)"
  local ItemList = {
    {text = DefaultSetting,value = 500},
    {text = "100 M",value = 100},
    {text = "1 000 M",value = 1000},
    {text = "10 000 M",value = 10000},
    {text = "100 000 M",value = 100000},
    {text = "1 000 000 000 M",value = 1000000000},
    {text = "90 000 000 000 M",value = 90000000000},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      --reset money back to 0
      UICity.funding = 0
      --and add the new amount
      ChangeFunding(amount)

      ChoGGi.MsgPopup(choice[1].text,
      "Funding","UI/Icons/IPButtons/rare_metals.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Funding","If your funds are a negative value, then you added too much.\n\nFix with: " .. DefaultSetting)
end

function ChoGGi.FillResource(self)
  if not SelectedObj then
    return
  end
  ChoGGi.MsgPopup("Resouce Filled",
  "Resource","UI/Icons/IPButtons/rare_metals.tga"
  )
  if pcall(function()
    ResourceProducer.CheatFill(self)
  end) then return --needed to put something for then
  elseif pcall(function()
    ResourceProducer.CheatFill(self)
    self.amount_stored = self.producers[1].max_storage
  end) then return
  elseif pcall(function()
    local group = self.group
    for i = 1, #group do
      group[i].transport_request:AddAmount(10000)
    end
    self:UpdateUI()
  end) then return
  elseif pcall(function()
    self.electricity:SetStoredAmount(self.capacity, "electricity")
  end) then return
  elseif pcall(function()
    self.air:SetStoredAmount(self.air_capacity, "air")
  end) then return
  elseif pcall(function()
    self.water:SetStoredAmount(self.water_capacity, "water")
  end) then return
  elseif pcall(function()
    self.transport_request:AddAmount(10000)
    self:UpdateUI()
  end) then return
  elseif pcall(function()
    self.demand.WasteRock:SetAmount(0)
    if self.supply.Concrete then
      self.supply.Concrete:SetAmount(self.max_amount_WasteRock / Max(1, g_Consts.WasteRockToConcreteRatio))
    end
    self:SetCount(self.max_amount_WasteRock)
  end) then return
  elseif pcall(function()
    self.amount = self.max_amount
    self:NotifyNearbyExploiters()
  end) then return
  elseif pcall(function()
    local resource = self.resource
    if self.supply[resource] then
      local max_name = "max_amount_" .. resource
      self.supply[resource]:SetAmount(self[max_name])
      self.demand[resource]:SetAmount(0)
    end
    self:SetCount(self.supply[resource]:GetActualAmount())
  end) then return
  elseif pcall(function()
    local amount_to_fill = self.max_storage - self:GetAmountStored()
    self.today_production = self.today_production + amount_to_fill
    self.lifetime_production = self.lifetime_production + amount_to_fill
    self:UpdateStockpileAmounts(self.max_storage)
  end) then return
  elseif pcall(function()
    local storable_resources = self.storable_resources
    local resource_count = #storable_resources
    self:InterruptDrones(nil, function(drone)
      local r = drone.d_request
      if r and self.demand[r:GetResource()] == r then
        return drone
      end
    end)
    for i = 1, resource_count do
      local resource_name = storable_resources[i]
      if self.supply[resource_name] then
        local a = self.demand[resource_name]:GetActualAmount()
        self:AddResource(a, resource_name)
      end
    end
  end) then return
  end
end
