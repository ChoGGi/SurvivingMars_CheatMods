-- See LICENSE for terms

-- add items/hint to the cheats pane

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
local ResourceScale = ChoGGi.Consts.ResourceScale

local string = string

local CurrentMap = CurrentMap
local DelayedCall = DelayedCall
local DestroyBuildingImmediate = DestroyBuildingImmediate
local IsValid = IsValid
local Random = Random
local RebuildInfopanel = RebuildInfopanel

local pf_SetStepLen = pf.SetStepLen

local g_Classes = g_Classes

function ChoGGi.MsgFuncs.InfoPaneCheats_ClassesGenerate()

--~ global objects
  function g_Classes.Building:CheatDestroy()
    local ChoGGi = ChoGGi
    local name = ChoGGi.ComFuncs.RetName(self)
    local obj_type
    if self:IsKindOf("BaseRover") then
      obj_type = 7825 --Destroy this Rover.
    elseif self:IsKindOf("Drone") then
      obj_type = 7824 --Destroy this Drone.
    else
      obj_type = 7822 --Destroy this building.
    end

    local function CallBackFunc(answer)
      if answer then
        self.indestructible = false
        DestroyBuildingImmediate(self)
      end
    end
    ChoGGi.ComFuncs.QuestionBox(
      Concat(T(6779--[[Warning--]]),"!\n",T(obj_type),"\n",name),
      CallBackFunc,
      Concat(T(6779--[[Warning--]]),": ",T(obj_type)),
      Concat(T(obj_type)," ",name),
      T(1176--[[Cancel Destroy--]])
    )
  end
  local function CheatDeleteObject(self)
    local ChoGGi = ChoGGi
    local name = ChoGGi.ComFuncs.RetName(self)
    local function CallBackFunc(answer)
      if answer then
        ChoGGi.CodeFuncs.DeleteObject(self)
      end
    end
    ChoGGi.ComFuncs.QuestionBox(
      Concat(T(6779--[[Warning--]]),"!\n",string.format(T(302535920000885--[[Permanently delete %s--]]),name),"?"),
      CallBackFunc,
      Concat(T(6779--[[Warning--]]),": ",T(302535920000855--[[Last chance before deletion!--]])),
      Concat(T(5451--[[DELETE--]]),": ",name),
      Concat(T(3687--[[Cancel--]])," ",T(1000287--[[Delete--]]))
    )
  end
  g_Classes.PinnableObject.CheatDeleteObject = CheatDeleteObject
  g_Classes.Building.CheatDeleteObject = CheatDeleteObject
  g_Classes.Unit.CheatDeleteObject = CheatDeleteObject
  g_Classes.SubsurfaceDepositMetals.CheatDeleteObject = CheatDeleteObject
  g_Classes.SubsurfaceDepositWater.CheatDeleteObject = CheatDeleteObject
  g_Classes.SubsurfaceDepositPreciousMetals.CheatDeleteObject = CheatDeleteObject
  g_Classes.SurfaceDepositGroup.CheatDeleteObject = CheatDeleteObject

-- consumption
  function g_Classes.Building:CheatPowerFree()
    ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
  end
  function g_Classes.Building:CheatPowerNeed()
    ChoGGi.CodeFuncs.AddBuildingElecConsump(self)
  end
  function g_Classes.Building:CheatWaterFree()
    ChoGGi.CodeFuncs.RemoveBuildingWaterConsump(self)
  end
  function g_Classes.Building:CheatWaterNeed()
    ChoGGi.CodeFuncs.AddBuildingWaterConsump(self)
  end

  function g_Classes.Building:CheatOxygenFree()
    ChoGGi.CodeFuncs.RemoveBuildingOxygenConsump(self)
  end
  function g_Classes.Building:CheatOxygenNeed()
    ChoGGi.CodeFuncs.AddBuildingOxygenConsump(self)
  end
