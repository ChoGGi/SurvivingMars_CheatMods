-- See LICENSE for terms

-- add items/hint to the cheats pane

local IsValid = IsValid
local CreateRealTimeThread = CreateRealTimeThread

local RetName
local Random
local Translate
local MsgPopup
local Strings
local ResourceScale

function OnMsg.ClassesGenerate()
	local ComFuncs = ChoGGi.ComFuncs
	RetName = ComFuncs.RetName
	Random = ComFuncs.Random
	Translate = ComFuncs.Translate
	MsgPopup = ComFuncs.MsgPopup
	Strings = ChoGGi.Strings
	ResourceScale = ChoGGi.Consts.ResourceScale

	Object.CheatExamine = ComFuncs.OpenInExamineDlg
	Object.CheatToggleCollision = ComFuncs.CollisionsObject_Toggle
	Object.CheatDeleteObject = ComFuncs.DeleteObjectQuestion
	Drone.CheatFindResource = ComFuncs.FindNearestResource
	Drone.CheatDestroy = ComFuncs.RuinObjectQuestion
	RCTransport.CheatFindResource = ComFuncs.FindNearestResource
	ColorizableObject.CheatColourRandom = ComFuncs.ObjectColourRandom
	ColorizableObject.CheatColourDefault = ComFuncs.ObjectColourDefault
	BaseBuilding.CheatToggleConstruct = ComFuncs.ToggleConstructEntityView
	MechanizedDepot.CheatEmptyDepot = ComFuncs.EmptyMechDepot
	BaseRover.CheatDestroy = ComFuncs.RuinObjectQuestion
	local Building = Building
	Building.CheatDestroy = ComFuncs.RuinObjectQuestion
	Building.CheatPowerFree = ComFuncs.RemoveBuildingElecConsump
	Building.CheatPowerNeed = ComFuncs.AddBuildingElecConsump
	Building.CheatWaterFree = ComFuncs.RemoveBuildingWaterConsump
	Building.CheatWaterNeed = ComFuncs.AddBuildingWaterConsump
	Building.CheatOxygenFree = ComFuncs.RemoveBuildingAirConsump
	Building.CheatOxygenNeed = ComFuncs.AddBuildingAirConsump

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
		action.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
	end
	local function SetIcon(action,name,icon)
		-- we're changing the name so we'll set the hint title to the orig name
		action.RolloverTitle = action.ActionName
		action.ActionName = name or "\0"
		action.ActionIcon = icon
	end

	local function SetUpgradeInfo(action,obj,num)
		local tempname = Translate(obj["upgrade" .. num .. "_display_name"])
		-- if there's an upgrade then add hint text, otherwise blank the id to hide it
		if tempname ~= "" then
			SetHint(action,Strings[302535920001207--[["Add: %s to this building.

%s"--]]]:format(tempname,Translate(T(obj["upgrade" .. num .. "_description"],obj))))
			SetIcon(action,num,obj["upgrade" .. num .. "_icon"])
		else
			action.ActionId = ""
		end
	end
	local doublec = Strings[302535920001199--[[Double the amount of colonist slots for this building.--]]]
	local resetc = Strings[302535920001200--[[Reset the capacity of colonist slots for this building.--]]]

	local grid_lookup = {
		OxygenFree = {
			icon = "UI/Icons/res_oxygen.tga",
			name = Translate(682--[[Oxygen--]]),
			text1 = Translate(4325--[[Free--]]),
			text2 = Strings[302535920001220--[[Change this %s so it doesn't need a %s source.--]]],
			con = "air_consumption",
		},
		OxygenNeed = {
			icon = "UI/Icons/res_oxygen.tga",
			name = Translate(682--[[Oxygen--]]),
			text1 = Strings[302535920000162--[[Need--]]],
			text2 = Strings[302535920001221--[[Change this %s so it needs a %s source.--]]],
			con = "air_consumption",
		},
		WaterFree = {
			icon = "UI/Icons/res_water.tga",
			name = Translate(681--[[Water--]]),
			text1 = Translate(4325--[[Free--]]),
			text2 = Strings[302535920001220--[[Change this %s so it doesn't need a %s source.--]]],
			con = "water_consumption",
		},
		WaterNeed = {
			icon = "UI/Icons/res_water.tga",
			name = Translate(681--[[Water--]]),
			text1 = Strings[302535920000162--[[Need--]]],
			text2 = Strings[302535920001221--[[Change this %s so it needs a %s source.--]]],
			con = "water_consumption",
		},
		PowerFree = {
			icon = "UI/Icons/res_electricity.tga",
			name = Translate(11683--[[Electricity--]]),
			text1 = Translate(4325--[[Free--]]),
			text2 = Strings[302535920001220--[[Change this %s so it doesn't need a %s source.--]]],
			con = "electricity_consumption",
		},
		PowerNeed = {
			icon = "UI/Icons/res_electricity.tga",
			name = Translate(11683--[[Electricity--]]),
			text1 = Strings[302535920000162--[[Need--]]],
			text2 = Strings[302535920001221--[[Change this %s so it needs a %s source.--]]],
			con = "electricity_consumption",
		},
	}
	local function SetGridInfo(action,obj,name,grid)
		local consumption = obj[grid.con]
		if consumption and consumption ~= 0 then
			SetHint(action,grid.text2:format(name,grid.name))
			SetIcon(action,grid.text1,grid.icon)
		else
			action.ActionId = ""
		end
	end

	local cheats_lookup = {
-- Colonist
		FillAll = {
			des = Strings[302535920001202--[[Fill all stat bars.--]]],
		},
		SpawnColonist = {
			des = Strings[302535920000005--[[Drops a new colonist in selected dome.--]]],
			icon = "UI/Icons/ColonyControlCenter/colonist_on.tga",
		},
		PrefDbl = {
			des = Strings[302535920001203--[[Double %s's performance.--]]],
			des_name = true,
		},
		PrefDef = {
			des = Strings[302535920001204--[[Reset %s's performance to default.--]]],
			des_name = true,
		},
		RandomSpecialization = {
			des = Strings[302535920001205--[[Randomly set %s's specialization.--]]],
			des_name = true,
		},
		ReneagadeCapDbl = {
			des = Strings[302535920001236--[[Double amount of reneagades this station can negate (currently: %s) < Reselect to update amount.--]]],
			des_name = "negated_renegades",
		},
		Die = {
			des = Strings[302535920001431--[[Kill this colonist!--]]],
		},
		ToggleConstruct = {
			des = Strings[302535920001531--[[Make the building model look like a construction site (toggle).--]]],
		},
		CrimeEvent = {
			des = Strings[302535920001541--[[Start a Crime Event--]]],
		},

-- Building
		VisitorsDbl = {des = doublec},
		VisitorsDef = {des = resetc},
		WorkersDbl = {des = doublec},
		WorkersDef = {des = resetc},
		ColonistCapDbl = {des = doublec},
		ColonistCapDef = {des = resetc},
		WorkManual = {
			des = Strings[302535920001210--[[Make this %s need workers.--]]],
			des_name = true,
		},
		CapDef = {
			des = Strings[302535920001213--[[Reset the storage capacity of this %s to default.--]]],
			des_name = true,
		},
		EmptyDepot = {
			des = Strings[302535920001214--[[Sticks small depot in front of mech depot and moves all resources to it (max of 20 000).--]]],
		},
		["Quick build"] = {
			des = Strings[302535920000060--[[Instantly complete building without needing resources.--]]],
		},
		AllShifts = {
			des = Strings[302535920001215--[[Turn on all work shifts.--]]],
		},
		Fill = {
			des = Strings[302535920001232--[[Fill the storage of this building.--]]],
		},
		MaxShuttlesDbl = {
			des = Strings[302535920001217--[[Double the shuttles this ShuttleHub can control.--]]],
		},

-- Rover/Drone
		BattCapDbl = {
			des = Strings[302535920001216--[[Double the battery capacity.--]]],
		},
		Scan = {
			des = Translate(979029137252--[[Scanned an Anomaly--]]),
			icon = "UI/Icons/pin_scan.tga",
		},
-- Rocket
		-- when i added a "working" AddDust to rockets it showed up twice, so i'm lazy
		AddDust2 = {
			des = Strings[302535920001225--[[Adds dust and maintenance points.--]]],
			name = "AddDust",
		},
		CleanAndFix2 = {
			des = Strings[302535920001226--[[Cleans dust and removes maintenance points.--]]],
			name = "CleanAndFix",
		},
		Launch = {
			des = Translate(6779--[[Warning--]]) .. ": " .. Strings[302535920001233--[[Launches rocket without asking.--]]],
			icon = "UI/Icons/ColonyControlCenter/rocket_r.tga",
		},

-- Misc
		FindResource = {
			des = Strings[302535920001218--[[Selects nearest storage containing specified resource (shows list of resources).--]]],
			icon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
		},
		Examine = {
			des = Strings[302535920001277--[[Open %s in the Object Examiner.--]]],
			des_name = true,
		},
		AddFuel = {
			des = Strings[302535920001053--[[Fill up %s with fuel.--]]],
			des_name = true,
			icon = "UI/Icons/res_fuel.tga",
		},
		DeleteObject = {
			des = Strings[302535920000414--[[Are you sure you wish to delete %s?--]]],
			des_name = true,
			icon = "UI/Icons/Sections/warning.tga",
		},
		ColourRandom = {
			des = Strings[302535920001224--[[Changes colour of %s to random colours (doesn't change attachments).--]]],
			des_name = true,
		},
		ColourDefault = {
			des = Strings[302535920001246--[[Changes colour of %s back to default.--]]],
			des_name = true,
		},
	}

	function ChoGGi.InfoFuncs.SetInfoPanelCheatHints(win)
		local obj = win.context
		local name = RetName(obj)
		local id = obj.template_name
		for i = 1, #win.actions do
			local action = win.actions[i]
			local aid = action.ActionId

			-- if it's stored in table than we'll use that otherwise it's elseif time
			local look = cheats_lookup[aid]
			if look then
				if look.des then
					if look.des_name then
						if type(look.des_name) == "string" then
							SetHint(action,look.des:format(obj[look.des_name]))
						else
							SetHint(action,look.des:format(name))
						end
					else
						SetHint(action,look.des)
					end
				end

				if look.name then
					action.ActionName = look.name
				end
				if look.icon then
					SetIcon(action,look.icon_name,look.icon)
				end

			elseif grid_lookup[aid] then
				SetGridInfo(action,obj,name,grid_lookup[aid])

			-- the below is somewhat arranged in freq order

			elseif aid == "ToggleCollision" then
				SetHint(action,Strings[302535920001543--[[Set collisions on %s. Collisions disabled: %s--]]]:format(name,ComFuncs.SettingState(obj.ChoGGi_CollisionsDisabled)))
				SetIcon(action,nil,"CommonAssets/UI/Menu/ToggleOcclusion.tga")

			elseif aid == "CleanAndFix" then
				if obj:IsKindOfClasses("UniversalStorageDepot","WasteRockDumpSite") then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920001226--[[Cleans dust and removes maintenance points.--]]])
				end

			elseif aid == "AddDust" then
				if obj:IsKindOfClasses("UniversalStorageDepot","WasteRockDumpSite") then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920001225--[[Adds dust and maintenance points.--]]])
				end

			elseif aid == "ToggleSigns" then
				if obj:IsKindOfClasses("SurfaceDeposit","SubsurfaceDeposit","WasteRockDumpSite","UniversalStorageDepot") then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920001223--[[Toggle any signs above %s (until state is changed).--]]]:format(name))
				end

			elseif aid == "Destroy" then
				if obj:IsKindOf("SupplyRocket") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920001227--[[Turns object into ruin.--]]])
					SetIcon(action,nil,"UI/Icons/IPButtons/demolition.tga")
				end

			elseif aid == "Refill" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920001231--[[Refill the deposit to full capacity.--]]])
				end

			elseif aid == "DoubleMaxAmount" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920001234--[[Double the amount this %s can hold.--]]]:format(name))
				end

			elseif aid == "Upgrade1" then
				SetUpgradeInfo(action,obj,1)
			elseif aid == "Upgrade2" then
				SetUpgradeInfo(action,obj,2)
			elseif aid == "Upgrade3" then
				SetUpgradeInfo(action,obj,3)
			elseif aid == "WorkAuto" then
				local bs = ChoGGi.UserSettings.BuildingSettings
				SetHint(action,Strings[302535920001209--[[Make this %s not need workers (performance: %s).--]]]:format(name,bs and bs[id] and bs[id].performance or 150))

			elseif aid == "CapDbl" then
				if obj:IsKindOf("SupplyRocket") then
					SetHint(action,Strings[302535920001211--[[Double the export storage capacity of this %s.--]]]:format(name))
				else
					SetHint(action,Strings[302535920001212--[[Double the storage capacity of this %s.--]]]:format(name))
				end

			elseif aid == "Malfunction" then
				if obj.destroyed or obj.is_malfunctioned then
					action.ActionId = ""
				else
					SetHint(action,Translate(8039--[[Trait: Idiot (can cause a malfunction)--]]) .. "...\n" .. Translate(53--[[Malfunction--]]) .. "?")
				end

			elseif aid == "Unfreeze" then
				if obj:IsKindOf("DroneHub") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action,Strings[302535920000903--[[Unfreeze frozen object.--]]])
				end

			elseif aid == "Empty" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					if obj:IsKindOfClasses("SubsurfaceDeposit","TerrainDeposit") then
						SetHint(action,Strings[302535920001228--[[Set the stored amount of this %s to 0.--]]]:format(name))
					else
						SetHint(action,Strings[302535920001230--[[Empties the storage of this building.

If this isn't a dumping site then waste rock will not be emptied.--]]])
					end
				end

			elseif aid == "Break" then
				if obj:IsKindOf("ElectricityGridElement") then
					SetHint(action,Translate(3890--[[Cable Fault--]]))
				else
					SetHint(action,Translate(3891--[[Pipe Leak--]]))
				end
			elseif aid == "Repair" then
				if obj:IsKindOf("ElectricityGridElement") then
					SetHint(action,Translate(6924--[[Repair--]]) .. " " .. Translate(3890--[[Cable Fault--]]))
				else
					SetHint(action,Translate(6924--[[Repair--]]) .. " " .. Translate(3891--[[Pipe Leak--]]))
				end

			end -- ifs
		end -- for

		return true
	end
end

function OnMsg.ClassesBuilt()
	ElectricityGridElement.CheatRepair = ElectricityGridElement.Repair
	LifeSupportGridElement.CheatRepair = LifeSupportGridElement.Repair
	ElectricityGridElement.CheatBreak = ElectricityGridElement.Break
	LifeSupportGridElement.CheatBreak = LifeSupportGridElement.Break
end

local Object = Object
local Building = Building
local Colonist = Colonist
local Workplace = Workplace

function Object:CheatToggleSigns()
	if self:CountAttaches("BuildingSign") > 0 then
		self:DestroyAttaches("BuildingSign")
	else
		self:UpdateSignsVisibility()
	end
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
	if not self:GetEntity():find("Child") then
		self:SetSpecialization(ChoGGi.Tables.ColonistSpecializations[Random(1,#ChoGGi.Tables.ColonistSpecializations)],"init")
	end
end
function Colonist:CheatPrefDbl()
	self.performance = self.performance * 2
end
function Colonist:CheatPrefDef()
	self.performance = self:GetClassValue("performance")
end
function Colonist:CheatRandomGender()
	ChoGGi.ComFuncs.ColonistUpdateGender(self,ChoGGi.Tables.ColonistGenders[Random(1,#ChoGGi.Tables.ColonistGenders)])
end
function Colonist:CheatRandomAge()
	ChoGGi.ComFuncs.ColonistUpdateAge(self,ChoGGi.Tables.ColonistAges[Random(1,#ChoGGi.Tables.ColonistAges)])
end
function Colonist:CheatDie()
	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning--]]) .. "!\n" .. Strings[302535920001430--[[Kill colonist-]]] .. "?",
		function(answer)
			if answer then
				self:SetCommand("Die")
			end
		end,
		Translate(6779--[[Warning--]]) .. ": " .. Strings[302535920000855--[[Last chance before deletion!--]]]
	)
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
	self.max_workers = self:GetClassValue("max_workers")
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
	if self.amount == 1 then
		-- removes the object after the second click
		self.amount = 0
	else
		-- it'll look empty, but it won't actually remove the object
		self.amount = 1
	end
end
SubsurfaceDeposit.CheatEmpty = CheatEmpty
TerrainDeposit.CheatEmpty = CheatEmpty
function TerrainDeposit:CheatRefill()
	self.amount = self.max_amount
end

-- CheatCap storage
local function RetGridValues(obj)
	if obj:IsKindOf("ElectricityStorage") then
		return "capacity",obj.electricity
	elseif obj:IsKindOf("AirStorage") then
		return "air_capacity",obj.air
	elseif obj:IsKindOf("WaterStorage") then
		return "water_capacity",obj.water
	end
end
local function CheatCapDbl(obj)
	local cap_key,grid = RetGridValues(obj)
	local new = obj[cap_key] * 2
	obj[cap_key] = new
	grid.storage_capacity = new
	grid.storage_mode = "charging"
	ChoGGi.ComFuncs.ToggleWorking(obj)
end
local function CheatCapDef(obj)
	local cap_key,grid = RetGridValues(obj)
	local new = obj:GetClassValue(cap_key)
	obj[cap_key] = new
	grid.storage_capacity = new
	grid.storage_mode = "full"
	ChoGGi.ComFuncs.ToggleWorking(obj)
end
ElectricityStorage.CheatCapDbl = CheatCapDbl
ElectricityStorage.CheatCapDef = CheatCapDef
WaterTank.CheatCapDbl = CheatCapDbl
WaterTank.CheatCapDef = CheatCapDef
OxygenTank.CheatCapDbl = CheatCapDbl
OxygenTank.CheatCapDef = CheatCapDef

-- CheatCapDbl people
function Residence:CheatColonistCapDbl()
	if self.capacity == 4096 then
		return
	end
	self.capacity = self.capacity * 2
end
function Residence:CheatColonistCapDef()
	self.capacity = self:GetClassValue("capacity")
end

-- CheatVisitorsDbl
function Service:CheatVisitorsDbl()
	if self.max_visitors == 4096 then
		return
	end
	self.max_visitors = self.max_visitors * 2
end
function Service:CheatVisitorsDef()
	self.max_visitors = self:GetClassValue("max_visitors")
end

-- Double Shuttles
function ShuttleHub:CheatMaxShuttlesDbl()
	self.max_shuttles = self.max_shuttles * 2
end
function ShuttleHub:CheatMaxShuttlesDef()
	self.max_shuttles = self:GetClassValue("max_shuttles")
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
	self:SetMoveSpeed(self:GetClassValue("move_speed"))
end
Drone.CheatMoveSpeedDbl = CheatMoveSpeedDbl
Drone.CheatMoveSpeedDef = CheatMoveSpeedDef
BaseRover.CheatMoveSpeedDbl = CheatMoveSpeedDbl
BaseRover.CheatMoveSpeedDef = CheatMoveSpeedDef
-- CheatCleanAndFix
local function CheatAddDust(self)
	self.dust = self:GetDustMax() - 1
	self:SetDustVisuals()
end
Drone.CheatAddDust = CheatAddDust
BaseRover.CheatAddDust = CheatAddDust

Drone.CheatCleanAndFix = function(self)
	CreateRealTimeThread(function()
		self.auto_connect = false
		if self.malfunction_end_state then
			self:PlayState(self.malfunction_end_state, 1)
			if not IsValid(self) then
				return
			end
		end
		self:CheatAddDust()
		Sleep(10)
		self.dust = 0
		self:SetDustVisuals()
		RebuildInfopanel(self)
 end)
end
BaseRover.CheatCleanAndFix = function(self)
	CreateRealTimeThread(function()
		self:CheatAddDust()
		Sleep(10)
		self.dust = 0
		self:SetDustVisuals()
		self:Repair()
 end)
end
local orig_Building_CheatCleanAndFix = Building.CheatCleanAndFix
function Building:CheatCleanAndFix()
	self:CheatAddDust()
	orig_Building_CheatCleanAndFix(self)
end

-- misc
function SecurityStation:CheatReneagadeCapDbl()
	self.negated_renegades = self.negated_renegades * 2
end
function SecurityStation:CheatReneagadeCapDef()
	self.negated_renegades = self.max_negated_renegades
end

function SupplyRocket:CheatCapDbl()
	ChoGGi.ComFuncs.SetTaskReqAmount(self,self.max_export_storage * 2,"export_requests","max_export_storage")
end
function SupplyRocket:CheatCapDef()
	ChoGGi.ComFuncs.SetTaskReqAmount(self,self:GetClassValue("max_export_storage"),"export_requests","max_export_storage")
end

function SupplyRocket:CheatAddFuel()
	-- skip if we're full/over full
	local actual = self.refuel_request:GetActualAmount()
	if actual < 1 then
		return
	end

	local target = self.refuel_request:GetTargetAmount()
	self.accumulated_fuel = self.accumulated_fuel + target
	self.refuel_request:SetAmount(target)
	-- make sure it always shows the correct amount
	self.refuel_request:SetAmount(0)
	Msg("RocketRefueled", self)
	RebuildInfopanel(self)
end
function SupplyRocket:CheatAddDust2()
	self:SetDust(600,0)
	ApplyToObjAndAttaches(self, SetObjDust, 600)
end
function SupplyRocket:CheatCleanAndFix2()
	self:SetDust(0,0)
	ApplyToObjAndAttaches(self, SetObjDust, 0)
end

if rawget(_G,"Sinkhole") then
	Sinkhole.CheatSpawnFirefly = Sinkhole.TestSpawnFireflyAndGo
end

function Dome:CheatCrimeEvent()
	-- build a list
	local item_list = {{
		text = "CheckCrimeEvents",
		value = Dome.CheckCrimeEvents,
	}}
	local c = #item_list
	local Dome = Dome
	for key,value in pairs(Dome) do
		if type(value) == "function" and key:sub(1,12) == "CrimeEvents_" then
			c = c + 1
			item_list[c] = {
				text = key:sub(13),
				value = value,
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		-- fire off the crime func
		choice[1].value(self)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001541--[[Start a Crime Event--]]],
		hint = Strings[302535920001542--[[Renegades not required.--]]],
	}

end

