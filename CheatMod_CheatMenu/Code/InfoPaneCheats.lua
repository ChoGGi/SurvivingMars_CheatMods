--add items to the cheat pane
function ChoGGi.InfoPaneCheats_ClassesGenerate()

--global objects
  function Building.CheatPowerless(self)
    if self.modifications.electricity_consumption then
      local mod = self.modifications.electricity_consumption[1]
      self.ChoGGi_mod_electricity_consumption = {
        amount = mod.amount,
        percent = mod.percent
      }
      mod:Change(0,0)
    end
    self:SetBase("electricity_consumption", 0)
  end
  function Building.CheatPowered(self)
    if self.ChoGGi_mod_electricity_consumption then
      local mod = self.modifications.electricity_consumption[1]
      local orig = self.ChoGGi_mod_electricity_consumption
      mod:Change(orig.amount,orig.percent)
      self.ChoGGi_mod_electricity_consumption = nil
    end
    local amount = DataInstances.BuildingTemplate[self.encyclopedia_id].electricity_consumption
    self:SetBase("electricity_consumption", amount)
  end
  function Object.CheatHideSigns(self)
    self:DestroyAttaches("BuildingSign")
  end
  function Object.CheatColourRandom(self)
    if self:IsKindOf("ColorizableObject") then
      local SetPal = self.SetColorizationMaterial
      local GetPal = self.GetColorizationMaterial
      --s,1,Color, Roughness, Metallic
      if not self.ChoGGi_origcolors then
        self.ChoGGi_origcolors = {}
        table.insert(self.ChoGGi_origcolors,{GetPal(self,1)})
        table.insert(self.ChoGGi_origcolors,{GetPal(self,2)})
        table.insert(self.ChoGGi_origcolors,{GetPal(self,3)})
        table.insert(self.ChoGGi_origcolors,{GetPal(self,4)})
      end
      SetPal(self, 1, UICity:Random(1,99999999), 0,0)
      SetPal(self, 2, UICity:Random(1,99999999), 0,0)
      SetPal(self, 3, UICity:Random(1,99999999), 0,0)
      SetPal(self, 4, UICity:Random(1,99999999), 0,0)
    end
  end
  function Object.CheatColourDefault(self)
    if self.ChoGGi_origcolors then
      local SetPal = self.SetColorizationMaterial
      local c = self.ChoGGi_origcolors
      SetPal(self,1, c[1][1], c[1][2], c[1][3])
      SetPal(self,2, c[2][1], c[2][2], c[2][3])
      SetPal(self,3, c[3][1], c[3][2], c[3][3])
      SetPal(self,4, c[4][1], c[4][2], c[4][3])
    end
  end
