--See LICENSE for terms

--add items to the cheats pane
function ChoGGi.MsgFuncs.InfoPaneCheats_ClassesGenerate()

--global objects
  function Building:CheatPowerless()
    ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
  end
  function Building:CheatPowered()
    --if this is here we know it has what we need so no need to check for mod/consump
    if self.ChoGGi_mod_electricity_consumption then
      local mod = self.modifications.electricity_consumption
      if mod[1] then
        mod = mod[1]
      end
      local orig = self.ChoGGi_mod_electricity_consumption
      if mod:IsKindOf("ObjectModifier") then
        mod:Change(orig.amount,orig.percent)
      else
        mod.amount = orig.amount
        mod.percent = orig.percent
      end
      self.ChoGGi_mod_electricity_consumption = nil
    end
    local amount = DataInstances.BuildingTemplate[self.encyclopedia_id].electricity_consumption
    self:SetBase("electricity_consumption", amount)
  end

  local function CheatHideSigns(self)
    self:DestroyAttaches("BuildingSign")
  end
  local function CheatColourRandom(self)
    ChoGGi.CodeFuncs.ObjectColourRandom(self)
  end
  local function CheatColourDefault(self)
    ChoGGi.CodeFuncs.ObjectColourDefault(self)
  end
  Unit.CheatHideSigns = CheatHideSigns
  Unit.CheatColourRandom = CheatColourRandom
  Unit.CheatColourDefault = CheatColourDefault
  Building.CheatHideSigns = CheatHideSigns
  Building.CheatColourRandom = CheatColourRandom
  Building.CheatColourDefault = CheatColourDefault
--colonists
  function Colonist:CheatFillMorale()
    self.stat_morale = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist:CheatFillSanity()
    self.stat_sanity = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist:CheatFillComfort()
    self.stat_comfort = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist:CheatFillHealth()
    self.stat_health = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist:CheatFillAll()
    Colonist.CheatFillSanity(self)
    Colonist.CheatFillComfort(self)
    Colonist.CheatFillHealth(self)
    Colonist.CheatFillMorale(self)
  end
  function Colonist:CheatRenegade()
    self:AddTrait("Renegade",true)
  end
  function Colonist:CheatRenegadeClear()
    self:RemoveTrait("Renegade")
    CreateRealTimeThread(function()
      Sleep(100)
      Colonist.CheatFillMorale(self)
    end)
  end
  function Colonist:CheatRandomRace()
    self.race = UICity:Random(1,5)
    self:ChooseEntity()
  end
  function Colonist:CheatRandomSpec()
    --skip children, or they'll be a black cube
    if not self.entity:find("Child",1,true) then
      self:SetSpecialization(ChoGGi.Tables.ColonistSpecializations[UICity:Random(1,6)],"init")
    end
  end
  function Colonist:CheatPrefDbl()
    self.performance = self.performance * 2
  end
  function Colonist:CheatPrefDef()
    self.performance = self.base_performance
  end
  function Colonist:CheatRandomGender()
    ChoGGi.CodeFuncs.ColonistUpdateGender(self,ChoGGi.Tables.ColonistGenders[UICity:Random(1,5)])
  end
  function Colonist:CheatRandomAge()
    ChoGGi.CodeFuncs.ColonistUpdateAge(self,ChoGGi.Tables.ColonistAges[UICity:Random(1,6)])
  end
--CheatAllShifts
  local function CheatAllShiftsOn(self)
    self.closed_shifts[1] = false
    self.closed_shifts[2] = false
    self.closed_shifts[3] = false
  end
  FungalFarm.CheatAllShiftsOn = CheatAllShiftsOn
  FarmConventional.CheatAllShiftsOn = CheatAllShiftsOn
  FarmHydroponic.CheatAllShiftsOn = CheatAllShiftsOn
