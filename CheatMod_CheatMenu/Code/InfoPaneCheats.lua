--add items to the cheat pane
function ChoGGi.InfoPaneCheats_ClassesGenerate()

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
  function Colonist.CheatBoostPref(self)
    self.performance = 250
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
  local function CheatWorkAuto(self)
    self.max_workers = 0
    self.automation = 1
    self.auto_performance = ChoGGi.CheatMenuSettings.FullyAutomatedBuildingsPerf
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

function ChoGGi.SetHintsInfoPaneCheats(win)
  local cur = win.context
  local name = _InternalTranslate(cur.name)
  local id = cur.encyclopedia_id
  for _,action in ipairs(win.actions) do

    --Colonists
    if action.ActionId == "FillAll" then
      --have to set the name to make the hint show up
      action.ActionName = action.ActionId
      action.RolloverHint = "Fill all stat bars."
    elseif action.ActionId == "BoostPref" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Set " .. name .. "'s performance to 250."
    elseif action.ActionId == "RandomSpecialization" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Randomly set " .. name .. "'s specialization."
    elseif action.ActionId == "ColonistCapDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double the colonist capacity of this building (reselect to update head amount)."

    --Buildings
    elseif action.ActionId == "Upgrade1" then
      local tempname = _InternalTranslate(cur.upgrade1_display_name)
      if tempname ~= "" then
        action.ActionName = action.ActionId
        action.RolloverHint = "Add: " .. tempname .. " to this building.\n\n" .. _InternalTranslate(cur.upgrade1_description)
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Upgrade2" then
      local tempname = _InternalTranslate(cur.upgrade2_display_name)
      if tempname ~= "" then
        action.ActionName = action.ActionId
        action.RolloverHint = "Add: " .. tempname .. " to this building.\n\n" .. _InternalTranslate(cur.upgrade2_description)
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "Upgrade3" then
      local tempname = _InternalTranslate(cur.upgrade3_display_name)
      if tempname ~= "" then
        action.ActionName = action.ActionId
        action.RolloverHint = "Add: " .. tempname .. " to this building.\n\n" .. _InternalTranslate(cur.upgrade3_description)
      else
        action.ActionId = nil
      end
    elseif action.ActionId == "WorkAuto" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Make this " .. id .. " not need workers."
    elseif action.ActionId == "WorkManual" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Make this " .. id .. " need workers."
    elseif action.ActionId == "ProdDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double the production of this " .. id .. " (certain buildings will reset: Wind turbines and such)."
    elseif action.ActionId == "ProdDef" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Reset the production of this " .. id .. " to default."
    elseif action.ActionId == "CapDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double the storage capacity of this " .. id .. "."
    elseif action.ActionId == "CapDef" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Reset the storage capacity of this " .. id .. " to default."
    elseif action.ActionId == "VisitorsDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double the amount of colonist slots for this " .. id .. "."

    --RC
    elseif action.ActionId == "BattCapDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double capacity of battery."
    elseif action.ActionId == "MaxShuttlesDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double the shuttles this ShuttleHub can control."

    --Farms
    elseif action.ActionId == "AllShifts" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Turn on all work shifts."

    --Misc
    elseif action.ActionId == "AddDust" then
      if cur.class == "SupplyRocket" or cur.class == "UniversalStorageDepot" or cur.class == "WasteRockDumpSite" then
        action.ActionId = false
      else
        action.ActionName = action.ActionId
        action.RolloverHint = "Add visual dust and maintenance points."
      end
    elseif action.ActionId == "CleanAndFix" then
      if cur.class == "SupplyRocket" or cur.class == "UniversalStorageDepot" or cur.class == "WasteRockDumpSite" then
        action.ActionId = nil
      else
        action.ActionName = action.ActionId
        action.RolloverHint = "You may need to use AddDust before using this to make the building look visually."
      end
    elseif action.ActionId == "Destroy" then
      if cur.class == "SupplyRocket" then
        action.ActionId = nil
      else
        action.ActionName = action.ActionId
        action.RolloverHint = "Turns object into ruin."
      end
    elseif action.ActionId == "Empty" then
      if cur.class:find("SubsurfaceDeposit") then
        action.ActionName = action.ActionId
        action.RolloverHint = "Warning: This will remove the " .. id .. " object from the map."
      else
        action.ActionName = action.ActionId
        action.RolloverHint = "Empties the storage of this building.\n\nExcluding waste rock in something other than a dumping site."
      end
    elseif action.ActionId == "Refill" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Refill the deposit to full capacity."
    elseif action.ActionId == "Fill" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Fill the storage of this building."
    elseif action.ActionId == "Launch" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Warning: Launches rocket without asking."
    elseif action.ActionId == "DoubleMaxAmount" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double the amount this " .. id .. " can hold."
    elseif action.ActionId == "ReneagadeCapDbl" then
      action.ActionName = action.ActionId
      action.RolloverHint = "Double amount of reneagades this station can negate (currently: " .. cur.negated_renegades .. ") < reselect to update num."
    end

  end --for
end
