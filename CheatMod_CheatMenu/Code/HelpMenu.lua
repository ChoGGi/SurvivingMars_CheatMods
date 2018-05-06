function ChoGGi.HelpMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  --------------------screenshot
  ChoGGi.AddAction(
    "[999]Help/[2]Screenshot/Screenshot",
    ChoGGi.TakeScreenshot,
    "-PrtScr",
    "Write screenshot",
    "light_model.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[2]Screenshot/Screenshot Upsampled",
    function()
      ChoGGi.TakeScreenshot(true)
    end,
    "-Ctrl-PrtScr",
    "Write screenshot upsampled",
    "light_model.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[2]Screenshot/Show Interface in Screenshots",
    ChoGGi.ShowInterfaceInScreenshots_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots and "(Enabled)" or "(Disabled)"
      return des .. " Do you want to see the interface in screenshots?"
    end,
    "toggle_dtm_slots.tga"
  )

  --------------------Interface
  ChoGGi.AddAction(
    "[999]Help/[1]Interface/Toggle Interface",
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    "Ctrl-Alt-I",
    nil,
    "ToggleSelectionOcclusion.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/Toggle Signs",
    ChoGGi.SignsInterface_Toggle,
    "Ctrl-Alt-S",
    "Concrete, metal deposits, not working, etc...",
    "ToggleMarkers.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/[16]Toggle on-screen hints",
    ChoGGi.OnScreenHints_Toggle,
    nil,
    "Don't show hints for this game",
    "HideUnselected.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/[17]Reset on-screen hints",
    ChoGGi.OnScreenHints_Reset,
    nil,
    "Just in case you wanted to see them again.",
    "HideSelected.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[1]Interface/[18]Never Show Hints",
    ChoGGi.NeverShowHints_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.DisableHints and "(Enabled)" or "(Disabled)"
      return des .. " No more hints ever."
    end,
    "set_debug_texture.tga"
  )
  --------------------help
  ChoGGi.AddAction(
    "[999]Help/About ECM",
    ChoGGi.MenuHelp_About,
    nil,
    "Expanded Cheat Menu info dialog.",
    "help.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/Report Bug",
    ChoGGi.MenuHelp_ReportBug,
    "Ctrl-F1",
    "Report Bug\n\nThis doesn't go to ECM author, if you have a bug with ECM; see Help>About.",
    "ReportBug.tga"
  )

  ChoGGi.AddAction(
    "[999]Help/[999]Reset ECM Settings",
    ChoGGi.ResetECMSettings,
    nil,
    "Reset all settings to default (restart to enable).",
    "ToggleEnvMap.tga"
  )

end
