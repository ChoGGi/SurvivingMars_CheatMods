-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(1000207--[[Misc--]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Misc",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000682--[[Change Entity--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Change Entity",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = Strings[302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.--]]],
	OnAction = ChoGGi.MenuFuncs.ChangeEntity,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000684--[[Change Entity Scale--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Change Entity Scale",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		local obj = ChoGGi.ComFuncs.SelObject()
		return obj and ChoGGi.ComFuncs.SettingState(
			obj:GetScale(),
			Strings[302535920000685--[[You want them big, you want them small; have at it.--]]]
		) or Strings[302535920000685]
	end,
	OnAction = ChoGGi.MenuFuncs.SetEntityScale,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000686--[[Auto Unpin Objects--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Auto Unpin Objects",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = function()
--~ 			return ChoGGi.ComFuncs.SettingState(
--~ 				ChoGGi.UserSettings.UnpinObjects,
--~ 				Strings[302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]]]
--~ 			)
		-- it can get large, so for this one we stick the description first.
		return Strings[302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]]]
			.. "\n<color 100 255 100>" .. ValueToLuaCode(ChoGGi.UserSettings.UnpinObjects) .. "</color>"
	end,
	OnAction = ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000688--[[Clean All Objects--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Clean All Objects",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = Strings[302535920000689--[[Removes all dust from all objects.--]]],
	OnAction = ChoGGi.MenuFuncs.CleanAllObjects,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000690--[[Fix All Objects--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Fix All Objects",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = Strings[302535920000691--[[Fixes all malfunctioned objects.--]]],
	OnAction = ChoGGi.MenuFuncs.FixAllObjects,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000700--[[Scanner Queue Larger--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Scanner Queue Larger",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ExplorationQueueMaxSize,
			Strings[302535920000701--[[Queue up to 100 squares.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000702--[[Game Speed--]]],
	ActionMenubar = "ECM.ECM.Misc",
	ActionId = ".Game Speed",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToTemplates.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.mediumGameSpeed,
			Strings[302535920000703--[[Change the game speed (only for medium/fast, normal is normal).--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetGameSpeed,
	ActionSortKey = "90",
}
