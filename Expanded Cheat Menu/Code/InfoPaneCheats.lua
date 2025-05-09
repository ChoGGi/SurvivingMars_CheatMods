-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

-- add items/hint to the cheats pane

local ChoGGi_Funcs = ChoGGi_Funcs
local pairs, table = pairs, table
local IsValid = IsValid
local CreateRealTimeThread = CreateRealTimeThread

local Common = ChoGGi_Funcs.Common
local RetName = Common.RetName
local Random = Common.Random
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local ScaleStat = const.Scale.Stat

local CObject = CObject
CObject.CheatExamine = OpenExamineReturn
CObject.CheatToggleCollision = Common.CollisionsObject_Toggle
CObject.CheatDeleteObject = Common.DeleteObjectQuestion
CObject.CheatViewConstruct = Common.ToggleConstructEntityView
ColorizableObject.CheatColourRandom = Common.ObjectColourRandom
ColorizableObject.CheatColourDefault = Common.ObjectColourDefault
Drone.CheatFindResource = Common.FindNearestResource
Drone.CheatDestroy = Common.RuinObjectQuestion
RCTransport.CheatFindResource = Common.FindNearestResource

BaseBuilding.CheatViewEditor = Common.ToggleEditorEntityView
MechanizedDepot.CheatEmptyDepot = Common.EmptyMechDepot
BaseRover.CheatDestroy = Common.RuinObjectQuestion
local Building = Building
Building.CheatDestroy = Common.RuinObjectQuestion
Building.CheatPowerFree = Common.RemoveBuildingElecConsump
Building.CheatPowerNeed = Common.AddBuildingElecConsump
Building.CheatWaterFree = Common.RemoveBuildingWaterConsump
Building.CheatWaterNeed = Common.AddBuildingWaterConsump
Building.CheatOxygenFree = Common.RemoveBuildingAirConsump
Building.CheatOxygenNeed = Common.AddBuildingAirConsump

function ChoGGi_Funcs.InfoPane.InfopanelCheatsCleanup()
	if ActiveMapID and not ActiveMapID:find("Tutorial") then
		local g_Classes = g_Classes
		g_Classes.Building.CheatAddMaintenancePnts = nil
		g_Classes.Building.CheatMakeSphereTarget = nil
		g_Classes.Building.CheatSpawnWorker = nil
		g_Classes.Building.CheatSpawnVisitor = nil
	end
end
ColdSensitive.CheatUnfreeze = nil

local function SetHint(action, hint)
	-- name has to be set to make the hint show up
	action.ActionName = action.ActionId
	action.RolloverText = hint
	action.RolloverHint = T(302535920001718--[[<left_click> Activate]])
end
local function SetIcon(action, name, icon)
	-- we're changing the name so we'll set the hint title to the orig name
	action.RolloverTitle = action.ActionName
	action.ActionName = name or "\0"
	action.ActionIcon = icon
end

