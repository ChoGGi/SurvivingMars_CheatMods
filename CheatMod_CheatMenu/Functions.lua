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

  --set consts to saved ones
  if ChoGGi.SettingsFileLoaded then
    ChoGGi.SetSettings()
  end
end

function restart()
  quit("restart")
end
function dump(Obj,Mode,File,Ext)
  ChoGGi.Dump(Obj,Mode,File,Ext)
end
function dumptable(Obj,Mode,File,Ext)
  ChoGGi.DumpTable(Obj,Mode,Funcs)
end
function dumpobject(Obj,Mode,File,Ext)
  ChoGGi.DumpObject(Obj,Mode,Funcs)
end

function alert(Msg,Title,Icon)
  ChoGGi.MsgPopup(Msg,Title,Icon)
end

function ChoGGi.MsgPopup(Msg,Title,Icon)
  Msg = Msg or ""
  Title = Title or "Placeholder"
  Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
  CreateRealTimeThread(AddCustomOnScreenNotification(
    AsyncRand(),Title,"" .. Msg,Icon,nil,{expiration=5000})
  )
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

--debug stuff
function ChoGGi.MsgPopup2(Msg,Title,Icon)
  Msg = Msg or ""
  Title = Title or "Placeholder"
  Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
  CreateRealTimeThread(AddCustomOnScreenNotification(
    AsyncRand(),Title,Msg,Icon,nil,{expiration=5000})
  )
end

function ChoGGi.Dump(Obj,Mode,File,Ext,Skip)
  Mode = Mode or "a"
  Ext = Ext or "txt"
  File = File or "DumpedText"
  local tempfile = assert(io.open("AppData/" .. File .. "." .. Ext,Mode))
  tempfile:write(tostring(Obj))
  tempfile:close()
  if not Skip then
    ChoGGi.MsgPopup("Dumped: " .. tostring(Obj),
      "AppData/" .. File .. "." .. Ext,"UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
  end
end

--redirect print to consolelog
function ChoGGi.AddConsoleLog(...)
  if ... then
    AddConsoleLog(...,true)
  end
  ChoGGi.print(...)
end

function ChoGGi.WriteDebugLogsEnable()
  --remove old logs
  os.remove("AppData/Printf.previous.log")
  os.remove("AppData/DebugPrint.previous.log")
  os.rename("AppData/Printf.log","AppData/Printf.previous.log")
  os.rename("AppData/DebugPrint.log","AppData/DebugPrint.previous.log")

  ChoGGi.printf = printf
  printf = function(...)
    ChoGGi.Dump(... .. "\n","a","printf","log",true)
    ChoGGi.printf(...)
  end
  DebugPrint = function(...)
    ChoGGi.Dump(... .. "\n","a","DebugPrint","log",true)
  end
  OutputDebugString = function(...)
    ChoGGi.Dump(... .. "\n","a","DebugPrint","log",true)
  end
end

--ChoGGi.PrintIds(TechTree)
function ChoGGi.PrintIds(Table)
  local text = ""
  for i,_ in ipairs(Table) do
    text = text .. "----------------- " .. Table[i].id .. ": " .. i .. "\n"
    for j,_ in ipairs(Table[i]) do
      text = text .. Table[i][j].id .. ": " .. j .. "\n"
    end
  end
  dump(text)
end

--[[
ChoGGi.TextFile = assert(io.open("AppData/DumpedTable.txt","w"))
ChoGGi.DumpTable(TechTree)
ChoGGi.TextFile:close()

if you want to dump functions as well DumpTable(TechTree,nil,true)
--]]
function ChoGGi.DumpTable(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end
  Mode = Mode or "a"
  ChoGGi.TextFile = assert(io.open("AppData/DumpedText.txt",Mode))
  ChoGGi.DumpTableFunc(Obj,nil,Funcs)
  ChoGGi.TextFile:close()
  ChoGGi.MsgPopup("Dumped: " .. tostring(Obj),
    "AppData/DumpedText.txt","UI/Icons/Upgrades/magnetic_filtering_04.tga"
  )
end

function ChoGGi.DumpTableFunc(Obj,hierarchyLevel,Funcs)
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  if Obj.id then
    ChoGGi.TextFile:write("\n-----------------Obj.id: " .. Obj.id .. " :")
  end
  if (type(Obj) == "table") then
    for k,v in pairs(Obj) do
      if (type(v) == "table") then
        ChoGGi.DumpTableFunc(v, hierarchyLevel+1)
      else
        if k ~= nil then
          ChoGGi.TextFile:write("\n" .. tostring(k) .. " = ")
        end
        if v ~= nil then
          ChoGGi.TextFile:write(tostring(ChoGGi.RetTextForDump(v,Funcs)))
        end
        ChoGGi.TextFile:write("\n")
      end
    end
  end
end

--[[
ChoGGi.DumpObject(Consts)
ChoGGi.DumpObject(const)
if you want to dump functions as well DumpObject(object,true)
--]]
function ChoGGi.DumpObject(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end

  local Text = ""
  for k,v in pairs(Obj) do
    if k ~= nil then
      Text = Text .. "\n" .. tostring(k) .. " = "
    end
    if v ~= nil then
      Text = Text .. tostring(ChoGGi.RetTextForDump(v,Funcs))
    end
    --Text = Text .. "\n"
  end
  ChoGGi.Dump(Text,Mode)
--[[
  tech = ""
  for k,i in ipairs(Obj) do
    tech = tech .. ChoGGi.RetTextForDump(k[i]) .. "\n"
  end
  tech = tech .. "\n\n\n"
  ChoGGi.Dump(tech)
--]]
end

function ChoGGi.RetTextForDump(Obj,Funcs)
  if type(Obj) == "userdata" then
    return tostring(Obj) .. ": " .. tostring(getmetatable(Obj) or {})
  elseif Funcs and type(Obj) == "function" then
    return "Func: \n\n" .. string.dump(Obj) .. "\n\n"
  elseif type(Obj) == "table" then
    return tostring(Obj) .. " len: " .. #Obj
  else
    return tostring(Obj)
  end
end

--list active user actions (menuitem entries)
--UserActions.IsActionActive(id)
--[[
UserActions.RemoveActions({
  "G_ToggleInfopanelCheats",
})
--]]
function ChoGGi.GetActiveActions()
  local ActiveActions = {}
  for id,_ in pairs(UserActions.Actions) do
    if UserActions.IsActionActive(id) then
      ActiveActions[#ActiveActions + 1] = id .. "\n"
    end
  end
  --ChoGGi.Dump(ActiveActions)
  return ActiveActions
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: Functions.lua",true)
end