--~
  local function CheatHideSigns(self)
    self:DestroyAttaches("BuildingSign")
  end
  local function CheatColourRandom(self)
    ChoGGi.CodeFuncs.ObjectColourRandom(self)
  end
  local function CheatColourDefault(self)
    ChoGGi.CodeFuncs.ObjectColourDefault(self)
  end
  g_Classes.Building.CheatHideSigns = CheatHideSigns
  g_Classes.Building.CheatColourRandom = CheatColourRandom
  g_Classes.Building.CheatColourDefault = CheatColourDefault
  g_Classes.Unit.CheatHideSigns = CheatHideSigns
  g_Classes.Unit.CheatColourRandom = CheatColourRandom
  g_Classes.Unit.CheatColourDefault = CheatColourDefault
  g_Classes.SubsurfaceDepositMetals.CheatColourRandom = CheatColourRandom
  g_Classes.SubsurfaceDepositWater.CheatColourRandom = CheatColourRandom
  g_Classes.SubsurfaceDepositPreciousMetals.CheatColourRandom = CheatColourRandom
  g_Classes.SurfaceDepositGroup.CheatColourRandom = CheatColourRandom
  g_Classes.SubsurfaceDepositMetals.CheatColourDefault = CheatColourDefault
  g_Classes.SubsurfaceDepositWater.CheatColourDefault = CheatColourDefault
  g_Classes.SubsurfaceDepositPreciousMetals.CheatColourDefault = CheatColourDefault
  g_Classes.SurfaceDepositGroup.CheatColourDefault = CheatColourDefault

--colonists
  function g_Classes.Colonist:CheatFillMorale()
    self.stat_morale = 100 * ResourceScale
  end
  function g_Classes.Colonist:CheatFillSanity()
    self.stat_sanity = 100 * ResourceScale
  end
  function g_Classes.Colonist:CheatFillComfort()
    self.stat_comfort = 100 * ResourceScale
  end
  function g_Classes.Colonist:CheatFillHealth()
    self.stat_health = 100 * ResourceScale
  end
  function g_Classes.Colonist:CheatFillAll()
    self:CheatFillSanity()
    self:CheatFillComfort()
    self:CheatFillHealth()
    self:CheatFillMorale()
  end
  function g_Classes.Colonist:CheatRenegade()
    self:AddTrait("Renegade",true)
  end
  function g_Classes.Colonist:CheatRenegadeClear()
    self:RemoveTrait("Renegade")
    DelayedCall(100, function()
      self:CheatFillMorale()
    end)
  end
  function g_Classes.Colonist:CheatRandomRace()
    self.race = Random(1,5)
    self:ChooseEntity()
  end
  function g_Classes.Colonist:CheatRandomSpec()
    --skip children, or they'll be a black cube
    if not self.entity:find("Child",1,true) then
      self:SetSpecialization(ChoGGi.Tables.ColonistSpecializations[Random(1,6)],"init")
    end
  end
  function g_Classes.Colonist:CheatPrefDbl()
    self.performance = self.performance * 2
  end
  function g_Classes.Colonist:CheatPrefDef()
    self.performance = self.base_performance
  end
  function g_Classes.Colonist:CheatRandomGender()
    ChoGGi.CodeFuncs.ColonistUpdateGender(self,ChoGGi.Tables.ColonistGenders[Random(1,5)])
  end
  function g_Classes.Colonist:CheatRandomAge()
    ChoGGi.CodeFuncs.ColonistUpdateAge(self,ChoGGi.Tables.ColonistAges[Random(1,6)])
  end
