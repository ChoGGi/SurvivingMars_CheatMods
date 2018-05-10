local UsualIcon = "UI/Icons/Sections/attention.tga"

function ChoGGi.ShowInterfaceInScreenshots_Toggle()
  hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
  ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots = not ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Interface in screenshots: " .. tostring(ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots),
    "Interface",UsualIcon
  )
end

function ChoGGi.TakeScreenshot(Bool)
  if Bool == true then
    CreateRealTimeThread(function()
      WaitNextFrame(3)
      LockCamera("Screenshot")
      MovieWriteScreenshot(GenerateScreenshotFilename("SSAA","AppData/"), 0, 64, false)
      UnlockCamera("Screenshot")
    end)
  else
    WriteScreenshot(GenerateScreenshotFilename("SS", "AppData/"))
  end
end

function ChoGGi.ResetECMSettings()
  local file = ChoGGi.SettingsFile
  local old = file .. ".old"

  local ResetSettings = function()
    ChoGGi.ResetSettings = true

    ThreadLockKey(old)
    AsyncCopyFile(file,old)
    ThreadUnlockKey(old)

    ThreadLockKey(file)
    AsyncFileDelete(ChoGGi.SettingsFile)
    ThreadUnlockKey(file)

    ChoGGi.MsgPopup("Restart to take effect.","Reset!",UsualIcon)

  end

  ChoGGi.QuestionBox("Are you sure you want to reset ECM settings?\n\nOld settings are saved as " .. old,ResetSettings,"Reset!")
end

function ChoGGi.SignsInterface_Toggle()
  ToggleSigns()
  ChoGGi.MsgPopup("Sign, sign, everywhere a sign.\nBlockin' out the scenery, breakin' my mind.\nDo this, don't do that, can't you read the sign?",
    "Signs",UsualIcon,true
  )
end

function ChoGGi.OnScreenHints_Toggle()
  SetHintNotificationsEnabled(not HintsEnabled)
  UpdateOnScreenHintDlg()
  ChoGGi.MsgPopup(HintsEnabled,"Hints",UsualIcon)
end

function ChoGGi.OnScreenHints_Reset()
  g_ShownOnScreenHints = {}
  UpdateOnScreenHintDlg()
  ChoGGi.MsgPopup("Hints Reset!","Hints",UsualIcon)
end

function ChoGGi.NeverShowHints_Toggle()
  ChoGGi.CheatMenuSettings.DisableHints = not ChoGGi.CheatMenuSettings.DisableHints
  if ChoGGi.CheatMenuSettings.DisableHints then
    mapdata.DisableHints = true
    HintsEnabled = false
  else
    mapdata.DisableHints = false
    HintsEnabled = true
  end
  ChoGGi.WriteSettings()

  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DisableHints) .. ": Bye bye hints","Hints","UI/Icons/Sections/attention.tga")
end

function ChoGGi.MenuHelp_ReportBug()
  if Platform.ged then
    return
  end
  CreateRealTimeThread(function()
    CreateBugReportDlg()
  end)
end

function ChoGGi.MenuHelp_About()
  CreateRealTimeThread(
    WaitCustomPopupNotification,
    "Help",
    "Hover mouse over menu item to get description and enabled status" ..
      "\nIf there isn't a status then it's likely a list of options to choose from" ..
      "\n\nFor any issues; please report them to my github/nexusmods page, or email ECM@choggi.org",
    {"OK"}
  )
end

