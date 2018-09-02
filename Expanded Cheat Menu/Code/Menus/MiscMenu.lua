-- See LICENSE for terms

local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

local str_ExpandedCM_Misc = "Expanded CM.Misc"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM",
	ActionName = string.format("%s ..",S[1000207--[[Misc--]]]),
	ActionId = ".Misc",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "90Misc",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000682--[[Change Entity--]]],
	ActionId = ".Change Entity",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = S[302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.--]]],
	OnAction = ChoGGi.MenuFuncs.SetEntity,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000684--[[Change Entity Scale--]]],
	ActionId = ".Change Entity Scale",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = S[302535920000685--[[You want them big, you want them small; have at it.--]]],
	OnAction = ChoGGi.MenuFuncs.SetEntityScale,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000686--[[Auto Unpin Objects--]]],
	ActionId = ".Auto Unpin Objects",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = S[302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]]],
	OnAction = ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000688--[[Clean All Objects--]]],
	ActionId = ".Clean All Objects",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = S[302535920000689--[[Removes all dust from all objects.--]]],
	OnAction = ChoGGi.MenuFuncs.CleanAllObjects,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000690--[[Fix All Objects--]]],
	ActionId = ".Fix All Objects",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = S[302535920000691--[[Fixes all broken objects.--]]],
	OnAction = ChoGGi.MenuFuncs.FixAllObjects,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000696--[[Infopanel Cheats--]]],
	ActionId = ".Infopanel Cheats",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ToggleInfopanelCheats,
			302535920000697--[[Shows the cheat pane in the info panel (selection panel).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.InfopanelCheats_Toggle,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000698--[[Infopanel Cheats Cleanup--]]],
	ActionId = ".302535920000698--[[Infopanel Cheats Cleanup",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.CleanupCheatsInfoPane,
			302535920000699--[[Remove some entries from the cheat pane (restart to re-enable).

AddMaintenancePnts, MakeSphereTarget, SpawnWorker, SpawnVisitor--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000700--[[Scanner Queue Larger--]]],
	ActionId = ".Scanner Queue Larger",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ExplorationQueueMaxSize,
			302535920000701--[[Queue up to 100 squares.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Misc,
	ActionName = S[302535920000702--[[Game Speed--]]],
	ActionId = ".Game Speed",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToTemplates.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.mediumGameSpeed,
			302535920000703--[[Change the game speed (only for medium/fast, normal is normal).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetGameSpeed,
	ActionSortKey = "90",
}
