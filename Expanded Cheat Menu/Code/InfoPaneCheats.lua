-- See LICENSE for terms

-- add items/hint to the cheats pane

local pairs, table = pairs, table
local DoneObject = DoneObject
local IsValid = IsValid
local CreateRealTimeThread = CreateRealTimeThread

local ComFuncs = ChoGGi.ComFuncs
local RetName = ComFuncs.RetName
local Random = ComFuncs.Random
local Translate = ComFuncs.Translate
local Strings = ChoGGi.Strings
local ResourceScale = const.ResourceScale

Object.CheatExamine = ComFuncs.OpenInExamineDlg
Object.CheatToggleCollision = ComFuncs.CollisionsObject_Toggle
Object.CheatDeleteObject = ComFuncs.DeleteObjectQuestion
Drone.CheatFindResource = ComFuncs.FindNearestResource
Drone.CheatDestroy = ComFuncs.RuinObjectQuestion
RCTransport.CheatFindResource = ComFuncs.FindNearestResource
ColorizableObject.CheatColourRandom = ComFuncs.ObjectColourRandom
ColorizableObject.CheatColourDefault = ComFuncs.ObjectColourDefault
BaseBuilding.CheatViewConstruct = ComFuncs.ToggleConstructEntityView
BaseBuilding.CheatViewEditor = ComFuncs.ToggleEditorEntityView
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
	action.RolloverHint = Translate(608042494285--[[<left_click> Activate]])
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
		SetHint(action, Strings[302535920001207--[["Add: %s to this building.

%s"]]]:format(
			Translate(obj["upgrade" .. num .. "_display_name"]),
			Translate(T{obj["upgrade" .. num .. "_description"], obj})
		))
		SetIcon(action, num, obj["upgrade" .. num .. "_icon"])
	else
		action.ActionId = ""
	end
end
local doublec = Strings[302535920001199--[[Double the amount of colonist slots for this building.]]]
local resetc = Strings[302535920001200--[[Reset the capacity of colonist slots for this building.]]]

local grid_lookup = {
	OxygenFree = {
		icon = "UI/Icons/res_oxygen.tga",
		name = Translate(682--[[Oxygen]]),
		text1 = Translate(4325--[[Free]]),
		text2 = Strings[302535920001220--[[Change this %s so it doesn't need a %s source.]]],
		con = "air_consumption",
	},
	OxygenNeed = {
		icon = "UI/Icons/res_oxygen.tga",
		name = Translate(682--[[Oxygen]]),
		text1 = Strings[302535920000162--[[Need]]],
		text2 = Strings[302535920001221--[[Change this %s so it needs a %s source.]]],
		con = "air_consumption",
	},
	WaterFree = {
		icon = "UI/Icons/res_water.tga",
		name = Translate(681--[[Water]]),
		text1 = Translate(4325--[[Free]]),
		text2 = Strings[302535920001220--[[Change this %s so it doesn't need a %s source.]]],
		con = "water_consumption",
	},
	WaterNeed = {
		icon = "UI/Icons/res_water.tga",
		name = Translate(681--[[Water]]),
		text1 = Strings[302535920000162--[[Need]]],
		text2 = Strings[302535920001221--[[Change this %s so it needs a %s source.]]],
		con = "water_consumption",
	},
	PowerFree = {
		icon = "UI/Icons/res_electricity.tga",
		name = Translate(11683--[[Electricity]]),
		text1 = Translate(4325--[[Free]]),
		text2 = Strings[302535920001220--[[Change this %s so it doesn't need a %s source.]]],
		con = "electricity_consumption",
	},
	PowerNeed = {
		icon = "UI/Icons/res_electricity.tga",
		name = Translate(11683--[[Electricity]]),
		text1 = Strings[302535920000162--[[Need]]],
		text2 = Strings[302535920001221--[[Change this %s so it needs a %s source.]]],
		con = "electricity_consumption",
	},
}
local function SetGridInfo(action, obj, name, grid)
--~ 	local consumption = obj[grid.con]
--~ 	if consumption and consumption ~= 0 then
	if obj[grid.con] then
		SetHint(action, grid.text2:format(name, grid.name))
		SetIcon(action, grid.text1, grid.icon)
	else
		action.ActionId = ""
	end
end

local cheats_lookup = {
-- Colonist
	FillAll = {
		des = Strings[302535920001202--[[Fill all stat bars.]]],
	},
	SpawnColonist = {
		des = Strings[302535920000005--[[Drops a new colonist in selected dome.]]],
		icon = "UI/Icons/ColonyControlCenter/colonist_on.tga",
	},
	PrefDbl = {
		des = Strings[302535920001203--[[Double %s's performance.]]],
		des_name = true,
	},
	PrefDef = {
		des = Strings[302535920001204--[[Reset %s's performance to default.]]],
		des_name = true,
	},
	ReneagadeCapDbl = {
		des = Strings[302535920001236--[[Double amount of reneagades this station can negate (currently: %s) < Reselect to update amount.]]],
		des_name = "negated_renegades",
	},
	ReneagadeCapDef = {
		des = Strings[302535920001603--[[Reset the amount of reneagades this station can negate.]]],
	},
	Die = {
		des = Strings[302535920001431--[[Kill this colonist!]]],
	},
	ViewConstruct = {
		des = Strings[302535920001531--[[Make the building model look like a construction site (toggle).]]],
	},
	ViewEditor = {
		des = Strings[302535920001531--[[Make the building model look simpler (toggle).]]],
	},
	CrimeEvent = {
		des = Strings[302535920001541--[[Start a Crime Event]]],
	},
	FillComfort = {
		des = Strings[302535920001606--[[Max the <green>%s</green> value for this colonist.]]]:format(Translate(4295--[[Comfort]]))
			.. "\n\n" .. Translate(4296--[[Residences and visited buildings improve Comfort up to their Service Comfort value, but Colonists will try to visit only buildings that correspond to their interests. Colonists are more inclined to have children at higher Comfort. Earthborn Colonists whose Comfort is depleted will quit their job and leave the Colony at first opportunity.]]),
	},
	FillHealth = {
		des = Strings[302535920001606--[[Max the <green>%s</green> value for this colonist.]]]:format(Translate(4291--[[Health]]))
			.. "\n\n" .. Translate(4292--[[Represents physical injury, illness and exhaustion. Lowered by working on a heavy workload, having no functional home, shock when deprived from vital resources or when the Colonist is injured. Colonists can be healed in Medical Buildings in a powered Dome, but only if they are provided with Food, Water and Oxygen. Colonists can't work at low health unless they're Fit.]]),
	},
	FillMorale = {
		des = Strings[302535920001606--[[Max the <green>%s</green> value for this colonist.]]]:format(Translate(4297--[[Morale]]))
			.. "\n\n" .. Translate(4298--[[Represents overall happiness, optimism and loyalty. All other stats affect Morale. Influences the Colonist’s job performance. Colonists with low Morale may become Renegades.]]),
	},
	FillSanity = {
		des = Strings[302535920001606--[[Max the <green>%s</green> value for this colonist.]]]:format(Translate(4293--[[Sanity]]))
			.. "\n\n" .. Translate(4294--[[Represents mental condition. Lowered by working on a heavy workload, in outside buildings and during dark hours, witnessing the death of a Colonist living in the same Residence or various Martian disasters. Recovered when resting at home and by visiting certain Service Buildings.]]),
	},
	RandomAge = {
		des = Strings[302535920001607--[[Set a random <green>%s</green> for this colonist.]]]:format(Translate(11607--[[Age Group]]))
			.. "\n\n" .. Translate(3930--[[Colonists are divided into five Age Groups. Children and seniors cannot work.]]),
	},
	RandomGender = {
		des = Strings[302535920001607--[[Set a random <green>%s</green> for this colonist.]]]:format(Translate(3932--[[Sex]]))
			.. "\n\n" .. Translate(3933--[[The sex of the Colonist. The birth rate in any Dome is determined by the number of Male/Female couples at high Comfort.]]),
	},
	RandomRace = {
		des = Strings[302535920001607--[[Set a random <green>%s</green> for this colonist.]]]:format(Strings[302535920000741--[[Race]]])
			.. "\n\n" .. Strings[302535920001608--[["I said if you're thinkin' of being my baby
It don't matter if you're black or white

I said if you're thinkin' of being my brother
It don't matter if you're black or white"]]],
	},
	RandomSpec = {
		des = Strings[302535920001607--[[Set a random <green>%s</green> for this colonist.]]]:format(Translate(11609--[[Specialization]]))
			.. "\n\n" .. Translate(3931--[[Specialized Colonists perform better at certain workplaces.]]),
	},
	Renegade = {
		des = Strings[302535920001609--[[Turn this colonist into a renegade.]]],
	},
	RenegadeClear = {
		des = Strings[302535920001610--[[Remove the renegade trait from this colonist.]]],
	},
	MakeEarthsick = {
		des = Strings[302535920000064--[[Add Earthsick status to Colonist.]]],
	},
	Kill = {
		des = Strings[302535920000065--[[Colonist will no longer enjoy life.]]],
	},
	Age1Year = {
		des = Strings[302535920000244--[[Age will increase by 1 year.]]],
	},
	AddTouristTrait = {
		des = Strings[302535920000663--[[Change colonist into a tourist.]]],
	},
	AddSolOnMars = {
		des = Strings[302535920000981--[[Bump the time they've spent on Mars.]]],
	},

-- Building
	VisitorsDbl = {des = doublec},
	VisitorsDef = {des = resetc},
	WorkersDbl = {des = doublec},
	WorkersDef = {des = resetc},
	ColonistCapDbl = {des = doublec},
	ColonistCapDef = {des = resetc},
	WorkManual = {
		des = Strings[302535920001210--[[Make this %s need workers.]]],
		des_name = true,
	},
	CapDef = {
		des = Strings[302535920001213--[[Reset the storage capacity of this %s to default.]]],
		des_name = true,
	},
	ChargeDbl = {
		des = Strings[302535920001095--[[Double the charge capacity of this %s.]]],
		des_name = true,
	},
	ChargeDef = {
		des = Strings[302535920001096--[[Reset the charge capacity of this %s to default.]]],
		des_name = true,
	},
	EmptyDepot = {
		des = Strings[302535920001214--[[Sticks small depot in front of mech depot and moves all resources to it (max of 20 000).]]],
	},
	["Quick build"] = {
		des = Strings[302535920000060--[[Instantly complete building without needing resources.]]],
	},
	Fill = {
		des = Strings[302535920001232--[[Fill the storage of this building.]]],
	},
	AllShiftsOn = {
		des = Strings[302535920001215--[[Turn on all work shifts.]]],
	},
	CompleteTraining = {
		des = Strings[302535920001600--[[Instantly finish the training for all visitors.]]],
	},
	GenerateOffer = {
		des = Strings[302535920001602--[[Force add a new trade offer.]]],
	},
	ToggleGlass = {
		des = Strings[302535920001617--[[Toggle opening all dome glass (for screenshots?).]]],
	},
	ToggleFreeze = {
		des = Strings[302535920000985--[[Toggle frozen state of building.]]],
	},
	FinishConstruct = {
		des = Strings[302535920001428--[[Instantly finish current drone/biorobot.]]],
	},
	FillAll = {
		des = Strings[302535920001463--[[Fill all depots of same type.]]],
	},
	SpawnDrone = {
		des = Strings[302535920001466--[[Spawn a drone.]]],
	},
	SpawnDrone = {
		des = Strings[302535920001466--[[Spawn a drone.]]],
	},
	SpawnAndroid = {
		des = Strings[302535920001577--[[Spawn an Android.]]],
	},
	AddProgressPoints = {
		des = Strings[302535920000983--[[Bump the TV Show progress by 5000.]]],
	},
	ResetShowProgress = {
		des = Strings[302535920001628--[[Reset the TV Show progress.]]],
	},
	VolMinus5 = {
		des = Strings[302535920001629--[[Increase lake volume by 5.]]],
	},
	VolPlus5 = {
		des = Strings[302535920001630--[[Decrease lake volume by 5.]]],
	},

-- Rover/Drone
	BattCapDbl = {
		des = Strings[302535920001216--[[Double the battery capacity.]]],
	},
	Scan = {
		des = Translate(979029137252--[[Scanned an Anomaly]]),
		icon = "UI/Icons/pin_scan.tga",
	},
	BattCapDef = {
		des = Strings[302535920001611--[[Reset the battery cap to default.]]],
	},
	DrainBattery = {
		des = Strings[302535920001612--[[Drain the battery to zero.]]],
	},
	RechargeBattery = {
		des = Strings[302535920001613--[[Refill the battery to max.]]],
	},
	Despawn = {
		des = Translate(833734167742--[[Delete Item]]),
	},
	MoveSpeedDbl = {
		des = Strings[302535920001614--[[Doubles the move speed.]]],
	},
	MoveSpeedDef = {
		des = Strings[302535920001615--[[Reset the move speed to default.]]],
	},
	GoHome = {
		des = Strings[302535920000929--[[Tell drone to go back to controller.]]],
	},
	RemoveDustRC = {
		des = Strings[302535920001631--[[Remove dust covering Rover.]]],
	},

-- Rocket/Shuttles
	-- when i added a "working" AddDust to rockets it showed up twice, so i'm lazy
	AddDust2 = {
		des = Strings[302535920001225--[[Adds dust and maintenance points.]]],
		name = "AddDust",
	},
	AddDustRC = {
		des = Strings[302535920001225--[[Adds dust and maintenance points.]]],
	},
	CleanAndFix2 = {
		des = Strings[302535920001226--[[Cleans dust and removes maintenance points.]]],
		name = "CleanAndFix",
	},
	Launch = {
		des = Translate(6779--[[Warning]]) .. ": " .. Strings[302535920001233--[[Launches rocket without asking.]]],
		icon = "UI/Icons/ColonyControlCenter/rocket_r.tga",
	},
	ShowFlights = {
		des = Strings[302535920001599--[[Show flight trajectories.]]],
	},
	MaxShuttlesDbl = {
		des = Strings[302535920001217--[[Double the shuttles this ShuttleHub can control.]]],
	},
	MaxShuttlesDef = {
		des = Strings[302535920001598--[[Reset shuttle control amount to default.]]],
	},
	MaxShuttles = {
		des = Strings[302535920001416--[[Max out shuttles for this hub.]]],
	},

-- Units
	Breadcrumbs = {
		des = Strings[302535920001464--[[Leave a trail of rudimentary orbs.]]],
	},
	SpawnDog = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnGoat = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnCat = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnPony = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnPenguin = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnRabbit = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnDeer = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},
	SpawnLlama = {
		des = Strings[302535920001632--[[Spawn an animal.]]],
	},


-- Misc
	FindResource = {
		des = Strings[302535920001218--[[Selects nearest storage containing specified resource (shows list of resources).]]],
		icon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
	},
	Examine = {
		des = Strings[302535920001277--[[Open %s in the Object Examiner.]]],
		des_name = true,
		icon = ChoGGi.library_path .. "UI/incal_egg.png",
	},
	AddFuel = {
		des = Strings[302535920001053--[[Fill up %s with fuel.]]],
		des_name = true,
		icon = "UI/Icons/res_fuel.tga",
	},
	DeleteObject = {
		des = Strings[302535920000414--[[Are you sure you wish to delete %s?]]],
		des_name = true,
		icon = "UI/Icons/Sections/warning.tga",
	},
	ColourRandom = {
		des = Strings[302535920001224--[[Changes colour of %s to random colours (doesn't change attachments).]]],
		des_name = true,
	},
	ColourDefault = {
		des = Strings[302535920001246--[[Changes colour of %s back to default.]]],
		des_name = true,
	},
	Expand = {
		des = Strings[302535920001601--[[Make the pool expand to the next radius.]]],
	},
	Remove = {
		des = Strings[302535920001604--[[Remove this pool.]]],
	},
	ToggleWaterGrid = {
		des = Strings[302535920001605--[[Shows a debug type view of the grid.]]],
	},
	SpawnFirefly = {
		des = Strings[302535920001616--[[Spawn a firefly.]]],
	},

-- crystal myst
	SpawnDustDevil = {
		des = Strings[302535920001593--[[Spawns a dust devil nearby.]]],
	},
	LowConsumption = {
		des = Strings[302535920001594--[[Lowers the electricity_consumption by 99%.]]],
	},
	AllowExploration = {
		des = Strings[302535920001595--[[Something to do with CrystallineFrequencyJamming tech.]]],
	},
	AllowSalvage = {
		des = Strings[302535920001596--[[Lets you salvage the crystal.]]],
	},
	StartLiftoff = {
		des = Strings[302535920001597--[[Makes all crystals liftoff and head to the centre.]]],
	},
	ChangeGrade = {
		des = Strings[302535920000977--[[Change grade of a deposit.]]],
	},
	FillWater = {
		des = Strings[302535920001646--[[Max out the stored water to fire it up immediately.]]],
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
local skip_ToggleSigns = {"TerrainDeposit", "SubsurfaceDeposit", "SurfaceDeposit", "WasteRockDumpSite"}
local skip_Empty = {"SubsurfaceDeposit", "TerrainDeposit"}

-- check for any cheat funcs missing the tooltip description
function ChoGGi.InfoFuncs.CheckForMissingCheatDes()
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
		ChoGGi.ComFuncs.OpenInExamineDlg(missing)
	else
		print("No missing cheat descriptions.")
	end
end

-- called from InfopanelObj:CreateCheatActions()
function ChoGGi.InfoFuncs.SetInfoPanelCheatHints(win)
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
						SetHint(action, look.des:format(obj[look.des_name]))
					else
						SetHint(action, look.des:format(name))
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
				SetHint(action, Strings[302535920001543--[[Set collisions on %s. Collisions disabled: %s]]]:format(name, ComFuncs.SettingState(obj.ChoGGi_CollisionsDisabled)))
				SetIcon(action, nil, "CommonAssets/UI/Menu/ToggleOcclusion.tga")

			elseif aid == "CleanAndFix" then
				if obj:IsKindOfClasses(skip_CleanAndFix_AddDust) then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920001226--[[Cleans dust and removes maintenance points.]]])
				end

			elseif aid == "AddDust" then
				if obj:IsKindOfClasses(skip_CleanAndFix_AddDust) then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920001225--[[Adds dust and maintenance points.]]])
				end

			elseif aid == "ToggleSigns" then
				if obj:IsKindOfClasses(skip_ToggleSigns) then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920001223--[[Toggle any signs above %s (until state is changed).]]]:format(name))
				end

			elseif aid == "Destroy" then
				if obj:IsKindOf("RocketBase") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920001227--[[Turns object into ruin.]]])
					SetIcon(action, nil, "UI/Icons/IPButtons/demolition.tga")
				end

			elseif aid == "Refill" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920001231--[[Refill the deposit to full capacity.]]])
				end

			elseif aid == "DoubleMaxAmount" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920001234--[[Double the amount this %s can hold.]]]:format(name))
				end

			elseif aid == "Upgrade1" then
				SetUpgradeInfo(action, obj, 1)
			elseif aid == "Upgrade2" then
				SetUpgradeInfo(action, obj, 2)
			elseif aid == "Upgrade3" then
				SetUpgradeInfo(action, obj, 3)
			elseif aid == "WorkAuto" then
				local bs = ChoGGi.UserSettings.BuildingSettings
				SetHint(action, Strings[302535920001209--[[Make this %s not need workers (performance: %s).]]]:format(name, bs and bs[id] and bs[id].performance or 100))

			elseif aid == "CapDbl" then
				if obj:IsKindOf("RocketBase") then
					SetHint(action, Strings[302535920001211--[[Double the export storage capacity of this %s.]]]:format(name))
				else
					SetHint(action, Strings[302535920001212--[[Double the storage capacity of this %s.]]]:format(name))
				end

			elseif aid == "Malfunction" then
				if obj.destroyed or obj.is_malfunctioned then
					action.ActionId = ""
				else
					SetHint(action, Translate(8039--[[Trait: Idiot (can cause a malfunction)]]) .. "...\n" .. Translate(53--[[Malfunction]]) .. "?")
				end

			elseif aid == "Unfreeze" then
				if obj:IsKindOf("DroneHub") or obj.destroyed then
					action.ActionId = ""
				else
					SetHint(action, Strings[302535920000903--[[Unfreeze frozen object.]]])
				end

			elseif aid == "Empty" then
				if obj:IsKindOf("SubsurfaceAnomaly") then
					action.ActionId = ""
				else
					if obj:IsKindOfClasses(skip_Empty) then
						SetHint(action, Strings[302535920001228--[[Set the stored amount of this %s to 0.]]]:format(name))
					else
						SetHint(action, Strings[302535920001230--[[Empties the storage of this building.

	If this isn't a dumping site then waste rock will not be emptied.]]])
					end
				end

			elseif aid == "Break" then
				if obj:IsKindOf("ElectricityGridElement") then
					SetHint(action, Translate(3890--[[Cable Fault]]))
				else
					SetHint(action, Translate(3891--[[Pipe Leak]]))
				end
			elseif aid == "Repair" then
				if obj:IsKindOf("ElectricityGridElement") then
					SetHint(action, Translate(6924--[[Repair]]) .. " " .. Translate(3890--[[Cable Fault]]))
				else
					SetHint(action, Translate(6924--[[Repair]]) .. " " .. Translate(3891--[[Pipe Leak]]))
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
	RCSafari.CheatDestroy = nil
	RCSafari.CheatMalfunction = nil
end

local Colonist = Colonist
local Workplace = Workplace

function Object:CheatToggleSigns()
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

function ColdSensitive:CheatToggleFreeze()
	if self.frozen then
		self:SetFrozen(false)
	else
		self:SetFrozen(true)
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
--~ 		self:SetSpecialization(ChoGGi.Tables.ColonistSpecializations[Random(1, #ChoGGi.Tables.ColonistSpecializations)], "init")
		local spec = ChoGGi.Tables.ColonistSpecializations[Random(1, #ChoGGi.Tables.ColonistSpecializations)]
		self:SetSpecialization(spec)
		-- "fix" for picard
		self:SetSpecialization(spec)
	end
end
function Colonist:CheatPrefDbl()
	self.performance = self.performance * 2
end
function Colonist:CheatPrefDef()
	self.performance = self:GetClassValue("performance")
end
function Colonist:CheatRandomGender()
	ChoGGi.ComFuncs.ColonistUpdateGender(self, ChoGGi.Tables.ColonistGenders[Random(1, #ChoGGi.Tables.ColonistGenders)])
end
function Colonist:CheatRandomAge()
	ChoGGi.ComFuncs.ColonistUpdateAge(self, ChoGGi.Tables.ColonistAges[Random(1, #ChoGGi.Tables.ColonistAges)])
end
function Colonist:CheatDie()
	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. "!\n" .. Strings[302535920001430--[[Kill colonist-]]] .. "?",
		function(answer)
			if answer then
				self:SetCommand("Die")
			end
		end,
		Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000855--[[Last chance before deletion!]]]
	)
end

function Unit:CheatBreadcrumbs()
	return ChoGGi.ComFuncs.ToggleBreadcrumbs(self)
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

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000977--[[Change grade of a deposit.]]],
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
	ChoGGi.ComFuncs.ToggleWorking(obj)
end
local function CheatCapDbl(obj)
	local cap_key, grid = RetGridValues(obj)
	local new = obj[cap_key] * 2
	obj[cap_key] = new
	grid.storage_capacity = new
	grid.storage_mode = "charging"
	ChoGGi.ComFuncs.ToggleWorking(obj)
end
local function CheatChargeDef(obj)
	local c_key, d_key, grid = RetGridCharValues(obj)
	local c_new = obj:GetClassValue(c_key)
	local d_new = obj:GetClassValue(d_key)
	obj[c_key] = c_new
	obj[d_key] = d_new
	grid.max_charge = c_new
	grid.max_discharge = d_new
	ChoGGi.ComFuncs.ToggleWorking(obj)
end
local function CheatCapDef(obj)
	local cap_key, grid = RetGridValues(obj)
	local new = obj:GetClassValue(cap_key)
	obj[cap_key] = new
	grid.storage_capacity = new
	grid.storage_mode = "full"
	ChoGGi.ComFuncs.ToggleWorking(obj)
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
	self.battery_max = ChoGGi.ComFuncs.GetResearchedTechValue("DroneBatteryMax")
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
local orig_Building_CheatCleanAndFix = Building.CheatCleanAndFix
function Building:CheatCleanAndFix()
	self:ResetDust()
	orig_Building_CheatCleanAndFix(self)
end

-- misc

do -- Fireflies
	function Building:CheatRemoveAllFireflies()
		if not self.fireflies then
			return
		end

		for i = #self.fireflies, 1, -1 do
			DoneObject(self.fireflies[i])
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
				DoneObject(self)
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
end -- do

function SecurityStation:CheatReneagadeCapDbl()
	self.negated_renegades = self.negated_renegades * 2
end
function SecurityStation:CheatReneagadeCapDef()
	self.negated_renegades = self.max_negated_renegades
end

function RocketBase:CheatCapDbl()
	ChoGGi.ComFuncs.SetTaskReqAmount(self, self.max_export_storage * 2, "export_requests", "max_export_storage")
end
function RocketBase:CheatCapDef()
	ChoGGi.ComFuncs.SetTaskReqAmount(self, self:GetClassValue("max_export_storage"), "export_requests", "max_export_storage")
end

function RocketBase:CheatAddFuel()
	-- skip if we're full/over full
	local actual = self.refuel_request:GetActualAmount()
	if actual == 0 then
		return
	end

	local target = self.refuel_request:GetTargetAmount()
	self.accumulated_fuel = self.accumulated_fuel + target
	self.refuel_request:SetAmount(target)
	-- make sure it always shows the correct amount
	self.refuel_request:SetAmount(0)
	Msg("RocketRefueled", self)
	-- update selection panel
	local sel = SelectedObj
	if sel and sel.handle == self.handle then
		RebuildInfopanel(self)
	end
end
function RocketBase:CheatAddDust2()
	self:SetDust(600, 0)
	ApplyToObjAndAttaches(self, SetObjDust, 600)
end
function RocketBase:CheatCleanAndFix2()
	self:SetDust(0, 0)
	ApplyToObjAndAttaches(self, SetObjDust, 0)
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

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001541--[[Start a Crime Event]]],
		hint = Strings[302535920001542--[[Renegades not required.]]],
	}
end

if LandscapeLake then
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
local orig_ResourceProducer_CheatEmpty = ResourceProducer.CheatEmpty
function ResourceProducer:CheatEmpty(...)
	-- An IsValid won't hurt
	if IsValid(self.consumption_resource_stockpile) then
		self:Consume_Internal(self.consumption_stored_resources)
	end
	return orig_ResourceProducer_CheatEmpty(self, ...)
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