--colonists
  function Colonist.CheatFillMorale(self)
    self.stat_morale = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist.CheatFillSanity(self)
    self.stat_sanity = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist.CheatFillComfort(self)
    self.stat_comfort = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist.CheatFillHealth(self)
    self.stat_health = 100 * ChoGGi.Consts.ResourceScale
  end
  function Colonist.CheatFillAll(self)
    Colonist.CheatFillSanity(self)
    Colonist.CheatFillComfort(self)
    Colonist.CheatFillHealth(self)
    Colonist.CheatFillMorale(self)
  end
  function Colonist.CheatRenegade(self)
    self:AddTrait("Renegade",true)
  end
  function Colonist.CheatRenegadeClear(self)
    self:RemoveTrait("Renegade")
    CreateRealTimeThread(function()
      Sleep(100)
      Colonist.CheatFillMorale(self)
    end)
  end
  function Colonist.CheatRandomRace(self)
    self.race = UICity:Random(1,5)
    self:ChooseEntity()
  end
  function Colonist.CheatRandomSpec(self)
    --skip children, or they'll be a black cube
    if not self.entity:find("Child",1,true) then
      self:SetSpecialization(ChoGGi.ColonistSpecializations[UICity:Random(1,6)],"init")
    end
  end
  function Colonist.CheatPrefDbl(self)
    self.performance = self.performance * 2
  end
  function Colonist.CheatPrefDef(self)
    self.performance = self.base_performance
  end
  function Colonist.CheatRandomGender(self)
    ChoGGi.ColonistUpdateGender(self,ChoGGi.ColonistGenders[UICity:Random(1,5)])
  end
  function Colonist.CheatRandomAge(self)
    ChoGGi.ColonistUpdateAge(self,ChoGGi.ColonistAges[UICity:Random(1,6)])
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
    self.max_workers = 0
    self.automation = 1
    if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings then
      self.auto_performance = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings
    else
      self.auto_performance = 150
    end
    ChoGGi.ToggleWorking(self)
  end
  local function CheatWorkManual(self)
    self.max_workers = nil
    self.automation = nil
    self.auto_performance = nil
    ChoGGi.ToggleWorking(self)
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
--CheatProdDbl
  local function CheatProdDblWater(self)
    self.water_production = self.water.production * 2
    self.water:SetProduction(self.water_production)
  end
  local function CheatProdDefWater(self)
    self.water_production = self.base_water_production
    self.water:SetProduction(self.water_production)
  end
  MoistureVaporator.CheatProdDbl = CheatProdDblWater
  MoistureVaporator.CheatProdDef = CheatProdDefWater
  WaterExtractor.CheatProdDbl = CheatProdDblWater
  WaterExtractor.CheatProdDef = CheatProdDefWater
  --
  local function CheatProdDblElec(self)
    self.electricity_production = self.electricity.production * 2
    self.electricity:SetProduction(self.electricity_production)
  end
  local function CheatProdDefElec(self)
    self.electricity_production = self.base_electricity_production
    self.electricity:SetProduction(self.electricity_production)
  end
  FusionReactor.CheatProdDbl = CheatProdDblElec
  FusionReactor.CheatProdDef = CheatProdDefElec
  StirlingGenerator.CheatProdDbl = CheatProdDblElec
  StirlingGenerator.CheatProdDef = CheatProdDefElec
  WindTurbine.CheatProdDbl = CheatProdDblElec
  WindTurbine.CheatProdDef = CheatProdDefElec
  SolarPanel.CheatProdDbl = CheatProdDblElec
  SolarPanel.CheatProdDef = CheatProdDefElec
  ArtificialSun.CheatProdDbl = CheatProdDblElec
  ArtificialSun.CheatProdDef = CheatProdDefElec
  --
  function MOXIE.CheatProdDbl(self)
    self.air_production = self.air.production * 2
    self.air:SetProduction(self.air_production)
  end
  function MOXIE.CheatProdDef(self)
    self.air_production = self.base_air_production
    self.air:SetProduction(self.air_production)
  end
  --
  local function CheatProdDblProducer(self)
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  local function CheatProdDefProducer(self)
    self.producers[1].production_per_day = self.base_production_per_day1
  end
  RegolithExtractor.CheatProdDbl = CheatProdDblProducer
  RegolithExtractor.CheatProdDef = CheatProdDefProducer
  MetalsExtractor.CheatProdDbl = CheatProdDblProducer
  MetalsExtractor.CheatProdDef = CheatProdDefProducer
  PreciousMetalsExtractor.CheatProdDbl = CheatProdDblProducer
  PreciousMetalsExtractor.CheatProdDef = CheatProdDefProducer
  PolymerPlant.CheatProdDbl = CheatProdDblProducer
  PolymerPlant.CheatProdDef = CheatProdDefProducer
  ElectronicsFactory.CheatProdDbl = CheatProdDblProducer
  ElectronicsFactory.CheatProdDef = CheatProdDefProducer
  MachinePartsFactory.CheatProdDbl = CheatProdDblProducer
  MachinePartsFactory.CheatProdDef = CheatProdDefProducer
  FuelFactory.CheatProdDbl = CheatProdDblProducer
  FuelFactory.CheatProdDef = CheatProdDefProducer
  FarmHydroponic.CheatProdDbl = CheatProdDblProducer
  FarmHydroponic.CheatProdDef = CheatProdDefProducer
  FungalFarm.CheatProdDbl = CheatProdDblProducer
  FungalFarm.CheatProdDef = CheatProdDefProducer
  FarmConventional.CheatProdDbl = CheatProdDblProducer
  FarmConventional.CheatProdDef = CheatProdDefProducer
  TheExcavator.CheatProdDbl = CheatProdDblProducer
  TheExcavator.CheatProdDef = CheatProdDefProducer
  function MoholeMine:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
    self.producers[2].production_per_day = self.producers[2].production_per_day * 2
  end
  function MoholeMine:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
    self.producers[2].production_per_day = self.producers[2].base_production_per_day
  end
