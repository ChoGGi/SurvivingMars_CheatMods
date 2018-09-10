-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	local str_ExpandedCM_Resources = "Expanded CM.Resources"
	c = c + 1
	Actions[c] = {
		ActionMenubar = "Expanded CM",
		ActionName = string.format("%s ..",S[692--[[Resources--]]]),
		ActionId = ".Resources",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Resources",
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_ExpandedCM_Resources,
		ActionName = S[302535920000719--[[Add Orbital Probes--]]],
		ActionId = ".Add Orbital Probes",
		ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
		RolloverText = S[302535920000720--[[Add more probes.--]]],
		OnAction = ChoGGi.MenuFuncs.AddOrbitalProbes,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_ExpandedCM_Resources,
		ActionName = S[4616--[[Food Per Rocket Passenger--]]],
		ActionId = ".Food Per Rocket Passenger",
		ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.FoodPerRocketPassenger,
				302535920000722--[[Change the amount of Food supplied with each Colonist arrival.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_ExpandedCM_Resources,
		ActionName = S[1110--[[Prefab Buildings--]]],
		ActionId = ".Prefab Buildings",
		ActionIcon = "CommonAssets/UI/Menu/gear.tga",
		RolloverText = S[1111--[[Prefabricated parts needed for the construction of certain buildings on Mars.--]]],
		OnAction = ChoGGi.MenuFuncs.AddPrefabs,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_ExpandedCM_Resources,
		ActionName = S[3613--[[Funding--]]],
		ActionId = ".Funding",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = S[302535920000726--[[Add more funding (or reset back to 500 M).--]]],
		OnAction = ChoGGi.MenuFuncs.SetFunding,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.SetFunding,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_ExpandedCM_Resources,
		ActionName = S[302535920000727--[[Fill Selected Resource--]]],
		ActionId = ".Fill Selected Resource",
		ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
		RolloverText = S[302535920000728--[[Fill the selected/moused over object's resource(s)--]]],
		OnAction = ChoGGi.MenuFuncs.FillResource,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.FillResource,
		ActionBindable = true,
	}

end
