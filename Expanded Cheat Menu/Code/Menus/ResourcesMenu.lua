-- See LICENSE for terms

local TranslationTable = TranslationTable
local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local LocaleInt = LocaleInt

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(692--[[Resources]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Resources",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Translate(4604--[[Rare Metals Price (M)]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Rare Metals Price (M)",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = function()
		if UICity then
			return SettingState(
				ChoGGi.UserSettings.ExportPricePreciousMetals,
				Translate(4603--[[Amount of Funding (in millions) received by exporting one unit of Rare Metals]])
			)
		end
		return Translate(4603)
	end,
	OnAction = ChoGGi.MenuFuncs.SetFundingPerRareMetalExport,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000719--[[Add Orbital Probes]]],
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Add Orbital Probes",
	ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
	RolloverText = function()
		if UICity then
			return SettingState(
				#(UICity.labels.OrbitalProbe or "") + #(UICity.labels.AdvancedOrbitalProbe or ""),
				TranslationTable[302535920000720--[[Add more probes.]]]
			)
		end
		return TranslationTable[302535920000720]
	end,
	OnAction = ChoGGi.MenuFuncs.AddOrbitalProbes,
}

c = c + 1
Actions[c] = {ActionName = Translate(4616--[[Food Per Rocket Passenger]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Food Per Rocket Passenger",
	ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.FoodPerRocketPassenger,
			Translate(4615--[[The amount of Food (unscaled) supplied with each Colonist arrival]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
}

c = c + 1
Actions[c] = {ActionName = Translate(1110--[[Prefab Buildings]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Prefab Buildings",
	ActionIcon = "CommonAssets/UI/Menu/gear.tga",
	RolloverText = Translate(1111--[[Prefabricated parts needed for the construction of certain buildings on Mars.]])
		.. "\n\n" .. TranslationTable[302535920000897--[[Drone prefabs]]],
	OnAction = ChoGGi.MenuFuncs.AddPrefabBuildings,
}

c = c + 1
Actions[c] = {ActionName = Translate(3613--[[Funding]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Funding",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		if UICity then
			return SettingState(
				LocaleInt(UIColony.funds.funding),
				TranslationTable[302535920000726--[[Add more funding (or reset back to 500 M).]]]
			)
		end
		return TranslationTable[302535920000726]
	end,
	OnAction = ChoGGi.MenuFuncs.SetFunding,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000727--[[Fill Selected Resource]]],
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Fill Selected Resource",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = TranslationTable[302535920000728--[[Fill the selected/moused over object's resource(s)]]],
	OnAction = ChoGGi.MenuFuncs.FillResource,
	ActionShortcut = "Ctrl-F",
	ActionBindable = true,
}
