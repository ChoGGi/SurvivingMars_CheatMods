-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local Actions = ChoGGi.Temp.Actions

	local c = #Actions
	--use number keys to activate/hide build menus
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
	Actions[c] = {
		ActionId = "ChoGGi_ClearConsoleLog",
		OnAction = cls,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ClearConsoleLog,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {-- ChoGGi_ObjectColourRandom
		ActionId = "ChoGGi_ObjectColourRandom",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjectColourRandom,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {-- ChoGGi_ObjectColourDefault
		ActionId = "ChoGGi_ObjectColourDefault",
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
	--~ 		dlgConsole.idEdit:SetFocus()
		end
	end

	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_ShowConsoleTilde",
		OnAction = function()
			ToggleConsole()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ShowConsoleTilde,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_ShowConsoleEnter",
		OnAction = function()
			ToggleConsole()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ShowConsoleEnter,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_ConsoleRestart",
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

	c = c + 1
	Actions[c] = {-- goes to placement mode with last built object
		ActionId = "ChoGGi_LastConstructedBuilding",
		OnAction = function()
			local last = UICity.LastConstructedBuilding
			if type(last) == "table" then
				ChoGGi.CodeFuncs.ConstructionModeSet(last.encyclopedia_id ~= "" and last.encyclopedia_id or last.entity)
			end
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.LastConstructedBuilding,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {-- goes to placement mode with SelectedObj
		ActionId = "ChoGGi_LastPlacedObject",
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