--CheatFullyAuto
  local function CheatWorkersDbl(self)
    self.max_workers = self.max_workers * 2
  end
  local function CheatWorkersDef(self)
    self.max_workers = self.base_max_workers
  end
  local function CheatWorkAuto(self)
    local ChoGGi = ChoGGi
    self.max_workers = 0
    self.automation = 1
    local bs = ChoGGi.UserSettings.BuildingSettings
    bs = bs and bs[self.encyclopedia_id] and bs[self.encyclopedia_id].performance or 150
    self.auto_performance = bs
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  local function CheatWorkManual(self)
    self.max_workers = nil
    self.automation = nil
    self.auto_performance = nil
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  DroneFactory.CheatWorkAuto = CheatWorkAuto
  DroneFactory.CheatWorkManual = CheatWorkManual
  DroneFactory.CheatWorkersDbl = CheatWorkersDbl
  DroneFactory.CheatWorkersDef = CheatWorkersDef
  MedicalCenter.CheatWorkAuto = CheatWorkAuto
  MedicalCenter.CheatWorkManual = CheatWorkManual
  MedicalCenter.CheatWorkersDbl = CheatWorkersDbl
  MedicalCenter.CheatWorkersDef = CheatWorkersDef
  NetworkNode.CheatWorkAuto = CheatWorkAuto
  NetworkNode.CheatWorkManual = CheatWorkManual
  NetworkNode.CheatWorkersDbl = CheatWorkersDbl
  NetworkNode.CheatWorkersDef = CheatWorkersDef
  CloningVats.CheatWorkAuto = CheatWorkAuto
  CloningVats.CheatWorkManual = CheatWorkManual
  CloningVats.CheatWorkersDbl = CheatWorkersDbl
  CloningVats.CheatWorkersDef = CheatWorkersDef
  WaterReclamationSpire.CheatWorkAuto = CheatWorkAuto
  WaterReclamationSpire.CheatWorkManual = CheatWorkManual
  WaterReclamationSpire.CheatWorkersDbl = CheatWorkersDbl
  WaterReclamationSpire.CheatWorkersDef = CheatWorkersDef
  BaseResearchLab.CheatWorkAuto = CheatWorkAuto
  BaseResearchLab.CheatWorkManual = CheatWorkManual
  BaseResearchLab.CheatWorkersDbl = CheatWorkersDbl
  BaseResearchLab.CheatWorkersDef = CheatWorkersDef
  SecurityStation.CheatWorkAuto = CheatWorkAuto
  SecurityStation.CheatWorkManual = CheatWorkManual
  SecurityStation.CheatWorkersDbl = CheatWorkersDbl
  SecurityStation.CheatWorkersDef = CheatWorkersDef
  CasinoComplex.CheatWorkAuto = CheatWorkAuto
  CasinoComplex.CheatWorkManual = CheatWorkManual
  CasinoComplex.CheatWorkersDbl = CheatWorkersDbl
  CasinoComplex.CheatWorkersDef = CheatWorkersDef
  Spacebar.CheatWorkAuto = CheatWorkAuto
  Spacebar.CheatWorkManual = CheatWorkManual
  Spacebar.CheatWorkersDbl = CheatWorkersDbl
  Spacebar.CheatWorkersDef = CheatWorkersDef
  ServiceWorkplace.CheatWorkAuto = CheatWorkAuto
  ServiceWorkplace.CheatWorkManual = CheatWorkManual
  ServiceWorkplace.CheatWorkersDbl = CheatWorkersDbl
  ServiceWorkplace.CheatWorkersDef = CheatWorkersDef
  Diner.CheatWorkAuto = CheatWorkAuto
  Diner.CheatWorkManual = CheatWorkManual
  Diner.CheatWorkersDbl = CheatWorkersDbl
  Diner.CheatWorkersDef = CheatWorkersDef
  MachinePartsFactory.CheatWorkAuto = CheatWorkAuto
  MachinePartsFactory.CheatWorkManual = CheatWorkManual
  MachinePartsFactory.CheatWorkersDbl = CheatWorkersDbl
  MachinePartsFactory.CheatWorkersDef = CheatWorkersDef
  ElectronicsFactory.CheatWorkAuto = CheatWorkAuto
  ElectronicsFactory.CheatWorkManual = CheatWorkManual
  ElectronicsFactory.CheatWorkersDbl = CheatWorkersDbl
  ElectronicsFactory.CheatWorkersDef = CheatWorkersDef
  Infirmary.CheatWorkAuto = CheatWorkAuto
  Infirmary.CheatWorkManual = CheatWorkManual
  Infirmary.CheatWorkersDbl = CheatWorkersDbl
  Infirmary.CheatWorkersDef = CheatWorkersDef
  Grocery.CheatWorkAuto = CheatWorkAuto
  Grocery.CheatWorkManual = CheatWorkManual
  Grocery.CheatWorkersDbl = CheatWorkersDbl
  Grocery.CheatWorkersDef = CheatWorkersDef
  FungalFarm.CheatWorkAuto = CheatWorkAuto
  FungalFarm.CheatWorkManual = CheatWorkManual
  FungalFarm.CheatWorkersDbl = CheatWorkersDbl
  FungalFarm.CheatWorkersDef = CheatWorkersDef
  PolymerPlant.CheatWorkAuto = CheatWorkAuto
  PolymerPlant.CheatWorkManual = CheatWorkManual
  PolymerPlant.CheatWorkersDbl = CheatWorkersDbl
  PolymerPlant.CheatWorkersDef = CheatWorkersDef
  FarmConventional.CheatWorkAuto = CheatWorkAuto
  FarmConventional.CheatWorkManual = CheatWorkManual
  FarmConventional.CheatWorkersDbl = CheatWorkersDbl
  FarmConventional.CheatWorkersDef = CheatWorkersDef
  FarmHydroponic.CheatWorkAuto = CheatWorkAuto
  FarmHydroponic.CheatWorkManual = CheatWorkManual
  FarmHydroponic.CheatWorkersDbl = CheatWorkersDbl
  FarmHydroponic.CheatWorkersDef = CheatWorkersDef
  MetalsExtractor.CheatWorkAuto = CheatWorkAuto
  MetalsExtractor.CheatWorkManual = CheatWorkManual
  MetalsExtractor.CheatWorkersDbl = CheatWorkersDbl
  MetalsExtractor.CheatWorkersDef = CheatWorkersDef
  PreciousMetalsExtractor.CheatWorkAuto = CheatWorkAuto
  PreciousMetalsExtractor.CheatWorkManual = CheatWorkManual
  PreciousMetalsExtractor.CheatWorkersDbl = CheatWorkersDbl
  PreciousMetalsExtractor.CheatWorkersDef = CheatWorkersDef
  FusionReactor.CheatWorkAuto = CheatWorkAuto
  FusionReactor.CheatWorkManual = CheatWorkManual
  FusionReactor.CheatWorkersDbl = CheatWorkersDbl
  FusionReactor.CheatWorkersDef = CheatWorkersDef
