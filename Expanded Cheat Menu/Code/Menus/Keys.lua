-- See LICENSE for terms

-- shortcut keys without a menu item (maybe Menus isn't the best folder for this)

function OnMsg.ClassesGenerate()
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = S[302535920000734--[[Clear Log--]]],
		ActionId = ".Keys.ClearConsoleLog",
		OnAction = cls,
		ActionShortcut = "F9",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Trans(174--[[Color Modifier--]]) .. " " .. S[302535920001346--[[Random Colour--]]],
		ActionId = ".Keys.ObjectColourRandom",
		OnAction = ChoGGi.ComFuncs.ObjectColourRandom,
		ActionShortcut = "Shift-F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Trans(174--[[Color Modifier--]]) .. " " .. S[302535920000025--[[Default Colour--]]],
		ActionId = ".Keys.ObjectColourDefault",
		OnAction = ChoGGi.ComFuncs.ObjectColourDefault,
		ActionShortcut = "Ctrl-F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001347--[[Show Console--]]],
		ActionId = ".Keys.ShowConsole",
		OnAction = ChoGGi.ComFuncs.ToggleConsole,
		ActionShortcut = "Enter",
		ActionShortcut2 = "~",
		ActionBindable = true,
	}
	c = c + 1
	Actions[c] = {ActionName = S[302535920001348--[[Restart--]]],
		ActionId = ".Keys.ConsoleRestart",
		OnAction = ChoGGi.MenuFuncs.ConsoleRestart,
		ActionShortcut = "Ctrl-Alt-R",
		ActionBindable = true,
	}

	-- goes to placement mode with last built object
	c = c + 1
	Actions[c] = {ActionName = S[302535920001349--[[Place Last Constructed Building--]]],
		ActionId = ".Keys.LastConstructedBuilding",
		OnAction = ChoGGi.MenuFuncs.LastConstructedBuilding,
		ActionShortcut = "Ctrl-Space",
		ActionBindable = true,
	}

	-- goes to placement mode with SelectedObj
	c = c + 1
	Actions[c] = {ActionName = S[302535920001350--[[Place Last Selected Object--]]],
		ActionId = ".Keys.LastSelectedObject",
		OnAction = ChoGGi.MenuFuncs.LastSelectedObject,
		ActionShortcut = "Ctrl-Shift-Space",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000069--[[Examine--]]] .. " " .. S[302535920001103--[[Objects--]]] .. " " .. Trans(1000448--[[Shift--]]),
		ActionId = ".Keys.Examine Objects Shift",
		OnAction = ChoGGi.MenuFuncs.ExamineObjectRadius,
		radius_amount = 2500,
		ActionShortcut = "Shift-F4",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000069--[[Examine--]]] .. " " .. S[302535920001103--[[Objects--]]] .. " " .. Trans(1000449--[[Ctrl--]]),
		ActionId = ".Keys.Examine Objects Ctrl",
		OnAction = ChoGGi.MenuFuncs.ExamineObjectRadius,
		radius_amount = 10000,
		ActionShortcut = "Ctrl-F4",
		ActionBindable = true,
	}

end
