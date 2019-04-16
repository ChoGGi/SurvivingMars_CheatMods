-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = Translate(5238--[[Rockets--]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Rockets",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001291--[[Max Export Amount--]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Max Export Amount",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.RocketMaxExportAmount,
			Strings[302535920001290--[[Change how many rares per rocket you can export.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RocketMaxExportAmount,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001317--[[Launch Fuel Per Rocket--]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Launch Fuel Per Rocket",
	ActionIcon = "CommonAssets/UI/Menu/DisableNormalMaps.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.LaunchFuelPerRocket,
			Strings[302535920001318--[[Change how much fuel rockets need to launch.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.LaunchFuelPerRocket,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001319--[[Rockets Ignore Fuel--]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Launch Fuel Per Rocket",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.RocketsIgnoreFuel,
			Strings[302535920001320--[[Rockets don't need fuel to launch.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RocketsIgnoreFuel_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000850--[[Change Resupply Settings--]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Change Resupply Settings",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	RolloverText = Strings[302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]]],
	OnAction = ChoGGi.MenuFuncs.ChangeResupplySettings,
}

--~ 	c = c + 1
--~ 	Actions[c] = {ActionName = Strings[302535920000557--[[Launch Empty Rocket--]]],
--~ 		ActionMenubar = "ECM.ECM.Rockets",
--~ 		ActionId = ".Launch Empty Rocket",
--~ 		ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
--~ 		RolloverText = Strings[302535920000558--[[Launches an empty rocket to Mars.--]]],
--~ 		OnAction = ChoGGi.MenuFuncs.LaunchEmptyRocket,
--~ 	}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000559--[[Cargo Capacity--]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Cargo Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.CargoCapacity,
			Strings[302535920000560--[[Change amount of storage space in rockets.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRocketCargoCapacity,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000561--[[Travel Time--]]],
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Travel Time",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.TravelTimeEarthMars,
			Strings[302535920000562--[[Change how long to take to travel between planets.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRocketTravelTime,
}

c = c + 1
Actions[c] = {ActionName = Translate(4594--[[Colonists Per Rocket--]]),
	ActionMenubar = "ECM.ECM.Rockets",
	ActionId = ".Colonists Per Rocket",
	ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			Consts.MaxColonistsPerRocket,
			Strings[302535920000564--[[Change how many colonists can arrive on Mars in a single Rocket.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetColonistsPerRocket,
}
