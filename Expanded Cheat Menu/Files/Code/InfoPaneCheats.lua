-- See LICENSE for terms

-- add items/hint to the cheats pane

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings
local ResourceScale = ChoGGi.Consts.ResourceScale

local CurrentMap = CurrentMap
local DelayedCall = DelayedCall
local DestroyBuildingImmediate = DestroyBuildingImmediate
local IsValid = IsValid
local Random = Random
local RebuildInfopanel = RebuildInfopanel

local pf_SetStepLen = pf.SetStepLen

do
  local Object = Object
  local Building = Building
  local Colonist = Colonist
  local Workplace = Workplace

--~   global objects
  function SupplyRocket:CheatFuel()
    local const = const
    self.accumulated_fuel = self.refuel_request:GetTargetAmount()
    self.refuel_request = Request_New(self, "Fuel", 0, const.rfStorageDepot + const.rfPairWithHigher,-1)
    Msg("RocketRefueled", self)
    RebuildInfopanel(self)
  end
  function Building:CheatDestroy()
    local ChoGGi = ChoGGi
    local name = ChoGGi.ComFuncs.RetName(self)
    local obj_type
    if self:IsKindOf("BaseRover") then
      obj_type = S[7825--[[Destroy this Rover.--]]]
    elseif self:IsKindOf("Drone") then
      obj_type = S[7824--[[Destroy this Drone.--]]]
    else
      obj_type = S[7822--[[Destroy this building.--]]]
    end

    local function CallBackFunc(answer)
      if answer then
        self.indestructible = false
        DestroyBuildingImmediate(self)
      end
    end
    ChoGGi.ComFuncs.QuestionBox(
      Concat(S[6779--[[Warning--]]],"!\n",obj_type,"\n",name),
      CallBackFunc,
      Concat(S[6779--[[Warning--]]],": ",obj_type),
      Concat(obj_type," ",name),
      S[1176--[[Cancel Destroy--]]]
    )
  end
  function Object:CheatDeleteObject()
    local ChoGGi = ChoGGi
    local name = ChoGGi.ComFuncs.RetName(self)
    local function CallBackFunc(answer)
      if answer then
        ChoGGi.CodeFuncs.DeleteObject(self)
      end
    end
    ChoGGi.ComFuncs.QuestionBox(
      Concat(S[6779--[[Warning--]]],"!\n",S[302535920000885--[[Permanently delete %s?--]]]:format(name),"?"),
      CallBackFunc,
      Concat(S[6779--[[Warning--]]],": ",S[302535920000855--[[Last chance before deletion!--]]]),
      Concat(S[5451--[[DELETE--]]],": ",name),
      Concat(S[6879--[[Cancel--]]]," ",S[1000287--[[Delete--]]])
    )
  end

  Object.CheatExamine = OpenExamine

  -- consumption
  function Building:CheatPowerFree()
    ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
  end
  function Building:CheatPowerNeed()
    ChoGGi.CodeFuncs.AddBuildingElecConsump(self)
  end
  --
  function Building:CheatWaterFree()
    ChoGGi.CodeFuncs.RemoveBuildingWaterConsump(self)
  end
  function Building:CheatWaterNeed()
    ChoGGi.CodeFuncs.AddBuildingWaterConsump(self)
  end
  --
  function Building:CheatOxygenFree()
    ChoGGi.CodeFuncs.RemoveBuildingOxygenConsump(self)
  end
  function Building:CheatOxygenNeed()
    ChoGGi.CodeFuncs.AddBuildingOxygenConsump(self)
  end
  --~
  function Object:CheatHideSigns()
    self:DestroyAttaches("BuildingSign")
  end
  function Object:CheatColourRandom()
    ChoGGi.CodeFuncs.ObjectColourRandom(self)
  end
  function Object:CheatColourDefault()
    ChoGGi.CodeFuncs.ObjectColourDefault(self)
  end

  --colonists
  function Colonist:CheatFillMorale()
    self.stat_morale = 100 * ResourceScale
  end
  function Colonist:CheatFillSanity()
    self.stat_sanity = 100 * ResourceScale
  end
  function Colonist:CheatFillComfort()
    self.stat_comfort = 100 * ResourceScale
  end
  function Colonist:CheatFillHealth()
    self.stat_health = 100 * ResourceScale
  end
  function Colonist:CheatFillAll()
    self:CheatFillSanity()
    self:CheatFillComfort()
    self:CheatFillHealth()
    self:CheatFillMorale()
  end
  function Colonist:CheatRenegade()
    self:AddTrait("Renegade",true)
  end
  function Colonist:CheatRenegadeClear()
    self:RemoveTrait("Renegade")
    DelayedCall(100, function()
      self:CheatFillMorale()
    end)
  end
  function Colonist:CheatRandomRace()
    self.race = Random(1,5)
    self:ChooseEntity()
  end
  function Colonist:CheatRandomSpec()
    --skip children, or they'll be a black cube
    if not self.entity:find("Child",1,true) then
      self:SetSpecialization(ChoGGi.Tables.ColonistSpecializations[Random(1,6)],"init")
    end
  end
  function Colonist:CheatPrefDbl()
    self.performance = self.performance * 2
  end
  function Colonist:CheatPrefDef()
    self.performance = self.base_performance
  end
  function Colonist:CheatRandomGender()
    ChoGGi.CodeFuncs.ColonistUpdateGender(self,ChoGGi.Tables.ColonistGenders[Random(1,5)])
  end
  function Colonist:CheatRandomAge()
    ChoGGi.CodeFuncs.ColonistUpdateAge(self,ChoGGi.Tables.ColonistAges[Random(1,6)])
  end
  --CheatAllShifts
  local function CheatAllShiftsOn(self)
    self.closed_shifts[1] = false
    self.closed_shifts[2] = false
    self.closed_shifts[3] = false
  end
  FungalFarm.CheatAllShiftsOn = CheatAllShiftsOn
  Farm.CheatAllShiftsOn = CheatAllShiftsOn

  --CheatFullyAuto
  function Workplace:CheatWorkersDbl()
    self.max_workers = self.max_workers * 2
  end
  function Workplace:CheatWorkersDef()
    self.max_workers = self.base_max_workers
  end
  function Workplace:CheatWorkAuto()
    local ChoGGi = ChoGGi
    self.max_workers = 0
    self.automation = 1
    local bs = ChoGGi.UserSettings.BuildingSettings
    bs = bs and bs[self.encyclopedia_id] and bs[self.encyclopedia_id].performance or 150
    self.auto_performance = bs
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end
  function Workplace:CheatWorkManual()
    self.max_workers = nil
    self.automation = nil
    self.auto_performance = nil
    ChoGGi.CodeFuncs.ToggleWorking(self)
  end

  --CheatDoubleMaxAmount
  function Deposit:CheatDoubleMaxAmount()
    self.max_amount = self.max_amount * 2
  end
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
  function Residence:CheatColonistCapDbl(self)
    if self.capacity == 4096 then
      return
    end
    self.capacity = self.capacity * 2
  end
  function Residence:CheatColonistCapDef(self)
    self.capacity = self.base_capacity
  end

  --CheatVisitorsDbl
  function Service:CheatVisitorsDbl(self)
    if self.max_visitors == 4096 then
      return
    end
    self.max_visitors = self.max_visitors * 2
  end
  function Service:CheatVisitorsDef(self)
    self.max_visitors = self.base_max_visitors
  end

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
  Drone.CheatBattCapDbl = CheatBattCapDbl
  Drone.CheatBattCapDef = CheatBattCapDef
  BaseRover.CheatBattCapDbl = CheatBattCapDbl
  BaseRover.CheatBattCapDef = CheatBattCapDef
  --CheatMoveSpeedDbl
  local function CheatMoveSpeedDbl(self)
    --self:SetMoveSpeed(self:GetMoveSpeed() * 2)
    pf_SetStepLen(self,self:GetMoveSpeed() * 2)
  end
  local function CheatMoveSpeedDef(self)
    --self:SetMoveSpeed(self.base_move_speed)
    pf_SetStepLen(self,self.base_move_speed)
  end
  Drone.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  Drone.CheatMoveSpeedDef = CheatMoveSpeedDef
  BaseRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
  BaseRover.CheatMoveSpeedDef = CheatMoveSpeedDef
  local function CheatBattRefill(self)
    self.battery_current = self.battery_max
  end
  BaseRover.CheatBattRefill = CheatBattRefill
  function Drone:CheatBattRefill()
    self.battery = self.battery_max
  end
  local function CheatFindResource(self)
    ChoGGi.CodeFuncs.FindNearestResource(self)
  end
  Drone.CheatFindResource = CheatFindResource
  RCTransport.CheatFindResource = CheatFindResource
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

  Drone.CheatCleanAndFix = CheatCleanAndFixDrone
  BaseRover.CheatCleanAndFix = CheatCleanAndFix
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

  --~   function SupplyRocket:CheatCapDbl()
  --~     self.max_export_storage = self.max_export_storage * 2
  --~   end
  --~   function SupplyRocket:CheatCapDef()
  --~     self.max_export_storage = self.base_max_export_storage
  --~   end
