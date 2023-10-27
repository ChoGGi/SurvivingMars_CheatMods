-- See LICENSE for terms

-- shortcut keys without a menu item (maybe Menus isn't the best folder for this)

local what_game = ChoGGi.what_game
local T = T
local Translate = ChoGGi.ComFuncs.Translate
local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = T(302535920000734--[[Clear Log]]),
	ActionId = ".Keys.ClearConsoleLog",
	OnAction = cls,
	ActionShortcut = "F9",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Translate(174--[[Color Modifier]]) .. " " .. T(302535920001346--[[Random Colour]]),
	ActionId = ".Keys.ObjectColourRandom",
	OnAction = ChoGGi.ComFuncs.ObjectColourRandom,
	ActionShortcut = "Shift-F6",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Translate(174--[[Color Modifier]]) .. " " .. T(302535920000025--[[Default Colour]]),
	ActionId = ".Keys.ObjectColourDefault",
	OnAction = ChoGGi.ComFuncs.ObjectColourDefault,
	ActionShortcut = "Ctrl-F6",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001347--[[Show Console]]),
	ActionId = ".Keys.ShowConsole",
	OnAction = ChoGGi.ComFuncs.ToggleConsole,
	ActionShortcut = "Enter",
	ActionShortcut2 = "~",
	ActionBindable = true,
}
c = c + 1
Actions[c] = {ActionName = T(302535920001348--[[Restart]]),
	ActionId = ".Keys.ConsoleRestart",
	OnAction = ChoGGi.MenuFuncs.ConsoleRestart,
	ActionShortcut = "Ctrl-Alt-R",
	ActionBindable = true,
}

-- goes to placement mode with SelectedObj or last built object
c = c + 1
Actions[c] = {ActionName = T(302535920001350--[[Place Last Selected/Constructed Building]]),
	ActionId = ".Keys.PlaceLastSelectedConstructedBld",
	OnAction = ChoGGi.ComFuncs.PlaceLastSelectedConstructedBld,
	ActionShortcut = "Ctrl-Space",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000069--[[Examine]]) .. " " .. T(302535920001103--[[Objects]]) .. " " .. T(302535920000163--[[Radius]]),
	ActionId = ".Keys.Examine Objects Radius",
	OnAction = ChoGGi.MenuFuncs.ExamineObjectRadius,
	ActionShortcut = what_game == "Mars" and "Shift-F4" or "F4",
	ActionBindable = true,
}