--CheatCapDbl storage
  function ElectricityStorage:CheatCapDbl()
    self.capacity = self.capacity * 2
    self.electricity.storage_capacity = self.capacity
    self.electricity.storage_mode = "charging"
    ChoGGi.ToggleWorking(self)
  end
  function ElectricityStorage:CheatCapDef()
    self.capacity = self.base_capacity
    self.electricity.storage_capacity = self.capacity
    self.electricity.storage_mode = "full"
    ChoGGi.ToggleWorking(self)
  end
  --
  function WaterTank:CheatCapDbl()
    self.water_capacity = self.water_capacity * 2
    self.water.storage_capacity = self.water_capacity
    self.water.storage_mode = "charging"
    ChoGGi.ToggleWorking(self)
  end
  function WaterTank:CheatCapDef()
    self.water_capacity = self.base_water_capacity
    self.water.storage_capacity = self.water_capacity
    self.water.storage_mode = "full"
    ChoGGi.ToggleWorking(self)
  end
  --
  function OxygenTank:CheatCapDbl()
    self.air_capacity = self.air_capacity * 2
    self.air.storage_capacity = self.air_capacity
    self.air.storage_mode = "charging"
    ChoGGi.ToggleWorking(self)
  end
  function OxygenTank:CheatCapDef()
    self.air_capacity = self.base_air_capacity
    self.air.storage_capacity = self.air_capacity
    self.air.storage_mode = "full"
    ChoGGi.ToggleWorking(self)
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
    self:SetMoveSpeed(self:GetMoveSpeed() * 2)
  end
  local function CheatMoveSpeedDef(self)
    self:SetMoveSpeed(self.base_move_speed)
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
    self:ApplyBatteryChange(self.battery_max)
  end
  ExplorerRover.CheatBattRefill = CheatBattRefill
  RCTransport.CheatBattRefill = CheatBattRefill
  Drone.CheatBattRefill = CheatBattRefill
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

end --OnMsg

function ChoGGi.InfopanelCheatsCleanup()
  Building.CheatAddMaintenancePnts = nil
  Building.CheatMakeSphereTarget = nil
  Building.CheatMalfunction = nil
  Building.CheatSpawnWorker = nil
  Building.CheatSpawnVisitor = nil
end


function ChoGGi.SetInfoPanelCheatHints(win)
  local obj = win.context
  local name = _InternalTranslate(obj.name)
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
  local tab = win.actions
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
      local tempname = _InternalTranslate(obj.upgrade1_display_name)
      if tempname ~= "" then
        SetHint(action,"Add: " .. tempname .. " to this building.\n\n" .. _InternalTranslate(obj.upgrade1_description))
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Upgrade2" then
      local tempname = _InternalTranslate(obj.upgrade2_display_name)
      if tempname ~= "" then
        SetHint(action,"Add: " .. tempname .. " to this building.\n\n" .. _InternalTranslate(obj.upgrade2_description))
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Upgrade3" then
      local tempname = _InternalTranslate(obj.upgrade3_display_name)
      if tempname ~= "" then
        SetHint(action,"Add: " .. tempname .. " to this building.\n\n" .. _InternalTranslate(obj.upgrade3_description))
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "WorkAuto" then
      local perf
      if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings then
        perf = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings
      else
        perf = 150
      end
      SetHint(action,"Make this " .. id .. " not need workers (performance: " .. perf .. ").")

    elseif action.ActionId == "WorkManual" then
      SetHint(action,"Make this " .. id .. " need workers.")
    elseif action.ActionId == "ProdDbl" then
      SetHint(action,"Double the production of this " .. id .. " (certain buildings will reset: Wind turbines and such).")
    elseif action.ActionId == "ProdDef" then
      SetHint(action,"Reset the production of this " .. id .. " to default.")
    elseif action.ActionId == "CapDbl" then
      SetHint(action,"Double the storage capacity of this " .. id .. ".")
    elseif action.ActionId == "CapDef" then
      SetHint(action,"Reset the storage capacity of this " .. id .. " to default.")
  --Farms
    elseif action.ActionId == "AllShifts" then
      SetHint(action,"Turn on all work shifts.")

  --RC
    elseif action.ActionId == "BattCapDbl" then
      SetHint(action,"Double capacity of battery.")
    elseif action.ActionId == "MaxShuttlesDbl" then
      SetHint(action,"Double the shuttles this ShuttleHub can control.")

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
      SetHint(action,"Hides any signs above object (until state is changed).")
    elseif action.ActionId == "ColourRandom" then
      SetHint(action,"Changes colour of object to random colour (doesn't touch attachments).")
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
