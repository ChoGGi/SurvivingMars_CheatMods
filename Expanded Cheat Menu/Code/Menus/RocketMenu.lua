-- See LICENSE for terms

local TranslationTable = TranslationTable
local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = Translate(5238--[[Rockets]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Rockets",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000975--[[Pod Price]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Pod Price",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.PodPrice,
			TranslationTable[302535920000976--[[Change the price per pod (applies to both supply/passenger).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetPodPrice,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000941--[[Passenger Ark Pod]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Passenger Ark Pod",
	ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.PassengerArkPod,
			TranslationTable[302535920000962--[[Allows you to use Ark Pod with any sponsor.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.PassengerArkPod_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001291--[[Max Export Amount]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Max Export Amount",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RocketMaxExportAmount,
			TranslationTable[302535920001290--[[Change how many rares per rocket you can export.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRocketMaxExportAmount,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001317--[[Launch Fuel Per Rocket]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Launch Fuel Per Rocket",
	ActionIcon = "CommonAssets/UI/Menu/DisableNormalMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.LaunchFuelPerRocket,
			TranslationTable[302535920001318--[[Change how much fuel rockets need to launch.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetLaunchFuelPerRocket,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001319--[[Rockets Ignore Fuel]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Launch Fuel Per Rocket",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RocketsIgnoreFuel,
			TranslationTable[302535920001320--[[Rockets don't need fuel to launch.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RocketsIgnoreFuel_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000850--[[Change Resupply Settings]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Change Resupply Settings",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	RolloverText = TranslationTable[302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."]]],
	OnAction = ChoGGi.MenuFuncs.ChangeResupplySettings,
}

--~ 	c = c + 1
--~ 	Actions[c] = {ActionName = TranslationTable[302535920000557--[[Launch Empty Rocket]]],
--~ 		ActionMenubar = "ECM.ECM.Rockets",
--~ 		ActionId = ".Launch Empty Rocket",
--~ 		ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
--~ 		RolloverText = TranslationTable[302535920000558--[[Launches an empty rocket to Mars.]]],
--~ 		OnAction = ChoGGi.MenuFuncs.LaunchEmptyRocket,
--~ 	}

c = c + 1
Actions[c] = {ActionName = Translate(4598--[[Payload Capacity]]),
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Payload Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CargoCapacity,
			Translate(4597--[[Maximum payload (in kg) of a resupply Rocket]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRocketCargoCapacity,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000561--[[Travel Time]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Travel Time",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.TravelTimeEarthMars,
			Translate(4591--[[Time it takes for a Rocket to travel from Mars to Earth]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRocketTravelTime,
}

c = c + 1
Actions[c] = {ActionName = Translate(4594--[[Colonists Per Rocket]]),
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Colonists Per Rocket",
	ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.MaxColonistsPerRocket,
			Translate(4593--[[Maximum number of Colonists that can arrive on Mars in a single Rocket]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetColonistsPerRocket,
}
