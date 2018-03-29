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

--return fake revision, 1 seems to work fine
return 17000

--[[load order for Msgs
function OnMsg.ClassesGenerate()
  dosomething()
end

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
--]]
