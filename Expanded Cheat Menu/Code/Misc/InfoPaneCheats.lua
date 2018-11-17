-- See LICENSE for terms

-- add items/hint to the cheats pane

local StringFormat = string.format
local TableFind = table.find
local DeleteThread = DeleteThread
local CreateRealTimeThread = CreateRealTimeThread

local RetName
local Random
local Trans
local S
local ResourceScale

function OnMsg.ClassesGenerate()
	RetName = ChoGGi.ComFuncs.RetName
	Random = ChoGGi.ComFuncs.Random
	Trans = ChoGGi.ComFuncs.Translate
	S = ChoGGi.Strings
	ResourceScale = ChoGGi.Consts.ResourceScale

	Object.CheatExamine = ChoGGi.ComFuncs.OpenInExamineDlg
	Drone.CheatFindResource = ChoGGi.ComFuncs.FindNearestResource
	RCTransport.CheatFindResource = ChoGGi.ComFuncs.FindNearestResource

	function ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
		local g_Classes = g_Classes
		if not CurrentMap:find("Tutorial") then
			g_Classes.Building.CheatAddMaintenancePnts = nil
			g_Classes.Building.CheatMakeSphereTarget = nil
			g_Classes.Building.CheatSpawnWorker = nil
			g_Classes.Building.CheatSpawnVisitor = nil
		end
	end

	local function SetHint(action,hint)
		-- name has to be set to make the hint show up
		action.ActionName = action.ActionId
		action.RolloverText = hint
		action.RolloverHint = S[302535920000083--[[<left_click> Activate--]]]
	end
	local function SetIcon(action,name,icon)
		-- we're changing the name so we'll set the hint title to the orig
		action.RolloverTitle = action.ActionName
		action.ActionName = name or "\0"
		action.ActionIcon = icon
	end

	local cheats_thread
	function ChoGGi.InfoFuncs.SetInfoPanelCheatHints(win,section)

		local obj = win.context
		local name = RetName(obj)
		local id = obj.template_name
		--needs to be strings or else!@!$@!
		local doublec = ""
		local resetc = ""
		if id then
			doublec = S[302535920001199--[["Double the amount of colonist slots for this %s.

	Reselect to update display."--]]]:format(name)
			resetc = S[302535920001200--[["Reset the capacity of colonist slots for this %s.

	Reselect to update display."--]]]:format(name)
		end
		for i = 1, #win.actions do
			local action = win.actions[i]

	-- Colonists
			if action.ActionId == "FillAll" then
				SetHint(action,S[302535920001202--[[Fill all stat bars.--]]])
			elseif action.ActionId == "SpawnColonist" then
				SetHint(action,S[302535920000005--[[Drops a new colonist in selected dome.--]]])
				SetIcon(action,nil,"UI/Icons/ColonyControlCenter/colonist_on.tga")
			elseif action.ActionId == "PrefDbl" then
				SetHint(action,S[302535920001203--[[Double %s's performance.--]]]:format(name))
			elseif action.ActionId == "PrefDef" then
				SetHint(action,S[302535920001204--[[Reset %s's performance to default.--]]]:format(name))
			elseif action.ActionId == "RandomSpecialization" then
				SetHint(action,S[302535920001205--[[Randomly set %s's specialization.--]]]:format(name))

	-- Buildings
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

			elseif action.ActionId == "PowerFree" then
				if obj.electricity_consumption then
					SetHint(action,S[302535920001220--[[Change this %s so it doesn't need a power source.--]]]:format(name))
					SetIcon(action,S[4325--[[Free--]]],"UI/Icons/res_electricity.tga")
				else
					action.ActionId = ""
				end
			elseif action.ActionId == "PowerNeed" then
				if obj.electricity_consumption then
					SetHint(action,S[302535920001221--[[Change this %s so it needs a power source.--]]]:format(name))
					SetIcon(action,S[302535920000162--[[Need--]]],"UI/Icons/res_electricity.tga")
				else
					action.ActionId = ""
				end

			elseif action.ActionId == "WaterFree" then
				if obj.water_consumption then
					SetHint(action,S[302535920000853--[[Change this %s so it doesn't need a water source.--]]]:format(name))
					SetIcon(action,S[4325--[[Free--]]],"UI/Icons/res_water.tga")
				else
					action.ActionId = ""
				end
			elseif action.ActionId == "WaterNeed" then
				if obj.water_consumption then
					SetHint(action,S[302535920001247--[[Change this %s so it needs a water source.--]]]:format(name))
					SetIcon(action,S[302535920000162--[[Need--]]],"UI/Icons/res_water.tga")
				else
					action.ActionId = ""
				end

			elseif action.ActionId == "OxygenFree" then
				if obj.air_consumption then
					SetHint(action,S[302535920001248--[[Change this %s so it doesn't need a oxygen source.--]]]:format(name))
					SetIcon(action,S[4325--[[Free--]]],"UI/Icons/res_oxygen.tga")
				else
					action.ActionId = ""
				end
			elseif action.ActionId == "OxygenNeed" then
				if obj.air_consumption then
					SetHint(action,S[302535920001249--[[Change this %s so it needs a oxygen source.--]]]:format(name))
					SetIcon(action,S[302535920000162--[[Need--]]],"UI/Icons/res_oxygen.tga")
				else
					action.ActionId = ""
				end

			elseif action.ActionId == "Upgrade1" then
				local tempname = Trans(obj.upgrade1_display_name)
				if tempname ~= "" then
					SetHint(action,S[302535920001207--[["Add: %s to this building.

	%s."--]]]:format(tempname,Trans(T{obj.upgrade1_description,obj})))
					SetIcon(action,1,obj.upgrade1_icon)
				else
					action.ActionId = ""
				end
			elseif action.ActionId == "Upgrade2" then
				local tempname = Trans(obj.upgrade2_display_name)
				if tempname ~= "" then
					SetHint(action,S[302535920001207--[["Add: %s to this building.

	%s."--]]]:format(tempname,Trans(T{obj.upgrade2_description,obj})))
					SetIcon(action,2,obj.upgrade2_icon)
				else
					action.ActionId = ""
				end
			elseif action.ActionId == "Upgrade3" then
				local tempname = Trans(obj.upgrade3_display_name)
				if tempname ~= "" then
					SetHint(action,S[302535920001207--[["Add: %s to this building.

	%s."--]]]:format(tempname,Trans(T{obj.upgrade3_description,obj})))
					SetIcon(action,3,obj.upgrade2_icon)
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
			elseif action.ActionId == "Quick build" then
				SetHint(action,S[302535920000060--[[Instantly complete building without needing resources.--]]])

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
				SetIcon(action,nil,"CommonAssets/UI/Menu/EV_OpenFirst.tga")

	--Misc
			elseif action.ActionId == "Scan" then
				SetHint(action,S[979029137252--[[Scanned an Anomaly--]]])
				SetIcon(action,nil,"UI/Icons/pin_scan.tga")

			elseif action.ActionId == "Examine" then
				SetHint(action,S[302535920001277--[[Open %s in the Object Examiner.--]]]:format(name))
--~ 				SetIcon(action,nil,StringFormat("%sUI/TheIncal.png",ChoGGi.LibraryPath))

			elseif action.ActionId == "AddFuel" then
				SetHint(action,S[302535920001053--[[Fill up %s with fuel.--]]]:format(name))
				SetIcon(action,nil,"UI/Icons/res_fuel.tga")

			elseif action.ActionId == "DeleteObject" then
				SetHint(action,S[302535920000885--[[Permanently delete %s--]]]:format(name))
				SetIcon(action,nil,"UI/Icons/Sections/warning.tga")

			elseif action.ActionId == "Malfunction" then
				if obj.destroyed or obj.is_malfunctioned then
					action.ActionId = ""
				else
					SetHint(action,StringFormat("%s...\n%s?",S[8039--[[Trait: Idiot (can cause a malfunction)--]]],S[53--[[Malfunction--]]]))
--~ 					SetIcon(action,nil,"UI/Icons/Notifications/dust_storm_2.tga")
				end

			elseif action.ActionId == "HideSigns" then
				if obj:IsKindOfClasses("SurfaceDeposit","SubsurfaceDeposit","WasteRockDumpSite","UniversalStorageDepot") then
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
				if obj:IsKindOfClasses("SupplyRocket","UniversalStorageDepot","WasteRockDumpSite") then
					action.ActionId = ""
				else
					SetHint(action,S[302535920001225--[[Add visual dust and maintenance points.--]]])
--~ 					SetIcon(action,nil,"UI/Icons/Notifications/dust_storm.tga")
				end
			elseif action.ActionId == "CleanAndFix" then
				if obj:IsKindOfClasses("SupplyRocket","UniversalStorageDepot","WasteRockDumpSite") then
					action.ActionId = ""
				else
					SetHint(action,S[302535920001226--[[You may need to use AddDust before using this to change the building visually.--]]])
				end
			elseif action.ActionId == "Destroy" then
				if obj:IsKindOf("SupplyRocket") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action,S[302535920001227--[[Turns object into ruin.--]]])
					SetIcon(action,nil,"UI/Icons/IPButtons/demolition.tga")
				end
			elseif action.ActionId == "Empty" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = nil
				else
					if obj:IsKindOfClasses("SubsurfaceDeposit","TerrainDeposit") then
						SetHint(action,S[302535920001228--[[Set the stored amount of this %s to 0.--]]]:format(name))
					else
						SetHint(action,S[302535920001230--[[Empties the storage of this building.

	If this isn't a dumping site then waste rock will not be emptied.--]]])
					end
				end
			elseif action.ActionId == "Refill" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = nil
				else
					SetHint(action,S[302535920001231--[[Refill the deposit to full capacity.--]]])
				end
			elseif action.ActionId == "Fill" then
				SetHint(action,S[302535920001232--[[Fill the storage of this building.--]]])
			elseif action.ActionId == "Launch" then
				SetHint(action,StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920001233--[[Launches rocket without asking.--]]]))
				SetIcon(action,nil,"UI/Icons/ColonyControlCenter/rocket_r.tga")
--~ 				SetIcon(action,nil,"UI/Achievements/YouCantTakeTheSkyFromMe.tga")

			elseif action.ActionId == "DoubleMaxAmount" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = nil
				else
					SetHint(action,S[302535920001234--[[Double the amount this %s can hold.--]]]:format(name))
				end
			elseif action.ActionId == "ReneagadeCapDbl" then
				SetHint(action,S[302535920001236--[[Double amount of reneagades this station can negate (currently: %s) < Reselect to update amount.--]]]:format(obj.negated_renegades))
			end

		end --for

		return true
	end
end


local Object = Object
local Building = Building
local Colonist = Colonist
local Workplace = Workplace

--~	 global objects
function Object:CheatDeleteObject()
	local ChoGGi = ChoGGi
	local name = RetName(self)
	local function CallBackFunc(answer)
		if answer then
			ChoGGi.ComFuncs.DeleteObject(self)
			SelectObj()
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		StringFormat("%s!\n%s?",S[6779--[[Warning--]]],S[302535920000885--[[Permanently delete %s?--]]]:format(name)),
		CallBackFunc,
		StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]]),
		StringFormat("%s: %s",S[5451--[[DELETE--]]],name),
		StringFormat("%s %s",S[6879--[[Cancel--]]],S[1000615--[[Delete--]]])
	)
end
function Object:CheatHideSigns()
	self:DestroyAttaches("BuildingSign")
end
function Object:CheatColourRandom()
	ChoGGi.ComFuncs.ObjectColourRandom(self)
end
function Object:CheatColourDefault()
	ChoGGi.ComFuncs.ObjectColourDefault(self)
end

function Building:CheatDestroy()
	local ChoGGi = ChoGGi
	local name = RetName(self)
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
			if self:IsKindOf("Dome") and #(self.labels.Buildings or "") > 0 then
				MsgPopup(
					S[302535920001354--[[%s is a Dome with buildings (likely crash if deleted).--]]]:format(RetName(self)),
					302535920000489--[[Delete Object(s)--]]
				)
				return
			end

			self.can_demolish = true
			self.indestructible = false
			DestroyBuildingImmediate(self)
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		StringFormat("%s!\n%s\n%s",S[6779--[[Warning--]]],obj_type,name),
		CallBackFunc,
		StringFormat("%s: %s",S[6779--[[Warning--]]],obj_type),
		StringFormat("%s %s",obj_type,name),
		S[1176--[[Cancel Destroy--]]]
	)
end

-- consumption
function Building:CheatPowerFree()
	ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
end

function Building:CheatPowerNeed()
	ChoGGi.ComFuncs.AddBuildingElecConsump(self)
end
--
function Building:CheatWaterFree()
	ChoGGi.ComFuncs.RemoveBuildingWaterConsump(self)
end
function Building:CheatWaterNeed()
	ChoGGi.ComFuncs.AddBuildingWaterConsump(self)
end
--
function Building:CheatOxygenFree()
	ChoGGi.ComFuncs.RemoveBuildingAirConsump(self)
end
function Building:CheatOxygenNeed()
	ChoGGi.ComFuncs.AddBuildingAirConsump(self)
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
	CreateRealTimeThread(function()
		Sleep(100)
		self:CheatFillMorale()
	end)
end
function Colonist:CheatRandomRace()
	self.race = Random(1,5)
	self:ChooseEntity()
end
function Colonist:CheatRandomSpec()
	-- skip children, or they'll be a black cube
	if not self.entity:find("Child") then
		self:SetSpecialization(ChoGGi.Tables.ColonistSpecializations[Random(1,#ChoGGi.Tables.ColonistSpecializations)],"init")
	end
end
function Colonist:CheatPrefDbl()
	self.performance = self.performance * 2
end
function Colonist:CheatPrefDef()
	self.performance = self.base_performance
end
function Colonist:CheatRandomGender()
	ChoGGi.ComFuncs.ColonistUpdateGender(self,ChoGGi.Tables.ColonistGenders[Random(1,#ChoGGi.Tables.ColonistGenders)])
end
function Colonist:CheatRandomAge()
	ChoGGi.ComFuncs.ColonistUpdateAge(self,ChoGGi.Tables.ColonistAges[Random(1,#ChoGGi.Tables.ColonistAges)])
end
-- CheatAllShifts
local function CheatAllShiftsOn(self)
	self.closed_shifts[1] = false
	self.closed_shifts[2] = false
	self.closed_shifts[3] = false
end
FungalFarm.CheatAllShiftsOn = CheatAllShiftsOn
Farm.CheatAllShiftsOn = CheatAllShiftsOn

-- CheatFullyAuto
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
	bs = bs and bs[self.template_name]
	if bs then
		-- changed saving as performance to auto_performance, get rid of this in a few months
		self.auto_performance = bs.auto_performance or bs.performance
	else
		self.auto_performance = 150
	end
	ChoGGi.ComFuncs.ToggleWorking(self)
end
function Workplace:CheatWorkManual()
	self.max_workers = nil
	self.automation = nil
	self.auto_performance = nil
	ChoGGi.ComFuncs.ToggleWorking(self)
end

-- Deposits
function Deposit:CheatDoubleMaxAmount()
	self.max_amount = self.max_amount * 2
end
local function CheatEmpty(self)
	-- it'll look empty, but it won't actually remove the object
	self.amount = 1
end
SubsurfaceDeposit.CheatEmpty = CheatEmpty
TerrainDeposit.CheatEmpty = CheatEmpty
function TerrainDeposit:CheatRefill()
	self.amount = self.max_amount
end

-- CheatCapDbl storage
function ElectricityStorage:CheatCapDbl()
	self.capacity = self.capacity * 2
	self.electricity.storage_capacity = self.capacity
	self.electricity.storage_mode = "charging"
	ChoGGi.ComFuncs.ToggleWorking(self)
end
function ElectricityStorage:CheatCapDef()
	self.capacity = self.base_capacity
	self.electricity.storage_capacity = self.capacity
	self.electricity.storage_mode = "full"
	ChoGGi.ComFuncs.ToggleWorking(self)
end
--
function WaterTank:CheatCapDbl()
	self.water_capacity = self.water_capacity * 2
	self.water.storage_capacity = self.water_capacity
	self.water.storage_mode = "charging"
	ChoGGi.ComFuncs.ToggleWorking(self)
end
function WaterTank:CheatCapDef()
	self.water_capacity = self.base_water_capacity
	self.water.storage_capacity = self.water_capacity
	self.water.storage_mode = "full"
	ChoGGi.ComFuncs.ToggleWorking(self)
end
--
function OxygenTank:CheatCapDbl()
	self.air_capacity = self.air_capacity * 2
	self.air.storage_capacity = self.air_capacity
	self.air.storage_mode = "charging"
	ChoGGi.ComFuncs.ToggleWorking(self)
end
function OxygenTank:CheatCapDef()
	self.air_capacity = self.base_air_capacity
	self.air.storage_capacity = self.air_capacity
	self.air.storage_mode = "full"
	ChoGGi.ComFuncs.ToggleWorking(self)
end
--
-- CheatCapDbl people
function Residence:CheatColonistCapDbl()
	if self.capacity == 4096 then
		return
	end
	self.capacity = self.capacity * 2
end
function Residence:CheatColonistCapDef()
	self.capacity = self.base_capacity
end

-- CheatVisitorsDbl
function Service:CheatVisitorsDbl()
	if self.max_visitors == 4096 then
		return
	end
	self.max_visitors = self.max_visitors * 2
end
function Service:CheatVisitorsDef()
	self.max_visitors = self.base_max_visitors
end

-- Double Shuttles
function ShuttleHub:CheatMaxShuttlesDbl()
	self.max_shuttles = self.max_shuttles * 2
end
function ShuttleHub:CheatMaxShuttlesDef()
	self.max_shuttles = self.base_max_shuttles
end

function Drone:CheatBattCapDbl()
	self.battery_max = self.battery_max * 2
end
function Drone:CheatBattCapDef()
	self.battery_max = const.BaseRoverMaxBattery
end
function Drone:CheatBattEmpty()
	self:ApplyBatteryChange(self.battery_max * -1)
end
function Drone:CheatBattRefill()
	self.battery = self.battery_max
end

-- CheatMoveSpeedDbl
local function CheatMoveSpeedDbl(self)
	self:SetMoveSpeed(self:GetMoveSpeed() * 2)
end
local function CheatMoveSpeedDef(self)
	self:SetMoveSpeed(self.base_move_speed)
end
Drone.CheatMoveSpeedDbl = CheatMoveSpeedDbl
Drone.CheatMoveSpeedDef = CheatMoveSpeedDef
BaseRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
BaseRover.CheatMoveSpeedDef = CheatMoveSpeedDef
-- CheatCleanAndFix
Drone.CheatCleanAndFix = function(self)
	self:CheatMalfunction()
	CreateRealTimeThread(function()
		Sleep(1)
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
BaseRover.CheatCleanAndFix = function(self)
	self:CheatMalfunction()
	CreateRealTimeThread(function()
		Sleep(1)
		self:Repair()
 end)
end
-- misc
function SecurityStation:CheatReneagadeCapDbl()
	self.negated_renegades = self.negated_renegades * 2
end
function SecurityStation:CheatReneagadeCapDef()
	self.negated_renegades = self.max_negated_renegades
end
function MechanizedDepot:CheatEmptyDepot()
	ChoGGi.ComFuncs.EmptyMechDepot(self)
end

function SupplyRocket:CheatCapDbl()
	ChoGGi.ComFuncs.SetTaskReqAmount(self,self.max_export_storage * 2,"export_requests","max_export_storage")
end
function SupplyRocket:CheatCapDef()
	ChoGGi.ComFuncs.SetTaskReqAmount(self,self.base_max_export_storage,"export_requests","max_export_storage")
end
function SupplyRocket:CheatAddFuel()
	local total = self.refuel_request:GetTargetAmount()
	self.accumulated_fuel = total
	self.refuel_request:SetAmount(total)
	Msg("RocketRefueled", self)
	RebuildInfopanel(self)
end

function Sinkhole:CheatSpawnFirefly()
	self:TestSpawnFireflyAndGo()
end

