function restart()
  quit("restart")
end
function dump(obj,openas,name,ext)
  ChoGGi.Dump(obj,openas,name,ext)
end

function ChoGGi.FillResource(self)
  local temp
  if pcall(function ()
    ResourceProducer.CheatFill(self)
  end) then temp = false
  elseif pcall(function ()
    ResourceProducer.CheatFill(self)
    self.amount_stored = self.producers[1].max_storage
  end) then temp = false
  elseif pcall(function ()
    local group = self.group
    for i = 1, #group do
      group[i].transport_request:AddAmount(10000)
    end
    self:UpdateUI()
  end) then temp = false
  elseif pcall(function ()
    self.electricity:SetStoredAmount(self.capacity, "electricity")
  end) then temp = false
  elseif pcall(function ()
    self.air:SetStoredAmount(self.air_capacity, "air")
  end) then temp = false
  elseif pcall(function ()
    self.water:SetStoredAmount(self.water_capacity, "water")
  end) then temp = false
  elseif pcall(function ()
    self.transport_request:AddAmount(10000)
    self:UpdateUI()
  end) then temp = false
  elseif pcall(function ()
    self.demand.WasteRock:SetAmount(0)
    if self.supply.Concrete then
      self.supply.Concrete:SetAmount(self.max_amount_WasteRock / Max(1, g_Consts.WasteRockToConcreteRatio))
    end
    self:SetCount(self.max_amount_WasteRock)
  end) then temp = false
  elseif pcall(function ()
    self.amount = self.max_amount
    self:NotifyNearbyExploiters()
  end) then temp = false
  elseif pcall(function ()
    local resource = self.resource
    if self.supply[resource] then
      local max_name = "max_amount_" .. resource
      self.supply[resource]:SetAmount(self[max_name])
      self.demand[resource]:SetAmount(0)
    end
    self:SetCount(self.supply[resource]:GetActualAmount())
  end) then temp = false
  elseif pcall(function ()
    local amount_to_fill = self.max_storage - self:GetAmountStored()
    self.today_production = self.today_production + amount_to_fill
    self.lifetime_production = self.lifetime_production + amount_to_fill
    self:UpdateStockpileAmounts(self.max_storage)
  end) then temp = false
  elseif pcall(function ()
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
  end) then temp = false
  end
end

function ChoGGi.BlockCheatEmpty()
  --stop these from happening
  function SurfaceDeposit:CheatEmpty()
  end
  function Deposit:CheatEmpty()
  end
  function SubsurfaceDeposit:CheatEmpty()
  end
  function WasteRockDumpSite:CheatEmpty()
  end
  function WaterStorage:CheatEmpty()
  end
  function AirStorage:CheatEmpty()
  end
  function ElectricityStorage:CheatEmpty()
  end
  function Mine:CheatEmpty()
  end
  function ResourceProducer:CheatEmpty()
  end
  function SingleResourceProducer:CheatEmpty()
  end
  function StorageDepot:CheatEmpty()
  end
  UniversalStorageDepot.CheatEmpty = false
end

function ChoGGi.Dump(obj,openas,name,ext)
  openas = openas or "a"
  ext = ext or "txt"
  name = name or "DumpedText"
  local tempfile = assert(io.open("AppData/" .. name .. "." .. ext,openas))
  tempfile:write(obj)
  tempfile:close()
  CreateRealTimeThread(AddCustomOnScreenNotification(
    "ChoGGi_Dump_Func",
    "Dump",
    "Dumped: " .. Examine:ToString(obj) .. " to AppData/" .. name .. "." .. ext,
    "UI/Icons/Upgrades/magnetic_filtering_04.tga",
    nil,
    {expiration=5000})
  )
end

function ChoGGi.DumpObject(obj)
  local keyset={}
  for key,value in pairs(obj) do
    keyset[#keyset+1] = tostring(key) .. " = " .. tostring(value) .. "\n"
  end
  ChoGGi.Dump(keyset)
end

--list active functions
--[[
UserActions.IsActionActive(id)
UserActions.RemoveActions({
  "G_ToggleInfopanelCheats",
})
--]]
function ChoGGi.GetActiveActions()
  local ActiveActions = {}
  for id, _ in pairs(UserActions.Actions) do
    if UserActions.IsActionActive(id) then
      ActiveActions[#ActiveActions + 1] = id .. "\n"
    end
  end
  return ActiveActions
end

--functions to check for tech for default values
function ChoGGi.BuildingMaintenancePointsModifier()
  if UICity and UICity:IsTechDiscovered("HullPolarization") then
    return 75
  end
  return 100
end
--
function ChoGGi.CargoCapacity()
  if UICity and UICity:IsTechDiscovered("FuelCompression") then
    return 60000
  end
  return 50000
end
--
function ChoGGi.CommandCenterMaxDrones()
  if UICity and UICity:IsTechDiscovered("DroneSwarm") then
    return 80
  end
  return 20
end
--
function ChoGGi.DroneResourceCarryAmount()
  if UICity and UICity:IsTechDiscovered("ArtificialMuscles") then
    return 2
  end
  return 1
end
--
function ChoGGi.LowSanityNegativeTraitChance()
  if UICity and UICity:IsTechDiscovered("SupportiveCommunity") then
    return 7.5
  end
  return 30
end
--
function ChoGGi.MaxColonistsPerRocket()
  local PerRocket = 12
  if UICity and UICity:IsTechDiscovered("CompactPassengerModule") then
    PerRocket = PerRocket + 10
  end
  if UICity and UICity:IsTechDiscovered("CryoSleep") then
    PerRocket = PerRocket + 20
  end
  return PerRocket
end
--
function ChoGGi.NonSpecialistPerformancePenalty()
  if UICity and UICity:IsTechDiscovered("GeneralTraining") then
    return 40
  end
  return 50
end
--
function ChoGGi.RCRoverMaxDrones()
  if UICity and UICity:IsTechDiscovered("RoverCommandAI") then
    return 12
  end
  return 8
end
--
function ChoGGi.RCTransportGatherResourceWorkTime()
  if UICity and UICity:IsTechDiscovered("TransportOptimization") then
    ResourceWorkTime = 7500
    return 7500
  end
  return 15000
end
--
function ChoGGi.TravelTimePlanets()
  if UICity and UICity:IsTechDiscovered("PlasmaRocket") then
    return 375000
  end
  return 750000
end

--called everytime you set a setting
function ChoGGi.WriteSettings()
  AsyncStringToFile(ChoGGi.SettingsFile,TupleToLuaCode(ChoGGi.CheatMenuSettings))
end

--read settings from file
function ChoGGi.ReadSettings()
	if not ChoGGi.SettingsFile then return end

	local file_error, code = AsyncFileToString(ChoGGi.SettingsFile)
	if file_error then
		return file_error
	end

	local code_error
  code_error, ChoGGi.CheatMenuSettings = LuaCodeToTuple(code)
	if code_error then
		return code_error
	end

  if ChoGGi.SettingsFileLoaded then
    ChoGGi.SetSettings()
  end

end

--give a CheatFill cmd to concrete (well try to, it doesn't seem to have the cheat section...find out why)
--[[
function TerrainDepositConcrete:CheatRefill()
  self.amount = self.max_amount
  self:NotifyNearbyExploiters()
  self:UpdateUI()
end
--]]
