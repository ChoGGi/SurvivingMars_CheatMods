if ChoGGi.ChoGGiTest then
  --uses slightly more vid memory (it seems 1 means toggle off)
  hr.TR_ToggleTextureCompression = 1

--do they do anything?
  hr.EnableScreenSpaceReflection = 1
  hr.FadeCullRadius = 5000
  hr.D3D11ParallelCompilation = 1

  config.MapSlotChunksMem = 16384
  config.ObjectPoolMem = 256000
  config.ParticlesMaxBaseColorMapSize = 4096
  config.ParticlesMaxNormalMapSize = 1024
  config.MinimapScreenshotSize = 4096
end

--on by default, you know all them martian trees (might make a cpu difference, probably not)
hr.TreeWind = 0

if ChoGGi.CheatMenuSettings.HigherRenderDist then
  --lot of lag for some small rocks in distance
  --hr.DistanceModifier = 230 --default 130
  --hr.AutoFadeDistanceScale = 2200 --def 2200
  --render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
  if type(ChoGGi.CheatMenuSettings.HigherRenderDist) == "number" then
    hr.LODDistanceModifier = ChoGGi.CheatMenuSettings.HigherRenderDist
  else
    hr.LODDistanceModifier = 600 --def 120
  end
end

if ChoGGi.CheatMenuSettings.HigherShadowDist then
  --shadow cutoff dist
  hr.ShadowRangeOverride = 1000000
  --no shadow fade out when zooming
  hr.ShadowFadeOutRangePercent = 0 --def 30
end

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"RenderSettings")
end
