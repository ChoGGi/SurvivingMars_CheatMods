
function ChoGGi.SetObjectOpacity()
  local sel = SelectedObj or SelectionMouseObj()
  if not sel then
    ChoGGi.MsgPopup("Nothing selected or moused over","Object")
    return
  end

  local ItemList = {
    {text = 0,value = 0},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
  }
  --callback
  local CallBackFunc = function(choice)
    --ChoGGi.ListChoiceCustomDialog_CheckBox1

    local value = choice[1].value
    if type(value) == "number" then
      sel:SetOpacity(value)
    end
    ChoGGi.MsgPopup("Selected: " .. choice[1].text,
      "Opacity","UI/Icons/Sections/attention.tga"
    )
  end
  local hint = "Current: " .. sel:GetOpacity() .. "\n\nYou can still select items after making them invisible (0), but it may take some time :)."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Opacity",hint)

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
  local hint_highest = "Warning: Highest uses vram (one gig for starter base, a couple for large base)."
  local ItemList = {
    {text = " Default",value = false,hint = "restart to enable"},
    {text = "1 Crap (256)",value = 256},
    {text = "2 Lower (512)",value = 512},
    {text = "3 Low (1536) < Menu Option",value = 1536},
    {text = "4 Medium (2048) < Menu Option",value = 2048},
    {text = "5 High (4096) < Menu Option",value = 4096},
    {text = "6 Higher (8192)",value = 8192},
    {text = "7 Highest (16384)",value = 16384,hint = hint_highest},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      if value > 16384 then
        hr.ShadowmapSize = 16384
      else
        hr.ShadowmapSize = value
      end
      ChoGGi.SetSavedSetting("ShadowmapSize",value)
    else
      ChoGGi.CheatMenuSettings.ShadowmapSize = false
    end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("ShadowmapSize: " .. choice[1].text,
       "Video","UI/Icons/Anomaly_Event.tga"
      )
  end
  local hint = "Current: " .. hr.ShadowmapSize .. "\n\n" .. hint_highest .. "\n\nMax set to 16384."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shadowmap Size",hint)
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

  local DefaultSetting = ChoGGi.Consts.HigherRenderDist
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

function ChoGGi.SetBorderScrolling()
  local DefaultSetting = 5
  local hint_down = "Down scrolling may not work (dependant on aspect ratio?)."
  local ItemList = {
    {text = " Default",value = DefaultSetting},
    {text = 0,value = 0,hint = "disable mouse border scrolling, WASD still works fine."},
    {text = 1,value = 1,hint = hint_down},
    {text = 2,value = 2,hint = hint_down},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 10,value = 10},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.BorderScrollingArea then
    hint = tostring(ChoGGi.CheatMenuSettings.BorderScrollingArea)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetSavedSetting("BorderScrollingArea",value)

      ChoGGi.SetCameraSettings()

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].value .. ": Mouse Border Scrolling",
       "BorderScrolling","UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"TitleBar","Current: " .. hint)

end

function ChoGGi.CameraZoom_Toggle()
  local DefaultSetting = ChoGGi.Consts.CameraZoomToggle
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 16000,value = 16000},
    {text = 20000,value = 20000},
    {text = 24000,value = 24000, hint = "What used to be the default for this ECM setting"},
    {text = 32000,value = 32000},
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
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Camera Zoom","Current: " .. hint)
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

  local current = "Default"
  pcall(function()
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
  end)

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * value
      const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * value
      --so it changes the speed
      ChangeGameSpeedState(-1)
      ChangeGameSpeedState(1)
      --update settings
      ChoGGi.CheatMenuSettings.mediumGameSpeed = const.mediumGameSpeed
      ChoGGi.CheatMenuSettings.fastGameSpeed = const.fastGameSpeed

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": I think I can...",
       "Speed","UI/Icons/Notifications/timer.tga"
      )
    end
  end

  local hint = "Current speed: " .. current
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Game Speed",hint)
end

function ChoGGi.InstantColonyApproval()
  CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay")
  Msg("ColonyApprovalPassed")
  g_ColonyNotViableUntil = -1
end