end -- do

function ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  local g_Classes = g_Classes
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
    doublec = S[302535920001199--[["Double the amount of colonist slots for this %s.

Reselect to update display."--]]]:format(name)
    resetc = S[302535920001200--[["Reset the capacity of colonist slots for this %s.

Reselect to update display."--]]]:format(name)
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
      SetHint(action,S[302535920001202--[[Fill all stat bars.--]]])
    elseif action.ActionId == "SpawnColonist" then
      SetHint(action,S[302535920000005--[[Drops a new colonist in selected dome.--]]])
    elseif action.ActionId == "PrefDbl" then
      SetHint(action,S[302535920001203--[[Double %s's performance.--]]]:format(name))
    elseif action.ActionId == "PrefDef" then
      SetHint(action,S[302535920001204--[[Reset %s's performance to default.--]]]:format(name))
    elseif action.ActionId == "RandomSpecialization" then
      SetHint(action,S[302535920001205--[[Randomly set %s's specialization.--]]]:format(name))

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
        SetHint(action,S[302535920001207--[["Add: %s to this building.

%s."--]]]:format(tempname,T(obj.upgrade1_description)))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "Upgrade2" then
      local tempname = T(obj.upgrade2_display_name)
      if tempname ~= "" then
        SetHint(action,S[302535920001207--[["Add: %s to this building.

%s."--]]]:format(tempname,T(obj.upgrade2_description)))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "Upgrade3" then
      local tempname = T(obj.upgrade3_display_name)
      if tempname ~= "" then
        SetHint(action,S[302535920001207--[["Add: %s to this building.

%s."--]]]:format(tempname,T(obj.upgrade3_description)))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "WorkAuto" then
      local bs = ChoGGi.UserSettings.BuildingSettings
      SetHint(action,S[302535920001209--[[Make this %s not need workers (performance: %s).--]]]:format(name,bs and bs[id] and bs[id].performance or 150))

    elseif action.ActionId == "WorkManual" then
      SetHint(action,S[302535920001210--[[Make this %s need workers.--]]]:format(name))
    elseif action.ActionId == "CapDbl" then
      if obj:IsKindOf("SupplyRocket") then
        SetHint(action,S[302535920001211--[[Double the export storage capacity of this %s.--]]]:format(name))
      else
        SetHint(action,S[302535920001212--[[Double the storage capacity of this %s.--]]]:format(name))
      end
    elseif action.ActionId == "CapDef" then
      SetHint(action,S[302535920001213--[[Reset the storage capacity of this %s to default.--]]]:format(name))
    elseif action.ActionId == "EmptyDepot" then
      SetHint(action,S[302535920001214--[[sticks small depot in front of mech depot and moves all resources to it (max of 20 000).--]]])

--Farms
    elseif action.ActionId == "AllShifts" then
      SetHint(action,S[302535920001215--[[Turn on all work shifts.--]]])

--RC
    elseif action.ActionId == "BattCapDbl" then
      SetHint(action,S[302535920001216--[[Double the battery capacity.--]]])
    elseif action.ActionId == "MaxShuttlesDbl" then
      SetHint(action,S[302535920001217--[[Double the shuttles this ShuttleHub can control.--]]])
    elseif action.ActionId == "FindResource" then
      SetHint(action,S[302535920001218--[[Selects nearest storage containing specified resource (shows list of resources).--]]])

--Misc
    elseif action.ActionId == "Examine" then
      SetHint(action,S[302535920001277--[[Open %s in the Object Examiner.--]]]:format(name))
    elseif action.ActionId == "Fuel" then
      SetHint(action,S[302535920001053--[[Fill up %s with fuel.--]]]:format(name))

    elseif action.ActionId == "DeleteObject" then
      SetHint(action,S[302535920000885--[[Permanently delete %s--]]]:format(name))

    elseif action.ActionId == "Malfunction" then
      SetHint(action,Concat(S[8039--[[Trait: Idiot (can cause a malfunction)--]]],"...\n",S[53--[[Malfunction--]]],"?"))
    elseif action.ActionId == "PowerFree" then
      if obj.electricity_consumption then
        SetHint(action,S[302535920001220--[[Change this %s so it doesn't need a power source.--]]]:format(name))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "PowerNeed" then
      if obj.electricity_consumption then
        SetHint(action,S[302535920001221--[[Change this %s so it needs a power source.--]]]:format(name))
      else
        action.ActionId = ""
      end

    elseif action.ActionId == "WaterFree" then
      if obj.water_consumption then
        SetHint(action,S[302535920000853--[[Change this %s so it doesn't need a water source.--]]]:format(name))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "WaterNeed" then
      if obj.water_consumption then
        SetHint(action,S[302535920001247--[[Change this %s so it needs a water source.--]]]:format(name))
      else
        action.ActionId = ""
      end

    elseif action.ActionId == "OxygenFree" then
      if obj.air_consumption then
        SetHint(action,S[302535920001248--[[Change this %s so it doesn't need a oxygen source.--]]]:format(name))
      else
        action.ActionId = ""
      end
    elseif action.ActionId == "OxygenNeed" then
      if obj.air_consumption then
        SetHint(action,S[302535920001249--[[Change this %s so it needs a oxygen source.--]]]:format(name))
      else
        action.ActionId = ""
      end

    elseif action.ActionId == "HideSigns" then
      if obj:IsKindOf("SurfaceDeposit") or obj:IsKindOf("SubsurfaceDeposit") or obj:IsKindOf("WasteRockDumpSite") or obj:IsKindOf("UniversalStorageDepot") then
        action.ActionId = ""
      else
        SetHint(action,S[302535920001223--[[Hides any signs above %s (until state is changed).--]]]:format(name))
      end

    elseif action.ActionId == "ColourRandom" then
      if obj:IsKindOf("WasteRockDumpSite") then
        action.ActionId = ""
      else
        SetHint(action,S[302535920001224--[[Changes colour of %s to random colours (doesn't change attachments).--]]]:format(name))
      end
    elseif action.ActionId == "ColourDefault" then
      if obj:IsKindOf("WasteRockDumpSite") then
        action.ActionId = ""
      else
        SetHint(action,S[302535920001246--[[Changes colour of %s back to default.--]]]:format(name))
      end
    elseif action.ActionId == "AddDust" then
      if obj.class == "SupplyRocket" or obj.class == "UniversalStorageDepot" or obj.class == "WasteRockDumpSite" then
        action.ActionId = ""
      else
        SetHint(action,S[302535920001225--[[Add visual dust and maintenance points.--]]])
      end
    elseif action.ActionId == "CleanAndFix" then
      if obj.class == "SupplyRocket" or obj.class == "UniversalStorageDepot" or obj.class == "WasteRockDumpSite" then
        action.ActionId = ""
      else
        SetHint(action,S[302535920001226--[[You may need to use AddDust before using this to change the building visually.--]]])
      end
    elseif action.ActionId == "Destroy" then
      if obj.class == "SupplyRocket" then
        action.ActionId = ""
      else
        SetHint(action,S[302535920001227--[[Turns object into ruin.--]]])
      end
    elseif action.ActionId == "Empty" then
      if obj.class:find("SubsurfaceDeposit") then
        SetHint(action,Concat(S[6779--[[Warning--]]],": ",S[302535920001228--[[This will remove the %s object from the map.--]]]:format(name)))
      else
        SetHint(action,S[302535920001230--[[Empties the storage of this building.

If this isn't a dumping site then waste rock will not be emptied.--]]])
      end
    elseif action.ActionId == "Refill" then
      SetHint(action,S[302535920001231--[[Refill the deposit to full capacity.--]]])
    elseif action.ActionId == "Fill" then
      SetHint(action,S[302535920001232--[[Fill the storage of this building.--]]])
    elseif action.ActionId == "Launch" then
      SetHint(action,Concat(S[6779--[[Warning--]]],": ",S[302535920001233--[[Launches rocket without asking.--]]]))
    elseif action.ActionId == "DoubleMaxAmount" then
      SetHint(action,S[302535920001234--[[Double the amount this %s can hold.--]]]:format(name))
    elseif action.ActionId == "ReneagadeCapDbl" then
      SetHint(action,S[302535920001236--[[Double amount of reneagades this station can negate (currently: %s) < Reselect to update amount.--]]]:format(obj.negated_renegades))
    end

  end --for

  return true
end
