-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local SettingState = ChoGGi_Funcs.Common.SettingState
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local LocaleInt = LocaleInt

-- menu
c = c + 1
Actions[c] = {ActionName = T(692--[[Resources]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Resources",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(4604--[[Rare Metals Price (M)]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Rare Metals Price (M)",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = function()
		if MainCity then
			return SettingState(
				ChoGGi.UserSettings.ExportPricePreciousMetals,
				T(4603--[[Amount of Funding (in millions) received by exporting one unit of Rare Metals]])
			)
		end
		return T(4603--[[Amount of Funding (in millions) received by exporting one unit of Rare Metals]])
	end,
	OnAction = ChoGGi_Funcs.Menus.SetFundingPerRareMetalExport,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000719--[[Add Orbital Probes]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Add Orbital Probes",
	ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
	RolloverText = function()
		if MainCity then
			return SettingState(
				#(MainCity.labels.OrbitalProbe or "") + #(MainCity.labels.AdvancedOrbitalProbe or ""),
				T(302535920000720--[[Add more probes.]])
			)
		end
		return T(302535920000720--[[Add more probes.]])
	end,
	OnAction = ChoGGi_Funcs.Menus.AddOrbitalProbes,
}

c = c + 1
Actions[c] = {ActionName = T(4616--[[Food Per Rocket Passenger]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Food Per Rocket Passenger",
	ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.FoodPerRocketPassenger,
			T(4615--[[The amount of Food (unscaled) supplied with each Colonist arrival]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetFoodPerRocketPassenger,
}

c = c + 1
Actions[c] = {ActionName = T(1110--[[Prefab Buildings]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Prefab Buildings",
	ActionIcon = "CommonAssets/UI/Menu/gear.tga",
	RolloverText = T(1111--[[Prefabricated parts needed for the construction of certain buildings on Mars.]])
		.. "\n\n" .. T(302535920000897--[[Drone prefabs]]),
	OnAction = ChoGGi_Funcs.Menus.AddPrefabBuildings,
}

c = c + 1
Actions[c] = {ActionName = T(3613--[[Funding]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Funding",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		if MainCity then
			return SettingState(
				LocaleInt(UIColony.funds.funding),
				T(302535920000726--[[Add more funding (or reset back to 500 M).]])
			)
		end
		return T(302535920000726)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetFunding,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000727--[[Fill Selected Resource]]),
	ActionMenubar = "ECM.ECM.Resources",
	ActionId = ".Fill Selected Resource",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = T(302535920000728--[[Fill the selected/moused over object's resource(s)]]),
	OnAction = ChoGGi_Funcs.Menus.FillResource,
	ActionShortcut = "Ctrl-F",
	ActionBindable = true,
}
