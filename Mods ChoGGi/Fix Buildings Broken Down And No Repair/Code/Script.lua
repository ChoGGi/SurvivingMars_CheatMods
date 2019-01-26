-- See LICENSE for terms

function OnMsg.LoadGame()

  if IsValidThread(DustStorm) then
    return
  end
  MapForEach("map", "RequiresMaintenance", function(o)
    o:CreateResourceRequest()
    o:AccumulateMaintenancePoints()
  end)
  if g_DustStorm then
    local storm_type = g_DustStorm.type
    local preset = storm_type .. "DustStormDuration"
    if storm_type == "electrostatic" then
      PlayFX("ElectrostaticStorm", "end")
    elseif storm_type == "great" then
      PlayFX("GreatStorm", "end")
    else
      PlayFX("DustStorm", "end")
    end
    g_DustStorm = false
    g_DustStormStart = false
    g_DustStormEnd = false
    RemoveOnScreenNotification(preset)
    Msg("DustStormEnded")
  end
  RestartGlobalGameTimeThread("DustStorm")

end
