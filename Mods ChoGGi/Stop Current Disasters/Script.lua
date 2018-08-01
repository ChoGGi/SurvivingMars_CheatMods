
local function SomeCode()
  local Msg,pairs = Msg,pairs
  local empty_table = empty_table

  local im = g_IncomingMissiles or empty_table
  for Key,_ in pairs(im) do
    Key:ExplodeInAir()
  end

  if g_DustStorm then
    StopDustStorm()
  end

  if g_ColdWave then
    StopColdWave()
  end

  local mp = g_MeteorsPredicted or empty_table
  for i = #mp, 1, -1 do
    Msg("MeteorIntercepted", mp[i])
    mp[i]:ExplodeInAir()
  end

end

--~ function OnMsg.CityStart()
--~   SomeCode()
--~ end

function OnMsg.LoadGame()
  SomeCode()
end
