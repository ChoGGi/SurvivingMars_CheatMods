
function OnMsg.LoadGame()
  for Key,_ in pairs(g_IncomingMissiles or empty_table) do
    Key:ExplodeInAir()
  end
  if g_DustStorm then
    StopDustStorm()
  end
  if g_ColdWave then
    StopColdWave()
  end

  local mp = g_MeteorsPredicted
  while #mp > 0 do
    for i = 1, #mp do
      pcall(function()
        --Msg("MeteorIntercepted", mp[i], MeteorInterceptRocket.shooter)
        Msg("MeteorIntercepted", mp[i])
        mp[i]:ExplodeInAir()
      end)
    end
  end

end
