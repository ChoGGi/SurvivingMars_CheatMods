-- See LICENSE for terms

local tostring = tostring

local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- use number keys to activate/hide build menus
local function ShowBuildMenu(which)
	-- make sure the game has started (and the build menu is around)
	if not GameState.gameplay then
		return
	end

	local cat = BuildCategories[which]

	local Dialogs = Dialogs
	local dlg = Dialogs.XBuildMenu
	if dlg then
		-- check if number corresponds and if so hide the menu
		if dlg.category == cat.id then
			ToggleXBuildMenu(true, "close")
		else
			-- have to fire twice to highlight the icon
			dlg:SelectCategory(cat)
			dlg:SelectCategory(cat)
		end
	else
		ToggleXBuildMenu(true, "close")
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			-- we closed it so
			dlg = Dialogs.XBuildMenu
			dlg:SelectCategory(cat)
			dlg:SelectCategory(cat)
		end)
	end
end

local build_str = "BuildmenuKeys.BuildMenu"
local function AddMenuKey(num, key, name)
	c = c + 1
	Actions[c] = {
		ActionName = T(302535920011475, "Build menu key") .. ": " .. T(name),
		ActionId = build_str .. num,
		OnAction = function()
			ShowBuildMenu(num)
		end,
		ActionShortcut = key,
		ActionBindable = true,
	}
end

build_str = "Shift-"
local skipped
local BuildCategories = BuildCategories
for i = 1, #BuildCategories do
	local cat = BuildCategories[i]
	if i < 10 then
		-- the key has to be a string
		AddMenuKey(i, tostring(i), cat.name)
	elseif i == 10 then
		AddMenuKey(i, "0", cat.name)
	else
		-- skip Hidden
		if cat.id == "Hidden" then
			skipped = true
		else
			if skipped then
				-- -1 more for skipping Hidden
				AddMenuKey(i, build_str .. (i - 11), cat.name)
			else
				-- -10 since we're doing Shift-*
				AddMenuKey(i, build_str .. (i - 10), cat.name)
			end
		end
	end
end
