--called everytime we set a setting in menu
function ChoGGi.WriteSettings()
  AsyncStringToFile(ChoGGi.SettingsFile,TupleToLuaCode(ChoGGi.CheatMenuSettings))
end

--read saved settings from file
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

  --if we have new settings not yet in SettingsFile, check for nil
  for Key,Value in pairs(ChoGGi.Consts) do
    if type(ChoGGi.CheatMenuSettings[Key]) == "nil" then
      ChoGGi.CheatMenuSettings[Key] = Value
    end
  end

  --set consts to saved ones
  if ChoGGi.SettingsFileLoaded then
    ChoGGi.SetSettings()
  end
end

function ChoGGi.MsgPopup(Msg,Title,Icon)
  pcall(function()
    Msg = Msg or ""
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    if type(AddCustomOnScreenNotification) == "function" then --incase we called it where there ain't no UI
      CreateRealTimeThread(AddCustomOnScreenNotification(
        --AsyncRand(),Title,"" .. Msg,Icon,nil,{expiration=5000}
        AsyncRand(),Title,Msg,Icon,nil,{expiration=5000}
      ))
    end
  end)
end

--give a CheatFill cmd to concrete (well try to, it doesn't seem to have the cheat section...find out why)
--[[
function TerrainDepositConcrete:CheatRefill()
  self.amount = self.max_amount
  self:NotifyNearbyExploiters()
  self:UpdateUI()
end
--]]

function ChoGGi.FullyAutomatedBuildingsSet(building)
  if building.encyclopedia_id == "ElectronicsFactory"
  or building.encyclopedia_id == "MachinePartsFactory"
  or building.encyclopedia_id == "ElectronicsFactory"
  or building.encyclopedia_id == "PolymerPlant"
  or building.encyclopedia_id == "MachinePartsFactory"
  or building.encyclopedia_id == "MetalsExtractor"
  or building.encyclopedia_id == "PreciousMetalsExtractor"
  or building.encyclopedia_id == "WaterExtractor"
  or building.encyclopedia_id == "RegolithExtractor" then
      building.upgrade2_id = "FullyAutomatedBuildings"
      building.upgrade2_display_name = "Fully Automated"
      building.upgrade2_description = "Fully Automated"
      building.upgrade2_icon = "UI/Icons/Upgrades/home_collective_01.tga"
      building.upgrade2_mod_prop_id_1 = "automation"
      building.upgrade2_add_value_1 = 1
      building.upgrade2_mod_prop_id_2 = "auto_performance"
      building.upgrade2_add_value_2 = 150
      building.upgrade2_mod_prop_id_3 = "max_workers"
      building.upgrade2_mul_value_3 = -100
  elseif building.encyclopedia_id == "CloningVats"
  or building.encyclopedia_id == "DroneFactory"
  or building.encyclopedia_id == "ElectronicsFactory"
  or building.encyclopedia_id == "Farm"
  or building.encyclopedia_id == "FungalFarm"
  or building.encyclopedia_id == "FusionReactor"
  or building.encyclopedia_id == "HydroponicFarm"
  or building.encyclopedia_id == "Infirmary"
  or building.encyclopedia_id == "MedicalCenter"
  or building.encyclopedia_id == "NetworkNode"
  or building.encyclopedia_id == "RechargeStation"
  or building.encyclopedia_id == "ScienceInstitute"
  or building.encyclopedia_id == "ScienceInstitute"
  or building.encyclopedia_id == "SecurityStation"
  or building.encyclopedia_id == "SecurityStation" then
      building.upgrade3_id = "FullyAutomatedBuildings"
      building.upgrade3_display_name = "Fully Automated"
      building.upgrade3_description = "Fully Automated"
      building.upgrade3_icon = "UI/Icons/Upgrades/home_collective_01.tga"
      building.upgrade3_mod_prop_id_1 = "automation"
      building.upgrade3_add_value_1 = 1
      building.upgrade3_mod_prop_id_2 = "auto_performance"
      building.upgrade3_add_value_2 = 150
      building.upgrade3_mod_prop_id_3 = "max_workers"
      building.upgrade3_mul_value_3 = -100
    end
end

--used to add or remove traits from schools/sanitariums
function ChoGGi.BuildingsSetAll_Traits(Building,Traits,Nil)
  local Buildings = UICity.labels.Building
  for i = 1, #(Buildings or "") do
    local Obj = Buildings[i]
    if IsKindOf(Obj,Building) then
      for j = 1, #Traits do
        if Nil then
          Obj:SetTrait(j,nil)
        else
          Obj:SetTrait(j,Traits[j])
        end
      end
    end
  end
end

--stop these from happening
function ChoGGi.SetBlockCheatEmpty()
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

-- positive or 1 return TrueVar || negative or 0 return FalseVar
---Consts.XXX = ChoGGi.NumRetBool(Consts.XXX,0,ChoGGi.Consts.XXX)
function ChoGGi.NumRetBool(Num,TrueVar,FalseVar)
  local Bool = true
  if Num < 1 then
    Bool = nil
  end
  return Bool and TrueVar or FalseVar
end

--toggle 0/1
function ChoGGi.ToggleBoolNum(Num)
  if Num == 0 then
    return 1
  end
  return 0
end

--ChoGGi.ReturnTechAmount("HullPolarization","BuildingMaintenancePointsModifier")
--ChoGGi.ReturnTechAmount("TransportOptimization","max_shared_storage")
--ReturnTechAmount().a amount and .p percent
function ChoGGi.ReturnTechAmount(Tech,Prop)
  for i,_ in ipairs(TechTree) do
    for j,_ in ipairs(TechTree[i]) do
      if TechTree[i][j].id == Tech then
        for k,_ in ipairs(TechTree[i][j]) do
          if TechTree[i][j][k].Prop == Prop then
            local Tech = TechTree[i][j][k]
            local RetObj = {}
            if Tech.Percent then
              RetObj.p = Tech.Percent * -1 + 0.0 / 100 -- -5 > 5 > 5.0 > 0.05
            end
            if Tech.Amount then
              if Tech.Amount <= 0 then
                RetObj.a = Tech.Amount * -1
              else
                RetObj.a = Tech.Amount
              end
            end
            return RetObj
          end
        end
      end
    end
  end
end

--check if tech is researched before we set these consts (activated from menuitems)
function ChoGGi.BuildingMaintenancePointsModifier()
  if UICity and UICity:IsTechDiscovered("HullPolarization") then
    local p = ChoGGi.ReturnTechAmount("HullPolarization","BuildingMaintenancePointsModifier").p
    return ChoGGi.Consts.BuildingMaintenancePointsModifier * p
  end
  return ChoGGi.Consts.BuildingMaintenancePointsModifier
end
--
function ChoGGi.CargoCapacity()
  if UICity and UICity:IsTechDiscovered("FuelCompression") then
    local a = ChoGGi.ReturnTechAmount("FuelCompression","CargoCapacity").a
    return ChoGGi.Consts.CargoCapacity + a
  end
  return ChoGGi.Consts.CargoCapacity
end
--
function ChoGGi.CommandCenterMaxDrones()
  if UICity and UICity:IsTechDiscovered("DroneSwarm") then
    local a = ChoGGi.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones").a
    return ChoGGi.Consts.CommandCenterMaxDrones + a
  end
  return ChoGGi.Consts.CommandCenterMaxDrones
end
--
function ChoGGi.DroneResourceCarryAmount()
  if UICity and UICity:IsTechDiscovered("ArtificialMuscles") then
    local a = ChoGGi.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount").a
    return ChoGGi.Consts.DroneResourceCarryAmount + a
  end
  return ChoGGi.Consts.DroneResourceCarryAmount
end
--
function ChoGGi.LowSanityNegativeTraitChance()
  if UICity and UICity:IsTechDiscovered("SupportiveCommunity") then
    local p = ChoGGi.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance").p
    --[[
    LowSanityNegativeTraitChance = 30%
    SupportiveCommunity = -70%
    --]]
    local LowSan = ChoGGi.Consts.LowSanityNegativeTraitChance + 0.0 --SM has no math.funcs so + 0.0
    return p*LowSan/100*100
  end
  return ChoGGi.Consts.LowSanityNegativeTraitChance
end
--
function ChoGGi.MaxColonistsPerRocket()
  local PerRocket = ChoGGi.Consts.MaxColonistsPerRocket
  local a
  if UICity and UICity:IsTechDiscovered("CompactPassengerModule") then
    a = ChoGGi.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket").a
    PerRocket = PerRocket + a
  end
  if UICity and UICity:IsTechDiscovered("CryoSleep") then
    a = ChoGGi.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  return PerRocket
end
--
function ChoGGi.NonSpecialistPerformancePenalty()
  if UICity and UICity:IsTechDiscovered("GeneralTraining") then
    local a = ChoGGi.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty").a
    return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
  end
  return ChoGGi.Consts.NonSpecialistPerformancePenalty
end
--
function ChoGGi.RCRoverMaxDrones()
  if UICity and UICity:IsTechDiscovered("RoverCommandAI") then
    local a = ChoGGi.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones").a
    return ChoGGi.Consts.RCRoverMaxDrones + a
  end
  return ChoGGi.Consts.RCRoverMaxDrones
end
--
function ChoGGi.RCTransportGatherResourceWorkTime()
  if UICity and UICity:IsTechDiscovered("TransportOptimization") then
    local p = ChoGGi.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime").p
    return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
  end
  return ChoGGi.Consts.RCTransportGatherResourceWorkTime
end
--
function ChoGGi.RCTransportResourceCapacity()
  if UICity and UICity:IsTechDiscovered("TransportOptimization") then
    local a = ChoGGi.ReturnTechAmount("TransportOptimization","max_shared_storage").a
    return ChoGGi.Consts.RCTransportResourceCapacity + a
  end
  return ChoGGi.Consts.RCTransportResourceCapacity
end
--
function ChoGGi.TravelTimeEarthMars()
  if UICity and UICity:IsTechDiscovered("PlasmaRocket") then
    local p = ChoGGi.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars").p
    return ChoGGi.Consts.TravelTimeEarthMars * p
  end
  return ChoGGi.Consts.TravelTimeEarthMars
end
--
function ChoGGi.TravelTimeMarsEarth()
  if UICity and UICity:IsTechDiscovered("PlasmaRocket") then
    local p = ChoGGi.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth").p
    return ChoGGi.Consts.TravelTimeMarsEarth * p
  end
  return ChoGGi.Consts.TravelTimeMarsEarth
end

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: FuncGame.lua",true)
end

