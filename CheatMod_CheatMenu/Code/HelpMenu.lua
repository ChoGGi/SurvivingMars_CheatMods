--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

--------------------
ChoGGi.AddAction(
  "[999]Help/[2]Screenshot/Show Interface in Screenshots",
  function()
    hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
    ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots = not ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Interface is: " .. tostring(ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots),
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

    ChoGGi.MsgPopup("No more hints stopping gameplay","Hints","UI/Icons/Sections/attention.tga")
  end,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.DisableHints and "(Enabled)" or "(Disabled)"
    return des .. " Stop showing hints."
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
    CreateRealTimeThread(WaitCustomPopupNotification,
      "Help",
      "Hover mouse over menu item to get description and enabled status" ..
        "\nIf menu item has a '+ num' then that means it'll add to the current amount" ..
        "\n(you can add as many times as you want)" ..
        "\n\nFor any issues; please report them to my github/nexusmods page, or email ECM@choggi.org",
      {"OK"}
    )
  end,
  nil,
  "Expanded Cheat Menu info dialog.",
  "ReportBug.tga"
)