--CheatAllShifts
  local function CheatAllShiftsOn(self)
    self.closed_shifts[1] = false
    self.closed_shifts[2] = false
    self.closed_shifts[3] = false
  end
  g_Classes.FungalFarm.CheatAllShiftsOn = CheatAllShiftsOn
  g_Classes.FarmConventional.CheatAllShiftsOn = CheatAllShiftsOn
  g_Classes.FarmHydroponic.CheatAllShiftsOn = CheatAllShiftsOn
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
  g_Classes.BaseResearchLab.CheatWorkAuto = CheatWorkAuto
  g_Classes.BaseResearchLab.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.BaseResearchLab.CheatWorkersDef = CheatWorkersDef
  g_Classes.BaseResearchLab.CheatWorkManual = CheatWorkManual
  g_Classes.CasinoComplex.CheatWorkAuto = CheatWorkAuto
  g_Classes.CasinoComplex.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.CasinoComplex.CheatWorkersDef = CheatWorkersDef
  g_Classes.CasinoComplex.CheatWorkManual = CheatWorkManual
  g_Classes.CloningVats.CheatWorkAuto = CheatWorkAuto
  g_Classes.CloningVats.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.CloningVats.CheatWorkersDef = CheatWorkersDef
  g_Classes.CloningVats.CheatWorkManual = CheatWorkManual
  g_Classes.Diner.CheatWorkAuto = CheatWorkAuto
  g_Classes.Diner.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.Diner.CheatWorkersDef = CheatWorkersDef
  g_Classes.Diner.CheatWorkManual = CheatWorkManual
  g_Classes.DroneFactory.CheatWorkAuto = CheatWorkAuto
  g_Classes.DroneFactory.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.DroneFactory.CheatWorkersDef = CheatWorkersDef
  g_Classes.DroneFactory.CheatWorkManual = CheatWorkManual
  g_Classes.ElectronicsFactory.CheatWorkAuto = CheatWorkAuto
  g_Classes.ElectronicsFactory.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.ElectronicsFactory.CheatWorkersDef = CheatWorkersDef
  g_Classes.ElectronicsFactory.CheatWorkManual = CheatWorkManual
  g_Classes.FarmConventional.CheatWorkAuto = CheatWorkAuto
  g_Classes.FarmConventional.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.FarmConventional.CheatWorkersDef = CheatWorkersDef
  g_Classes.FarmConventional.CheatWorkManual = CheatWorkManual
  g_Classes.FarmHydroponic.CheatWorkAuto = CheatWorkAuto
  g_Classes.FarmHydroponic.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.FarmHydroponic.CheatWorkersDef = CheatWorkersDef
  g_Classes.FarmHydroponic.CheatWorkManual = CheatWorkManual
  g_Classes.FungalFarm.CheatWorkAuto = CheatWorkAuto
  g_Classes.FungalFarm.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.FungalFarm.CheatWorkersDef = CheatWorkersDef
  g_Classes.FungalFarm.CheatWorkManual = CheatWorkManual
  g_Classes.FusionReactor.CheatWorkAuto = CheatWorkAuto
  g_Classes.FusionReactor.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.FusionReactor.CheatWorkersDef = CheatWorkersDef
  g_Classes.FusionReactor.CheatWorkManual = CheatWorkManual
  g_Classes.Grocery.CheatWorkAuto = CheatWorkAuto
  g_Classes.Grocery.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.Grocery.CheatWorkersDef = CheatWorkersDef
  g_Classes.Grocery.CheatWorkManual = CheatWorkManual
  g_Classes.Infirmary.CheatWorkAuto = CheatWorkAuto
  g_Classes.Infirmary.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.Infirmary.CheatWorkersDef = CheatWorkersDef
  g_Classes.Infirmary.CheatWorkManual = CheatWorkManual
  g_Classes.MachinePartsFactory.CheatWorkAuto = CheatWorkAuto
  g_Classes.MachinePartsFactory.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.MachinePartsFactory.CheatWorkersDef = CheatWorkersDef
  g_Classes.MachinePartsFactory.CheatWorkManual = CheatWorkManual
  g_Classes.MedicalCenter.CheatWorkAuto = CheatWorkAuto
  g_Classes.MedicalCenter.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.MedicalCenter.CheatWorkersDef = CheatWorkersDef
  g_Classes.MedicalCenter.CheatWorkManual = CheatWorkManual
  g_Classes.MetalsExtractor.CheatWorkAuto = CheatWorkAuto
  g_Classes.MetalsExtractor.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.MetalsExtractor.CheatWorkersDef = CheatWorkersDef
  g_Classes.MetalsExtractor.CheatWorkManual = CheatWorkManual
  g_Classes.NetworkNode.CheatWorkAuto = CheatWorkAuto
  g_Classes.NetworkNode.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.NetworkNode.CheatWorkersDef = CheatWorkersDef
  g_Classes.NetworkNode.CheatWorkManual = CheatWorkManual
  g_Classes.PolymerPlant.CheatWorkAuto = CheatWorkAuto
  g_Classes.PolymerPlant.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.PolymerPlant.CheatWorkersDef = CheatWorkersDef
  g_Classes.PolymerPlant.CheatWorkManual = CheatWorkManual
  g_Classes.PreciousMetalsExtractor.CheatWorkAuto = CheatWorkAuto
  g_Classes.PreciousMetalsExtractor.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.PreciousMetalsExtractor.CheatWorkersDef = CheatWorkersDef
  g_Classes.PreciousMetalsExtractor.CheatWorkManual = CheatWorkManual
  g_Classes.SecurityStation.CheatWorkAuto = CheatWorkAuto
  g_Classes.SecurityStation.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.SecurityStation.CheatWorkersDef = CheatWorkersDef
  g_Classes.SecurityStation.CheatWorkManual = CheatWorkManual
  g_Classes.ServiceWorkplace.CheatWorkAuto = CheatWorkAuto
  g_Classes.ServiceWorkplace.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.ServiceWorkplace.CheatWorkersDef = CheatWorkersDef
  g_Classes.ServiceWorkplace.CheatWorkManual = CheatWorkManual
  g_Classes.Spacebar.CheatWorkAuto = CheatWorkAuto
  g_Classes.Spacebar.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.Spacebar.CheatWorkersDef = CheatWorkersDef
  g_Classes.Spacebar.CheatWorkManual = CheatWorkManual
  g_Classes.WaterReclamationSpire.CheatWorkAuto = CheatWorkAuto
  g_Classes.WaterReclamationSpire.CheatWorkersDbl = CheatWorkersDbl
  g_Classes.WaterReclamationSpire.CheatWorkersDef = CheatWorkersDef
  g_Classes.WaterReclamationSpire.CheatWorkManual = CheatWorkManual

