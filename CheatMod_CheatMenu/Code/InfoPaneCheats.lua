--add items to the cheat pane
function OnMsg.ClassesGenerate()

--CheatDoubleMaxAmount
  function SubsurfaceDepositMetals:CheatDoubleMaxAmount()
    self.max_amount = self.max_amount * 2
  end
  --
  function SubsurfaceDepositWater:CheatDoubleMaxAmount()
    self.max_amount = self.max_amount * 2
  end
  --
  function SubsurfaceDepositPreciousMetals:CheatDoubleMaxAmount()
    self.max_amount = self.max_amount * 2
  end
  --
  function SurfaceDepositGroup:CheatDoubleMaxAmount()
    self.max_amount = self.max_amount * 2
  end
--CheatProdDbl
  function MoistureVaporator:CheatProdDbl()
    self.water.production = self.water.production * 2
  end
  function MoistureVaporator:CheatProdDef()
    self.water.production = self.base_water_production
  end
  --
  function WaterExtractor:CheatProdDbl()
    self.water.production = self.water.production * 2
  end
  function WaterExtractor:CheatProdDef()
    self.water.production = self.base_water_production
  end
  --
  function MOXIE:CheatProdDbl()
    self.air.production = self.air.production * 2
  end
  function MOXIE:CheatProdDef()
    self.air.production = self.base_air_production
  end
  --
  function FusionReactor:CheatProdDbl()
    self.electricity.production = self.electricity.production * 2
  end
  function FusionReactor:CheatProdDef()
    self.electricity.production = self.base_electricity_production
  end
  --
  function StirlingGenerator:CheatProdDbl()
    self.electricity.production = self.electricity.production * 2
  end
  function StirlingGenerator:CheatProdDef()
    self.electricity.production = self.base_electricity_production
  end
  --
  function WindTurbine:CheatProdDbl()
    self.electricity.production = self.electricity.production * 2
  end
  function WindTurbine:CheatProdDef()
    self.electricity.production = self.base_electricity_production
  end
  --
  function SolarPanel:CheatProdDbl()
    self.electricity.production = self.electricity.production * 2
  end
  function SolarPanel:CheatProdDef()
    self.electricity.production = self.base_electricity_production
  end
  --
  function ArtificialSun:CheatProdDbl()
    self.electricity.production = self.electricity.production * 2
  end
  function ArtificialSun:CheatProdDef()
    self.electricity.production = self.base_electricity_production
  end
  --
  function RegolithExtractor:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function RegolithExtractor:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function MetalsExtractor:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function MetalsExtractor:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function PreciousMetalsExtractor:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function PreciousMetalsExtractor:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function PolymerPlant:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function PolymerPlant:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function ElectronicsFactory:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function ElectronicsFactory:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function MachinePartsFactory:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function MachinePartsFactory:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function FuelFactory:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function FuelFactory:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function FarmHydroponic:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function FarmHydroponic:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function FungalFarm:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function FungalFarm:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function FarmConventional:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function ElectricityStorage:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
  end
  --
  function MoholeMine:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
    self.producers[2].production_per_day = self.producers[2].production_per_day * 2
  end
  function MoholeMine:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
    self.producers[2].production_per_day = self.producers[2].base_production_per_day
  end
  --
  function TheExcavator:CheatProdDbl()
    self.producers[1].production_per_day = self.producers[1].production_per_day * 2
  end
  function TheExcavator:CheatProdDef()
    self.producers[1].production_per_day = self.producers[1].base_production_per_day
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
  function UniversalStorageDepot:CheatCapDbl()
    self.max_storage_per_resource = self.max_storage_per_resource * 2
  end
  function UniversalStorageDepot:CheatCapDef()
    self.max_storage_per_resource = self.base_max_storage_per_resource
  end
  --
  function BlackCubeDumpSite:CheatCapDbl()
    self.max_amount_BlackCube = self.max_amount_BlackCube * 2
  end
  function BlackCubeDumpSite:CheatCapDef()
    self.max_amount_BlackCube = self.base_max_amount_BlackCube
  end
  --
  function MysteryDepot:CheatCapDbl()
    self.max_storage_per_resource = self.max_storage_per_resource * 2
  end
  function MysteryDepot:CheatCapDef()
    self.max_storage_per_resource = self.base_max_storage_per_resource
  end
