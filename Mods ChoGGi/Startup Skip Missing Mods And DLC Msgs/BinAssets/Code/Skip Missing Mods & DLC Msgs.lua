local are_we_setup
function OnMsg.ReloadLua()
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