--CheatDoubleMaxAmount
  local function CheatDoubleMaxAmount(self)
    self.max_amount = self.max_amount * 2
  end
  SubsurfaceDepositMetals.CheatDoubleMaxAmount = CheatDoubleMaxAmount
  SubsurfaceDepositWater.CheatDoubleMaxAmount = CheatDoubleMaxAmount
  SubsurfaceDepositPreciousMetals.CheatDoubleMaxAmount = CheatDoubleMaxAmount
  SurfaceDepositGroup.CheatDoubleMaxAmount = CheatDoubleMaxAmount
--CheatCapDbl storage
  function ElectricityStorage:CheatCapDbl()
    self.capacity = self.capacity * 2
    self.electricity.storage_capacity = self.capacity
    self.electricity.storage_mode = "charging"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function ElectricityStorage:CheatCapDef()
    self.capacity = self.base_capacity
    self.electricity.storage_capacity = self.capacity
    self.electricity.storage_mode = "full"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  --
  function WaterTank:CheatCapDbl()
    self.water_capacity = self.water_capacity * 2
    self.water.storage_capacity = self.water_capacity
    self.water.storage_mode = "charging"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function WaterTank:CheatCapDef()
    self.water_capacity = self.base_water_capacity
    self.water.storage_capacity = self.water_capacity
    self.water.storage_mode = "full"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  --
  function OxygenTank:CheatCapDbl()
    self.air_capacity = self.air_capacity * 2
    self.air.storage_capacity = self.air_capacity
    self.air.storage_mode = "charging"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function OxygenTank:CheatCapDef()
    self.air_capacity = self.base_air_capacity
    self.air.storage_capacity = self.air_capacity
    self.air.storage_mode = "full"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  --
