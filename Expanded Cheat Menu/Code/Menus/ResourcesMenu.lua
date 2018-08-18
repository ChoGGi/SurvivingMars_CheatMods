-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

local str_ExpandedCM_Resources = "Expanded CM.Resources"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[692--[[Resources--]]]," .."),
  ActionId = str_ExpandedCM_Resources,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "1Resources",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Resources,
  ActionName = S[302535920000719--[[Add Orbital Probes--]]],
  ActionId = "Expanded CM.Resources.Add Orbital Probes",
  ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
  RolloverText = S[302535920000720--[[Add more probes.--]]],
  OnAction = ChoGGi.MenuFuncs.AddOrbitalProbes,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Resources,
  ActionName = S[4616--[[Food Per Rocket Passenger--]]],
  ActionId = "Expanded CM.Resources.Food Per Rocket Passenger",
  ActionIcon = "CommonAssets/UI/Menu/ToggleTerrainHeight.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.FoodPerRocketPassenger,
      302535920000722--[[Change the amount of Food supplied with each Colonist arrival.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Resources,
  ActionName = S[302535920000723--[[Add Prefabs--]]],
  ActionId = "Expanded CM.Resources.Add Prefabs",
  ActionIcon = "CommonAssets/UI/Menu/gear.tga",
  RolloverText = S[302535920000724--[[Adds prefabs.--]]],
  OnAction = ChoGGi.MenuFuncs.AddPrefabs,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Resources,
  ActionName = S[302535920000725--[[Add Funding--]]],
  ActionId = "Expanded CM.Resources.Add Funding",
  ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
  RolloverText = S[302535920000726--[[Add more funding (or reset back to 500 M).--]]],
  OnAction = ChoGGi.MenuFuncs.SetFunding,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetFunding,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Resources,
  ActionName = S[302535920000727--[[Fill Selected Resource--]]],
  ActionId = "Expanded CM.Resources.Fill Selected Resource",
  ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
  RolloverText = S[302535920000728--[[Fill the selected/moused over object's resource(s)--]]],
  OnAction = ChoGGi.MenuFuncs.FillResource,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.FillResource,
}
