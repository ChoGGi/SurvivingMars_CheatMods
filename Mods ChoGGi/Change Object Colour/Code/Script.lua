-- See LICENSE for terms

local Actions = ChoGGi.Temp.Actions
local c = #Actions
local T = T

c = c + 1
Actions[c] = {ActionName = T(174, "Color Modifier"),
	ActionId = "ChangeObjectColour.Color Modifier",
	OnAction = ChoGGi_Funcs.Common.CreateObjectListAndAttaches,
	ActionShortcut = "F6",
	replace_matching_id = true,
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(298035641454, "Object") .. " " .. T(302535920001346, "Random Colour"),
	ActionId = "ChangeObjectColour.ObjectColourRandom",
	OnAction = ChoGGi_Funcs.Common.ObjectColourRandom,
	ActionShortcut = "Shift-F6",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(298035641454, "Object") .. " " .. T(302535920000025, "Default Colour"),
	ActionId = "ChangeObjectColour.ObjectColourDefault",
	OnAction = ChoGGi_Funcs.Common.ObjectColourDefault,
	ActionShortcut = "Ctrl-F6",
	ActionBindable = true,
}
