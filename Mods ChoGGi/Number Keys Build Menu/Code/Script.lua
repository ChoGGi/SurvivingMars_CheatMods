-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 53
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Number Keys Build Menu requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end

	local tostring = tostring

	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
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
				Sleep(1)
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
			ActionName = S[302535920001414--[[Build menu key: %s--]]]:format(Trans(name)),
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
