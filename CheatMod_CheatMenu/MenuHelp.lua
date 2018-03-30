--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

ChoGGi.AddAction(
  "[999]Help/Screenshot No Interface",
  function()
    CreateRealTimeThread(function()
      WriteScreenshot(GenerateScreenshotFilename("SS", "AppData/"))
    end)
  end,
  "-Ctrl-PrtScr",
  "Write screenshot without the interface (still shows signs).",
  "light_model.tga"
)

ChoGGi.AddAction(
  "[999]Help/Screenshot",
  function()
    CreateRealTimeThread(function()
      table.change(hr, "print_screen", {InterfaceInScreenshot = 1})
      WaitNextFrame(3)
      LockCamera("Screenshot")
      MovieWriteScreenshot(GenerateScreenshotFilename("SS", "AppData/"), 0, 32, false)
      UnlockCamera("Screenshot")
      table.restore(hr, "print_screen")
    end)
  end,
  "-PrtScr",
  "Write screenshot",
  "light_model.tga"
)

ChoGGi.AddAction(
  "[999]Help/Toggle Interface",
  function()
    hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
  end,
  "Ctrl-Alt-I"
)
--[[ alt interface toggle
rawset(_G, "OrgXRender", rawget(_G, "OrgXRender") or XRender)
if XRender == OrgXRender then
  function XRender() end
else
  XRender = OrgXRender
end
UIL.Invalidate()
--]]

ChoGGi.AddAction(
  "[999]Help/Toggle Signs",
  function()
    ToggleSigns()
    ChoGGi.MsgPopup("Sign, sign, everywhere a sign.\nBlockin' out the scenery, breakin' my mind.\nDo this, don't do that, can't you read the sign?",
      "Signs","UI/Icons/Sections/attention.tga")
  end,
  "Ctrl-Alt-S",
  "Concrete, metal deposits, etc..."
)

ChoGGi.AddAction(
  "[999]Help/Show Last Hint",
  function(_, controller_id)
    ShowLastHint()
  end,
  "F1",
  "Show Last Hint"
)

ChoGGi.AddAction(
  "[999]Help/Toggle Free Camera",
  ChoGGi.FreeCamera_Toggle,
  "Shift-C",
  "I believe I can fly."
)

ChoGGi.AddAction(
  "[999]Help/[16]Toggle on-screen hints",
  function()
    SetHintNotificationsEnabled(not HintsEnabled)
    UpdateOnScreenHintDlg()
    ChoGGi.MsgPopup(HintsEnabled,"Hints","UI/Icons/Sections/attention.tga")
  end
)

ChoGGi.AddAction(
  "[999]Help/[17]Reset on-screen hints",
  function()
    g_ShownOnScreenHints = {}
    UpdateOnScreenHintDlg()
    ChoGGi.MsgPopup("Hints Reset!","Hints","UI/Icons/Sections/attention.tga")
  end
)

ChoGGi.AddAction(
  "[999]Help/About",
  function()
    CreateRealTimeThread(WaitCustomPopupNotification,
      "Help",
      "Hover mouse over menu item to get description and enabled status" ..
        "\nIf menu item has a '+ num' then that means it'll add to the current amount" ..
        "\n(you can add as many times as you want)",
      {"OK"}
    )
  end,
  nil,
  nil,
  "ReportBug.tga"
)

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"MenuHelp")
end
