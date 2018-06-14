local function Enable()
  Consts.InstantPipes = 1
  Consts.InstantCables = 1
  g_Consts.InstantPipes = 1
  g_Consts.InstantCables = 1
end

function OnMsg.NewMapLoaded()
  Enable()
end
function OnMsg.LoadGame()
  Enable()
end