--CheatCapDbl people
  local function CheatColonistCapDbl(self)
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  local function CheatColonistCapDef(self)
    self.capacity = self.base_capacity
  end
  Arcology.CheatColonistCapDbl = CheatColonistCapDbl
  Arcology.CheatColonistCapDef = CheatColonistCapDef
  SmartHome.CheatColonistCapDbl = CheatColonistCapDbl
  SmartHome.CheatColonistCapDef = CheatColonistCapDef
  Nursery.CheatColonistCapDbl = CheatColonistCapDbl
  Nursery.CheatColonistCapDef = CheatColonistCapDef
  Apartments.CheatColonistCapDbl = CheatColonistCapDbl
  Apartments.CheatColonistCapDef = CheatColonistCapDef
  LivingQuarters.CheatColonistCapDbl = CheatColonistCapDbl
  LivingQuarters.CheatColonistCapDef = CheatColonistCapDef
--CheatVisitorsDbl
  local function CheatVisitorsDbl(self)
    if self.max_visitors == 4096 then
      return
    end
    self.max_visitors = self.max_visitors * 2
  end
  local function CheatVisitorsDef(self)
    self.max_visitors = self.base_max_visitors
  end
  CasinoComplex.CheatVisitorsDbl = CheatVisitorsDbl
  CasinoComplex.CheatVisitorsDef = CheatVisitorsDef
  Diner.CheatVisitorsDbl = CheatVisitorsDbl
  Diner.CheatVisitorsDef = CheatVisitorsDef
  Grocery.CheatVisitorsDbl = CheatVisitorsDbl
  Grocery.CheatVisitorsDef = CheatVisitorsDef
  HangingGardens.CheatVisitorsDbl = CheatVisitorsDbl
  HangingGardens.CheatVisitorsDef = CheatVisitorsDef
  Infirmary.CheatVisitorsDbl = CheatVisitorsDbl
  Infirmary.CheatVisitorsDef = CheatVisitorsDef
  MedicalCenter.CheatVisitorsDbl = CheatVisitorsDbl
  MedicalCenter.CheatVisitorsDef = CheatVisitorsDef
  OpenAirGym.CheatVisitorsDbl = CheatVisitorsDbl
  OpenAirGym.CheatVisitorsDef = CheatVisitorsDef
  Playground.CheatVisitorsDbl = CheatVisitorsDbl
  Playground.CheatVisitorsDef = CheatVisitorsDef
  ServiceWorkplace.CheatVisitorsDbl = CheatVisitorsDbl
  ServiceWorkplace.CheatVisitorsDef = CheatVisitorsDef
  Spacebar.CheatVisitorsDbl = CheatVisitorsDbl
  Spacebar.CheatVisitorsDef = CheatVisitorsDef
  MartianUniversity.CheatVisitorsDbl = CheatVisitorsDbl
  MartianUniversity.CheatVisitorsDef = CheatVisitorsDef
  Sanatorium.CheatVisitorsDbl = CheatVisitorsDbl
  Sanatorium.CheatVisitorsDef = CheatVisitorsDef
  School.CheatVisitorsDbl = CheatVisitorsDbl
  School.CheatVisitorsDef = CheatVisitorsDef
  --