--CheatDoubleMaxAmount
  local function CheatDoubleMaxAmount(self)
    self.max_amount = self.max_amount * 2
  end
  g_Classes.SubsurfaceDepositMetals.CheatDoubleMaxAmount = CheatDoubleMaxAmount
  g_Classes.SubsurfaceDepositWater.CheatDoubleMaxAmount = CheatDoubleMaxAmount
  g_Classes.SubsurfaceDepositPreciousMetals.CheatDoubleMaxAmount = CheatDoubleMaxAmount
  g_Classes.SurfaceDepositGroup.CheatDoubleMaxAmount = CheatDoubleMaxAmount
--CheatCapDbl storage
  function g_Classes.ElectricityStorage:CheatCapDbl()
    self.capacity = self.capacity * 2
    self.electricity.storage_capacity = self.capacity
    self.electricity.storage_mode = "charging"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function g_Classes.ElectricityStorage:CheatCapDef()
    self.capacity = self.base_capacity
    self.electricity.storage_capacity = self.capacity
    self.electricity.storage_mode = "full"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  --
  function g_Classes.WaterTank:CheatCapDbl()
    self.water_capacity = self.water_capacity * 2
    self.water.storage_capacity = self.water_capacity
    self.water.storage_mode = "charging"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function g_Classes.WaterTank:CheatCapDef()
    self.water_capacity = self.base_water_capacity
    self.water.storage_capacity = self.water_capacity
    self.water.storage_mode = "full"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  --
  function g_Classes.OxygenTank:CheatCapDbl()
    self.air_capacity = self.air_capacity * 2
    self.air.storage_capacity = self.air_capacity
    self.air.storage_mode = "charging"
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function g_Classes.OxygenTank:CheatCapDef()
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
  g_Classes.Apartments.CheatColonistCapDbl = CheatColonistCapDbl
  g_Classes.Apartments.CheatColonistCapDef = CheatColonistCapDef
  g_Classes.Arcology.CheatColonistCapDbl = CheatColonistCapDbl
  g_Classes.Arcology.CheatColonistCapDef = CheatColonistCapDef
  g_Classes.LivingQuarters.CheatColonistCapDbl = CheatColonistCapDbl
  g_Classes.LivingQuarters.CheatColonistCapDef = CheatColonistCapDef
  g_Classes.Nursery.CheatColonistCapDbl = CheatColonistCapDbl
  g_Classes.Nursery.CheatColonistCapDef = CheatColonistCapDef
  g_Classes.SmartHome.CheatColonistCapDbl = CheatColonistCapDbl
  g_Classes.SmartHome.CheatColonistCapDef = CheatColonistCapDef

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
  g_Classes.CasinoComplex.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.CasinoComplex.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.Diner.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.Diner.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.Grocery.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.Grocery.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.HangingGardens.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.HangingGardens.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.Infirmary.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.Infirmary.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.MartianUniversity.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.MartianUniversity.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.MedicalCenter.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.MedicalCenter.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.OpenAirGym.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.OpenAirGym.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.Playground.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.Playground.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.Sanatorium.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.Sanatorium.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.School.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.School.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.ServiceWorkplace.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.ServiceWorkplace.CheatVisitorsDef = CheatVisitorsDef
  g_Classes.Spacebar.CheatVisitorsDbl = CheatVisitorsDbl
  g_Classes.Spacebar.CheatVisitorsDef = CheatVisitorsDef

