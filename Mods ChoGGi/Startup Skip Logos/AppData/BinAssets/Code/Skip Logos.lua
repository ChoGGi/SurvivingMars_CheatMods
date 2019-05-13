
function OnMsg.DesktopCreated()

	-- stops "Attempt to create a new global", see CommonLua\Core\autorun.lua for more info
	local orig_Loading = Loading
	Loading = true

	-- stop intro videos
	PlayInitialMovies = empty_func

	-- get rid of mod manager warnings (not the reboot one though)
	ParadoxBuildsModManagerWarning = true

	Loading = orig_Loading

	-- bonus:
	--[[
	CreateRealTimeThread(function()
		-- wait for it (otherwise stuff below won't work right)
		local WaitMsg = WaitMsg
		local Dialogs = Dialogs

		WaitMsg("OnRender")
		while not Dialogs.PGMainMenu do
			WaitMsg("OnRender")
		end

		-- starts in load game menu
		CreateRealTimeThread(function()
			Sleep(1000)
			-- make sure load menu doesn't steal focus away from console if it's open
			if not dlgConsole:GetVisible() then
				Dialogs.PGMainMenu:SetMode("Load")
			end
		end)

		-- load mods in main menu
		ModsReloadItems()
		WaitMsg("OnRender")

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
		if Dialogs.PGMainMenu.idContent.idParadoxNews then
			Dialogs.PGMainMenu.idContent.idParadoxNews:delete()
		end
	end)
	--]]

end
