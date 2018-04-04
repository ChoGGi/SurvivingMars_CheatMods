--add items to the cheat pane
function OnMsg.ClassesGenerate()

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
  end
  local function CheatProdDefWater(self)
    self.water.production = self.base_water_production
  end
  MoistureVaporator.CheatProdDbl = CheatProdDblWater
  MoistureVaporator.CheatProdDef = CheatProdDefWater
  WaterExtractor.CheatProdDbl = CheatProdDblWater
  WaterExtractor.CheatProdDef = CheatProdDefWater
  --
  local function CheatProdDblElec(self)
    self.electricity.production = self.electricity.production * 2
  end
  local function CheatProdDefElec(self)
    self.electricity.production = self.base_electricity_production
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
  local function CheatProdDblAir(self)
    self.air.production = self.air.production * 2
  end
  local function CheatProdDefAir(self)
    self.air.production = self.base_air_production
  end
  MOXIE.CheatProdDbl = CheatProdDblAir
  MOXIE.CheatProdDef = CheatProdDefAir
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
  end
  function ElectricityStorage:CheatCapDef()
    self.capacity = self.base_capacity
  end
  --
  function WaterTank:CheatCapDbl()
    self.water_capacity = self.water_capacity * 2
  end
  function WaterTank:CheatCapDef()
    self.water_capacity = self.base_water_capacity
  end
  --
  function OxygenTank:CheatCapDbl()
    self.air_capacity = self.air_capacity * 2
  end
  function OxygenTank:CheatCapDef()
    self.air_capacity = self.base_air_capacity
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
--Double Drones/Shuttles
  function DroneHub:CheatDblMaxAllHubs()
    Consts.CommandCenterMaxDrones = Consts.CommandCenterMaxDrones * 2
  end
  --
  function ShuttleHub:CheatDblMaxShuttles()
    self.max_shuttles = self.max_shuttles * 2
  end
  function ShuttleHub:CheatDefMaxShuttles()
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
  function SecurityStation:CheatNegReneagadesDbl()
    self.negated_renegades = self.negated_renegades * 2
  end
  function SecurityStation:CheatNegReneagadesDef()
    self.negated_renegades = self.max_negated_renegades
  end

end --OnMsg

if ChoGGi.Testing then
  table.insert(ChoGGi.FilesCount,"InfoPaneCheats")
end
