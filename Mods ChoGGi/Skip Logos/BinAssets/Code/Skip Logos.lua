function OnMsg.DesktopCreated()
  -- skip the two logos
  PlayInitialMovies = nil
end

local are_we_setup
local function ChoGGi_Setup()
  if are_we_setup then
    return
  end
  are_we_setup = true

  -- get rid of mod manager warnings (not the reboot one though)
  ParadoxBuildsModEditorWarning = true
  ParadoxBuildsModManagerWarning = true

end

function OnMsg.ReloadLua()
  ChoGGi_Setup()
end
function OnMsg.UASetMode()
  ChoGGi_Setup()
end
