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

c = c + 1
Actions[c] = {ActionName = T(302535920000031--[[Find Nearest Resource]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Find Nearest Resource",
	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
	RolloverText = T(302535920000554--[[Select an object and click this to display a list of resources (Shows nearest resource to object).]]),
	OnAction = ChoGGi_Funcs.Common.FindNearestResource,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000333--[[Building Info]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Building Info",
	ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
	RolloverText = T(302535920000345--[[Shows info about building in text above it.]]),
	OnAction = ChoGGi_Funcs.Menus.BuildingInfo_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001307--[[Grid Info]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Grid Info",
	ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
	RolloverText = T(302535920001477--[["List objects in grids (air, electricity, and water)."]]),
	OnAction = ChoGGi_Funcs.Menus.BuildGridList,
}

--~ c = c + 1
--~ Actions[c] = {ActionName = T(302535920000555--[[Monitor Info]]),
--~ 	ActionMenubar = "ECM.ECM",
--~ 	ActionId = ".Monitor Info",
--~ 	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
--~ 	RolloverText = T(302535920000556--[[Shows a list of updated information about your city.]]),
--~ 	OnAction = ChoGGi_Funcs.Menus.MonitorInfo,
--~ }

c = c + 1
Actions[c] = {ActionName = T(302535920000688--[[Clean All Objects]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Clean All Objects",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = T(302535920000689--[[Removes all dust from all objects.]]),
	OnAction = ChoGGi_Funcs.Menus.CleanAllObjects,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000690--[[Fix All Objects]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Fix All Objects",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = T(302535920000691--[[Fixes all malfunctioned objects.]]),
	OnAction = ChoGGi_Funcs.Menus.FixAllObjects,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000700--[[Scanner Queue Larger]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Scanner Queue Larger",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ExplorationQueueMaxSize,
			T(302535920000701--[[Queue up to 100 squares.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ScannerQueueLarger_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000469--[[Close Dialogs]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Close Dialogs",
	ActionIcon = "CommonAssets/UI/Menu/remove_water.tga",
	RolloverText = T(302535920000470--[[Close any dialogs opened by ECM (Examine, Object Editor, Change Colours, etc...)]]),
	OnAction = ChoGGi_Funcs.Common.CloseDialogsECM,
	ActionSortKey = "99",
}
