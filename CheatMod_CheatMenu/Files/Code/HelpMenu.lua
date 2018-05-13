local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.HelpMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  --------------------screenshot
  CComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Screenshot",
    CMenuFuncs.TakeScreenshot,
    "-PrtScr",
    "Write screenshot",
    "light_model.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Screenshot Upsampled",
    function()
      CMenuFuncs.TakeScreenshot(true)
    end,
    "-Ctrl-PrtScr",
    "Write screenshot upsampled",
    "light_model.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[2]Screenshot/Show Interface in Screenshots",
    CMenuFuncs.ShowInterfaceInScreenshots_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ShowInterfaceInScreenshots and "(Enabled)" or "(Disabled)"
      return des .. " Do you want to see the interface in screenshots?"
    end,
    "toggle_dtm_slots.tga"
  )

  --------------------Interface
  CComFuncs.AddAction(
    "[999]Help/[1]Interface/Toggle Interface",
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    "Ctrl-Alt-I",
    nil,
    "ToggleSelectionOcclusion.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[1]Interface/Toggle Signs",
    CMenuFuncs.SignsInterface_Toggle,
    "Ctrl-Alt-S",
    "Concrete, metal deposits, not working, etc...",
    "ToggleMarkers.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[1]Interface/[16]Toggle on-screen hints",
    CMenuFuncs.OnScreenHints_Toggle,
    nil,
    "Don't show hints for this game",
    "HideUnselected.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[1]Interface/[17]Reset on-screen hints",
    CMenuFuncs.OnScreenHints_Reset,
    nil,
    "Just in case you wanted to see them again.",
    "HideSelected.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[1]Interface/[18]Never Show Hints",
    CMenuFuncs.NeverShowHints_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableHints and "(Enabled)" or "(Disabled)"
      return des .. " No more hints ever."
    end,
    "set_debug_texture.tga"
  )
  --------------------help
  CComFuncs.AddAction(
    "[999]Help/About ECM",
    CMenuFuncs.MenuHelp_About,
    nil,
    "Expanded Cheat Menu info dialog.",
    "help.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/Report Bug",
    CMenuFuncs.MenuHelp_ReportBug,
    "Ctrl-F1",
    "Report Bug\n\nThis doesn't go to ECM author, if you have a bug with ECM; see Help>About.",
    "ReportBug.tga"
  )

  CComFuncs.AddAction(
    "[999]Help/[999]Reset ECM Settings",
    CMenuFuncs.ResetECMSettings,
    nil,
    "Reset all settings to default (restart to enable).",
    "ToggleEnvMap.tga"
  )

end
