function OnMsg.DesktopCreated()
  --skip the two logos
  PlayInitialMovies = nil
end

function OnMsg.ReloadLua()
  --opens load game menu, uncomment to enable
  --[[
  CreateRealTimeThread(function()
    OpenPreGameMainMenu("Load")
  end)
  --]]

  --get rid of some of those mod manager warnings (not the reboot prompt)
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