--Double Shuttles
  function ShuttleHub:CheatMaxShuttlesDbl()
    self.max_shuttles = self.max_shuttles * 2
  end
  function ShuttleHub:CheatMaxShuttlesDef()
    self.max_shuttles = self.base_max_shuttles
  end
--CheatBattCapDbl
  local function CheatBattCapDbl(self)
    self.battery_max = self.battery_max * 2
  end
  local function CheatBattCapDef(self)
    self.battery_max = const.BaseRoverMaxBattery
  end
  ExplorerRover.CheatBattCapDbl = CheatBattCapDbl
  ExplorerRover.CheatBattCapDef = CheatBattCapDef
  RCTransport.CheatBattCapDbl = CheatBattCapDbl
  RCTransport.CheatBattCapDef = CheatBattCapDef
  RCRover.CheatBattCapDbl = CheatBattCapDbl
  RCRover.CheatBattCapDef = CheatBattCapDef
  Drone.CheatBattCapDbl = CheatBattCapDbl
  Drone.CheatBattCapDef = CheatBattCapDef
--CheatMoveSpeedDbl
  local function CheatMoveSpeedDbl(self)
    --self:SetMoveSpeed(self:GetMoveSpeed() * 2)
    pf.SetStepLen(Obj,self:GetMoveSpeed() * 2)
  end
  local function CheatMoveSpeedDef(self)
    --self:SetMoveSpeed(self.base_move_speed)
    pf.SetStepLen(Obj,self.base_move_speed)
  end
  ExplorerRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  ExplorerRover.CheatMoveSpeedDef = CheatMoveSpeedDef
  RCTransport.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  RCTransport.CheatMoveSpeedDef = CheatMoveSpeedDef
  RCRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  RCRover.CheatMoveSpeedDef = CheatMoveSpeedDef
  Drone.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  Drone.CheatMoveSpeedDef = CheatMoveSpeedDef
  local function CheatBattRefill(self)
    self.battery_current = self.battery_max
  end
  ExplorerRover.CheatBattRefill = CheatBattRefill
  RCTransport.CheatBattRefill = CheatBattRefill
  RCRover.CheatBattRefill = CheatBattRefill
  function Drone:CheatBattRefill()
    self.battery = self.battery_max
  end
  local function CheatFindResource(self)
    ChoGGi.CodeFuncs.FindNearestResource(self)
  end
  RCTransport.CheatFindResource = CheatFindResource
  Drone.CheatFindResource = CheatFindResource

--CheatCleanAndFix
  local function CheatCleanAndFix(self)
    self:CheatMalfunction()
    CreateRealTimeThread(function()
      self:Repair()
   end)
  end
  local function CheatCleanAndFixDrone(self)
    self:CheatMalfunction()
    CreateRealTimeThread(function()
      self.auto_connect = false
      if self.malfunction_end_state then
        self:PlayState(self.malfunction_end_state, 1)
        if not IsValid(self) then
          return
        end
      end
      self:SetState("idle")
      self:AddDust(-self.dust_max)
      self.command = ""
      self:SetCommand("Idle")
      RebuildInfopanel(self)
   end)
  end

  ExplorerRover.CheatCleanAndFix = CheatCleanAndFix
  RCTransport.CheatCleanAndFix = CheatCleanAndFix
  RCRover.CheatCleanAndFix = CheatCleanAndFix
  Drone.CheatCleanAndFix = CheatCleanAndFixDrone