--CheatCapDbl people
  function Arcology:CheatCapDbl()
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  function Arcology:CheatCapDef()
    self.capacity = self.base_capacity
  end
  --
  function SmartHome:CheatCapDbl()
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  function SmartHome:CheatCapDef()
    self.capacity = self.base_capacity
  end
  --
  function Nursery:CheatCapDbl()
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  function Nursery:CheatCapDef()
    self.capacity = self.base_capacity
  end
  --
  function Apartments:CheatCapDbl()
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  function Apartments:CheatCapDef()
    self.capacity = self.base_capacity
  end
  --
  function LivingQuarters:CheatCapDbl()
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  function LivingQuarters:CheatCapDef()
    self.capacity = self.base_capacity
  end
--CheatVisitorsDbl
  function CasinoComplex:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function CasinoComplex:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function Diner:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function Diner:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function Grocery:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function Grocery:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function HangingGardens:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function HangingGardens:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function Infirmary:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function Infirmary:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function MedicalCenter:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function MedicalCenter:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function OpenAirGym:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function OpenAirGym:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function Playground:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function Playground:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function ServiceWorkplace:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function ServiceWorkplace:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function Spacebar:CheatVisitorsDbl()
    self.max_visitors = self.max_visitors * 2
  end
  function Spacebar:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function MartianUniversity:CheatVisitorsDbl()
    if self.max_visitors == 4096 then
      return
    end
    self.max_visitors = self.max_visitors * 2
  end
  function MartianUniversity:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function Sanatorium:CheatVisitorsDbl()
    if self.max_visitors == 4096 then
      return
    end
    self.max_visitors = self.max_visitors * 2
  end
  function Sanatorium:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
  --
  function School:CheatVisitorsDbl()
    if self.max_visitors == 4096 then
      return
    end
    self.max_visitors = self.max_visitors * 2
  end
  function School:CheatVisitorsDef()
    self.max_visitors = self.base_max_visitors
  end
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
--Explorer
  function ExplorerRover:CheatBattRefill()
    self:ApplyBatteryChange(self.battery_max)
  end
  --
  function ExplorerRover:CheatBattCapDbl()
    self.battery_max = self.battery_max * 2
  end
  function ExplorerRover:CheatBattCapDef()
    self.battery_max = const.BaseRoverMaxBattery
  end
  --
  function ExplorerRover:CheatMoveSpeedDbl()
    self:SetMoveSpeed(self:GetMoveSpeed() * 2)
  end
  function ExplorerRover:CheatMoveSpeedDef()
    self:SetMoveSpeed(self.base_move_speed)
  end
--Transport
  function RCTransport:CheatBattRefill()
    self:ApplyBatteryChange(self.battery_max)
  end
  --
  function RCTransport:CheatBattCapDbl()
    self.battery_max = self.battery_max * 2
  end
  function RCTransport:CheatBattCapDef()
    self.battery_max = const.BaseRoverMaxBattery
  end
  --
  function RCTransport:CheatMoveSpeedDbl()
    self:SetMoveSpeed(self:GetMoveSpeed() * 2)
  end
  function RCTransport:CheatMoveSpeedDef()
    self:SetMoveSpeed(self.base_move_speed)
  end
--Rover
  --[[
  function RCRover:CheatBattRefill()
    self:ApplyBatteryChange(self.battery_max)
  end
  --]]
  --
  function RCRover:CheatBattCapDbl()
    self.battery_max = self.battery_max * 2
  end
  function RCRover:CheatBattCapDef()
    self.battery_max = const.BaseRoverMaxBattery
  end
  --
  function RCRover:CheatMoveSpeedDbl()
    self:SetMoveSpeed(self:GetMoveSpeed() * 2)
  end
  function RCRover:CheatMoveSpeedDef()
    self:SetMoveSpeed(self.base_move_speed)
  end
--Drones
  function Drone:CheatBattRefill()
    self:ApplyBatteryChange(self.battery_max)
  end
  --
  function Drone:CheatBattCapDbl()
    self.battery_max = self.battery_max * 2
  end
  function Drone:CheatBattCapDef()
    self.battery_max = self.base_battery_max
  end
  --
  function Drone:CheatMoveSpeedDbl()
    self:SetMoveSpeed(self:GetMoveSpeed() * 2)
  end
  function Drone:CheatMoveSpeedDef()
    self:SetMoveSpeed(self.base_move_speed)
  end

--misc
  function SecurityStation:CheatNegReneagadesDbl()
    self.negated_renegades = self.negated_renegades * 2
  end
  function SecurityStation:CheatNegReneagadesDef()
    self.negated_renegades = self.max_negated_renegades
  end



end --OnMsg

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"InfoPaneCheats")
end
