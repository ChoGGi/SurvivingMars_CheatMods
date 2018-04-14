--add items to the cheat pane
function ChoGGi.InfoPaneCheats_ClassesGenerate()

  function Colonist.CheatFillAll(self)
    self.stat_morale = 100 * ChoGGi.Consts.ResourceScale
    self.stat_sanity = 100 * ChoGGi.Consts.ResourceScale
    self.stat_comfort = 100 * ChoGGi.Consts.ResourceScale
    self.stat_health = 100 * ChoGGi.Consts.ResourceScale
  end
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
  function Colonist.CheatRandomSpecialization(self)
    --skip children, or they'll be a black cube
    if not self.entity:find("Child",1,true) then
      self:SetSpecialization(ChoGGi.ColonistSpecializations[UICity:Random(1,6)],"init")
    end
  end
  function Colonist.CheatBoostPref(self)
    self.performance = 250
  end
  function Colonist.CheatRandomGender(self)
    ChoGGi.ColonistUpdateSex(self,ChoGGi.ColonistGenders[UICity:Random(1,5)])
  end
  function Colonist.CheatRandomAge(self)
    ChoGGi.ColonistUpdateAge(self,ChoGGi.ColonistAges[UICity:Random(1,6)])
  end
--CheatAllShifts
  local function CheatAllShifts(self)
    self.closed_shifts[1] = false
    self.closed_shifts[2] = false
    self.closed_shifts[3] = false
  end
  FungalFarm.CheatAllShifts = CheatAllShifts
  FarmConventional.CheatAllShifts = CheatAllShifts
  FarmHydroponic.CheatAllShifts = CheatAllShifts
--CheatFullyAuto
  local function CheatWorkAuto(self)
    self.max_workers = 0
    self.automation = 1
    self.auto_performance = 100
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
  MedicalCenter.CheatWorkAuto = CheatWorkAuto
  MedicalCenter.CheatWorkManual = CheatWorkManual
  NetworkNode.CheatWorkAuto = CheatWorkAuto
  NetworkNode.CheatWorkManual = CheatWorkManual
  CloningVats.CheatWorkAuto = CheatWorkAuto
  CloningVats.CheatWorkManual = CheatWorkManual
  WaterReclamationSpire.CheatWorkAuto = CheatWorkAuto
  WaterReclamationSpire.CheatWorkManual = CheatWorkManual
  BaseResearchLab.CheatWorkAuto = CheatWorkAuto
  BaseResearchLab.CheatWorkManual = CheatWorkManual

  SecurityStation.CheatWorkAuto = CheatWorkAuto
  SecurityStation.CheatWorkManual = CheatWorkManual

  CasinoComplex.CheatWorkAuto = CheatWorkAuto
  CasinoComplex.CheatWorkManual = CheatWorkManual
  Spacebar.CheatWorkAuto = CheatWorkAuto
  Spacebar.CheatWorkManual = CheatWorkManual
  ServiceWorkplace.CheatWorkAuto = CheatWorkAuto
  ServiceWorkplace.CheatWorkManual = CheatWorkManual
  Diner.CheatWorkAuto = CheatWorkAuto
  Diner.CheatWorkManual = CheatWorkManual
  MachinePartsFactory.CheatWorkAuto = CheatWorkAuto
  MachinePartsFactory.CheatWorkManual = CheatWorkManual
  ElectronicsFactory.CheatWorkAuto = CheatWorkAuto
  ElectronicsFactory.CheatWorkManual = CheatWorkManual
  Infirmary.CheatWorkAuto = CheatWorkAuto
  Infirmary.CheatWorkManual = CheatWorkManual
  Grocery.CheatWorkAuto = CheatWorkAuto
  Grocery.CheatWorkManual = CheatWorkManual
  FungalFarm.CheatWorkAuto = CheatWorkAuto
  FungalFarm.CheatWorkManual = CheatWorkManual
  PolymerPlant.CheatWorkAuto = CheatWorkAuto
  PolymerPlant.CheatWorkManual = CheatWorkManual
  FarmConventional.CheatWorkAuto = CheatWorkAuto
  FarmConventional.CheatWorkManual = CheatWorkManual
  FarmHydroponic.CheatWorkAuto = CheatWorkAuto
  FarmHydroponic.CheatWorkManual = CheatWorkManual
  MetalsExtractor.CheatWorkAuto = CheatWorkAuto
  MetalsExtractor.CheatWorkManual = CheatWorkManual
  PreciousMetalsExtractor.CheatWorkAuto = CheatWorkAuto
  PreciousMetalsExtractor.CheatWorkManual = CheatWorkManual
  FusionReactor.CheatWorkAuto = CheatWorkAuto
  FusionReactor.CheatWorkManual = CheatWorkManual
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
    self.water.production = self.water.production * 2
    self.water_production = self.water.production
  end
  local function CheatProdDefWater(self)
    self.water.production = self.base_water_production
    self.water_production = self.base_water_production
  end
  MoistureVaporator.CheatProdDbl = CheatProdDblWater
  MoistureVaporator.CheatProdDef = CheatProdDefWater
  WaterExtractor.CheatProdDbl = CheatProdDblWater
  WaterExtractor.CheatProdDef = CheatProdDefWater
  --
  local function CheatProdDblElec(self)
    self.electricity.production = self.electricity.production * 2
    self.electricity_production = self.electricity.production
  end
  local function CheatProdDefElec(self)
    self.electricity.production = self.base_electricity_production
    self.electricity_production = self.base_electricity_production
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
    self.air.production = self.air.production * 2
    self.air_production = self.air.production
  end
  function MOXIE.CheatProdDef(self)
    self.air.production = self.base_air_production
    self.air_production = self.base_air_production
  end
  --
  local function CheatProdDblProducer(self)
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  local function CheatProdDefProducer(self)
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
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
  --[[
  local function CheatCapStorageDbl(self)
    self.max_storage_per_resource = self.max_storage_per_resource * 2
    ChoGGi.UpdateResourceAmount(self,self.max_storage_per_resource)
  end
  local function CheatCapStorageDef(self)
    self.max_storage_per_resource = self.base_max_storage_per_resource
    ChoGGi.UpdateResourceAmount(self,self.max_storage_per_resource)
  end
  UniversalStorageDepot.CheatCapStorageDbl = CheatCapStorageDbl
  UniversalStorageDepot.CheatCapStorageDef = CheatCapStorageDef
  MysteryDepot.CheatCapStorageDbl = CheatCapStorageDbl
  MysteryDepot.CheatCapStorageDef = CheatCapStorageDef
  --
  function BlackCubeDumpSite:CheatCapDbl()
    self.max_amount_BlackCube = self.max_amount_BlackCube * 2
    ChoGGi.UpdateResourceAmount(self,self.max_amount_BlackCube)
  end
  function BlackCubeDumpSite:CheatCapDef()
    self.max_amount_BlackCube = self.base_max_amount_BlackCube
    ChoGGi.UpdateResourceAmount(self,self.max_amount_BlackCube)
  end
  --]]
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
--misc
  function SecurityStation:CheatReneagadesCapDbl()
    self.negated_renegades = self.negated_renegades * 2
  end
  function SecurityStation:CheatReneagadesCapDef()
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
