-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local SettingState = ChoGGi_Funcs.Common.SettingState

local Actions = ChoGGi.Temp.Actions
local c = #Actions
local iconD = "CommonAssets/UI/Menu/ShowAll.tga"

c = c + 1
Actions[c] = {ActionName = T(517--[[Drones]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Drones",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000505--[[Work Radius RC Rover]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Work Radius RC Rover",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCRoverMaxRadius,
			T(302535920000506--[[Change RC Rover drone radius (this ignores slider).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetRoverWorkRadius,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000507--[[Work Radius DroneHub]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Work Radius DroneHub",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CommandCenterMaxRadius,
			T(302535920000508--[[Change DroneHub drone radius (this ignores slider).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneHubWorkRadius,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000509--[[Drone Rock To Concrete Speed]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Rock To Concrete Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount,
			T(302535920000510--[[How long it takes drones to convert rock to concrete.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneRockToConcreteSpeed,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000511--[[Drone Move Speed]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Move Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedDrone,
			T(302535920000512--[[How fast drones will move.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneMoveSpeed,
	setting_speed = "SpeedDrone",
	setting_title = T(302535920000511--[[Drone Move Speed]]),
}

c = c + 1
Actions[c] = {ActionName = T(302535920000702--[[Drone Wasp Move Speed]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Wasp Move Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedWaspDrone,
			T(302535920000512--[[How fast drones will move.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneMoveSpeed,
	setting_speed = "SpeedWaspDrone",
	setting_title = T(302535920000702--[[Drone Wasp Move Speed]]),
}

c = c + 1
Actions[c] = {ActionName = T(302535920000513--[[Change Amount Of Drones In Hub]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Change Amount Of Drones In Hub",
	ActionIcon = iconD,
	RolloverText = function()
		local obj = SelectedObj
		return obj and obj:IsKindOf("DroneHub") and SettingState(
			obj:GetDronesCount(),
			T(302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).]])
		) or T(302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).]])
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneAmountDroneHub,
	ActionShortcut = "Shift-D",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000515--[[DroneFactory Build Speed]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".DroneFactory Build Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.BuildingSettings.DroneFactory.performance_notauto",
			T(302535920000516--[[Change how fast drone factories build drones.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneFactoryBuildSpeed,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000519--[[Drone Battery Infinite]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Battery Infinite",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneMoveBatteryUse,
			T(302535920000519--[[Drone Battery Infinite]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DroneBatteryInfinite_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000521--[[Drone Build Speed]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Build Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneConstructAmount,
			T(302535920000522--[[Instant build/repair when resources are ready.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DroneBuildSpeed_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4645--[[Drone Recharge Time]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Recharge Time",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneRechargeTime,
			T(4644--[[The time it takes for a Drone to be fully recharged]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DroneRechargeTime_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000527--[[Drone Repair Supply Leak Speed]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Repair Supply Leak Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneRepairSupplyLeak,
			T(960116597482--[[The amount of time in seconds it takes a Drone to fix a supply leak]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DroneRepairSupplyLeak_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(6980--[[Drone resource carry amount]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone resource carry amount",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneResourceCarryAmount,
			T(302535920000530--[[Change amount drones can carry.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneCarryAmount,
}

c = c + 1
Actions[c] = {ActionName = T(4707--[[Command center max Drones]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Command center max Drones",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CommandCenterMaxDrones,
			T(4706--[[Maximum number of Drones a Drone Hub can control]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDronesPerDroneHub,
}

c = c + 1
Actions[c] = {ActionName = T(4633--[[RC Commander max Drones]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".RC Commander max Drones",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCRoverMaxDrones,
			T(4632--[[Maximum Drones an RC Commander can control]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDronesPerRCRover,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001403--[[Drone Type]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Type",
	ActionIcon = "CommonAssets/UI/Menu/UncollectObjects.tga",
	RolloverText = function()
		return SettingState(
			GetMissionSponsor().drone_class or "Drone",
			T(302535920001404--[[Change what type of drones will spawn (doesn't effect existing).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneType,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000051--[[Drone Battery Cap]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Battery Cap",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneBatteryMax,
			T(302535920000945--[[Change the capacity of drone batteries.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDroneBatteryCap,
}
