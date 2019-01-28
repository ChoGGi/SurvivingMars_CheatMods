-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local c = #Actions

	local str_ExpandedCM_Resources = "ECM.Expanded CM.Resources"
	c = c + 1
	Actions[c] = {ActionName = S[692--[[Resources--]]],
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Resources",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Resources",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000719--[[Add Orbital Probes--]]],
		ActionMenubar = str_ExpandedCM_Resources,
		ActionId = ".Add Orbital Probes",
		ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
		RolloverText = function()
			if GameState.gameplay then
				return ChoGGi.ComFuncs.SettingState(
					#(UICity.labels.OrbitalProbe or "") + #(UICity.labels.AdvancedOrbitalProbe or ""),
					302535920000720--[[Add more probes.--]]
				)
			end
		end,
		OnAction = ChoGGi.MenuFuncs.AddOrbitalProbes,
	}

	c = c + 1
	Actions[c] = {ActionName = S[4616--[[Food Per Rocket Passenger--]]],
		ActionMenubar = str_ExpandedCM_Resources,
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
	Actions[c] = {ActionName = S[1110--[[Prefab Buildings--]]],
		ActionMenubar = str_ExpandedCM_Resources,
		ActionId = ".Prefab Buildings",
		ActionIcon = "CommonAssets/UI/Menu/gear.tga",
		RolloverText = StringFormat("%s\n%s",S[1111--[[Prefabricated parts needed for the construction of certain buildings on Mars.--]]],S[302535920000897--[[Drone prefabs--]]]),
		OnAction = ChoGGi.MenuFuncs.AddPrefabs,
	}

	c = c + 1
	Actions[c] = {ActionName = S[3613--[[Funding--]]],
		ActionMenubar = str_ExpandedCM_Resources,
		ActionId = ".Funding",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = function()
			if GameState.gameplay then
				return ChoGGi.ComFuncs.SettingState(
					UICity.funding,
					302535920000726--[[Add more funding (or reset back to 500 M).--]]
				)
			end
		end,
		OnAction = ChoGGi.MenuFuncs.SetFunding,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000727--[[Fill Selected Resource--]]],
		ActionMenubar = str_ExpandedCM_Resources,
		ActionId = ".Fill Selected Resource",
		ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
		RolloverText = S[302535920000728--[[Fill the selected/moused over object's resource(s)--]]],
		OnAction = ChoGGi.MenuFuncs.FillResource,
		ActionShortcut = "Ctrl-F",
		ActionBindable = true,
	}

end
