-- See LICENSE for terms

-- nope not hacky at all
local is_loaded
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_CheatMenu" then
		return
	end
	is_loaded = true

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

	--spawn and fill a deposit at mouse pos
	function ChoGGi.MenuFuncs.AddDeposit(sType)
		local obj = PlaceObj(sType, {
			"Pos", ChoGGi.CodeFuncs.CursorNearestHex(),
			"revealed", true,
		})
		obj.max_amount = ChoGGi.ComFuncs.Random(1000 * ChoGGi.Consts.ResourceScale,100000 * ChoGGi.Consts.ResourceScale)
		obj:CheatRefill()
		obj.amount = obj.max_amount
	end

	-- fixup name we get from Object
	function ChoGGi.MenuFuncs.ConstructionModeNameClean(itemname)
		--we want template_name or we have to guess from the placeobj name
		local tempname = itemname:match("^.+template_name%A+([A-Za-z_%s]+).+$")
		if not tempname then
			tempname = itemname:match("^PlaceObj%('(%a+).+$")
		end

	--~	 print(tempname)
		if tempname:find("Deposit") then
			ChoGGi.MenuFuncs.AddDeposit(tempname)
		else
			ChoGGi.MenuFuncs.ConstructionModeSet(tempname)
		end
	end

	-- place item under the mouse for construction
	function ChoGGi.MenuFuncs.ConstructionModeSet(itemname)
		-- make sure it's closed so we don't mess up selection
		if GetDialog("XBuildMenu") then
			CloseDialog("XBuildMenu")
		end
		-- fix up some names
		local fixed = ChoGGi.Tables.ConstructionNamesListFix[itemname]
		if fixed then
			itemname = fixed
		end
		-- n all the rest
		local igi = Dialogs.InGameInterface
		if not igi or not igi:GetVisible() then
			return
		end

		local bld_template = BuildingTemplates[itemname]
		if not bld_template then
			return
		end
	--~	 local show,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)
		local _,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)

		-- interferes with building passage ramp
	--~	 if show then
			local dlg = Dialogs.XBuildMenu
			if action then
				action(dlg,{
					enabled = can_build,
					name = bld_template.id ~= "" and bld_template.id or bld_template.encyclopedia_id,
					construction_mode = bld_template.construction_mode
				})
			else
				igi:SetMode("construction",{
					template = bld_template.id ~= "" and bld_template.id or bld_template.encyclopedia_id,
					selected_dome = dlg and dlg.context.selected_dome
				})
			end
			CloseXBuildMenu()
	--~	 end
	end

	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_ClearConsoleLog",
		OnAction = cls,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ClearConsoleLog,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_ObjectColourRandom",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjectColourRandom,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
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

	-- goes to placement mode with last built object
	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_LastConstructedBuilding",
		OnAction = function()
			local last = UICity.LastConstructedBuilding
			if type(last) == "table" then
				ChoGGi.MenuFuncs.ConstructionModeSet(last.encyclopedia_id ~= "" and last.encyclopedia_id or last.entity)
			end
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.LastConstructedBuilding,
		ActionBindable = true,
	}

	-- goes to placement mode with SelectedObj
	c = c + 1
	Actions[c] = {
		ActionId = "ChoGGi_LastPlacedObject",
		OnAction = function()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if type(sel) == "table" then
				ChoGGi.Temp.LastPlacedObject = sel
				ChoGGi.MenuFuncs.ConstructionModeNameClean(ValueToLuaCode(sel))
			end
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.LastPlacedObject,
		ActionBindable = true,
	}

end
