function ChoGGi.ToggleInfopanelCheats()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.CheatMenuSettings.ToggleInfopanelCheats = config.BuildingInfopanelCheats
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("HAXOR",
   "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.BlockCheatEmpty()
  ChoGGi.SetBlockCheatEmpty()
  ChoGGi.CheatMenuSettings.BlockCheatEmpty = not ChoGGi.CheatMenuSettings.BlockCheatEmpty
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Camera Zoom Speed",
   "Camera","UI/Icons/Sections/warning.tga"
  )
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
  AddConsoleLog("ChoGGi: MenuTogglesFunc.lua",true)
end