--Double Shuttles
  function g_Classes.ShuttleHub:CheatMaxShuttlesDbl()
    self.max_shuttles = self.max_shuttles * 2
  end
  function g_Classes.ShuttleHub:CheatMaxShuttlesDef()
    self.max_shuttles = self.base_max_shuttles
  end
--CheatBattCapDbl
  local function CheatBattCapDbl(self)
    self.battery_max = self.battery_max * 2
  end
  local function CheatBattCapDef(self)
    self.battery_max = const.BaseRoverMaxBattery
  end
  g_Classes.Drone.CheatBattCapDbl = CheatBattCapDbl
  g_Classes.Drone.CheatBattCapDef = CheatBattCapDef
  g_Classes.ExplorerRover.CheatBattCapDbl = CheatBattCapDbl
  g_Classes.ExplorerRover.CheatBattCapDef = CheatBattCapDef
  g_Classes.RCRover.CheatBattCapDbl = CheatBattCapDbl
  g_Classes.RCRover.CheatBattCapDef = CheatBattCapDef
  g_Classes.RCTransport.CheatBattCapDbl = CheatBattCapDbl
  g_Classes.RCTransport.CheatBattCapDef = CheatBattCapDef
--CheatMoveSpeedDbl
  local function CheatMoveSpeedDbl(self)
    --self:SetMoveSpeed(self:GetMoveSpeed() * 2)
    pf_SetStepLen(self,self:GetMoveSpeed() * 2)
  end
  local function CheatMoveSpeedDef(self)
    --self:SetMoveSpeed(self.base_move_speed)
    pf_SetStepLen(self,self.base_move_speed)
  end
  g_Classes.Drone.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  g_Classes.Drone.CheatMoveSpeedDef = CheatMoveSpeedDef
  g_Classes.ExplorerRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  g_Classes.ExplorerRover.CheatMoveSpeedDef = CheatMoveSpeedDef
  g_Classes.RCRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  g_Classes.RCRover.CheatMoveSpeedDef = CheatMoveSpeedDef
  g_Classes.RCTransport.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  g_Classes.RCTransport.CheatMoveSpeedDef = CheatMoveSpeedDef
  local function CheatBattRefill(self)
    self.battery_current = self.battery_max
  end
  g_Classes.ExplorerRover.CheatBattRefill = CheatBattRefill
  g_Classes.RCRover.CheatBattRefill = CheatBattRefill
  g_Classes.RCTransport.CheatBattRefill = CheatBattRefill
  function g_Classes.Drone:CheatBattRefill()
    self.battery = self.battery_max
  end
  local function CheatFindResource(self)
    ChoGGi.CodeFuncs.FindNearestResource(self)
  end
  g_Classes.Drone.CheatFindResource = CheatFindResource
  g_Classes.RCTransport.CheatFindResource = CheatFindResource
