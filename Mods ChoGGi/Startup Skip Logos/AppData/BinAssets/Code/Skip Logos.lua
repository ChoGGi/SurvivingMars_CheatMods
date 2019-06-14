
-- load mods in mainmenu
local load_mods = true
--~ local load_mods = false

function OnMsg.DesktopCreated()

	-- stop intro videos
	PlayInitialMovies = empty_func
	-- get rid of mod manager warnings (not the reboot one though)
	ParadoxBuildsModManagerWarning = true

	-- bonus:
	CreateRealTimeThread(function()
		-- wait for it (otherwise stuff below won't work right)
		local WaitMsg = WaitMsg
		local Dialogs = Dialogs

		WaitMsg("OnRender")
		while not Dialogs.PGMainMenu do
			WaitMsg("OnRender")
		end

		if load_mods then
			-- load mods (figure out how to skip loading mod entity in main menu)
			ModsReloadItems()
			WaitMsg("OnRender")
		end

		-- update cheat menu toolbar
		XShortcutsTarget:UpdateToolbar()
		-- show cheat menu
		XShortcutsTarget:SetVisible(true)

		-- update my list of table names
		if rawget(_G, "ChoGGi") and ChoGGi.ComFuncs.RetName_Update then
			ChoGGi.ComFuncs.RetName_Update()
		end

		-- remove the update news
		UIShowParadoxFeeds = empty_func
		WaitMsg("OnRender")
		if Dialogs.PGMainMenu and Dialogs.PGMainMenu.idContent.idParadoxNews then
			Dialogs.PGMainMenu.idContent.idParadoxNews:delete()
		end
	end)

end
