
function ChoGGi.ChangeGameLogo()
  local ListActual = {}
  for _,Value in ipairs(DataInstances.MissionLogo) do
    if Value.name ~= "random" then
      table.insert(ListActual,Value.name)
    end
  end

  table.sort(ListActual)
  local ListDisplay = {}
  for i = 1, #ListActual do
    local Value = DataInstances.MissionLogo[ListActual[i]]
    table.insert(ListDisplay,_InternalTranslate(Value.display_name))
  end

  local TempFunc = function(choice)
    ChoGGi.SetNewLogo(ListActual[choice],ListDisplay[choice])
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set New Logo",1)
end

function ChoGGi.SetNewLogo(sName,sDisplay)
  --any newly built/landed uses this logo
  g_CurrentMissionParams.idMissionLogo = sName

  --loop through landed rockets and change logo
  for _,object in ipairs(UICity.labels.AllRockets or empty_table) do
    local tempLogo = object:GetAttach("Logo")
    if tempLogo then
      tempLogo:ChangeEntity(
        DataInstances.MissionLogo[g_CurrentMissionParams.idMissionLogo].entity_name
      )
    end
  end
  --same for any buildings that use the logo
  for _,object in ipairs(UICity.labels.Building or empty_table) do
    local tempLogo = object:GetAttach("Logo")
    if tempLogo then
      tempLogo:ChangeEntity(
        DataInstances.MissionLogo[g_CurrentMissionParams.idMissionLogo].entity_name
      )
    end
  end

  ChoGGi.MsgPopup("Logo: " .. sDisplay,
    "Logo","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.DisableTextureCompression_Toggle()
  ChoGGi.CheatMenuSettings.DisableTextureCompression = not ChoGGi.CheatMenuSettings.DisableTextureCompression

  hr.TR_ToggleTextureCompression = 1

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Texture Compression: " .. tostring(ChoGGi.CheatMenuSettings.DisableTextureCompression),
   "Video","UI/Icons/Anomaly_Event.tga"
  )
end

function ChoGGi.SetShadowmapSize()
  local ListDisplay = {"Default (restart to enable)","Crap (256)","Lower (512)","Low (1536) < Menu Option","Medium (2048) < Menu Option","High (4096) < Menu Option","Higher (8192)","Highest (16384)"}
  local ListActual = {false,256,512,1536,2048,4096,8192,16384}
  local TempFunc = function(choice)
    if choice == 1 then
      ChoGGi.CheatMenuSettings.ShadowmapSize = nil
    else
      ChoGGi.CheatMenuSettings.ShadowmapSize = ListActual[choice]
      hr.ShadowmapSize = ListActual[choice]
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("ShadowmapSize: " .. ListActual[choice],
     "Video","UI/Icons/Anomaly_Event.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Shadowmap Size",1," Warning: Highest uses a couple extra gigs of vram")
end

function ChoGGi.HigherShadowDist_Toggle()
  ChoGGi.CheatMenuSettings.HigherShadowDist = not ChoGGi.CheatMenuSettings.HigherShadowDist
  if ChoGGi.CheatMenuSettings.HigherShadowDist then
    hr.ShadowRangeOverride = 1000000
    hr.ShadowFadeOutRangePercent = 0
  else
    hr.ShadowRangeOverride = 0
    hr.ShadowFadeOutRangePercent = 30
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Higher Shadow Render Dist: " .. tostring(ChoGGi.CheatMenuSettings.HigherShadowDist),
   "Video","UI/Icons/Anomaly_Event.tga"
  )
end

function ChoGGi.HigherRenderDist_Toggle()
  ChoGGi.CheatMenuSettings.HigherRenderDist = not ChoGGi.CheatMenuSettings.HigherRenderDist
  if ChoGGi.CheatMenuSettings.HigherRenderDist then
    hr.LODDistanceModifier = 600
  else
    hr.LODDistanceModifier = 120
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Higher Render Dist: " .. tostring(ChoGGi.CheatMenuSettings.HigherRenderDist),
   "Video","UI/Icons/Anomaly_Event.tga"
  )
end

function ChoGGi.CameraFree_Toggle()
  if not mapdata.GameLogic then
    return
  end
  if cameraFly.IsActive() then
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS.Activate(1)
    engineShowMouseCursor()
    print("Camera RTS")
  else
    cameraFly.Activate(1)
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
    --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
    engineHideMouseCursor()
    print("Camera Fly")
  end
  --resets zoom so...
  ChoGGi.SetCameraSettings()
end

