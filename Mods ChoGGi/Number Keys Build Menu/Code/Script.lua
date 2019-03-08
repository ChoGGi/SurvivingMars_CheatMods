-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 58
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Number Keys Build Menu requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end

	local tostring = tostring

	local Translate = ChoGGi.ComFuncs.Translate
	local Strings = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	-- use number keys to activate/hide build menus
	local function ShowBuildMenu(which)
		local BuildCategories = BuildCategories

		-- make sure we're not in the main menu
		if not GameState.gameplay then
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
				WaitMsg("OnRender")
				dlg = Dialogs.XBuildMenu
				dlg:SelectCategory(BuildCategories[which])
				dlg:SelectCategory(BuildCategories[which])
			end)
		end
	end

	local build_str = "BuildmenuKeys.BuildMenu%s"
	local function AddMenuKey(num,key,name)
		c = c + 1
		Actions[c] = {
			ActionName = Strings[302535920001414--[[Build menu key: %s--]]]:format(Translate(name)),
			ActionId = build_str:format(num),
			OnAction = function()
				ShowBuildMenu(num)
			end,
			ActionShortcut = key,
			ActionBindable = true,
		}
	end

	build_str = "Shift-%s"
	local skipped
	local BuildCategories = BuildCategories
	for i = 1, #BuildCategories do
		if i < 10 then
			-- the key has to be a string
			AddMenuKey(i,tostring(i),BuildCategories[i].name)
		elseif i == 10 then
			AddMenuKey(i,"0",BuildCategories[i].name)
		else
			-- skip Hidden
			if BuildCategories[i].id == "Hidden" then
				skipped = true
			else
				if skipped then
					-- -1 more for skipping Hidden
					AddMenuKey(i,build_str:format(i - 11),BuildCategories[i].name)
				else
					-- -10 since we're doing Shift-*
					AddMenuKey(i,build_str:format(i - 10),BuildCategories[i].name)
				end
			end
		end
	end

end
