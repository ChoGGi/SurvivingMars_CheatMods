local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.HelpMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  --------------------screenshot
  cComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Screenshot",
    cMenuFuncs.TakeScreenshot,
    "-PrtScr",
    "Write screenshot",
    "light_model.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Screenshot Upsampled",
    function()
      cMenuFuncs.TakeScreenshot(true)
    end,
    "-Ctrl-PrtScr",
    "Write screenshot upsampled",
    "light_model.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Show Interface in Screenshots",
    cMenuFuncs.ShowInterfaceInScreenshots_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ShowInterfaceInScreenshots and "(Enabled)" or "(Disabled)"
      return des .. " Do you want to see the interface in screenshots?"
    end,
    "toggle_dtm_slots.tga"
  )

  --------------------Interface
  cComFuncs.AddAction(
    "[999]Help/[1]Interface/Toggle Interface",
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    "Ctrl-Alt-I",
    nil,
    "ToggleSelectionOcclusion.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[1]Interface/Toggle Signs",
    cMenuFuncs.SignsInterface_Toggle,
    "Ctrl-Alt-S",
    "Concrete, metal deposits, not working, etc...",
    "ToggleMarkers.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[1]Interface/[16]Toggle on-screen hints",
    cMenuFuncs.OnScreenHints_Toggle,
    nil,
    "Don't show hints for this game",
    "HideUnselected.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[1]Interface/[17]Reset on-screen hints",
    cMenuFuncs.OnScreenHints_Reset,
    nil,
    "Just in case you wanted to see them again.",
    "HideSelected.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[1]Interface/[18]Never Show Hints",
    cMenuFuncs.NeverShowHints_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableHints and "(Enabled)" or "(Disabled)"
      return des .. " No more hints ever."
    end,
    "set_debug_texture.tga"
  )
  --------------------help
  cComFuncs.AddAction(
    "[999]Help/About ECM",
    cMenuFuncs.MenuHelp_About,
    nil,
    "Expanded Cheat Menu info dialog.",
    "help.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/Report Bug",
    cMenuFuncs.MenuHelp_ReportBug,
    "Ctrl-F1",
    "Report Bug\n\nThis doesn't go to ECM author, if you have a bug with ECM; see Help>About.",
    "ReportBug.tga"
  )

  cComFuncs.AddAction(
    "[999]Help/[999]Reset ECM Settings",
    cMenuFuncs.ResetECMSettings,
    nil,
    "Reset all settings to default (restart to enable).",
    "ToggleEnvMap.tga"
  )

end
