local UsualIcon = "UI/Icons/Sections/attention.tga"

function ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle()
  hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
  ChoGGi.UserSettings.ShowInterfaceInScreenshots = not ChoGGi.UserSettings.ShowInterfaceInScreenshots

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup("Interface in screenshots: " .. tostring(ChoGGi.UserSettings.ShowInterfaceInScreenshots),
    "Interface",UsualIcon
  )
end

function ChoGGi.MenuFuncs.TakeScreenshot(Bool)
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

function ChoGGi.MenuFuncs.ResetECMSettings()
  local file = ChoGGi.SettingsFile
  local old = file .. ".old"

  local CallBackFunc = function()

    ThreadLockKey(old)
    AsyncCopyFile(file,old)
    ThreadUnlockKey(old)

    ThreadLockKey(file)
    AsyncFileDelete(ChoGGi.SettingsFile)
    ThreadUnlockKey(file)

    --so we don't save file on exit
    ChoGGi.Temp.ResetSettings = true

    ChoGGi.ComFuncs.MsgPopup("Restart to take effect.","Reset!",UsualIcon)

  end

  ChoGGi.ComFuncs.QuestionBox(
    "Are you sure you want to reset ECM settings?\n\nOld settings are saved as " .. old .. "\n\nRestart to take effect.",
    CallBackFunc,
    "Reset!"
  )
end

function ChoGGi.MenuFuncs.SignsInterface_Toggle()
  ToggleSigns()
  ChoGGi.ComFuncs.MsgPopup("Sign, sign, everywhere a sign.\nBlockin' out the scenery, breakin' my mind.\nDo this, don't do that, can't you read the sign?",
    "Signs",UsualIcon,true
  )
end

function ChoGGi.MenuFuncs.OnScreenHints_Toggle()
  SetHintNotificationsEnabled(not HintsEnabled)
  UpdateOnScreenHintDlg()
  ChoGGi.ComFuncs.MsgPopup(HintsEnabled,"Hints",UsualIcon)
end

function ChoGGi.MenuFuncs.OnScreenHints_Reset()
  g_ShownOnScreenHints = {}
  UpdateOnScreenHintDlg()
  ChoGGi.ComFuncs.MsgPopup("Hints Reset!","Hints",UsualIcon)
end

function ChoGGi.MenuFuncs.NeverShowHints_Toggle()
  ChoGGi.UserSettings.DisableHints = not ChoGGi.UserSettings.DisableHints
  if ChoGGi.UserSettings.DisableHints then
    mapdata.DisableHints = true
    HintsEnabled = false
  else
    mapdata.DisableHints = false
    HintsEnabled = true
  end
  ChoGGi.SettingFuncs.WriteSettings()

  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DisableHints) .. ": Bye bye hints","Hints","UI/Icons/Sections/attention.tga")
end

function ChoGGi.MenuFuncs.MenuHelp_ReportBug()
  if Platform.ged then
    return
  end
  CreateRealTimeThread(function()
    CreateBugReportDlg()
  end)
end

function ChoGGi.MenuFuncs.MenuHelp_About()
  ChoGGi.ComFuncs.MsgWait(
    "Hover mouse over menu item to get description and enabled status" ..
    "\nIf there isn't a status then it's likely a list of options to choose from" ..
    "\n\nFor any issues; please report them to my github/nexusmods page, or email " .. ChoGGi.email,
    "Help"
  )
end

