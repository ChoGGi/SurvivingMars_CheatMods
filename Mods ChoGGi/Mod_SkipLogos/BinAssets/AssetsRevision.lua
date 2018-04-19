function OnMsg.DesktopCreated()
  --skip the two logos
  PlayInitialMovies = nil
end

function OnMsg.ReloadLua()
  --[[
  CreateRealTimeThread(function()

    --opens to load game menu
    local savegame_count = WaitCountSaveGames()
    if savegame_count then
      local dlg = OpenXDialog("PGMainMenu", nil, {savegame_count = savegame_count})
      if dlg then
        dlg:SetMode("Load")
      end
    end

    --show menu
    UAMenu.ToggleOpen()

    --stop bugging me about missing mods
    function GetMissingMods()
      return "", false
    end

  end)
  --]]

  --get rid of mod manager warnings (not the reboot one though)
  ParadoxBuildsModEditorWarning = true
  ParadoxBuildsModManagerWarning = true
end

--return revision, or else you get a blank map on new game
return 18035

--[[startup msg order
ClassesGenerate
ClassesPreprocess
ClassesPostprocess
ClassesBuilt
XTemplatesLoaded
Autorun
OptionsApply
GameStateChanged
Start
XInputInitialized
SystemSize
DesktopCreated
XInputInited
GameStateChanged
GameStateChangedNotify
SystemSize
ReloadLua

example:
function OnMsg.ClassesGenerate()
  dosomething()
end
--]]
