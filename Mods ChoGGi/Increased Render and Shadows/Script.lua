local function SomeCode()

  --lot of lag for some small rocks in distance
  --hr.DistanceModifier = 260 --default 130

  --render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
  hr.LODDistanceModifier = 600 --def 120

  --shadow cutoff dist
  hr.ShadowRangeOverride = 1000000 --def 0

  --no shadow fade out when zooming
  hr.ShadowFadeOutRangePercent = 0 --def 30

  --in game menu only allows 4096 as max (16384 works, but uses a couple extra gigs of vram)
  hr.ShadowmapSize = 8192

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end

