-- See LICENSE for terms

local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local T = T

c = c + 1
Actions[c] = {ActionName = T(174, "Color Modifier"),
	ActionId = "ChangeObjectColour.Color Modifier",
	OnAction = ChoGGi.ComFuncs.CreateObjectListAndAttaches,
	ActionShortcut = "F6",
	replace_matching_id = true,
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(298035641454, "Object") .. " " .. Strings[302535920001346--[[Random Colour]]],
	ActionId = "ChangeObjectColour.ObjectColourRandom",
	OnAction = ChoGGi.ComFuncs.ObjectColourRandom,
	ActionShortcut = "Shift-F6",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(298035641454, "Object") .. " " .. Strings[302535920000025--[[Default Colour]]],
	ActionId = "ChangeObjectColour.ObjectColourDefault",
	OnAction = ChoGGi.ComFuncs.ObjectColourDefault,
	ActionShortcut = "Ctrl-F6",
	ActionBindable = true,
}
