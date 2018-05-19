local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables
local cMenuFuncs = ChoGGi.MenuFuncs

local UsualIcon = "UI/Icons/Sections/attention.tga"

function cMenuFuncs.ShowInterfaceInScreenshots_Toggle()
  hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
  ChoGGi.UserSettings.ShowInterfaceInScreenshots = not ChoGGi.UserSettings.ShowInterfaceInScreenshots

  cSettingFuncs.WriteSettings()
  cComFuncs.MsgPopup("Interface in screenshots: " .. tostring(ChoGGi.UserSettings.ShowInterfaceInScreenshots),
    "Interface",UsualIcon
  )
end

function cMenuFuncs.TakeScreenshot(Bool)
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

function cMenuFuncs.ResetECMSettings()
  local file = ChoGGi.SettingsFile
  local old = file .. ".old"

  local ResetSettings = function()

    ThreadLockKey(old)
    AsyncCopyFile(file,old)
    ThreadUnlockKey(old)

    ThreadLockKey(file)
    AsyncFileDelete(ChoGGi.SettingsFile)
    ThreadUnlockKey(file)

    --so we don't save file on exit
    ChoGGi.Temp.CallBackFunc = true

    cComFuncs.MsgPopup("Restart to take effect.","Reset!",UsualIcon)

  end

  cComFuncs.QuestionBox(
    "Are you sure you want to reset ECM settings?\n\nOld settings are saved as " .. old .. "\n\nRestart to take effect.",
    CallBackFunc,
    "Reset!"
  )
end

function cMenuFuncs.SignsInterface_Toggle()
  ToggleSigns()
  cComFuncs.MsgPopup("Sign, sign, everywhere a sign.\nBlockin' out the scenery, breakin' my mind.\nDo this, don't do that, can't you read the sign?",
    "Signs",UsualIcon,true
  )
end

function cMenuFuncs.OnScreenHints_Toggle()
  SetHintNotificationsEnabled(not HintsEnabled)
  UpdateOnScreenHintDlg()
  cComFuncs.MsgPopup(HintsEnabled,"Hints",UsualIcon)
end

function cMenuFuncs.OnScreenHints_Reset()
  g_ShownOnScreenHints = {}
  UpdateOnScreenHintDlg()
  cComFuncs.MsgPopup("Hints Reset!","Hints",UsualIcon)
end

function cMenuFuncs.NeverShowHints_Toggle()
  ChoGGi.UserSettings.DisableHints = not ChoGGi.UserSettings.DisableHints
  if ChoGGi.UserSettings.DisableHints then
    mapdata.DisableHints = true
    HintsEnabled = false
  else
    mapdata.DisableHints = false
    HintsEnabled = true
  end
  cSettingFuncs.WriteSettings()

  cComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DisableHints) .. ": Bye bye hints","Hints","UI/Icons/Sections/attention.tga")
end

function cMenuFuncs.MenuHelp_ReportBug()
  if Platform.ged then
    return
  end
  CreateRealTimeThread(function()
    CreateBugReportDlg()
  end)
end

function cMenuFuncs.MenuHelp_About()
  ChoGGi.ComFuncs.MsgWait(
    "Hover mouse over menu item to get description and enabled status" ..
    "\nIf there isn't a status then it's likely a list of options to choose from" ..
    "\n\nFor any issues; please report them to my github/nexusmods page, or email " .. ChoGGi.email,
    "Help"
  )
end

