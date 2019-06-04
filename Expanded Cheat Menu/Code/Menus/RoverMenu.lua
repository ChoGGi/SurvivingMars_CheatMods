-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local iconRC = "CommonAssets/UI/Menu/HostGame.tga"

c = c + 1
Actions[c] = {ActionName = Translate(5438--[[Rovers]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Rovers",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000541--[[RC Set Charging Distance]]],
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Set Charging Distance",
	ActionIcon = iconRC,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCChargeDist,
			Strings[302535920000542--[[Distance from power lines that rovers can charge.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRoverChargeRadius,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000543--[[RC Move Speed]]],
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Move Speed",
	ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedRC,
			Strings[302535920000544--[[How fast RCs will move.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRCMoveSpeed,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000545--[[RC Gravity]]],
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Gravity",
	ActionIcon = iconRC,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.GravityRC,
			Strings[302535920000546--[[Change gravity of RCs.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetGravityRC,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000549--[[RC Instant Resource Transfer]]],
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Transport Instant Transfer",
	ActionIcon = "CommonAssets/UI/Menu/Mirror.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCRoverTransferResourceWorkTime,
			Strings[302535920000550--[[Make it instantly gather/transfer resources.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000551--[[RC Storage Capacity]]],
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Storage Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCTransportStorageCapacity,
			Strings[302535920000552--[[Change amount of resources RC Transports/Constructors can carry.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetRCTransportStorageCapacity,
}
