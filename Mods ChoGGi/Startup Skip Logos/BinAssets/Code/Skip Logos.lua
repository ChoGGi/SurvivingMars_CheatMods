
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
		local Sleep = Sleep
		local Dialogs = Dialogs

		Sleep(100)
		while not Dialogs.PGMainMenu do
			Sleep(25)
		end

		-- starts in load game menu
		Dialogs.PGMainMenu:SetMode("Load")

		-- load mods
		ModsReloadItems()
		WaitMsg("OnRender")

		-- update cheat menu toolbar
		XShortcutsTarget:UpdateToolbar()
		-- show cheat menu
		XShortcutsTarget:SetVisible(true)

		-- stop the update news images
		UIShowParadoxFeeds = empty_func
	end)
	--]]

end