local function SetUpgradeInfo(action, obj, num)
	-- If there's an upgrade then add hint text, otherwise blank the id to hide it
	if obj:GetUpgradeID(num) ~= "" then
		SetHint(action, T{302535920001207--[["Add: <upgrade> to this building.

<upgrade_info>"]],
			upgrade = T(obj["upgrade" .. num .. "_display_name"]),
			upgrade_info = T{obj["upgrade" .. num .. "_description"], obj},
		})
		SetIcon(action, num, obj["upgrade" .. num .. "_icon"])
	else
		action.ActionId = ""
	end
end
local doublec = T(302535920001199--[[Double the amount of colonist slots for this building.]])
local resetc = T(302535920001200--[[Reset the capacity of colonist slots for this building.]])

local grid_lookup = {
	OxygenFree = {
		icon = "UI/Icons/res_oxygen.tga",
		name = T(682--[[Oxygen]]),
		text1 = T(4325--[[Free]]),
		text2 = T(302535920001220--[[Make this <obj_name> ignore <grid_type> grids.]]),
		con = "air_consumption",
	},
	OxygenNeed = {
		icon = "UI/Icons/res_oxygen.tga",
		name = T(682--[[Oxygen]]),
		text1 = T(302535920000162--[[Need]]),
		text2 = T(302535920001221--[[Make this <obj_name> use <grid_type> grids.]]),
		con = "air_consumption",
	},
	WaterFree = {
		icon = "UI/Icons/res_water.tga",
		name = T(681--[[Water]]),
		text1 = T(4325--[[Free]]),
		text2 = T(302535920001220--[[Make this <obj_name> ignore <grid_type> grids.]]),
		con = "water_consumption",
	},
	WaterNeed = {
		icon = "UI/Icons/res_water.tga",
		name = T(681--[[Water]]),
		text1 = T(302535920000162--[[Need]]),
		text2 = T(302535920001221--[[Make this <obj_name> use <grid_type> grids.]]),
		con = "water_consumption",
	},
	PowerFree = {
		icon = "UI/Icons/res_electricity.tga",
		name = T(11683--[[Electricity]]),
		text1 = T(4325--[[Free]]),
		text2 = T(302535920001220--[[Make this <obj_name> ignore <grid_type> grids.]]),
		con = "electricity_consumption",
	},
	PowerNeed = {
		icon = "UI/Icons/res_electricity.tga",
		name = T(11683--[[Electricity]]),
		text1 = T(302535920000162--[[Need]]),
		text2 = T(302535920001221--[[Make this <obj_name> use <grid_type> grids.]]),
		con = "electricity_consumption",
	},
}
local function SetGridInfo(action, obj, name, grid)
	if obj[grid.con] then
		SetHint(action, T{grid.text2,
			obj_name = name,
			grid_type = grid.name,
		})
		SetIcon(action, grid.text1, grid.icon)
	else
		action.ActionId = ""
	end
end

local cheats_lookup = {
-- Colonist
	FillAll = {
		des = T(302535920001202--[[Fill all stat bars.]]),
	},
	SpawnColonist = {
		des = T(302535920000005--[[Drops a new colonist in selected dome.]]),
		icon = "UI/Icons/ColonyControlCenter/colonist_on.tga",
	},
	PrefDbl = {
		des = T(302535920001203--[[Double <str>'s performance.]]),
		des_name = true,
	},
	PrefDef = {
		des = T(302535920001204--[[Reset <str>'s performance to default.]]),
		des_name = true,
	},
	ReneagadeCapDbl = {
		des = T(302535920001236--[[Double amount of reneagades this station can negate (currently: <str>) < Reselect to update amount.]]),
		des_name = "negated_renegades",
	},
	ReneagadeCapDef = {
		des = T(302535920001603--[[Reset the amount of reneagades this station can negate.]]),
	},
	Die = {
		des = T(302535920001431--[[Kill this colonist!]]),
	},
	ViewConstruct = {
		des = T(302535920001531--[[Make the building model look like a construction site (toggle).]]),
	},
	ViewEditor = {
		des = T(302535920001531--[[Make the building model look simpler (toggle).]]),
	},
	CrimeEvent = {
		des = T(302535920001541--[[Start a Crime Event]]),
	},
	FillComfort = {
		des = T{302535920001606--[[Max the <green><stat></green> value for this colonist.

<info>]],
			stat = T(4295--[[Comfort]]),
			info = T(4296--[[Residences and visited buildings improve Comfort up to their Service Comfort value, but Colonists will try to visit only buildings that correspond to their interests. Colonists are more inclined to have children at higher Comfort. Earthborn Colonists whose Comfort is depleted will quit their job and leave the Colony at first opportunity.]]),
		},
	},
	FillHealth = {
		des = T{302535920001606--[[snipped]],
			stat = T(4291--[[Health]]),
			info = T(4292--[[Represents physical injury, illness and exhaustion. Lowered by working on a heavy workload, having no functional home, shock when deprived from vital resources or when the Colonist is injured. Colonists can be healed in Medical Buildings in a powered Dome, but only if they are provided with Food, Water and Oxygen. Colonists can't work at low health unless they're Fit.]]),
		},
	},
	FillMorale = {
		des = T{302535920001606--[[snipped]],
			stat = T(4297--[[Morale]]),
			info = T(4298--[[Represents overall happiness, optimism and loyalty. All other stats affect Morale. Influences the Colonist’s job performance. Colonists with low Morale may become Renegades.]]),
		},
	},
	FillSanity = {
		des = T{302535920001606--[[snipped]],
			stat = T(4293--[[Sanity]]),
			info = T(4294--[[Represents mental condition. Lowered by working on a heavy workload, in outside buildings and during dark hours, witnessing the death of a Colonist living in the same Residence or various Martian disasters. Recovered when resting at home and by visiting certain Service Buildings.]]),
		},
	},
	RandomAge = {
		des = T{302535920001607--[[Set a random <green><stat></green> for this colonist.

<info>]],
			stat = T(11607--[[Age Group]]),
			info = T(3930--[[Colonists are divided into five Age Groups. Children and seniors cannot work.]]),
		},
	},
	RandomGender = {
		des = T{302535920001607--[[snipped]],
			stat = T(3932--[[Sex]]),
			info = T(3933--[[The sex of the Colonist. The birth rate in any Dome is determined by the number of Male/Female couples at high Comfort.]]),
		},
	},
	RandomRace = {
		des = T{302535920001607--[[snipped]],
			stat = T(302535920000741--[[Race]]),
			info = T(302535920001608--[["I said if you're thinkin' of being my baby
It don't matter if you're black or white

I said if you're thinkin' of being my brother
It don't matter if you're black or white"]]),
		},
	},
	RandomSpec = {
		des = T{302535920001607--[[snipped]],
			stat = T(11609--[[Specialization]]),
			info = T(3931--[[Specialized Colonists perform better at certain workplaces.]]),
		},
	},
	Renegade = {
		des = T(302535920001609--[[Turn this colonist into a renegade.]]),
	},
	RenegadeClear = {
		des = T(302535920001610--[[Remove the renegade trait from this colonist.]]),
	},
	MakeEarthsick = {
		des = T(302535920000064--[[Add Earthsick status to Colonist.]]),
	},
	Kill = {
		des = T(302535920000065--[[Colonist will no longer enjoy life.]]),
	},
	Age1Year = {
		des = T(302535920000244--[[Age will increase by 1 year.]]),
	},
	AddTouristTrait = {
		des = T(302535920000663--[[Change colonist into a tourist.]]),
	},
	AddSolOnMars = {
		des = T(302535920000981--[[Bump the time they've spent on Mars.]]),
	},





-- Building
	VisitorsDbl = {des = doublec},
	VisitorsDef = {des = resetc},
	WorkersDbl = {des = doublec},
	WorkersDef = {des = resetc},
	ColonistCapDbl = {des = doublec},
	ColonistCapDef = {des = resetc},
	WorkManual = {
		des = T(302535920001210--[[Make this <str> need workers.]]),
		des_name = true,
	},
	CapDef = {
		des = T(302535920001213--[[Reset the storage capacity of this <str> to default.]]),
		des_name = true,
	},
	ChargeDbl = {
		des = T(302535920001095--[[Double the charge capacity of this <str>.]]),
		des_name = true,
	},
	ChargeDef = {
		des = T(302535920001096--[[Reset the charge capacity of this <str> to default.]]),
		des_name = true,
	},
	EmptyDepot = {
		des = T(302535920001214--[[Sticks small depot in front of mech depot and moves all resources to it (max of 20 000).]]),
	},
	["Quick build"] = {
		des = T(302535920000060--[[Instantly complete building without needing resources.]]),
	},
	Fill = {
		des = T(302535920001232--[[Fill the storage of this building.]]),
	},
	AllShiftsOn = {
		des = T(302535920001215--[[Turn on all work shifts.]]),
	},
	CompleteTraining = {
		des = T(302535920001600--[[Instantly finish the training for all visitors.]]),
	},
	GenerateOffer = {
		des = T(302535920001602--[[Force add a new trade offer.]]),
	},
	ToggleGlass = {
		des = T(302535920001617--[[Toggle opening all dome glass (for screenshots?).]]),
	},
	ToggleFreeze = {
		des = T(302535920000985--[[Toggle frozen state of building.]]),
	},
	FinishConstruct = {
		des = T(302535920001428--[[Instantly finish current drone/biorobot.]]),
	},
	FillAll = {
		des = T(302535920001463--[[Fill all depots of same type.]]),
	},
	SpawnDrone = {
		des = T(302535920001466--[[Spawn a drone.]]),
	},
	SpawnDrone = {
		des = T(302535920001466--[[Spawn a drone.]]),
	},
	SpawnAndroid = {
		des = T(302535920001577--[[Spawn an Android.]]),
	},
	AddProgressPoints = {
		des = T(302535920000983--[[Bump the TV Show progress by 5000.]]),
	},
	ResetShowProgress = {
		des = T(302535920001628--[[Reset the TV Show progress.]]),
	},
	VolMinus5 = {
		des = T(302535920001629--[[Increase lake volume by 5.]]),
	},
	VolPlus5 = {
		des = T(302535920001630--[[Decrease lake volume by 5.]]),
	},
	InstHarvest = {
		des = T(302535920001668--[[Instantly harvest current crop.]]),
	},






-- Rover/Drone
	BattCapDbl = {
		des = T(302535920001216--[[Double the battery capacity.]]),
	},
	Scan = {
		des = T(979029137252--[[Scanned an Anomaly]]),
		icon = "UI/Icons/pin_scan.tga",
	},
	BattCapDef = {
		des = T(302535920001611--[[Reset the battery cap to default.]]),
	},
	DrainBattery = {
		des = T(302535920001612--[[Drain the battery to zero.]]),
	},
	RechargeBattery = {
		des = T(302535920001613--[[Refill the battery to max.]]),
	},
	Despawn = {
		des = T(302535920001711--[[Delete Item]]),
	},
	MoveSpeedDbl = {
		des = T(302535920001614--[[Doubles the move speed.]]),
	},
	MoveSpeedDef = {
		des = T(302535920001615--[[Reset the move speed to default.]]),
	},
	GoHome = {
		des = T(302535920000929--[[Tell drone to go back to controller.]]),
	},
	RemoveDustRC = {
		des = T(302535920001631--[[Remove dust covering Rover.]]),
	},
	SpawnAllDrones = {
		des = T(302535920001470--[[Try to spawn all prefabs at this dronehub.]]),
	},






-- Rocket/Shuttles
	-- when i added a "working" AddDust to rockets it showed up twice, so i'm lazy
	AddDust2 = {
		des = T(302535920001225--[[Adds dust and maintenance points.]]),
		name = "AddDust",
	},
	AddDustRC = {
		des = T(302535920001225--[[Adds dust and maintenance points.]]),
	},
	CleanAndFix2 = {
		des = T(302535920001226--[[Cleans dust and removes maintenance points.]]),
		name = "CleanAndFix",
	},
	Launch = {
		des = T(6779--[[Warning]]) .. ": " .. T(302535920001233--[[Launches rocket without asking.]]),
		icon = "UI/Icons/ColonyControlCenter/rocket_r.tga",
	},
	ShowFlights = {
		des = T(302535920001599--[[Show flight trajectories.]]),
	},
	MaxShuttlesDbl = {
		des = T(302535920001217--[[Double the shuttles this ShuttleHub can control.]]),
	},
	MaxShuttlesDef = {
		des = T(302535920001598--[[Reset shuttle control amount to default.]]),
	},
	MaxShuttles = {
		des = T(302535920001416--[[Max out shuttles for this hub.]]),
	},
--~ 	Refuel = {
--~ 		des = T(302535920001416--[[Max out shuttles for this hub.]]),
--~ 	},
	Refuel = {
		des = T(302535920001053--[[Fill up rocket with fuel.]]),
		icon = "UI/Icons/res_fuel.tga",
	},






-- Units
	Breadcrumbs = {
		des = T(302535920001464--[[Leave a trail of rudimentary orbs.]]),
	},
	UnitPathing = {
		des = T(302535920001748--[[Show path unit is trying to take.]]),
	},
	SpawnDog = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnGoat = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnCat = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnPony = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnPenguin = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnRabbit = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnDeer = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},
	SpawnLlama = {
		des = T(302535920001632--[[Spawn an animal.]]),
	},






-- Misc
	MoveRealm = {
		des = T(302535920001380--[[Move object to new realm]]),
	},
	FindResource = {
		des = T(302535920001218--[[Selects nearest storage containing specified resource (shows list of resources).]]),
		icon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
	},
	Examine = {
		des = T(302535920001277--[[Examine <color ChoGGi_green><str></color>.]]),
		des_name = true,
		icon = ChoGGi.library_path .. "UI/incal_egg.png",
	},
--~ 	AddFuel = {
--~ 		des = T(302535920001053--[[Fill up a rocket with fuel.]]),
--~ 		des_name = true,
--~ 		icon = "UI/Icons/res_fuel.tga",
--~ 	},
	DeleteObject = {
		des = T(302535920000414--[["Are you sure you wish to delete <color ChoGGi_red><str></color>?"]]),
		des_name = true,
		icon = "UI/Icons/Sections/warning.tga",
	},
	ColourRandom = {
		des = T(302535920001224--[[Changes colour of <str> to random colours (doesn't change attachments).]]),
		des_name = true,
	},
	ColourDefault = {
		des = T(302535920001246--[[Changes colour of <str> back to default.]]),
		des_name = true,
	},
	Expand = {
		des = T(302535920001601--[[Make the pool expand to the next radius.]]),
	},
	Remove = {
		des = T(302535920001604--[[Remove this pool.]]),
	},
	ToggleWaterGrid = {
		des = T(302535920001605--[[Shows a debug type view of the grid.]]),
	},
	SpawnFirefly = {
		des = T(302535920001616--[[Spawn a firefly.]]),
	},
	ChangeGrade = {
		des = T(302535920000977--[[Change grade of a deposit.]]),
	},
	FillWater = {
		des = T(302535920001646--[[Max out the stored water to fire it up immediately.]]),
	},
	DeleteAllObjects = {
		des = T(302535920001664--[[Do you want to delete all objects that are the same as this object from the map?]]),
	},





-- crystal myst
	SpawnDustDevil = {
		des = T(302535920001593--[[Spawns a dust devil nearby.]]),
	},
	LowConsumption = {
		des = T(302535920001594--[[Lowers the electricity_consumption by 99%.]]),
	},
	AllowExploration = {
		des = T(302535920001595--[[Something to do with CrystallineFrequencyJamming tech.]]),
	},
	AllowSalvage = {
		des = T(302535920001596--[[Lets you salvage the crystal.]]),
	},
	StartLiftoff = {
		des = T(302535920001597--[[Makes all crystals liftoff and head to the centre.]]),
	},
}
-- stuff checked in the SetInfoPanelCheatHints func
local cheats_lookup2 = {
	ToggleCollision = true,
	CleanAndFix = true,
	AddDust = true,
	ToggleSigns = true,
	Destroy = true,
	Refill = true,
	DoubleMaxAmount = true,
	Upgrade1 = true,
	Upgrade2 = true,
	Upgrade3 = true,
	WorkAuto = true,
	CapDbl = true,
	Malfunction = true,
	Unfreeze = true,
	Empty = true,
	Break = true,
	Repair = true,
}

local skip_CleanAndFix_AddDust = {"UniversalStorageDepot", "WasteRockDumpSite", "BaseRover"}
--~ local skip_ToggleSigns = {"TerrainDeposit", "SubsurfaceDeposit", "SurfaceDeposit", "WasteRockDumpSite"}
local skip_ToggleSigns = {"TerrainDeposit", "SubsurfaceDeposit", "SurfaceDeposit"}
local skip_Empty = {"SubsurfaceDeposit", "TerrainDeposit"}

-- check for any cheat funcs missing the tooltip description
function ChoGGi_Funcs.InfoPane.CheckForMissingCheatDes()
	-- list any missing ones
	local missing = {}
	-- funcs already checked
	local checked = {}

	local g_Classes = g_Classes
	for _, value_cls in pairs(g_Classes) do
		for key_obj, value_obj in pairs(value_cls) do
			-- skip some cls objs have a false in them, and if we've already checked it
			-- and if it's not a func / a func with Cheat starting in the name
			if key_obj ~= false and not checked[value_obj] and type(value_obj) == "function" and key_obj:sub(1, 5) == "Cheat" then
				-- always add func to checked list
				checked[value_obj] = true

				local aid = key_obj:sub(6)
				-- If it isn't in a lookup table then it's missing
				if not cheats_lookup[aid] and not cheats_lookup2[aid] and not grid_lookup[aid] then
					missing[value_obj] = true
				end
			end
		end
	end
	if next(missing) then
		OpenExamine(missing)
	else
		print("No missing cheat descriptions.")
	end
end

-- called from InfopanelObj:CreateCheatActions()
function ChoGGi_Funcs.InfoPane.SetInfoPanelCheatHints(win)
	local obj = win.context
	local name = RetName(obj)
	local id = obj.template_name
	for i = 1, #win.actions do
		local action = win.actions[i]
		local aid = action.ActionId

		-- If it's stored in table than we'll use that otherwise it's elseif time
		local look = cheats_lookup[aid]
		if look then
			if look.des then
				if look.des_name then
					if type(look.des_name) == "string" then
						SetHint(action, T{look.des,
							str = obj[look.des_name],
						})
					else
						SetHint(action, T{look.des,
							str = name,
						})
					end
				else
					SetHint(action, look.des)
				end
			end

			if look.name then
				action.ActionName = look.name
			end
			if look.icon then
				SetIcon(action, look.icon_name, look.icon)
			end

		elseif grid_lookup[aid] then
			SetGridInfo(action, obj, name, grid_lookup[aid])

		-- cheats_lookup2 is a list of name = true
		elseif cheats_lookup2[aid] then
			if aid == "ToggleCollision" then
				SetHint(action, Translate(302535920001543--[[Set collisions on %s. Collisions disabled: %s]]):format(name, Common.SettingState(obj.ChoGGi_CollisionsDisabled)))
				SetIcon(action, nil, "CommonAssets/UI/Menu/ToggleOcclusion.tga")

			elseif aid == "CleanAndFix" then
				if obj:IsKindOfClasses(skip_CleanAndFix_AddDust) then
					action.ActionId = ""
				else
					SetHint(action, T(302535920001226--[[Cleans dust and removes maintenance points.]]))
				end

			elseif aid == "AddDust" then
				if obj:IsKindOfClasses(skip_CleanAndFix_AddDust) then
					action.ActionId = ""
				else
					SetHint(action, T(302535920001225--[[Adds dust and maintenance points.]]))
				end

			elseif aid == "ToggleSigns" then
				if obj:IsKindOfClasses(skip_ToggleSigns) then
					action.ActionId = ""
				else
					SetHint(action, Translate(302535920001223--[[Toggle any signs above %s (until state is changed).]]):format(name))
				end

			elseif aid == "Destroy" then
				if obj:IsKindOf("RocketBase") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action, T(302535920001227--[[Turns object into ruin.]]))
					SetIcon(action, nil, "UI/Icons/IPButtons/demolition.tga")
				end

			elseif aid == "Refill" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					SetHint(action, T(302535920001231--[[Refill the deposit to full capacity.]]))
				end

			elseif aid == "DoubleMaxAmount" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					SetHint(action, Translate(302535920001234--[[Double the amount this %s can hold.]]):format(name))
				end

			elseif aid == "Upgrade1" then
				SetUpgradeInfo(action, obj, 1)
			elseif aid == "Upgrade2" then
				SetUpgradeInfo(action, obj, 2)
			elseif aid == "Upgrade3" then
				SetUpgradeInfo(action, obj, 3)
			elseif aid == "WorkAuto" then
				local bs = ChoGGi.UserSettings.BuildingSettings
				SetHint(action, Translate(302535920001209--[[Make this %s not need workers (performance: %s).]]):format(name, bs and bs[id] and bs[id].performance or 100))

			elseif aid == "CapDbl" then
				if obj:IsKindOf("RocketBase") then
					SetHint(action, Translate(302535920001211--[[Double the export storage capacity of this %s.]]):format(name))
				else
					SetHint(action, Translate(302535920001212--[[Double the storage capacity of this %s.]]):format(name))
				end

			elseif aid == "Malfunction" then
				if obj.destroyed or obj.is_malfunctioned then
					action.ActionId = ""
				else
					SetHint(action, T(8039--[[Trait: Idiot (can cause a malfunction)]]) .. "...\n" .. T(53--[[Malfunction]]) .. "?")
				end

			elseif aid == "Unfreeze" then
				if obj:IsKindOf("DroneHub") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action, T(302535920000903--[[Unfreeze frozen object.]]))
				end

			elseif aid == "Empty" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					if obj:IsKindOfClasses(skip_Empty) then
						SetHint(action, Translate(302535920001228--[[Set the stored amount of this %s to 0.]]):format(name))
					else
						SetHint(action, T(302535920001230--[[Empties the storage of this building.

	If this isn't a dumping site then waste rock will not be emptied.]]))
					end
				end

			elseif aid == "Break" then
				if obj:IsKindOf("ElectricityGridElement") then
					SetHint(action, T(3890--[[Cable Fault]]))
				else
					SetHint(action, T(3891--[[Pipe Leak]]))
				end
			elseif aid == "Repair" then
				if obj:IsKindOf("ElectricityGridElement") then
					SetHint(action, T(6924--[[Repair]]) .. " " .. T(3890--[[Cable Fault]]))
				else
					SetHint(action, T(6924--[[Repair]]) .. " " .. T(3891--[[Pipe Leak]]))
				end
			-- no more elseif
			end

		else
			SetHint(action, "Missing Hint")
		end -- lookup ifs
	end -- for

	return true
end

function OnMsg.ClassesBuilt()
	ElectricityGridElement.CheatRepair = ElectricityGridElement.Repair
	LifeSupportGridElement.CheatRepair = LifeSupportGridElement.Repair
	ElectricityGridElement.CheatBreak = ElectricityGridElement.Break
	LifeSupportGridElement.CheatBreak = LifeSupportGridElement.Break

	-- lazy devs... (stop using the Building class for rovers)
	if RCSafari then
		RCSafari.CheatDestroy = nil
		RCSafari.CheatMalfunction = nil
	end
end

local Colonist = Colonist
local Workplace = Workplace

function CObject:CheatToggleSigns()
	if self:CountAttaches("BuildingSign") > 0 then
		self:DestroyAttaches("BuildingSign")
	else
		if self:IsKindOf("Colonist") then
			self:ShowAttachedSigns(not self.status_effect_sign_visible)
		else
			self:UpdateSignsVisibility()
		end
	end
end

function CObject:CheatDeleteAllObjects()
	local id = Common.RetTemplateOrClass(self)

	local function CallBackFunc(answer)
		if answer then
			local objs = Common.MapGet(id)
			for i = 1, #objs do
				Common.DeleteObject(objs[i], true)
			end
		end
	end

	Common.QuestionBox(
		T(6779--[[Warning]]) .. "!\n" .. T(302535920001702--[[Destroy]]) .. " " .. T(302535920001691--[[All]]) .. ": " .. id,
		CallBackFunc,
		T(6779--[[Warning]]) .. ": " .. T(302535920001702--[[Destroy]]),
		T(302535920001702--[[Destroy]]) .. " " .. T(302535920001691--[[All]]) .. " " .. id,
		T(1176--[[Cancel Destroy]])
	)
end

function CObject:CheatMoveRealm(map_id)
	if not g_AccessibleDlc.picard then
		return
	end

	if map_id then
		Common.MoveRealm(self, map_id)
		return
	end

	-- shows list of realms
	-- zheight on nearest passable pos
	local item_list = {}
	local c = 0

	local ActiveMapID = ActiveMapID
	local GameMaps = GameMaps

	local maps = MapSwitch:GetEntries()
	for i = 1, #maps do
		local map = maps[i]
		-- Skip unloaded maps/current map
		if GameMaps[map.Map] and ActiveMapID ~= map.Map then
			c = c + 1
			item_list[c] = {
				text = map.RolloverTitle,
				map_id = map.Map,
				hint = map.RolloverText,
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		Common.MoveRealm(self, choice[1].map_id)
	end

	Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001262--[[Move To Realm]]),
		hint = T(302535920001380--[[Move object to new realm]]),
	}
end

function ColdSensitive:CheatToggleFreeze()
	if self.frozen then
		self:SetFrozen(false)
	else
		self:SetFrozen(true)
	end
end

-- colonists
function Colonist:CheatFillMorale()
	self.stat_morale = 100 * ScaleStat
end
function Colonist:CheatFillSanity()
	self.stat_sanity = 100 * ScaleStat
end
function Colonist:CheatFillComfort()
	self.stat_comfort = 100 * ScaleStat
end
function Colonist:CheatFillHealth()
	self.stat_health = 100 * ScaleStat
end
function Colonist:CheatFillAll()
	self:CheatFillSanity()
	self:CheatFillComfort()
	self:CheatFillHealth()
	self:CheatFillMorale()
end
function Colonist:CheatRenegade()
	self:AddTrait("Renegade", true)
end
function Colonist:CheatRenegadeClear()
	self:RemoveTrait("Renegade")
	CreateRealTimeThread(function()
		Sleep(100)
		self:CheatFillMorale()
	end)
end
function Colonist:CheatRandomRace()
	self.race = Random(1, 5)
	self:ChooseEntity()
end
function Colonist:CheatRandomSpec()
	-- skip children, or they'll be a black cube
	if not self:GetEntity():find("Child") then
		local spec = ChoGGi.Tables.ColonistSpecializations[Random(1, #ChoGGi.Tables.ColonistSpecializations)]

		if self.specialist ~= "none" then
			self:RemoveTrait(self.specialist)
		end
		self:AddTrait(spec)
--~ 		self:SetSpecialization(spec)
--~ 		-- "fix" for picard
--~ 		self:SetSpecialization(spec)
	end
end
function Colonist:CheatPrefDbl()
	self.performance = self.performance * 2
end
function Colonist:CheatPrefDef()
	self.performance = self:GetClassValue("performance")
end
function Colonist:CheatRandomGender()
	Common.ColonistUpdateGender(self, ChoGGi.Tables.ColonistGenders[Random(1, #ChoGGi.Tables.ColonistGenders)])
end
function Colonist:CheatRandomAge()
	Common.ColonistUpdateAge(self, ChoGGi.Tables.ColonistAges[Random(1, #ChoGGi.Tables.ColonistAges)])
end
function Colonist:CheatDie()
	Common.QuestionBox(
		T(6779--[[Warning]]) .. "!\n" .. T(302535920001430--[[Kill colonist-]]) .. "?",
		function(answer)
			if answer then
				self:SetCommand("Die")
			end
		end,
		T(6779--[[Warning]]) .. ": " .. T(302535920000855--[[Last chance before deletion!]])
	)
end

function Unit:CheatBreadcrumbs()
	return Common.ToggleBreadcrumbs(self)
end
function Shuttle:CheatBreadcrumbs()
	return Common.ToggleBreadcrumbs(self)
end

function Unit:CheatUnitPathing()
	return Common.ToggleUnitPathing(self)
end
function Shuttle:CheatUnitPathing()
	return Common.ToggleUnitPathing(self)
end

-- CheatAllShifts
local function CheatAllShiftsOn(self)
	self.closed_shifts[1] = false
	self.closed_shifts[2] = false
	self.closed_shifts[3] = false
end
FungalFarm.CheatAllShiftsOn = CheatAllShiftsOn
Farm.CheatAllShiftsOn = CheatAllShiftsOn
function Farm:CheatInstHarvest()
	-- change harvest_planted_time to always be bigger than "duration"
	self.harvest_planted_time = -max_int
	-- force an update instead of waiting
	self:BuildingUpdate()
	-- update info panel
	ObjModified(self)
end

-- CheatFullyAuto
function Workplace:CheatWorkersDbl()
	self.max_workers = self.max_workers * 2
end
function Workplace:CheatWorkersDef()
	self.max_workers = self:GetClassValue("max_workers")
end
function Workplace:CheatWorkAuto()
	self.max_workers = 0
	self.automation = 1
	local bs = ChoGGi.UserSettings.BuildingSettings
	bs = bs and bs[self.template_name]
	if bs then
		-- changed saving as performance to auto_performance, get rid of this in a few months
		self.auto_performance = bs.auto_performance or bs.performance
	else
		self.auto_performance = 100
	end
	Common.ToggleWorking(self)
end
function Workplace:CheatWorkManual()
	self.max_workers = nil
	self.automation = nil
	self.auto_performance = nil
	Common.ToggleWorking(self)
end

-- Deposits
function Deposit:CheatDoubleMaxAmount()
	self.max_amount = self.max_amount * 2
end
local function CheatChangeGrade(self)
	-- build a list of grades
	local item_list = {}
	local DepositGradesTable = DepositGradesTable
	for i = 1, #DepositGradesTable do
		local grade = DepositGradesTable[i]
		item_list[i] = {
			text = DepositGradeToDisplayName[grade],
			value = grade,
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		self.grade = choice[1].value
	end

	Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000977--[[Change grade of a deposit.]]),
		skip_sort = true,
	}
end
local function CheatEmpty(self)
	if self.amount == 1 then
		-- removes the object after the second click
		self.amount = 0
	else
		-- It'll look empty, but it won't actually remove the object
		self.amount = 1
	end
end
SubsurfaceDeposit.CheatEmpty = CheatEmpty
SubsurfaceDeposit.CheatChangeGrade = CheatChangeGrade
TerrainDeposit.CheatEmpty = CheatEmpty
TerrainDeposit.CheatChangeGrade = CheatChangeGrade
function TerrainDeposit:CheatRefill()
	self.amount = self.max_amount
end
-- building depots
function Building:CheatFillDepot()
	self:ForEachAttach("ConsumptionResourceStockpile", function(stock)
		stock:AddResource(self.consumption_resource_request:GetActualAmount(), nil, true)
	end)
end
-- storage
local function CheatFillAll(self)
	local template = self.template_name
	local objs = (self.city or UICity).labels[template]
	for i = 1, #objs do
		local obj = objs[i]
		-- UniversalStorageDepot label has all depots in it
		if obj.template_name == template then
			obj:CheatFill()
		end
	end
end
UniversalStorageDepot.CheatFillAll = CheatFillAll
StorageDepot.CheatFillAll = CheatFillAll
MechanizedDepot.CheatFillAll = CheatFillAll
-- CheatCap storage
local function RetGridCharValues(obj)
	if obj:IsKindOf("ElectricityStorage") then
		return "max_electricity_charge", "max_electricity_discharge", obj.electricity
	elseif obj:IsKindOf("AirStorage") then
		return "max_air_charge", "max_air_discharge", obj.air
	elseif obj:IsKindOf("WaterStorage") then
		return "max_water_charge", "max_water_discharge", obj.water
	end
end
local function RetGridValues(obj)
	if obj:IsKindOf("ElectricityStorage") then
		return "capacity", obj.electricity
	elseif obj:IsKindOf("AirStorage") then
		return "air_capacity", obj.air
	elseif obj:IsKindOf("WaterStorage") then
		return "water_capacity", obj.water
	end
end
local function CheatChargeDbl(obj)
	local c_key, d_key, grid = RetGridCharValues(obj)
	local c_new = obj[c_key] * 2
	obj[c_key] = c_new
	local d_new = obj[d_key] * 2
	obj[d_key] = d_new

	grid.max_charge = c_new
	grid.max_discharge = d_new
	Common.ToggleWorking(obj)
end
local function CheatCapDbl(obj)
	local cap_key, grid = RetGridValues(obj)
	local new = obj[cap_key] * 2
	obj[cap_key] = new
	grid.storage_capacity = new
	grid.storage_mode = "charging"
	Common.ToggleWorking(obj)
end
local function CheatChargeDef(obj)
	local c_key, d_key, grid = RetGridCharValues(obj)
	local c_new = obj:GetClassValue(c_key)
	local d_new = obj:GetClassValue(d_key)
	obj[c_key] = c_new
	obj[d_key] = d_new
	grid.max_charge = c_new
	grid.max_discharge = d_new
	Common.ToggleWorking(obj)
end
local function CheatCapDef(obj)
	local cap_key, grid = RetGridValues(obj)
	local new = obj:GetClassValue(cap_key)
	obj[cap_key] = new
	grid.storage_capacity = new
	grid.storage_mode = "full"
	Common.ToggleWorking(obj)
end
ElectricityStorage.CheatCapDbl = CheatCapDbl
ElectricityStorage.CheatCapDef = CheatCapDef
WaterStorage.CheatCapDbl = CheatCapDbl
WaterStorage.CheatCapDef = CheatCapDef
AirStorage.CheatCapDbl = CheatCapDbl
AirStorage.CheatCapDef = CheatCapDef
ElectricityStorage.CheatChargeDbl = CheatChargeDbl
ElectricityStorage.CheatChargeDef = CheatChargeDef
WaterStorage.CheatChargeDbl = CheatChargeDbl
WaterStorage.CheatChargeDef = CheatChargeDef
AirStorage.CheatChargeDbl = CheatChargeDbl
AirStorage.CheatChargeDef = CheatChargeDef

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
function ShuttleHub:CheatMaxShuttles()
	for _ = 1, (self.max_shuttles - #self.shuttle_infos) do
		self:SpawnShuttle()
	end
end

function Drone:CheatBattCapDbl()
	self.battery_max = self.battery_max * 2
end
function Drone:CheatBattCapDef()
	self.battery_max = Common.GetResearchedTechValue("DroneBatteryMax")
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
	self.dust = (self.visual_max_dust or 50000) - 1
	self:SetDustVisuals()
end
local function RemoveDust(self)
	self.dust = 0
	self:SetDustVisuals()
end
Drone.CheatAddDust = CheatAddDust
BaseRover.CheatAddDust = CheatAddDust
--
function DroneFactory:CheatFinishConstruct()
	if self.drone_construction_progress > 0 then
		self.drone_construction_progress = 100000
	end
end

function DroneFactory:CheatSpawnAndroid()
	self:SpawnAndroid()
end

local function CheatSpawnDrone(self)
	if self:IsKindOf("RocketBase") then
		if #self.drones >= self:GetMaxDrones() then
			return
		end
		local drone = self.city:CreateDrone()
		drone:SetCommandCenter(self)
		local spawn_pos = self:GetSpotLoc(self:GetSpotBeginIndex(self.drone_spawn_spot))
		drone:SetPos(spawn_pos)
		-- dunno doesn't work...
--~ 		CreateGameTimeThread(Drone.SetCommand, drone, "Embark")
		drone:SetCommand("Embark")
	else
		self:SpawnDrone()
	end
end
DroneControl.CheatSpawnDrone = CheatSpawnDrone
DroneFactory.CheatSpawnDrone = CheatSpawnDrone

function DroneHub:CheatSpawnAllDrones()
	local city = self.city
	local free_slots = self:GetFreeConstructionSlotsForDrones()

	for _ = 1, free_slots do
		if city.drone_prefabs == 0 then
			break
		end
		if self:SpawnDrone() then
			city.drone_prefabs = city.drone_prefabs - 1
		end
	end
end

function Drone:CheatGoHome()
	self:SetCommand("GoHome", nil, nil, nil, "ReturningToController")
end

function Drone:CheatCleanAndFix()
	CreateRealTimeThread(function()
		if not IsValid(self) then
			return
		end
		self.auto_connect = false
		if self.malfunction_end_state then
			self:PlayState(self.malfunction_end_state, 1)
		end
		self:CheatAddDust()
		RemoveDust(self)
		-- why not
		if self.command == "NoBattery" then
			self.battery = self.battery_max
			self:SetCommand("Fixed", "noBatteryFixed")
		elseif self.command == "Malfunction" or self.command == "Freeze" and self:CanBeThawed() then
			self:SetCommand("Fixed", "breakDownFixed")
		else
			self:SetCommand("Fixed", "Something")
		end
		RebuildInfopanel(self)
 end)
end
function BaseRover:CheatCleanAndFix()
	CreateRealTimeThread(function()
		if not IsValid(self) then
			return
		end
		self:CheatAddDust()
		RemoveDust(self)
		self:Repair()
 end)
end
local ChoOrig_Building_CheatCleanAndFix = Building.CheatCleanAndFix
function Building:CheatCleanAndFix()
	self:ResetDust()
	ChoOrig_Building_CheatCleanAndFix(self)
end

-- misc

if rawget(_G, "Firefly") then
	function Building:CheatRemoveAllFireflies()
		if not self.fireflies then
			return
		end

		for i = #self.fireflies, 1, -1 do
			self.fireflies[i]:delete()
		end

		self.fireflies = nil
	end

	local IsValid = IsValid

	local firefly_states = {
		"lightTrap",
		"moistureVaporator",
		"waterExtractor",
		"waterPillar",
		"waterPipe",
		"waterTank",
		"lightTrap",
		"waterTankLarge",
	}

	local	function Firefly_Drain(self)
		self:SetAngle(Random(0, 21600))
		while true do
			-- remove firefly if building removed
			if not IsValid(self.sinkhole) then
				self:delete()
				return
			end


--~ 			PlayFX("Approach", "start", self)

			if self.water_source.class == "WaterTank" then
				self:PlayState("waterTankStart")
				self:SetState("waterTankIdle")
			elseif self.water_source.class == "WaterTankLarge" then
				self:PlayState("waterTankLargeStart")
				self:SetState("waterTankLargeIdle")
			elseif self.water_source.class == "MoistureVaporator" then
				self:PlayState("moistureVaporatorStart")
				self:SetState("moistureVaporatorIdle")
			elseif self.water_source.class == "LifeSupportGridElement" then
				if self.water_source.entity == "Tube" then
					self:PlayState("waterPipeStart")
					self:SetState("waterPipeIdle")
				else
					self:PlayState("waterPillarStart")
					self:SetState("waterPillarIdle")
				end
			else
				local state = table.rand(firefly_states)
				self:PlayState(state .. "Start")
				self:SetState(state .. "Idle")
			end

			self.lights[1]:SetIntensity(Random(1, 150))

			Sleep(self:TimeToAnimEnd())
		end
	end

	function Building:CheatSpawnAFirefly()
		if not self.fireflies then
			self.fireflies = {}
		end

		local firefly = Firefly:new{sinkhole = self}
	--~ 	ex(firefly)

		firefly.water_source = self
		firefly.Drain = Firefly_Drain

		firefly:SetPos(self:GetPos())
		firefly:SetAngle(Random(0, 21600))
		table.insert(self.fireflies, firefly)
		firefly:SetCommand("Start")
	end
end

function SecurityStation:CheatReneagadeCapDbl()
	self.negated_renegades = self.negated_renegades * 2
end
function SecurityStation:CheatReneagadeCapDef()
	self.negated_renegades = self.max_negated_renegades
end

if rawget(_G, "RocketBase") then
--~ 	function RocketBase:CheatAddFuel()
--~ 		-- skip if we're full/over full
--~ 		local actual = self.refuel_request:GetActualAmount()
--~ 		if actual == 0 then
--~ 			return
--~ 		end

--~ 		local target = self.refuel_request:GetTargetAmount()
--~ 		self.accumulated_fuel = self.accumulated_fuel + target
--~ 		self.refuel_request:SetAmount(target)
--~ 		-- make sure it always shows the correct amount
--~ 		self.refuel_request:SetAmount(0)
--~ 		Msg("RocketRefueled", self)
--~ 		-- update selection panel
--~ 		local sel = SelectedObj
--~ 		if sel and sel.handle == self.handle then
--~ 			RebuildInfopanel(self)
--~ 		end
--~ 	end
	function RocketBase:CheatCapDbl()
		Common.SetTaskReqAmount(self, self.max_export_storage * 2, "export_requests", "max_export_storage")
	end
	function RocketBase:CheatCapDef()
		Common.SetTaskReqAmount(self, self:GetClassValue("max_export_storage"), "export_requests", "max_export_storage")
	end

	function RocketBase:CheatAddDust2()
		self:SetDust(600, 0)
		ApplyToObjAndAttaches(self, SetObjDust, 600)
	end
	function RocketBase:CheatCleanAndFix2()
		self:SetDust(0, 0)
		ApplyToObjAndAttaches(self, SetObjDust, 0)
	end
end


if rawget(_G, "Sinkhole") then
	Sinkhole.CheatSpawnFirefly = Sinkhole.TestSpawnFireflyAndGo
end

do -- Dome:CheatToggleGlass
	local opened
	function Dome:CheatToggleGlass()
		if opened then
			CloseAllDomes()
			opened = false
		else
			OpenAllDomes()
			opened = true
		end
	end
end -- do

function Dome:CheatCrimeEvent()
	-- build a list
	local item_list = {{
		text = "CheckCrimeEvents",
		value = Dome.CheckCrimeEvents,
	}}
	local c = #item_list
	local Dome = Dome
	for key, value in pairs(Dome) do
		if type(value) == "function" and key:sub(1, 12) == "CrimeEvents_" then
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

	Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001541--[[Start a Crime Event]]),
		hint = T(302535920001542--[[Renegades not required.]]),
	}
end

if rawget(_G, "LandscapeLake") then
	local function LandscapeLakeCheatVol(self, num)
		local five = 0.05 * self.volume_max
		self:SetVolume(self.volume + (five * num))
	end

	function LandscapeLake:CheatVolPlus5()
		LandscapeLakeCheatVol(self, 1)
	end

	function LandscapeLake:CheatVolMinus5()
		LandscapeLakeCheatVol(self, -1)
	end
end

-- CheatEmpty only empties the production depot, not the consumption one.
local ChoOrig_ResourceProducer_CheatEmpty = ResourceProducer.CheatEmpty
function ResourceProducer:CheatEmpty(...)
	-- An IsValid won't hurt
	if IsValid(self.consumption_resource_stockpile) then
		self:Consume_Internal(self.consumption_stored_resources)
	end
	return ChoOrig_ResourceProducer_CheatEmpty(self, ...)
end

function ArtificialSun:CheatFillWater()
	self.stored_water = self.water_capacity
end

-- needs better spin animation (full circle)
function SpaceElevator:CheatFidgetSpinner()
	if self.ChoGGi_FidgetSpinner_thread then
		if IsValidThread(self.ChoGGi_FidgetSpinner_thread) then
			DeleteThread(self.ChoGGi_FidgetSpinner_thread)
		end
		local angle = self.ChoGGi_FidgetSpinner_orig_angle

		self.ChoGGi_FidgetSpinner_thread = nil
		self.ChoGGi_FidgetSpinner_orig_angle = nil
		self:SetAngle(angle or 0, 1500)
		return
	end

	self.ChoGGi_FidgetSpinner_orig_angle = self:GetAngle()
	self.ChoGGi_FidgetSpinner_thread = CreateGameTimeThread(function()
		while true do
			self:SetAngle(10800, 1500)
			Sleep(1000)
			self:SetAngle(0, 1500)
			Sleep(1000)
		end
	end)
end
