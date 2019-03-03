-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local Trans = ChoGGi.ComFuncs.Translate
	local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	local str_ECM_Capacity = "ECM.ECM.Capacity"
	c = c + 1
	Actions[c] = {ActionName = Trans(109035890389--[[Capacity--]]),
		ActionMenubar = "ECM.ECM",
		ActionId = ".Capacity",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Capacity",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000565--[[Storage Mechanized Depots Temp--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Storage Mechanized Depots Temp",
		ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.StorageMechanizedDepotsTemp,
				S[302535920000566--[[Allow the temporary storage to hold 100 instead of 50 cubes.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000567--[[Worker Capacity--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Worker Capacity",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".workers",
				S[302535920000568--[["Set worker capacity of buildings of selected type, also applies to newly placed ones."--]]]
			) or S[302535920000568]
		end,
		OnAction = ChoGGi.MenuFuncs.SetWorkerCapacity,
		ActionShortcut = "Ctrl-Shift-W",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000569--[[Building Capacity--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Building Capacity",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".capacity",
				S[302535920000570--[[Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).--]]]
			) or S[302535920000570]
		end,
		OnAction = ChoGGi.MenuFuncs.SetBuildingCapacity,
		ActionShortcut = "Ctrl-Shift-C",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000571--[[Building Visitor Capacity--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Building Visitor Capacity",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".visitors",
				S[302535920000572--[[Set visitors capacity of all buildings of selected type, also applies to newly placed ones.--]]]
			) or S[302535920000572]
		end,
		OnAction = ChoGGi.MenuFuncs.SetVisitorCapacity,
		ActionShortcut = "Ctrl-Shift-V",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000573--[[Storage Universal Depot--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Storage Universal Depot",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.StorageUniversalDepot,
				S[302535920000574--[[Change universal storage depot capacity.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
		bld_id = "StorageUniversalDepot",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000575--[[Storage Other Depot--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Storage Other Depot",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.StorageOtherDepot,
				S[302535920000576--[[Change other storage depot capacity.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
		bld_id = "StorageOtherDepot",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000577--[[Storage Waste Depot--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Storage Waste Depot",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.StorageWasteDepot,
				S[302535920000578--[[Change waste storage depot capacity.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
		bld_id = "StorageWasteDepot",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000579--[[Storage Mechanized Depots--]]],
		ActionMenubar = str_ECM_Capacity,
		ActionId = ".Storage Mechanized Depots",
		ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.StorageMechanizedDepot,
				S[302535920000580--[[Change mechanized depot storage capacity.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetStorageDepotSize,
		bld_id = "StorageMechanizedDepot",
	}

end
