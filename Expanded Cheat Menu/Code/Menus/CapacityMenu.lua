-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(109035890389--[[Capacity--]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Capacity",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000565--[[Storage Mechanized Depots Temp--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Storage Mechanized Depots Temp",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageMechanizedDepotsTemp,
			Strings[302535920000566--[[Allow the temporary storage to hold 100 instead of 50 cubes.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000567--[[Worker Capacity--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Worker Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		local obj = ChoGGi.ComFuncs.SelObject()
		return obj and ChoGGi.ComFuncs.SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".workers",
			Strings[302535920000568--[["Set worker capacity of buildings of selected type, also applies to newly placed ones."--]]]
		) or Strings[302535920000568]
	end,
	OnAction = ChoGGi.MenuFuncs.SetWorkerCapacity,
	ActionShortcut = "Ctrl-Shift-W",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000569--[[Building Capacity--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Building Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		local obj = ChoGGi.ComFuncs.SelObject()
		return obj and ChoGGi.ComFuncs.SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".capacity",
			Strings[302535920000570--[[Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).--]]]
		) or Strings[302535920000570]
	end,
	OnAction = ChoGGi.MenuFuncs.SetBuildingCapacity,
	ActionShortcut = "Ctrl-Shift-C",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000571--[[Building Visitor Capacity--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Building Visitor Capacity",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		local obj = ChoGGi.ComFuncs.SelObject()
		return obj and ChoGGi.ComFuncs.SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".visitors",
			Strings[302535920000572--[[Set visitors capacity of all buildings of selected type, also applies to newly placed ones.--]]]
		) or Strings[302535920000572]
	end,
	OnAction = ChoGGi.MenuFuncs.SetVisitorCapacity,
	ActionShortcut = "Ctrl-Shift-V",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000573--[[Storage Universal Depot--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Storage Universal Depot",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageUniversalDepot,
			Strings[302535920000574--[[Change universal storage depot capacity.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
	bld_type = "StorageUniversalDepot",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000575--[[Storage Other Depot--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Storage Other Depot",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageOtherDepot,
			Strings[302535920000576--[[Change other storage depot capacity.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
	bld_type = "StorageOtherDepot",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000577--[[Storage Waste Depot--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Storage Waste Depot",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageWasteDepot,
			Strings[302535920000578--[[Change waste storage depot capacity.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
	bld_type = "StorageWasteDepot",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000579--[[Storage Mechanized Depots--]]],
	ActionMenubar = "ECM.ECM.Capacity",
	ActionId = ".Storage Mechanized Depots",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.StorageMechanizedDepot,
			Strings[302535920000580--[[Change mechanized depot storage capacity.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
	bld_type = "StorageMechanizedDepot",
}
