-- See LICENSE for terms

-- add items/hint to the cheats pane

local CreateRealTimeThread = CreateRealTimeThread

local RetName
local Random
local Trans
local MsgPopup
local S
local ResourceScale

function OnMsg.ClassesGenerate()
	RetName = ChoGGi.ComFuncs.RetName
	Random = ChoGGi.ComFuncs.Random
	Trans = ChoGGi.ComFuncs.Translate
	MsgPopup = ChoGGi.ComFuncs.MsgPopup
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
		-- we're changing the name so we'll set the hint title to the orig name
		action.RolloverTitle = action.ActionName
		action.ActionName = name or "\0"
		action.ActionIcon = icon
	end

	local function SetUpgradeInfo(action,obj,num)
		local tempname = Trans(obj["upgrade" .. num .. "_display_name"])
		-- if there's an upgrade then add hint text, otherwise blank the id to hide it
		if tempname ~= "" then
			SetHint(action,S[302535920001207--[["Add: %s to this building.

%s"--]]]:format(tempname,Trans(T(obj["upgrade" .. num .. "_description"],obj))))
			SetIcon(action,num,obj["upgrade" .. num .. "_icon"])
		else
			action.ActionId = ""
		end
	end
	local doublec = S[302535920001199--[[Double the amount of colonist slots for this building.--]]]
	local resetc = S[302535920001200--[[Reset the capacity of colonist slots for this building.--]]]

	local grid_lookup = {
		OxygenFree = {
			icon = "UI/Icons/res_oxygen.tga",
			name = S[682--[[Oxygen--]]],
			text1 = S[4325--[[Free--]]],
			text2 = S[302535920001220--[[Change this %s so it doesn't need a %s source.--]]],
			con = "air_consumption",
		},
		OxygenNeed = {
			icon = "UI/Icons/res_oxygen.tga",
			name = S[682--[[Oxygen--]]],
			text1 = S[302535920000162--[[Need--]]],
			text2 = S[302535920001221--[[Change this %s so it needs a %s source.--]]],
			con = "air_consumption",
		},
		WaterFree = {
			icon = "UI/Icons/res_water.tga",
			name = S[681--[[Water--]]],
			text1 = S[4325--[[Free--]]],
			text2 = S[302535920001220--[[Change this %s so it doesn't need a %s source.--]]],
			con = "water_consumption",
		},
		WaterNeed = {
			icon = "UI/Icons/res_water.tga",
			name = S[681--[[Water--]]],
			text1 = S[302535920000162--[[Need--]]],
			text2 = S[302535920001221--[[Change this %s so it needs a %s source.--]]],
			con = "water_consumption",
		},
		PowerFree = {
			icon = "UI/Icons/res_electricity.tga",
			name = S[11683--[[Electricity--]]],
			text1 = S[4325--[[Free--]]],
			text2 = S[302535920001220--[[Change this %s so it doesn't need a %s source.--]]],
			con = "electricity_consumption",
		},
		PowerNeed = {
			icon = "UI/Icons/res_electricity.tga",
			name = S[11683--[[Electricity--]]],
			text1 = S[302535920000162--[[Need--]]],
			text2 = S[302535920001221--[[Change this %s so it needs a %s source.--]]],
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
			des = S[302535920001202--[[Fill all stat bars.--]]],
		},
		SpawnColonist = {
			des = S[302535920000005--[[Drops a new colonist in selected dome.--]]],
			icon = "UI/Icons/ColonyControlCenter/colonist_on.tga",
		},
		PrefDbl = {
			des = S[302535920001203--[[Double %s's performance.--]]],
			des_name = true,
		},
		PrefDef = {
			des = S[302535920001204--[[Reset %s's performance to default.--]]],
			des_name = true,
		},
		RandomSpecialization = {
			des = S[302535920001205--[[Randomly set %s's specialization.--]]],
			des_name = true,
		},
		ReneagadeCapDbl = {
			des = S[302535920001236--[[Double amount of reneagades this station can negate (currently: %s) < Reselect to update amount.--]]],
			des_name = "negated_renegades",
		},
		Die = {
			des = S[302535920001431--[[Kill this colonist!--]]],
		},

-- Building
		VisitorsDbl = {des = doublec},
		VisitorsDef = {des = resetc},
		WorkersDbl = {des = doublec},
		WorkersDef = {des = resetc},
		ColonistCapDbl = {des = doublec},
		ColonistCapDef = {des = resetc},
		WorkManual = {
			des = S[302535920001210--[[Make this %s need workers.--]]],
			des_name = true,
		},
		CapDef = {
			des = S[302535920001213--[[Reset the storage capacity of this %s to default.--]]],
			des_name = true,
		},
		EmptyDepot = {
			des = S[302535920001214--[[Sticks small depot in front of mech depot and moves all resources to it (max of 20 000).--]]],
		},
		["Quick build"] = {
			des = S[302535920000060--[[Instantly complete building without needing resources.--]]],
		},
		AllShifts = {
			des = S[302535920001215--[[Turn on all work shifts.--]]],
		},
		DoubleMaxAmount = {
			des = S[302535920001234--[[Double the amount this %s can hold.--]]],
			des_name = true,
			filter_name = "SubsurfaceAnomaly",
			filter_func = "IsKindOf",
		},
		Refill = {
			des = S[302535920001231--[[Refill the deposit to full capacity.--]]],
			filter_name = "SubsurfaceAnomaly",
			filter_func = "IsKindOf",
		},
		Fill = {
			des = S[302535920001232--[[Fill the storage of this building.--]]],
		},
		MaxShuttlesDbl = {
			des = S[302535920001217--[[Double the shuttles this ShuttleHub can control.--]]],
		},

-- Rover/Drone
		BattCapDbl = {
			des = S[302535920001216--[[Double the battery capacity.--]]],
		},
		Scan = {
			des = S[979029137252--[[Scanned an Anomaly--]]],
			icon = "UI/Icons/pin_scan.tga",
		},
-- Rocket
		-- when i added a "working" AddDust to rockets it showed up twice, so i'm lazy
		AddDust2 = {
			des = S[302535920001225--[[Adds dust and maintenance points.--]]],
			name = "AddDust",
		},
		CleanAndFix2 = {
			des = S[302535920001226--[[Cleans dust and removes maintenance points.--]]],
			name = "CleanAndFix",
		},
		Launch = {
			des = S[6779--[[Warning--]]] .. ": " .. S[302535920001233--[[Launches rocket without asking.--]]],
			icon = "UI/Icons/ColonyControlCenter/rocket_r.tga",
		},

-- Misc
		FindResource = {
			des = S[302535920001218--[[Selects nearest storage containing specified resource (shows list of resources).--]]],
			icon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
		},
		Examine = {
			des = S[302535920001277--[[Open %s in the Object Examiner.--]]],
			des_name = true,
		},
		AddFuel = {
			des = S[302535920001053--[[Fill up %s with fuel.--]]],
			des_name = true,
			icon = "UI/Icons/res_fuel.tga",
		},
		DeleteObject = {
			des = S[302535920000885--[[Permanently delete %s--]]],
			des_name = true,
			icon = "UI/Icons/Sections/warning.tga",
		},
		ColourRandom = {
			des = S[302535920001224--[[Changes colour of %s to random colours (doesn't change attachments).--]]],
			des_name = true,
		},
		ColourDefault = {
			des = S[302535920001246--[[Changes colour of %s back to default.--]]],
			des_name = true,
		},
--~ 		AnimState = {
--~ 			des = S[302535920000458--[[Make object dance on command.--]]],
--~ 			filter_func = "GetStates",
--~ 		},
--~ 		AttachSpots = {
--~ 			des = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
--~ 		},
		ToggleSigns = {
			des = S[302535920001223--[[Toggle any signs above %s (until state is changed).--]]],
			des_name = true,
			filter_name = {"SurfaceDeposit","SubsurfaceDeposit","WasteRockDumpSite","UniversalStorageDepot"},
			filter_func = "IsKindOfClasses",
		},
		AddDust = {
			des = S[302535920001225--[[Adds dust and maintenance points.--]]],
			filter_name = {"UniversalStorageDepot","WasteRockDumpSite"},
			filter_func = "IsKindOfClasses",
		},
		CleanAndFix = {
			des = S[302535920001226--[[Cleans dust and removes maintenance points.--]]],
			filter_name = {"UniversalStorageDepot","WasteRockDumpSite"},
			filter_func = "IsKindOfClasses",
		},
	}

	function ChoGGi.InfoFuncs.SetInfoPanelCheatHints(win)
		local obj = win.context
		local name = RetName(obj)
		local id = obj.template_name
		for i = 1, #win.actions do
			local action = win.actions[i]
			local aid = action.ActionId

			-- if it's stored in table than we'll use that otherwise it's if time
			local look = cheats_lookup[aid]
			if look then
				-- filter power (yeah it's ugly)
				if (not look.filter_name and look.filter_func and obj[look.filter_func] and obj[look.filter_func](obj))
						or not (look.filter_func and look.filter_name and obj[look.filter_func] and obj[look.filter_func](obj,look.filter_name))
						or (look.filter_name and obj[look.filter_name]) then

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

				else
					action.ActionId = ""
				end

			elseif aid == "Upgrade1" then
				SetUpgradeInfo(action,obj,1)
			elseif aid == "Upgrade2" then
				SetUpgradeInfo(action,obj,2)
			elseif aid == "Upgrade3" then
				SetUpgradeInfo(action,obj,3)
			elseif aid == "WorkAuto" then
				local bs = ChoGGi.UserSettings.BuildingSettings
				SetHint(action,S[302535920001209--[[Make this %s not need workers (performance: %s).--]]]:format(name,bs and bs[id] and bs[id].performance or 150))

			elseif grid_lookup[aid] then
				SetGridInfo(action,obj,name,grid_lookup[aid])
			elseif aid == "CapDbl" then
				if obj:IsKindOf("SupplyRocket") then
					SetHint(action,S[302535920001211--[[Double the export storage capacity of this %s.--]]]:format(name))
				else
					SetHint(action,S[302535920001212--[[Double the storage capacity of this %s.--]]]:format(name))
				end

			elseif aid == "Malfunction" then
				if obj.destroyed or obj.is_malfunctioned then
					action.ActionId = ""
				else
					SetHint(action,S[8039--[[Trait: Idiot (can cause a malfunction)--]]] .. "...\n" .. S[53--[[Malfunction--]]] .. "?")
				end

			elseif aid == "Destroy" then
				if obj:IsKindOf("SupplyRocket") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action,S[302535920001227--[[Turns object into ruin.--]]])
					SetIcon(action,nil,"UI/Icons/IPButtons/demolition.tga")
				end

			elseif aid == "Empty" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					if obj:IsKindOfClasses("SubsurfaceDeposit","TerrainDeposit") then
						SetHint(action,S[302535920001228--[[Set the stored amount of this %s to 0.--]]]:format(name))
					else
						SetHint(action,S[302535920001230--[[Empties the storage of this building.

	If this isn't a dumping site then waste rock will not be emptied.--]]])
					end
				end

			end -- ifs

		end -- for

		return true
	end
end


local Object = Object
local Building = Building
local Colonist = Colonist
local Workplace = Workplace

-- global objects
function Object:CheatDeleteObject()
	local name = RetName(self)
	local function CallBackFunc(answer)
		if answer then
			ChoGGi.ComFuncs.DeleteObject(self)
			SelectObj()
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		S[6779--[[Warning--]]] .. "!\n" .. S[302535920000885--[[Permanently delete %s?--]]]:format(name) .. "?",
		CallBackFunc,
		S[6779--[[Warning--]]] .. ": " .. S[302535920000855--[[Last chance before deletion!--]]],
		S[5451--[[DELETE--]]] .. ": " .. name,
		S[6879--[[Cancel--]]] .. " " .. S[1000615--[[Delete--]]]
	)
end
function Object:CheatToggleSigns()
	if self:GetAttaches("BuildingSign") then
		self:DestroyAttaches("BuildingSign")
	else
		self:UpdateSignsVisibility()
	end
end
function ColorizableObject:CheatColourRandom()
	ChoGGi.ComFuncs.ObjectColourRandom(self)
end
function ColorizableObject:CheatColourDefault()
	ChoGGi.ComFuncs.ObjectColourDefault(self)
end
--~ function Object:CheatAnimState()
--~ 	ChoGGi.ComFuncs.SetAnimState(self)
--~ end
--~ function Object:CheatAttachSpots()
--~ 	ChoGGi.ComFuncs.AttachSpots_Toggle(self)
--~ end

local function CheatDestroy(self)
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
			self.demolishing_countdown = 0
			self.demolishing = true
			self:DoDemolish()
			-- probably not needed
			DestroyBuildingImmediate(self)

		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		S[6779--[[Warning--]]] .. "!\n" .. obj_type .. "\n" .. name,
		CallBackFunc,
		S[6779--[[Warning--]]] .. ": " .. obj_type,
		obj_type .. " " .. name,
		S[1176--[[Cancel Destroy--]]]
	)
end
Building.CheatDestroy = CheatDestroy
BaseRover.CheatDestroy = CheatDestroy
Drone.CheatDestroy = CheatDestroy

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
	if not self:GetEntity():find("Child") then
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
function Colonist:CheatDie()
	ChoGGi.ComFuncs.QuestionBox(
		S[6779--[[Warning--]]] .. "!\n" .. S[302535920001430--[[Kill colonist-]]] .. "?",
		function(answer)
			if answer then
				self:SetCommand("Die")
			end
		end,
		S[6779--[[Warning--]]] .. ": " .. S[302535920000855--[[Last chance before deletion!--]]]
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
local function CheatAddDust(self)
	self.dust = self:GetDustMax()-1
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
function ElectricityGridElement:CheatRepair()
	self:Repair()
end
function LifeSupportGridElement:CheatRepair()
	self:Repair()
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
	function Sinkhole:CheatSpawnFirefly()
		self:TestSpawnFireflyAndGo()
	end
end