--misc
  function SecurityStation:CheatReneagadeCapDbl()
    self.negated_renegades = self.negated_renegades * 2
  end
  function SecurityStation:CheatReneagadeCapDef()
    self.negated_renegades = self.max_negated_renegades
  end
  function MechanizedDepot:CheatEmptyDepot()
    ChoGGi.CodeFuncs.EmptyMechDepot(self)
  end
  --[[
  function SupplyRocket:CheatCapDbl()
    self.max_export_storage = self.max_export_storage * 2
  end
  function SupplyRocket:CheatCapDef()
    self.max_export_storage = self.base_max_export_storage
  end
--]]
end --OnMsg

function ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  Building.CheatAddMaintenancePnts = nil
  Building.CheatMakeSphereTarget = nil
  Building.CheatSpawnWorker = nil
  Building.CheatSpawnVisitor = nil
  --Building.CheatMalfunction = nil
end

function ChoGGi.InfoFuncs.SetInfoPanelCheatHints(win)
  local obj = win.context
  local name = ChoGGi.CodeFuncs.Trans(obj.name)
  local id = obj.encyclopedia_id
  local doublec = ""
  local resetc = ""
  if id then
    doublec = "Double the amount of colonist slots for this " .. id .. ".\n\nReselect to update display."
    resetc = "Reset the capacity of colonist slots for this " .. id .. " to default.\n\nReselect to update display."
  end
  local function SetHint(action,hint)
    --name has to be set to make the hint show up
    action.ActionName = action.ActionId
    action.RolloverHint = hint
  end
  local tab = win.actions or empty_table
  for i = 1, #tab do
    local action = tab[i]

--Colonists
    if action.ActionId == "FillAll" then
      SetHint(action,"Fill all stat bars.")
    elseif action.ActionId == "PrefDbl" then
      SetHint(action,"Double " .. name .. "'s performance.")
    elseif action.ActionId == "PrefDef" then
      SetHint(action,"Reset " .. name .. "'s performance to default.")
    elseif action.ActionId == "RandomSpecialization" then
      SetHint(action,"Randomly set " .. name .. "'s specialization.")

--Buildings
    elseif action.ActionId == "VisitorsDbl" then
      SetHint(action,doublec)
    elseif action.ActionId == "VisitorsDef" then
      SetHint(action,resetc)
    elseif action.ActionId == "WorkersDbl" then
      SetHint(action,doublec)
    elseif action.ActionId == "WorkersDef" then
      SetHint(action,resetc)
    elseif action.ActionId == "ColonistCapDbl" then
      SetHint(action,doublec)
    elseif action.ActionId == "ColonistCapDef" then
      SetHint(action,resetc)

    elseif action.ActionId == "Upgrade1" then
      local tempname = ChoGGi.CodeFuncs.Trans(obj.upgrade1_display_name)
      if tempname ~= "" then
        SetHint(action,"Add: " .. tempname .. " to this building.\n\n" .. ChoGGi.CodeFuncs.Trans(obj.upgrade1_description))
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Upgrade2" then
      local tempname = ChoGGi.CodeFuncs.Trans(obj.upgrade2_display_name)
      if tempname ~= "" then
        SetHint(action,"Add: " .. tempname .. " to this building.\n\n" .. ChoGGi.CodeFuncs.Trans(obj.upgrade2_description))
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Upgrade3" then
      local tempname = ChoGGi.CodeFuncs.Trans(obj.upgrade3_display_name)
      if tempname ~= "" then
        SetHint(action,"Add: " .. tempname .. " to this building.\n\n" .. ChoGGi.CodeFuncs.Trans(obj.upgrade3_description))
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "WorkAuto" then
      local perf
      local bs = ChoGGi.UserSettings.BuildingSettings
      bs = bs and bs[id] and bs[id].performance or 150
      SetHint(action,"Make this " .. id .. " not need workers (performance: " .. bs .. ").")

    elseif action.ActionId == "WorkManual" then
      SetHint(action,"Make this " .. id .. " need workers.")
    elseif action.ActionId == "CapDbl" then
      if obj:IsKindOf("SupplyRocket") then
        SetHint(action,"Double the export storage capacity of this " .. id .. ".")
      else
        SetHint(action,"Double the storage capacity of this " .. id .. ".")
      end
    elseif action.ActionId == "CapDef" then
      SetHint(action,"Reset the storage capacity of this " .. id .. " to default.")
    elseif action.ActionId == "EmptyDepot" then
      SetHint(action,"sticks small depot in front of mech depot and moves all resources to it (max of 20 000).")

