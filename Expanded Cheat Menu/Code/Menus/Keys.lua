-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	-- use number keys to activate/hide build menus
	do -- NumberKeysBuildMenu
		local function AddMenuKey(num,key)
			c = c + 1
			Actions[c] = {
				ActionId = string.format("ChoGGi_AddMenuKey%s",num),
				OnAction = function()
					ChoGGi.CodeFuncs.ShowBuildMenu(num)
				end,
				ActionShortcut = key,
			}
		end
		if ChoGGi.UserSettings.NumberKeysBuildMenu then
			local tostring = tostring
			local skipped
			local BuildCategories = BuildCategories
			for i = 1, #BuildCategories do
				if i < 10 then
					--the key has to be a string
					AddMenuKey(i,tostring(i))
				elseif i == 10 then
					AddMenuKey(i,"0")
				else
					--skip Hidden as it'll have the Rocket Landing Site (hard to remove).
					if BuildCategories[i].id == "Hidden" then
						skipped = true
					else
						if skipped then
							-- -1 more for skipping Hidden
							AddMenuKey(i,string.format("Shift-%s",i - 11))
						else
							-- -10 since we're doing Shift-*
							AddMenuKey(i,string.format("Shift-%s",i - 10))
						end
					end
				end
			end
		end
	end

	c = c + 1
	Actions[c] = {ActionName = S[302535920000734--[[Clear Log--]]],
		ActionId = "ECM.Keys.ClearConsoleLog",
		OnAction = cls,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ClearConsoleLog,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = string.format("%s %s",S[298035641454--[[Object--]]],S[302535920001346--[[Random Colour--]]]),
		ActionId = "ECM.Keys.ObjectColourRandom",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjectColourRandom,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = string.format("%s %s",S[298035641454--[[Object--]]],S[302535920000025--[[Default Colour--]]]),
		ActionId = "ECM.Keys.ObjectColourDefault",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourDefault(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjectColourDefault,
		ActionBindable = true,
	}

	local function ToggleConsole()
		local dlgConsole = dlgConsole
		if dlgConsole then
			ShowConsole(not dlgConsole:GetVisible())
			dlgConsole.idEdit:SetFocus()
		end
	end

	c = c + 1
	Actions[c] = {ActionName = string.format("%s %s",S[302535920001347--[[Show Console--]]],S[1000544--[[~--]]]),
		ActionId = "ECM.Keys.ShowConsoleTilde",
		OnAction = ToggleConsole,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ShowConsoleTilde,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = string.format("%s %s",S[302535920001347--[[Show Console--]]],S[1000447--[[Enter--]]]),
		ActionId = "ECM.Keys.ShowConsoleEnter",
		OnAction = ToggleConsole,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ShowConsoleEnter,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001348--[[Restart--]]],
		ActionId = "ECM.Keys.ConsoleRestart",
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
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ConsoleRestart,
		ActionBindable = true,
	}

	-- goes to placement mode with last built object
	c = c + 1
	Actions[c] = {ActionName = S[302535920001349--[[Place Last Constructed Building--]]],
		ActionId = "ECM.Keys.LastConstructedBuilding",
		OnAction = function()
			local last = UICity.LastConstructedBuilding
			if type(last) == "table" then
				ChoGGi.CodeFuncs.ConstructionModeSet(last.encyclopedia_id ~= "" and last.encyclopedia_id or last.entity)
			end
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.LastConstructedBuilding,
		ActionBindable = true,
	}

	-- goes to placement mode with SelectedObj
	c = c + 1
	Actions[c] = {ActionName = S[302535920001350--[[Place Last Selected Object--]]],
		ActionId = "ECM.Keys.LastSelectedObject",
		OnAction = function()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if type(sel) == "table" then
				ChoGGi.Temp.LastPlacedObject = sel
				ChoGGi.CodeFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
			end
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.LastPlacedObject,
		ActionBindable = true,
	}

end
