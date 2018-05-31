function OnMsg.DesktopCreated()
  --skip the two logos
  PlayInitialMovies = nil
end

function OnMsg.ReloadLua()
  --get rid of mod manager warnings (not the reboot one though)
  ParadoxBuildsModEditorWarning = true
  ParadoxBuildsModManagerWarning = true
end

--[[
function OnMsg.UASetMode()

  CreateRealTimeThread(function()

    --opens to load game menu
    OpenPreGameMainMenu("Load")

    --show cheats menu
    UAMenu.ToggleOpen()

    --stop bugging me about missing mods
    function GetMissingMods()
      return "", false
    end

  end)

end
--]]

--return revision, or else you get a blank map on new game
return 19673
