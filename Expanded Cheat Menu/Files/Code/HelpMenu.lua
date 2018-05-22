local icon = "new_city.tga"

function ChoGGi.MsgFuncs.HelpMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  --------------------screenshot
  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Screenshot",
    ChoGGi.MenuFuncs.TakeScreenshot,
    "-PrtScr",
    "Write screenshot",
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Screenshot Upsampled",
    function()
      ChoGGi.MenuFuncs.TakeScreenshot(true)
    end,
    "-Ctrl-PrtScr",
    "Write screenshot upsampled",
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Show Interface in Screenshots",
    ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ShowInterfaceInScreenshots and "(Enabled)" or "(Disabled)"
      return des .. " Do you want to see the interface in screenshots?"
    end,
    "toggle_dtm_slots.tga"
  )

  --------------------Interface
  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/Toggle Interface",
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    "Ctrl-Alt-I",
    nil,
    "ToggleSelectionOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/Toggle Signs",
    ChoGGi.MenuFuncs.SignsInterface_Toggle,
    "Ctrl-Alt-S",
    "Concrete, metal deposits, not working, etc...",
    "ToggleMarkers.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/[16]Toggle on-screen hints",
    ChoGGi.MenuFuncs.OnScreenHints_Toggle,
    nil,
    "Don't show hints for this game",
    "HideUnselected.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/[17]Reset on-screen hints",
    ChoGGi.MenuFuncs.OnScreenHints_Reset,
    nil,
    "Just in case you wanted to see them again.",
    "HideSelected.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/[18]Never Show Hints",
    ChoGGi.MenuFuncs.NeverShowHints_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableHints and "(Enabled)" or "(Disabled)"
      return des .. " No more hints ever."
    end,
    "set_debug_texture.tga"
  )
  --------------------help
  ChoGGi.ComFuncs.AddAction(
    "[999]Help/About ECM",
    ChoGGi.MenuFuncs.MenuHelp_About,
    nil,
    "Expanded Cheat Menu info dialog.",
    "help.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/Report Bug",
    ChoGGi.MenuFuncs.MenuHelp_ReportBug,
    "Ctrl-F1",
    "Report Bug\n\nThis doesn't go to ECM author, if you have a bug with ECM; see Help>About.",
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[999]Reset ECM Settings",
    ChoGGi.MenuFuncs.ResetECMSettings,
    nil,
    "Reset all settings to default (restart to enable).",
    "ToggleEnvMap.tga"
  )

end
