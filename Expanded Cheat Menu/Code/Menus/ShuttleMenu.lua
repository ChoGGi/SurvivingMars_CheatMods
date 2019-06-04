-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = Translate(745--[[Shuttles]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Shuttles",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000535--[[Set ShuttleHub Shuttle Capacity]]],
	ActionMenubar = "ECM.ECM.Shuttles",
	ActionId = ".Set ShuttleHub Shuttle Capacity",
	ActionIcon = "CommonAssets/UI/Menu/ShowAll.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles",
			Strings[302535920000536--[[Change amount of shuttles per shuttlehub.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000930--[[Set Cargo Shuttle Capacity]]],
	ActionMenubar = "ECM.ECM.Shuttles",
	ActionId = ".Set Cargo Shuttle Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.StorageShuttle,
			Strings[302535920000538--[[Change capacity of shuttles.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetShuttleCapacity,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000932--[[Set Cargo Shuttle Speed]]],
	ActionMenubar = "ECM.ECM.Shuttles",
	ActionId = ".Set Cargo Shuttle Speed",
	ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedShuttle,
			Strings[302535920000540--[[Change speed of shuttles.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetShuttleSpeed,
}
