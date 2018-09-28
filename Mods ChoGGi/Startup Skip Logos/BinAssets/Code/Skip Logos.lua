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

	-- opens to load game menu
	--[[
		local idx
		local desktop = terminal.desktop
		local TableFind = table.find
		local Sleep = Sleep
		while not idx do
			-- since there's just the one dialog opened, that's all we look for
			idx = TableFind(desktop,"class","XDialog")
			Sleep(50)
		end
		desktop[idx]:SetMode("Load")
	--]]

end
