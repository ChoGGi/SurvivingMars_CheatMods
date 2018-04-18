function ChoGGi.AddOrbitalProbes()
  if not UICity then
    return
  end
  local ListDisplay = {5,10,25,50,100,200}
  local TempFunc = function(choice)
    for i = 1, ListDisplay[choice] do
      PlaceObject("OrbitalProbe",{city = UICity})
    end
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Add Probes",10)
end

function ChoGGi.DeepScanToggle()
  Consts.DeepScanAvailable = ChoGGi.ToggleBoolNum(Consts.DeepScanAvailable)
  Consts.IsDeepWaterExploitable = ChoGGi.ToggleBoolNum(Consts.IsDeepWaterExploitable)
  Consts.IsDeepMetalsExploitable = ChoGGi.ToggleBoolNum(Consts.IsDeepMetalsExploitable)
  Consts.IsDeepPreciousMetalsExploitable = ChoGGi.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable)
  --GrantTech("AdaptedProbes")
  --GrantTech("DeepScanning")
  --GrantTech("DeepWaterExtraction")
  --GrantTech("DeepMetalExtraction")
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
  local DefaultAmount = ChoGGi.Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale
  local ListDisplay = {DefaultAmount,25,50,75,100,250,500,1000,10000}
  local hint
  if ChoGGi.CheatMenuSettings.FoodPerRocketPassenger then
    hint = "Current gravity: " .. ChoGGi.CheatMenuSettings.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale
  end

  local TempFunc = function(choice)
    local amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    Consts.FoodPerRocketPassenger = amount
    --save option for spawned
    if choice == 1 then
      ChoGGi.CheatMenuSettings.FoodPerRocketPassenger = false
    else
      ChoGGi.CheatMenuSettings.FoodPerRocketPassenger = amount
    end
    --save setting
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(ListDisplay[choice] .. ": om nom nom nom nom",
     "Passengers","UI/Icons/Sections/Food_4.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Colonists Gravity",1,hint)
end

function ChoGGi.AddPrefabsDrone()
  local ListDisplay = {1,5,10,25,50,100,500,1000}
  local TempFunc = function(choice)
    UICity.drone_prefabs = UICity.drone_prefabs + ListDisplay[choice]
    ChoGGi.MsgPopup(ListDisplay[choice] .. " Drone prefabs added.",
      "Prefabs","UI/Icons/Sections/storage.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Add Prefabs: Drone")
end

function ChoGGi.AddPrefabs(Type,Msg)
  --list to display and list with values
  local ListDisplay = {1,5,10,25,50,100,500,1000}
  local TempFunc = function(choice)
    UICity:AddPrefabs(Type,ListDisplay[choice])
    --and add the new amount
    ChangeFunding(ListDisplay[choice])

    ChoGGi.MsgPopup(ListDisplay[choice] .. Msg,
      "Prefabs","UI/Icons/Sections/storage.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Add Prefabs: " .. Type)
end

function ChoGGi.SetFunding()
  --list to display and list with values
  local DefaultAmount = "(Reset to 500 M)"
  local ListDisplay = {DefaultAmount,"100 M","1 000 M","10 000 M","100 000 M","1 000 000 000 M","90 000 000 000 M"}
  local ListActual = {500,100,1000,10000,100000,1000000000,90000000000}
  local TempFunc = function(choice)
    --reset money back to 0
    if choice == 1 and UICity then
      UICity.funding = 0
    end
    --and add the new amount
    ChangeFunding(ListActual[choice])

    ChoGGi.MsgPopup(ListDisplay[choice],
    "Funding","UI/Icons/IPButtons/rare_metals.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Add Funding",3,"If your funds are a negative value, then you added too much.\n\nFix with: " .. DefaultAmount)
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
