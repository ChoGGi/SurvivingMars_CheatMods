
function OnMsg.ReloadLua()
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
