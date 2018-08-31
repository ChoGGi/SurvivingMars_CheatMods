-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

local str_ExpandedCM_Capacity = "Expanded CM.Capacity"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM",
	ActionName = Concat(S[109035890389--[[Capacity--]]]," .."),
	ActionId = ".Capacity",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Capacity",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000565--[[Storage Mechanized Depots Temp--]]],
	ActionId = ".Storage Mechanized Depots Temp",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageMechanizedDepotsTemp,
			302535920000566--[[Allow the temporary storage to hold 100 instead of 50 cubes.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000567--[[Worker Capacity--]]],
	ActionId = ".Worker Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = S[302535920000568--[["Set worker capacity of buildings of selected type, also applies to newly placed ones."--]]],
	OnAction = ChoGGi.MenuFuncs.SetWorkerCapacity,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetWorkerCapacity,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000569--[[Building Capacity--]]],
	ActionId = ".Building Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = S[302535920000570--[[Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).--]]],
	OnAction = ChoGGi.MenuFuncs.SetBuildingCapacity,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetBuildingCapacity,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000571--[[Building Visitor Capacity--]]],
	ActionId = ".Building Visitor Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = S[302535920000572--[[Set visitors capacity of all buildings of selected type, also applies to newly placed ones.--]]],
	OnAction = ChoGGi.MenuFuncs.SetVisitorCapacity,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetVisitorCapacity,
	ActionSortKey = "",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000573--[[Storage Universal Depot--]]],
	ActionId = ".Storage Universal Depot",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageUniversalDepot,
			302535920000574--[[Change universal storage depot capacity.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000575--[[Storage Other Depot--]]],
	ActionId = ".Storage Other Depot",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageOtherDepot,
			302535920000576--[[Change other storage depot capacity.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetStorageDepotSize("StorageOtherDepot")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000577--[[Storage Waste Depot--]]],
	ActionId = ".Storage Waste Depot",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageWasteDepot,
			302535920000578--[[Change waste storage depot capacity.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetStorageDepotSize("StorageWasteDepot")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Capacity,
	ActionName = S[302535920000579--[[Storage Mechanized Depots--]]],
	ActionId = ".Storage Mechanized Depots",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageMechanizedDepot,
			302535920000580--[[Change mechanized depot storage capacity.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
	end,
}
