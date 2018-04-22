
function ChoGGi.ChangeGameLogo()
  local ItemList = {}
  for _,Value in ipairs(DataInstances.MissionLogo) do
    if Value.name ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.name,
      })
    end
  end

  local CallBackFunc = function(choice)
    ChoGGi.SetNewLogo(choice[1].value,choice[1].text)
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set New Logo")
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
  local current = hr.ShadowmapSize
  local hint_highest = "Warning: Highest uses vram (one gig for starter base, a couple for large base)."
  local ItemList = {
    {text = " Default (restart to enable)",value = false},
    {text = " Current: " .. current,value = current},
    {text = "Crap (256)",value = 256},
    {text = "Lower (512)",value = 512},
    {text = "Low (1536) < Menu Option",value = 1536},
    {text = "Medium (2048) < Menu Option",value = 2048},
    {text = "High (4096) < Menu Option",value = 4096},
    {text = "Higher (8192)",value = 8192},
    {text = "Highest (16384)",value = 16384,hint = hint_highest},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      hr.ShadowmapSize = value
      ChoGGi.SetSavedSetting("ShadowmapSize",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("ShadowmapSize: " .. choice[1].text,
       "Video","UI/Icons/Anomaly_Event.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shadowmap Size","Current: " .. current .. "\n\n" .. hint_highest)
end

function ChoGGi.HigherShadowDist_Toggle()
  ChoGGi.CheatMenuSettings.HigherShadowDist = not ChoGGi.CheatMenuSettings.HigherShadowDist

  hr.ShadowRangeOverride = ChoGGi.ValueRetOpp(hr.ShadowRangeOverride,0,1000000)
  hr.ShadowFadeOutRangePercent = ChoGGi.ValueRetOpp(hr.ShadowFadeOutRangePercent,30,0)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Higher Shadow Render Dist: " .. tostring(ChoGGi.CheatMenuSettings.HigherShadowDist),
   "Video","UI/Icons/Anomaly_Event.tga"
  )
end

function ChoGGi.HigherRenderDist_Toggle()

  local DefaultSetting = 120
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 240,value = 240,hint = "Minimal FPS hit on large base"},
    {text = 360,value = 360,hint = "Minimal FPS hit on large base"},
    {text = 480,value = 480,hint = "Minimal FPS hit on large base"},
    {text = 600,value = 600,hint = "Small FPS hit on large base"},
    {text = 720,value = 720,hint = "Small FPS hit on large base"},
    {text = 840,value = 840,hint = "FPS hit"},
    {text = 960,value = 960,hint = "FPS hit"},
    {text = 1080,value = 1080,hint = "FPS hit"},
    {text = 1200,value = 1200,hint = "FPS hit"},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.HigherRenderDist then
    hint = tostring(ChoGGi.CheatMenuSettings.HigherRenderDist)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      hr.LODDistanceModifier = value
      ChoGGi.SetSavedSetting("HigherRenderDist",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Higher Render Dist: " .. tostring(ChoGGi.CheatMenuSettings.HigherRenderDist),
       "Video","UI/Icons/Anomaly_Event.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Higher Render Dist","Current: " .. hint)
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
      ChoGGi.ToggleConsoleLog()
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
    ChoGGi.ToggleConsoleLog()
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
  ChoGGi.SetSavedSetting("ToggleInfopanelCheats",config.BuildingInfopanelCheats)

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
  local DefaultSetting = 8000
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 16000,value = 16000},
    {text = 20000,value = 20000},
    {text = 24000,value = 24000},
    {text = 32000,value = 32000},
    {text = 64000,value = 64000},
    {text = 128000,value = 128000},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.CameraZoomToggle then
    hint = tostring(ChoGGi.CheatMenuSettings.CameraZoomToggle)
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetSavedSetting("CameraZoomToggle",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": Camera Zoom",
       "Camera","UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"TitleBar","Current: " .. hint)
end

function ChoGGi.PipesPillarsSpacing_Toggle()
  ChoGGi.SetConstsG("PipesPillarSpacing",ChoGGi.ValueRetOpp(Consts.PipesPillarSpacing,1000,ChoGGi.Consts.PipesPillarSpacing))
  ChoGGi.SetSavedSetting("PipesPillarSpacing",Consts.PipesPillarSpacing)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.PipesPillarSpacing) .. ": Is that a rocket in your pocket?",
   "Buildings","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.ShowAllTraits_Toggle()
  ChoGGi.CheatMenuSettings.ShowAllTraits = not ChoGGi.CheatMenuSettings.ShowAllTraits

  g_SchoolTraits = ChoGGi.ValueRetOpp(
    g_SchoolTraits,
    ChoGGi.PositiveTraits,
    {"Nerd","Composed","Enthusiast","Religious","Survivor"}
  )
  g_SanatoriumTraits = ChoGGi.ValueRetOpp(
    g_SanatoriumTraits,
    ChoGGi.NegativeTraits,
    {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
  )

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ShowAllTraits) .. ": Good for what ails you",
   "Traits","UI/Icons/Upgrades/factory_ai_04.tga"
  )
end

function ChoGGi.ResearchQueueLarger_Toggle()
  const.ResearchQueueSize = ChoGGi.ValueRetOpp(const.ResearchQueueSize,25,ChoGGi.Consts.ResearchQueueSize)
  ChoGGi.SetSavedSetting("ResearchQueueSize",const.ResearchQueueSize)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ResearchQueueSize) .. ": Nerdgasm",
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.ScannerQueueLarger_Toggle()
  const.ExplorationQueueMaxSize = ChoGGi.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
  ChoGGi.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize) .. ": scans at a time.",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.SetGameSpeed()
  local ItemList = {
    {text = " Default",value = 1},
    {text = "1 Double",value = 2},
    {text = "2 Triple",value = 3},
    {text = "3 Quadruple",value = 4},
    {text = "4 Octuple",value = 8},
    {text = "5 Sexdecuple",value = 16},
    {text = "6 Duotriguple",value = 32},
    {text = "7 Quattuorsexaguple",value = 64},
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * amount
      const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * amount
      --so it changes the speed
      ChangeGameSpeedState(-1)
      ChangeGameSpeedState(1)
      --update settings
      ChoGGi.SetSavedSetting("mediumGameSpeed",const.mediumGameSpeed)
      ChoGGi.SetSavedSetting("fastGameSpeed",const.fastGameSpeed)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": I think I can...",
       "Speed","UI/Icons/Notifications/timer.tga"
      )
    end
  end

  local current = "Default"
  if const.mediumGameSpeed == 6 then
    current = "Double"
  elseif const.mediumGameSpeed == 9 then
    current = "Triple"
  elseif const.mediumGameSpeed == 12 then
    current = "Quadruple"
  elseif const.mediumGameSpeed == 24 then
    current = "Octuple"
  elseif const.mediumGameSpeed == 48 then
    current = "Sexdecuple"
  elseif const.mediumGameSpeed == 96 then
    current = "Duotriguple"
  elseif const.mediumGameSpeed == 192 then
    current = "Quattuorsexaguple"
  else
    current = "Custom: " .. const.mediumGameSpeed .. " < base number 3 multipled by custom amount"
  end

  local hint = "Current speed: " .. current
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Game Speed",hint)
end

function ChoGGi.InstantColonyApproval()
  CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay")
  Msg("ColonyApprovalPassed")
  g_ColonyNotViableUntil = -1
end

