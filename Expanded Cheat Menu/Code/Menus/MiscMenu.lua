-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local c = #Actions

	local str_ExpandedCM_Misc = "ECM.Expanded CM.Misc"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[1000207--[[Misc--]]]),
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Misc",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "90Misc",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000682--[[Change Entity--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Change Entity",
		ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
		RolloverText = S[302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.--]]],
		OnAction = ChoGGi.MenuFuncs.SetEntity,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000684--[[Change Entity Scale--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Change Entity Scale",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			if IsValid(sel) then
				return ChoGGi.ComFuncs.SettingState(
					sel:GetScale(),
					302535920000685--[[You want them big, you want them small; have at it.--]]
				)
			else
				return S[302535920000685--[[You want them big, you want them small; have at it.--]]]
			end
		end,
		OnAction = ChoGGi.MenuFuncs.SetEntityScale,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000686--[[Auto Unpin Objects--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Auto Unpin Objects",
		ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.UnpinObjects,
				302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000688--[[Clean All Objects--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Clean All Objects",
		ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
		RolloverText = S[302535920000689--[[Removes all dust from all objects.--]]],
		OnAction = ChoGGi.MenuFuncs.CleanAllObjects,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000690--[[Fix All Objects--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Fix All Objects",
		ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
		RolloverText = S[302535920000691--[[Fixes all malfunctioned objects.--]]],
		OnAction = ChoGGi.MenuFuncs.FixAllObjects,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001014--[[Hide Cheats Menu--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Hide Cheats Menu",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = S[302535920001019--[[This will hide the Cheats menu; Use F2 to see it again.--]]],
		OnAction = ChoGGi.ComFuncs.CheatsMenu_Toggle,
		ActionShortcut = "F2",
		ActionBindable = true,
		ActionSortKey = "-1Hide Cheats Menu",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000696--[[Infopanel Cheats--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Infopanel Cheats",
		ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ToggleInfopanelCheats,
				302535920000697--[[Shows the cheat pane in the info panel (selection panel).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
		ActionShortcut = "Ctrl-F2",
		ActionBindable = true,
		ActionSortKey = "-1Infopanel Cheats",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000698--[[Infopanel Cheats Cleanup--]]],
		ActionMenubar = str_ExpandedCM_Misc,
		ActionId = ".Infopanel Cheats Cleanup",
		ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CleanupCheatsInfoPane,
				302535920000699--[[Remove some entries from the cheat pane (restart to re-enable).

	AddMaintenancePnts, MakeSphereTarget, SpawnWorker, SpawnVisitor--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
		ActionSortKey = "-1Infopanel Cheats Cleanup",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000700--[[Scanner Queue Larger--]]],
		ActionMenubar = str_ExpandedCM_Misc,
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
	Actions[c] = {ActionName = S[302535920000702--[[Game Speed--]]],
		ActionMenubar = str_ExpandedCM_Misc,
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

end
