-- if we open something in ged we may get a create new global error from below if these aren't already globals
PlayInitialMovies = nil
ParadoxBuildsModManagerWarning = true

function OnMsg.DesktopCreated()
	-- skip the two logos
	PlayInitialMovies = nil
end

local are_we_setup
function OnMsg.ReloadLua()
	if are_we_setup then
		return
	end
	are_we_setup = true

	-- get rid of mod manager warnings (not the reboot one though)
	ParadoxBuildsModManagerWarning = true

	--[[
		-- opens to load game menu
		local Dialogs = Dialogs
		while not Dialogs.PGMainMenu do
			Sleep(100)
		end
		Dialogs.PGMainMenu:SetMode("Load")

		-- load mods in main menu
		ModsReloadItems()

		-- show cheat menu
		Sleep(100)
		XShortcutsTarget:SetVisible(true)
	--]]

end
