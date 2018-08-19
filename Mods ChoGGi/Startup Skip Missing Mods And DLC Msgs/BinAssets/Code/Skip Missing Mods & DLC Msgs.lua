local are_we_setup
local function ChoGGi_Setup()
  if are_we_setup then
    return
  end
  are_we_setup = true

  CreateRealTimeThread(function()
    -- stop bugging me about missing mods
    function GetMissingMods()
      return "", false
    end

    -- lets you load saved games that have dlc
    function IsDlcAvailable()
      return true
    end
  end)
end

function OnMsg.ReloadLua()
  ChoGGi_Setup()
end
function OnMsg.UASetMode()
  ChoGGi_Setup()
end