function ChoGGi.CameraFollow_Toggle()
  --it was on the free camera so
  if not mapdata.GameLogic then
    return
  end
  local obj = SelectedObj or SelectionMouseObj()

  --turn it off?
  if camera3p.IsActive() then
    engineShowMouseCursor()
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS.Activate(1)
    --reset camera fov settings
    if ChoGGi.cameraFovX then
      camera.SetFovX(ChoGGi.cameraFovX)
    end
    --show log again if it was hidden
    if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
      cls() --if it's going to spam the log, might as well clear it
      ToggleConsoleLog()
    end
    --reset camera zoom settings
    ChoGGi.SetCameraSettings()
    return
  --crashes game if we attach to "false"
  elseif not obj then
    return
  end
  --let user know the camera mode
  print("Camera Follow")
  --we only want to follow one object
  if ChoGGi.LastFollowedObject then
    camera3p.DetachObject(ChoGGi.LastFollowedObject)
  end
  --save for DetachObject
  ChoGGi.LastFollowedObject = obj
  --save for fovX reset
  ChoGGi.cameraFovX = camera.GetFovX()
  --zoom further out unless it's a colonist
  if not obj.base_death_age then
    --up the horizontal fov so we're further away from object
    camera.SetFovX(8400)
  end
  --consistent zoom level
  cameraRTS.SetZoom(8000)
  --Activate it
  camera3p.Activate(1)
  camera3p.AttachObject(obj)
  camera3p.SetLookAtOffset(point(0,0,-1500))
  camera3p.SetEyeOffset(point(0,0,-1000))
  --moving mouse moves camera
  camera3p.EnableMouseControl(true)
  --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
  engineHideMouseCursor()

  --toggle showing console history as console spams transparent something (and it'd be annoying to replace that function)
  if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
    ToggleConsoleLog()
  end

  --if it's a rover then stop the ctrl control mode from being active (from pressing ctrl-shift-f)
  pcall(function()
    obj:SetControlMode(false)
  end)
end
--LogCameraPos(print)
function ChoGGi.CursorVisible_Toggle()
  if IsMouseCursorHidden() then
    engineShowMouseCursor()
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
  else
    engineHideMouseCursor()
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
  end
end

function ChoGGi.InfopanelCheats_Toggle()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.CheatMenuSettings.ToggleInfopanelCheats = config.BuildingInfopanelCheats
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ToggleInfopanelCheats) .. ": HAXOR",
   "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.InfopanelCheatsCleanup_Toggle()
  ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane = not ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane

  if ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane then
    ChoGGi.InfopanelCheatsCleanup()
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane) .. ": Cleanup",
   "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.BorderScrolling_Toggle()
  ChoGGi.CheatMenuSettings.BorderScrollingToggle = not ChoGGi.CheatMenuSettings.BorderScrollingToggle
  ChoGGi.SetCameraSettings()
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.BorderScrollingToggle) .. ": Mouse Border Scrolling",
   "BorderScrolling","UI/Icons/IPButtons/status_effects.tga"
  )
end

function ChoGGi.BorderScrollingArea_Toggle()
  ChoGGi.CheatMenuSettings.BorderScrollingArea = not ChoGGi.CheatMenuSettings.BorderScrollingArea
  ChoGGi.SetCameraSettings()
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.BorderScrollingArea) .. ": Mouse Border Scrolling",
   "BorderScrolling","UI/Icons/IPButtons/status_effects.tga"
  )
end

function ChoGGi.CameraZoom_Toggle()
  ChoGGi.CheatMenuSettings.CameraZoomToggle = not ChoGGi.CheatMenuSettings.CameraZoomToggle
  ChoGGi.SetCameraSettings()
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CameraZoomToggle) .. ": Camera Zoom",
   "Camera","UI/Icons/IPButtons/status_effects.tga"
  )
end

function ChoGGi.PipesPillarsSpacing_Toggle()
  if Consts.PipesPillarSpacing == 1000 then
    Consts.PipesPillarSpacing = ChoGGi.Consts.PipesPillarSpacing
  else
    Consts.PipesPillarSpacing = 1000
  end
  ChoGGi.CheatMenuSettings.PipesPillarSpacing = Consts.PipesPillarSpacing
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.PipesPillarSpacing) .. ": Is that a rocket in your pocket?",
   "Buildings","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.ShowAllTraits_Toggle()
  ChoGGi.CheatMenuSettings.ShowAllTraits = not ChoGGi.CheatMenuSettings.ShowAllTraits
  if ChoGGi.CheatMenuSettings.ShowAllTraits then
    g_SchoolTraits = ChoGGi.PositiveTraits
    g_SanatoriumTraits = ChoGGi.NegativeTraits
  else
    g_SchoolTraits = {"Nerd","Composed","Enthusiast","Religious","Survivor"}
    g_SanatoriumTraits = {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ShowAllTraits) .. ": Good for what ails you",
   "Traits","UI/Icons/Upgrades/factory_ai_04.tga"
  )
end

function ChoGGi.ResearchQueueLarger_Toggle()
  if const.ResearchQueueSize == 25 then
    const.ResearchQueueSize = ChoGGi.Consts.ResearchQueueSize
  else
    const.ResearchQueueSize = 25
  end
  ChoGGi.CheatMenuSettings.ResearchQueueSize = const.ResearchQueueSize
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.ResearchQueueSize .. ": Nerdgasm",
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.ScannerQueueLarger_Toggle()
  if const.ExplorationQueueMaxSize == 100 then
    const.ExplorationQueueMaxSize = ChoGGi.Consts.ExplorationQueueMaxSize
  else
    const.ExplorationQueueMaxSize = 100
  end
  ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize = const.ExplorationQueueMaxSize
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize .. ": scans at a time.",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.SetGameSpeed()
  local ListDisplay = {"(Default)","Double (2)","Triple (3)","Quadruple (4)","Octuple (8)","Sexdecuple (16)","Duotriguple (32)","Quattuorsexaguple (64)"}
  local ListActual = {1,2,3,4,8,16,32,64}
  local hint = "Current speed: " .. const.mediumGameSpeed .. " (3 = Default, 9 = Triple)"
  local TempFunc = function(choice)
    const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * ListActual[choice]
    const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * ListActual[choice]
    --so it changes the speed
    ChangeGameSpeedState(-1)
    ChangeGameSpeedState(1)
    --update settings
    ChoGGi.CheatMenuSettings.mediumGameSpeed = const.mediumGameSpeed
    ChoGGi.CheatMenuSettings.fastGameSpeed = const.fastGameSpeed
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(ListDisplay[choice] .. ": I think I can...",
     "Speed","UI/Icons/Notifications/timer.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Game Speed",1,hint)
end
