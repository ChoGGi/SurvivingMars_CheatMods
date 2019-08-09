-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local iconD = "CommonAssets/UI/Menu/ShowAll.tga"

c = c + 1
Actions[c] = {ActionName = Translate(517--[[Drones]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Drones",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000505--[[Work Radius RC Rover]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Work Radius RC Rover",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCRoverMaxRadius,
			Strings[302535920000506--[[Change RC Rover drone radius (this ignores slider).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRoverWorkRadius,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000507--[[Work Radius DroneHub]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Work Radius DroneHub",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CommandCenterMaxRadius,
			Strings[302535920000508--[[Change DroneHub drone radius (this ignores slider).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneHubWorkRadius,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000509--[[Drone Rock To Concrete Speed]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Rock To Concrete Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount,
			Strings[302535920000510--[[How long it takes drones to convert rock to concrete.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000511--[[Drone Move Speed]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Move Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedDrone,
			Strings[302535920000512--[[How fast drones will move.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneMoveSpeed,
	setting_speed = "SpeedDrone",
	setting_title = Strings[302535920000511--[[Drone Move Speed]]],
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000702--[[Drone Wasp Move Speed]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Wasp Move Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedWaspDrone,
			Strings[302535920000512--[[How fast drones will move.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneMoveSpeed,
	setting_speed = "SpeedWaspDrone",
	setting_title = Strings[302535920000702--[[Drone Wasp Move Speed]]],
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000513--[[Change Amount Of Drones In Hub]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Change Amount Of Drones In Hub",
	ActionIcon = iconD,
	RolloverText = function()
		local obj = SelectedObj
		return obj and obj:IsKindOf("DroneHub") and SettingState(
			obj:GetDronesCount(),
			Strings[302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).]]]
		) or Strings[302535920000514]
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneAmountDroneHub,
	ActionShortcut = "Shift-D",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000515--[[DroneFactory Build Speed]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".DroneFactory Build Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.BuildingSettings.DroneFactory.performance_notauto",
			Strings[302535920000516--[[Change how fast drone factories build drones.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000519--[[Drone Battery Infinite]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Battery Infinite",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneMoveBatteryUse,
			Strings[302535920000519--[[Drone Battery Infinite]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000521--[[Drone Build Speed]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Build Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneConstructAmount,
			Strings[302535920000522--[[Instant build/repair when resources are ready.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Translate(4645--[[Drone Recharge Time]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Recharge Time",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneRechargeTime,
			Translate(4644--[[The time it takes for a Drone to be fully recharged]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DroneRechargeTime_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000527--[[Drone Repair Supply Leak Speed]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Repair Supply Leak Speed",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneRepairSupplyLeak,
			Translate(960116597482--[[The amount of time in seconds it takes a Drone to fix a supply leak]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Translate(6980--[[Drone resource carry amount]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone resource carry amount",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneResourceCarryAmount,
			Strings[302535920000530--[[Change amount drones can carry.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneCarryAmount,
}

c = c + 1
Actions[c] = {ActionName = Translate(4707--[[Command center max Drones]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Command center max Drones",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CommandCenterMaxDrones,
			Translate(4706--[[Maximum number of Drones a Drone Hub can control]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDronesPerDroneHub,
}

c = c + 1
Actions[c] = {ActionName = Translate(4633--[[RC Commander max Drones]]),
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".RC Commander max Drones",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCRoverMaxDrones,
			Translate(4632--[[Maximum Drones an RC Commander can control]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDronesPerRCRover,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001403--[[Drone Type]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Type",
	ActionIcon = "CommonAssets/UI/Menu/UncollectObjects.tga",
	RolloverText = function()
		return SettingState(
			GetMissionSponsor().drone_class or "Drone",
			Strings[302535920001404--[[Change what type of drones will spawn (doesn't effect existing).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneType,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000051--[[Drone Battery Cap]]],
	ActionMenubar = "ECM.ECM.Drones",
	ActionId = ".Drone Battery Cap",
	ActionIcon = iconD,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneBatteryMax,
			Strings[302535920000945--[[Change the capacity of drone batteries.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDroneBatteryCap,
}
