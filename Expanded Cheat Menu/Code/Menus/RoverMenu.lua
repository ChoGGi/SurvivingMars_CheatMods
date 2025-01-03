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
local iconRC = "CommonAssets/UI/Menu/HostGame.tga"

c = c + 1
Actions[c] = {ActionName = T(5438--[[Rovers]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Rovers",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000541--[[RC Set Charging Distance]]),
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Set Charging Distance",
	ActionIcon = iconRC,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCChargeDist,
			T(302535920000542--[[Distance from power lines that rovers can charge.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetRoverChargeRadius,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000543--[[RC Move Speed]]),
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Move Speed",
	ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedRC,
			T(302535920000544--[[How fast RCs will move.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetRCMoveSpeed,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000549--[[RC Instant Resource Transfer]]),
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Transport Instant Transfer",
	ActionIcon = "CommonAssets/UI/Menu/Mirror.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCRoverTransferResourceWorkTime,
			T(302535920000550--[[Make it instantly gather/transfer resources.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.RCTransportInstantTransfer_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000551--[[RC Storage Capacity]]),
	ActionMenubar = "ECM.ECM.Rovers",
	ActionId = ".RC Storage Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RCTransportStorageCapacity,
			T(302535920000552--[[Change amount of resources RC Transports/Constructors can carry.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetRCTransportStorageCapacity,
}
