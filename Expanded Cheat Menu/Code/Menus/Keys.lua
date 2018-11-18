-- See LICENSE for terms

-- shortcut keys without a menu item (maybe Menus isn't the best folder for this)

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions
	local StringFormat = string.format

	-- use number keys to activate/hide build menus
	do -- NumberKeysBuildMenu
		local function ShowBuildMenu(which)
			local BuildCategories = BuildCategories

			-- make sure we're not in the main menu
			if not UICity then
				return
			end

			local dlg = Dialogs.XBuildMenu
			if dlg then
				-- check if number corresponds and if so hide the menu
				if dlg.category == BuildCategories[which].id then
					ToggleXBuildMenu(true, "close")
				else
					dlg = Dialogs.XBuildMenu
					dlg:SelectCategory(BuildCategories[which])
					-- have to fire twice to highlight the icon
					dlg:SelectCategory(BuildCategories[which])
				end
			else
				ToggleXBuildMenu(true, "close")
				CreateRealTimeThread(function()
					Sleep(1)
					dlg = Dialogs.XBuildMenu
					dlg:SelectCategory(BuildCategories[which])
					dlg:SelectCategory(BuildCategories[which])
				end)
			end
		end

		local function AddMenuKey(num,key)
			c = c + 1
			Actions[c] = {
				ActionId = StringFormat(".Keys.BuildMenu%s",num),
				OnAction = function()
					ShowBuildMenu(num)
				end,
				ActionShortcut = key,
				ChoGGi_ECM = true,
				ActionBindable = true,
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
					-- skip Hidden
					if BuildCategories[i].id == "Hidden" then
						skipped = true
					else
						if skipped then
							-- -1 more for skipping Hidden
							AddMenuKey(i,StringFormat("Shift-%s",i - 11))
						else
							-- -10 since we're doing Shift-*
							AddMenuKey(i,StringFormat("Shift-%s",i - 10))
						end
					end
				end
			end
		end
	end

	c = c + 1
	Actions[c] = {ActionName = S[302535920000734--[[Clear Log--]]],
		ActionId = ".Keys.ClearConsoleLog",
		OnAction = cls,
		ActionShortcut = "F9",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[298035641454--[[Object--]]],S[302535920001346--[[Random Colour--]]]),
		ActionId = ".Keys.ObjectColourRandom",
		OnAction = function()
			ChoGGi.ComFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Shift-F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[298035641454--[[Object--]]],S[302535920000025--[[Default Colour--]]]),
		ActionId = ".Keys.ObjectColourDefault",
		OnAction = function()
			ChoGGi.ComFuncs.ObjectColourDefault(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Ctrl-F6",
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
	Actions[c] = {ActionName = S[302535920001347--[[Show Console--]]],
		ActionId = ".Keys.ShowConsole",
		OnAction = ToggleConsole,
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
				ChoGGi.ComFuncs.ConstructionModeSet(last.template_name ~= "" and last.template_name or last.entity)
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
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000069--[[Examine--]]],S[302535920001103--[[Objects--]]]),
		ActionId = ".Keys.Examine Objects",
		OnAction = function()
			local obj = MapGet(GetTerrainCursor(),2500)
			if #obj > 0 then
				ChoGGi.ComFuncs.OpenInExamineDlg(obj)
			end
		end,
		ActionShortcut = "Shift-F4",
		ActionBindable = true,
	}

end
