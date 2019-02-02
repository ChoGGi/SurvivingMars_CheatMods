
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
