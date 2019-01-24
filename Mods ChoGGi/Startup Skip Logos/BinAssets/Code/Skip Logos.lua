
function OnMsg.DesktopCreated()

	-- if we open something in ged we may get a create new global error if these aren't set
	-- see CommonLua\Core\autorun.lua for more info
	local pg = PersistableGlobals
	pg.PlayInitialMovies = true
	pg.ParadoxBuildsModManagerWarning = true

	-- stop intro videos
	PlayInitialMovies = empty_func

	-- get rid of mod manager warnings (not the reboot one though)
	ParadoxBuildsModManagerWarning = true

	-- we don't need these anymore, and we don't want them saved in the persist table
	pg.PlayInitialMovies = nil
	pg.ParadoxBuildsModManagerWarning = nil

	-- bonus:
	--[[
  CreateRealTimeThread(function()
		local Sleep = Sleep
		-- opens to load game menu
		local Dialogs = Dialogs
		Sleep(100)
		while not Dialogs.PGMainMenu do
			Sleep(25)
		end
		Dialogs.PGMainMenu:SetMode("Load")

		-- load mods in main menu
		ModsReloadItems()

		-- show cheat menu
		Sleep(100)
		XShortcutsTarget:SetVisible(true)
	end)
	--]]

end
