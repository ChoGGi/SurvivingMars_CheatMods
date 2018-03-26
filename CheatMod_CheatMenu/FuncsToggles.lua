function ChoGGi.ToggleInfopanelCheats()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.CheatMenuSettings.ToggleInfopanelCheats = config.BuildingInfopanelCheats
  ChoGGi.WriteSettings()
end

function ChoGGi.BorderScrollingToggle()
  ChoGGi.CheatMenuSettings.BorderScrollingToggle = not ChoGGi.CheatMenuSettings.BorderScrollingToggle
  if ChoGGi.CheatMenuSettings.BorderScrollingToggle then
    cameraRTS.SetProperties(1,{ScrollBorder = 0})
  else
    cameraRTS.SetProperties(1,{ScrollBorder = 2})
  end
  ChoGGi.WriteSettings()
end

function ChoGGi.CameraZoomToggle()
  ChoGGi.CheatMenuSettings.CameraZoomToggle = not ChoGGi.CheatMenuSettings.CameraZoomToggle
  if ChoGGi.CheatMenuSettings.CameraZoomToggle then
    cameraRTS.SetProperties(1,{
      MinHeight = 1,
      MaxHeight = 80,
      MinZoom = 1,
      MaxZoom = 24000
    })
  else
    cameraRTS.SetProperties(1,{
      MinHeight = 4,
      MaxHeight = 40,
      MinZoom = 400,
      MaxZoom = 8000
    })
  end
  ChoGGi.WriteSettings()
end

function ChoGGi.CameraZoomToggleSpeed()
  ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed = not ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed
  if ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed then
    cameraRTS.SetProperties(1,{CameraZoomToggleSpeed = 800})
  else
    cameraRTS.SetProperties(1,{CameraZoomToggleSpeed = 230})
  end
  ChoGGi.WriteSettings()
end

function ChoGGi.BlockCheatEmpty()
  ChoGGi.SetBlockCheatEmpty()
  ChoGGi.CheatMenuSettings.BlockCheatEmpty = not ChoGGi.CheatMenuSettings.BlockCheatEmpty
  ChoGGi.WriteSettings()
end

function ChoGGi.DeveloperModeToggle()
  ChoGGi.CheatMenuSettings.developer = not Platform.developer
  ChoGGi.WriteSettings()
  CreateRealTimeThread(WaitCustomPopupNotification,
    "Toggles Dev mode",
    "This adds more menuitems, but it'll change a bunch of labels to *stripped*, "
      .. "and some shortcut keys don't work\r\nrestart to take effect (or select again to disable).",
    {"OK"}
  )
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: FuncsToggles.lua",true)
end