--CheatCleanAndFix
  local function CheatCleanAndFix(self)
    self:CheatMalfunction()
    DelayedCall(1, function()
      self:Repair()
   end)
  end
  local function CheatCleanAndFixDrone(self)
    self:CheatMalfunction()
    DelayedCall(1, function()
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

  g_Classes.Drone.CheatCleanAndFix = CheatCleanAndFixDrone
  g_Classes.ExplorerRover.CheatCleanAndFix = CheatCleanAndFix
  g_Classes.RCRover.CheatCleanAndFix = CheatCleanAndFix
  g_Classes.RCTransport.CheatCleanAndFix = CheatCleanAndFix
--misc
  function g_Classes.SecurityStation:CheatReneagadeCapDbl()
    self.negated_renegades = self.negated_renegades * 2
  end
  function g_Classes.SecurityStation:CheatReneagadeCapDef()
    self.negated_renegades = self.max_negated_renegades
  end
  function g_Classes.MechanizedDepot:CheatEmptyDepot()
    ChoGGi.CodeFuncs.EmptyMechDepot(self)
  end
--~   function SupplyRocket:CheatCapDbl()
--~     self.max_export_storage = self.max_export_storage * 2
--~   end
--~   function SupplyRocket:CheatCapDef()
--~     self.max_export_storage = self.base_max_export_storage
--~   end
end --OnMsg

function ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  if not CurrentMap:find("Tutorial") then
    g_Classes.Building.CheatAddMaintenancePnts = nil
    g_Classes.Building.CheatMakeSphereTarget = nil
    g_Classes.Building.CheatSpawnWorker = nil
    g_Classes.Building.CheatSpawnVisitor = nil
  end
end

function ChoGGi.InfoFuncs.SetInfoPanelCheatHints(win)
  local obj = win.context
  local name = ChoGGi.ComFuncs.RetName(obj)
  local id = obj.encyclopedia_id
  --needs to be strings or else!@!$@!
  local doublec = ""
  local resetc = ""
  if id then
    doublec = string.format(T(302535920001199--[["Double the amount of colonist slots for this %s.

Reselect to update display."--]]),name)
    resetc = string.format(T(302535920001200--[["Reset the capacity of colonist slots for this %s.

Reselect to update display."--]]),name)
  end
  local function SetHint(action,hint)
    --name has to be set to make the hint show up
    action.ActionName = action.ActionId
    action.RolloverHint = hint
  end
  local Table = win.actions or empty_table
  for i = 1, #Table do
    local action = Table[i]

--Colonists
    if action.ActionId == "FillAll" then
      SetHint(action,T(302535920001202--[[Fill all stat bars.--]]))
    elseif action.ActionId == "SpawnColonist" then
      SetHint(action,T(302535920000005--[[Drops a new colonist in selected dome.--]]))
    elseif action.ActionId == "PrefDbl" then
      SetHint(action,string.format(T(302535920001203--[[Double %s's performance.--]]),name))
    elseif action.ActionId == "PrefDef" then
      SetHint(action,string.format(T(302535920001204--[[Reset %s's performance to default.--]]),name))
    elseif action.ActionId == "RandomSpecialization" then
      SetHint(action,string.format(T(302535920001205--[[Randomly set %s's specialization.--]]),name))

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
      local tempname = T(obj.upgrade1_display_name)
      if tempname ~= "" then
        SetHint(action,string.format(T(302535920001207--[["Add: %s to this building.

%s."--]]),tempname,T(obj.upgrade1_description)))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "Upgrade2" then
      local tempname = T(obj.upgrade2_display_name)
      if tempname ~= "" then
        SetHint(action,string.format(T(302535920001207--[["Add: %s to this building.

%s."--]]),tempname,T(obj.upgrade2_description)))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "Upgrade3" then
      local tempname = T(obj.upgrade3_display_name)
      if tempname ~= "" then
        SetHint(action,string.format(T(302535920001207--[["Add: %s to this building.

%s."--]]),tempname,T(obj.upgrade3_description)))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "WorkAuto" then
      local bs = ChoGGi.UserSettings.BuildingSettings
      SetHint(action,string.format(T(302535920001209--[[Make this %s not need workers (performance: %s).--]]),name,bs and bs[id] and bs[id].performance or 150))

    elseif action.ActionId == "WorkManual" then
      SetHint(action,string.format(T(302535920001210--[[Make this %s need workers.--]]),name))
    elseif action.ActionId == "CapDbl" then
      if obj:IsKindOf("SupplyRocket") then
        SetHint(action,string.format(T(302535920001211--[[Double the export storage capacity of this %s.--]]),name))
      else
        SetHint(action,string.format(T(302535920001212--[[Double the storage capacity of this %s.--]]),name))
      end
    elseif action.ActionId == "CapDef" then
      SetHint(action,string.format(T(302535920001213--[[Reset the storage capacity of this %s to default.--]]),name))
    elseif action.ActionId == "EmptyDepot" then
      SetHint(action,T(302535920001214--[[sticks small depot in front of mech depot and moves all resources to it (max of 20 000).--]]))

--Farms
    elseif action.ActionId == "AllShifts" then
      SetHint(action,T(302535920001215--[[Turn on all work shifts.--]]))

--RC
    elseif action.ActionId == "BattCapDbl" then
      SetHint(action,T(302535920001216--[[Double the battery capacity.--]]))
    elseif action.ActionId == "MaxShuttlesDbl" then
      SetHint(action,T(302535920001217--[[Double the shuttles this ShuttleHub can control.--]]))
    elseif action.ActionId == "FindResource" then
      SetHint(action,T(302535920001218--[[Selects nearest storage containing specified resource (shows list of resources).--]]))

--Misc
    elseif action.ActionId == "DeleteObject" then
      SetHint(action,string.format(T(302535920000885--[[Permanently delete %s--]]),name))

    elseif action.ActionId == "Malfunction" then
      SetHint(action,Concat(T(8039--[[Trait: Idiot (can cause a malfunction)--]]),"...\n",T(53--[[Malfunction--]],"?")))
    elseif action.ActionId == "PowerFree" then
      if obj.electricity_consumption then
        SetHint(action,string.format(T(302535920001220--[[Change this %s so it doesn't need a power source.--]]),name))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "PowerNeed" then
      if obj.electricity_consumption then
        SetHint(action,string.format(T(302535920001221--[[Change this %s so it needs a power source.--]]),name))
      else
        action.ActionId = ""
      end

    elseif action.ActionId == "WaterFree" then
      if obj.electricity_consumption then
        SetHint(action,string.format(T(302535920000853--[[Change this %s so it doesn't need a water source.--]]),name))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "WaterNeed" then
      if obj.electricity_consumption then
        SetHint(action,string.format(T(302535920001247--[[Change this %s so it needs a water source.--]]),name))
      else
        action.ActionId = ""
      end

    elseif action.ActionId == "OxygenFree" then
      if obj.electricity_consumption then
        SetHint(action,string.format(T(302535920001248--[[Change this %s so it doesn't need a oxygen source.--]]),name))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "OxygenNeed" then
      if obj.electricity_consumption then
        SetHint(action,string.format(T(302535920001249--[[Change this %s so it needs a oxygen source.--]]),name))
      else
        action.ActionId = ""
      end

    elseif action.ActionId == "HideSigns" then
      if obj:IsKindOf("SurfaceDeposit") or obj:IsKindOf("SubsurfaceDeposit") or obj:IsKindOf("WasteRockDumpSite") or obj:IsKindOf("UniversalStorageDepot") then
        action.ActionId = ""
      else
        SetHint(action,string.format(T(302535920001223--[[Hides any signs above %s (until state is changed).--]]),name))
      end

    elseif action.ActionId == "ColourRandom" then
      if obj:IsKindOf("WasteRockDumpSite") then
        action.ActionId = ""
      else
        SetHint(action,string.format(T(302535920001224--[[Changes colour of %s to random colours (doesn't change attachments).--]]),name))
      end
    elseif action.ActionId == "ColourDefault" then
      if obj:IsKindOf("WasteRockDumpSite") then
        action.ActionId = ""
      else
        SetHint(action,string.format(T(302535920001246--[[Changes colour of %s back to default.--]]),name))
      end
    elseif action.ActionId == "AddDust" then
      if obj.class == "SupplyRocket" or obj.class == "UniversalStorageDepot" or obj.class == "WasteRockDumpSite" then
        action.ActionId = ""
      else
        SetHint(action,T(302535920001225--[[Add visual dust and maintenance points.--]]))
      end
    elseif action.ActionId == "CleanAndFix" then
      if obj.class == "SupplyRocket" or obj.class == "UniversalStorageDepot" or obj.class == "WasteRockDumpSite" then
        action.ActionId = ""
      else
        SetHint(action,T(302535920001226--[[You may need to use AddDust before using this to change the building visually.--]]))
      end
    elseif action.ActionId == "Destroy" then
      if obj.class == "SupplyRocket" then
        action.ActionId = ""
      else
        SetHint(action,T(302535920001227--[[Turns object into ruin.--]]))
      end
    elseif action.ActionId == "Empty" then
      if obj.class:find("SubsurfaceDeposit") then
        SetHint(action,Concat(T(6779--[[Warning--]]),": ",string.format(T(302535920001228--[[This will remove the %s object from the map.--]]),name)))
      else
        SetHint(action,T(302535920001230--[[Empties the storage of this building.

If this isn't a dumping site then waste rock will not be emptied.--]]))
      end
    elseif action.ActionId == "Refill" then
      SetHint(action,T(302535920001231--[[Refill the deposit to full capacity.--]]))
    elseif action.ActionId == "Fill" then
      SetHint(action,T(302535920001232--[[Fill the storage of this building.--]]))
    elseif action.ActionId == "Launch" then
      SetHint(action,Concat(T(6779--[[Warning--]]),": ",T(302535920001233--[[Launches rocket without asking.--]])))
    elseif action.ActionId == "DoubleMaxAmount" then
      SetHint(action,string.format(T(302535920001234--[[Double the amount this %s can hold.--]]),name))
    elseif action.ActionId == "ReneagadeCapDbl" then
      SetHint(action,string.format(T(302535920001236--[[Double amount of reneagades this station can negate (currently: %s) < Reselect to update amount.--]]),obj.negated_renegades))
    end

  end --for

  return true
end