--Farms
    elseif action.ActionId == "AllShifts" then
      SetHint(action,"Turn on all work shifts.")

--RC
    elseif action.ActionId == "BattCapDbl" then
      SetHint(action,"Double capacity of battery.")
    elseif action.ActionId == "MaxShuttlesDbl" then
      SetHint(action,"Double the shuttles this ShuttleHub can control.")
    elseif action.ActionId == "FindResource" then
      SetHint(action,"Selects nearest storage containing specified resource (shows list of resources).")

--Misc
    elseif action.ActionId == "Powerless" then
      if obj.electricity_consumption then
        SetHint(action,"Change this " .. id .. " so it doesn't need a power connection.")
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Powered" then
      if obj.electricity_consumption then
        SetHint(action,"Change this " .. id .. " so it needs a power connection.")
      else
        action.ActionId = nil
      end

    elseif action.ActionId == "HideSigns" then
      if obj:IsKindOf("SurfaceDeposit") or obj:IsKindOf("SubsurfaceDeposit") or obj:IsKindOf("WasteRockDumpSite") or obj:IsKindOf("UniversalStorageDepot") then
        action.ActionId = nil
      else
        SetHint(action,"Hides any signs above object (until state is changed).")
      end

    elseif action.ActionId == "ColourRandom" then
      if obj:IsKindOf("WasteRockDumpSite") then
        action.ActionId = nil
      else
        SetHint(action,"Changes colour of object to random colour (doesn't touch attachments).")
      end
    elseif action.ActionId == "ColourDefault" then
      if obj:IsKindOf("WasteRockDumpSite") then
        action.ActionId = nil
      end
    elseif action.ActionId == "AddDust" then
      if obj.class == "SupplyRocket" or obj.class == "UniversalStorageDepot" or obj.class == "WasteRockDumpSite" then
        action.ActionId = false
      else
        SetHint(action,"Add visual dust and maintenance points.")
      end
    elseif action.ActionId == "CleanAndFix" then
      if obj.class == "SupplyRocket" or obj.class == "UniversalStorageDepot" or obj.class == "WasteRockDumpSite" then
        action.ActionId = nil
      else
        SetHint(action,"You may need to use AddDust before using this to make the building look visually.")
      end
    elseif action.ActionId == "Destroy" then
      if obj.class == "SupplyRocket" then
        action.ActionId = nil
      else
        SetHint(action,"Turns object into ruin.")
      end
    elseif action.ActionId == "Empty" then
      if obj.class:find("SubsurfaceDeposit") then
        SetHint(action,"Warning: This will remove the " .. id .. " object from the map.")
      else
        SetHint(action,"Empties the storage of this building.\n\nExcluding waste rock in something other than a dumping site.")
      end
    elseif action.ActionId == "Refill" then
      SetHint(action,"Refill the deposit to full capacity.")
    elseif action.ActionId == "Fill" then
      SetHint(action,"Fill the storage of this building.")
    elseif action.ActionId == "Launch" then
      SetHint(action,"Warning: Launches rocket without asking.")
    elseif action.ActionId == "DoubleMaxAmount" then
      SetHint(action,"Double the amount this " .. id .. " can hold.")
    elseif action.ActionId == "ReneagadeCapDbl" then
      SetHint(action,"Double amount of reneagades this station can negate (currently: " .. obj.negated_renegades .. ") < Reselect to update amount.")
    end

  end --for
end
