-- See LICENSE for terms

-- shortcut keys without a menu item (maybe Menus isn't the best folder for this)

local StringFormat = string.format

function OnMsg.ClassesGenerate()
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
	Actions[c] = {ActionName = StringFormat("%s %s",S[174--[[Color Modifier--]]],S[302535920001346--[[Random Colour--]]]),
		ActionId = ".Keys.ObjectColourRandom",
		OnAction = function()
			ChoGGi.ComFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Shift-F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[174--[[Color Modifier--]]],S[302535920000025--[[Default Colour--]]]),
		ActionId = ".Keys.ObjectColourDefault",
		OnAction = function()
			ChoGGi.ComFuncs.ObjectColourDefault(ChoGGi.ComFuncs.SelObject())
		end,
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
		OnAction = function()
			local dlgConsole = dlgConsole
			if dlgConsole then
				if not dlgConsole:GetVisible() then
					ShowConsole(true)
				end
				dlgConsole.idEdit:SetFocus()
				dlgConsole.idEdit:SetText("restart")
			end
		end,
		ActionShortcut = "Ctrl-Alt-R",
		ActionBindable = true,
	}

	-- goes to placement mode with last built object
	c = c + 1
	Actions[c] = {ActionName = S[302535920001349--[[Place Last Constructed Building--]]],
		ActionId = ".Keys.LastConstructedBuilding",
		OnAction = function()
			local last = UICity.LastConstructedBuilding
			if type(last) == "table" then
				ChoGGi.ComFuncs.ConstructionModeSet(last.template_name ~= "" and last.template_name or last:GetEntity())
			end
		end,
		ActionShortcut = "Ctrl-Space",
		ActionBindable = true,
	}

	-- goes to placement mode with SelectedObj
	c = c + 1
	Actions[c] = {ActionName = S[302535920001350--[[Place Last Selected Object--]]],
		ActionId = ".Keys.LastSelectedObject",
		OnAction = function()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if type(sel) == "table" then
				ChoGGi.Temp.LastPlacedObject = sel
				ChoGGi.ComFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
			end
		end,
		ActionShortcut = "Ctrl-Shift-Space",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s %s",S[302535920000069--[[Examine--]]],S[302535920001103--[[Objects--]]],S[1000448--[[Shift--]]]),
		ActionId = ".Keys.Examine Objects Shift",
		OnAction = function()
			local obj = MapGet(GetTerrainCursor(),2500)
			if #obj > 0 then
				ChoGGi.ComFuncs.OpenInExamineDlg(obj)
			end
		end,
		ActionShortcut = "Shift-F4",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s %s",S[302535920000069--[[Examine--]]],S[302535920001103--[[Objects--]]],S[1000449--[[Ctrl--]]]),
		ActionId = ".Keys.Examine Objects Ctrl",
		OnAction = function()
			local obj = MapGet(GetTerrainCursor(),10000)
			if #obj > 0 then
				ChoGGi.ComFuncs.OpenInExamineDlg(obj)
			end
		end,
		ActionShortcut = "Ctrl-F4",
		ActionBindable = true,
	}

end
