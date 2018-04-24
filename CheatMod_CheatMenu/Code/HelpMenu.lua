function OnMsg.Resume()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  --------------------
  ChoGGi.AddAction(
    "[999]Help/[2]Screenshot/Show Interface in Screenshots",
    function()
      hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
      ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots = not ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots
      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Interface in screenshots: " .. tostring(ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots),
        "Interface","UI/Icons/Sections/attention.tga"
      )
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots and "(Enabled)" or "(Disabled)"
      return des .. " Toggle showing interface in screenshots."
    end,
    "light_model.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[2]Screenshot/Screenshot",
    function()
      WriteScreenshot(GenerateScreenshotFilename("SS", "AppData/"))
    end,
    "-PrtScr",
    "Write screenshot",
    "light_model.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[999]Reset ECM Settings",
    function()
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

        ChoGGi.MsgPopup("Restart to take effect.","Reset!","UI/Icons/Sections/attention.tga")

      end

      ChoGGi.QuestionBox("Are you sure you want to reset ECM settings?\n\nOld settings are saved as " .. old,ResetSettings,"Reset!")
    end,
    nil,
    "Reset all settings to default (restart to enable).",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[2]Screenshot/Screenshot Upsampled",
    function()
      CreateRealTimeThread(function()
        WaitNextFrame(3)
        LockCamera("Screenshot")
        MovieWriteScreenshot(GenerateScreenshotFilename("SSAA","AppData/"), 0, 64, false)
        UnlockCamera("Screenshot")
      end)
    end,
    "-Ctrl-PrtScr",
    "Write screenshot upsampled",
    "light_model.tga"
  )
  --------------------
  ChoGGi.AddAction(
    "[999]Help/[1]Interface/Toggle Interface",
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    "Ctrl-Alt-I"
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/Toggle Signs",
    function()
      ToggleSigns()
      ChoGGi.MsgPopup("Sign, sign, everywhere a sign.\nBlockin' out the scenery, breakin' my mind.\nDo this, don't do that, can't you read the sign?",
        "Signs","UI/Icons/Sections/attention.tga"
      )
    end,
    "Ctrl-Alt-S",
    "Concrete, metal deposits, etc..."
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/[16]Toggle on-screen hints",
    function()
      SetHintNotificationsEnabled(not HintsEnabled)
      UpdateOnScreenHintDlg()
      ChoGGi.MsgPopup(HintsEnabled,"Hints","UI/Icons/Sections/attention.tga")
    end
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/[17]Reset on-screen hints",
    function()
      g_ShownOnScreenHints = {}
      UpdateOnScreenHintDlg()
      ChoGGi.MsgPopup("Hints Reset!","Hints","UI/Icons/Sections/attention.tga")
    end
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/[18]Never Show Hints",
    function()
      ChoGGi.CheatMenuSettings.DisableHints = not ChoGGi.CheatMenuSettings.DisableHints
      if ChoGGi.CheatMenuSettings.DisableHints then
        mapdata.DisableHints = true
      else
        mapdata.DisableHints = false
      end
      ChoGGi.WriteSettings()

      ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DisableHints) .. ": Bye bye hints","Hints","UI/Icons/Sections/attention.tga")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.DisableHints and "(Enabled)" or "(Disabled)"
      return des .. " No more hints popping up and stopping gameplay."
    end
  )
  --------------------
  ChoGGi.AddAction(
    "[999]Help/Report Bug",
    function()
      CreateRealTimeThread(function()
        CreateBugReportDlg()
      end)
    end,
    "Ctrl-F1",
    "Report Bug\n\nThis doesn't go to ECM author, if you have a bug with ECM; see Help>About.",
    "ReportBug.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/About",
    function()
      CreateRealTimeThread(
        WaitCustomPopupNotification,
        "Help",
        "Hover mouse over menu item to get description and enabled status" ..
          "\nIf there isn't a status then it's likely a list of options to choose from" ..
          "\n\nFor any issues; please report them to my github/nexusmods page, or email ECM@choggi.org",
        {"OK"}
      )
    end,
    nil,
    "Expanded Cheat Menu info dialog.",
    "ReportBug.tga"
  )
end
