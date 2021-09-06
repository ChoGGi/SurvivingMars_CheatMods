-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(12476--[[Terraforming]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Terraforming",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000529--[[Plant Random Vegetation]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Plant Random Vegetation",
	ActionIcon = "CommonAssets/UI/Menu/place_objects.tga",
	RolloverText = Strings[302535920000531--[[Plants a bunch of Tree/Bush/Grass.]]],
	OnAction = ChoGGi.MenuFuncs.PlantRandomVegetation,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000534--[[Plant Random Lichen]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Plant Random Lichen",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = Strings[302535920000537--[[Plants a bunch of Lichen/Grass.]]],
	OnAction = ChoGGi.MenuFuncs.PlantRandomLichen,
}

c = c + 1
Actions[c] = {ActionName = Translate(3949--[[Parameter]]) .. " " .. Translate(12480--[[Atmosphere]]),
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Parameter Atmosphere",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = Strings[302535920000839--[[Set %s Params]]]:format(Translate(12480--[[Atmosphere]])),
	OnAction = ChoGGi.MenuFuncs.SetTerraformingParams,
	setting_id = "Atmosphere",
}

c = c + 1
Actions[c] = {ActionName = Translate(3949--[[Parameter]]) .. " " .. Translate(4141--[[Temperature]]),
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Parameter Temperature",
	ActionIcon = "CommonAssets/UI/Menu/ShowOcclusion.tga",
	RolloverText = Strings[302535920000839--[[Set %s Params]]]:format(Translate(4141--[[Temperature]])),
	OnAction = ChoGGi.MenuFuncs.SetTerraformingParams,
	setting_id = "Temperature",
}

c = c + 1
Actions[c] = {ActionName = Translate(3949--[[Parameter]]) .. " " .. Translate(449433367242--[[Vegetation]]),
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Parameter Vegetation",
	ActionIcon = "CommonAssets/UI/Menu/place_single_object.tga",
	RolloverText = Strings[302535920000839--[[Set %s Params]]]:format(Translate(449433367242--[[Vegetation]])),
	OnAction = ChoGGi.MenuFuncs.SetTerraformingParams,
	setting_id = "Vegetation",
}

c = c + 1
Actions[c] = {ActionName = Translate(3949--[[Parameter]]) .. " " .. Translate(681--[[Water]]),
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Parameter Water",
	ActionIcon = "CommonAssets/UI/Menu/FixUndrwaterEges.tga",
	RolloverText = Strings[302535920000839--[[Set %s Params]]]:format(Translate(681--[[Water]])),
	OnAction = ChoGGi.MenuFuncs.SetTerraformingParams,
	setting_id = "Water",
}

c = c + 1
Actions[c] = {ActionName = Translate(3949--[[Parameter]]) .. " " .. Strings[302535920000532--[[All Max]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Parameter All Max",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	RolloverText = Strings[302535920000539--[[Set all params to %s.]]]:format(100),
	OnAction = ChoGGi.MenuFuncs.SetAllTerraformingParams,
	setting_value = 100,
}

c = c + 1
Actions[c] = {ActionName = Translate(3949--[[Parameter]]) .. " " .. Strings[302535920000533--[[All Min]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Parameter All Min",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	RolloverText = Strings[302535920000539--[[Set all params to %s.]]]:format(0),
	OnAction = ChoGGi.MenuFuncs.SetAllTerraformingParams,
	setting_value = 0,
}

c = c + 1
Actions[c] = {ActionName = Translate(776100024488--[[Soil Quality]]),
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Soil Quality",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = Strings[302535920000564--[[Set Soil Quality]]],
	OnAction = ChoGGi.MenuFuncs.SetSoilQuality,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000560--[[Remove LandScaping Limits]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Remove LandScaping Limits",
	ActionIcon = "CommonAssets/UI/Menu/vertex_push.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.RemoveLandScapingLimits,
			Strings[302535920000709--[["Allows you to start building on uneven ground, and removes the size limits."]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RemoveLandScapingLimits_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000559--[[Open Air Domes Toggle]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Open Air Domes Toggle",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			GetOpenAirBuildings(ActiveMapID),
			Strings[302535920000722--[[Open the domes to the fresh air (or lack of).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.OpenAirDomes_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Translate(12026--[[Toxic Pools]]) .. " " .. Strings[302535920000834--[[Max]]],
	ActionMenubar = "ECM.ECM.Terraforming",
	ActionId = ".Toxic Pools Max",
	ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			const.MaxToxicRainPools,
			Strings[302535920000870--[[Max amount of pools that can form.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetToxicPoolsMax,
}
