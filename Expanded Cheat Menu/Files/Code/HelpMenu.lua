--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.HelpMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  --------------------screenshot
  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[2]Screenshot/" .. ChoGGi.ComFuncs.Trans(302535920000657,"Screenshot"),
    ChoGGi.MenuFuncs.TakeScreenshot,
    "-PrtScr",
    ChoGGi.ComFuncs.Trans(302535920000658,"Write screenshot"),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[2]Screenshot/" .. ChoGGi.ComFuncs.Trans(302535920000659,"Screenshot Upsampled"),
    function()
      ChoGGi.MenuFuncs.TakeScreenshot(true)
    end,
    "-Ctrl-PrtScr",
    ChoGGi.ComFuncs.Trans(302535920000660,"Write screenshot upsampled"),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[2]Screenshot/" .. ChoGGi.ComFuncs.Trans(302535920000661,"Show Interface in Screenshots"),
    ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.ShowInterfaceInScreenshots and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000662,"Do you want to see the interface in screenshots?")
    end,
    "toggle_dtm_slots.tga"
  )

  --------------------Interface
  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/" .. ChoGGi.ComFuncs.Trans(302535920000663,"Toggle Interface"),
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    "Ctrl-Alt-I",
    nil,
    "ToggleSelectionOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/" .. ChoGGi.ComFuncs.Trans(302535920000664,"Toggle Signs"),
    ChoGGi.MenuFuncs.SignsInterface_Toggle,
    "Ctrl-Alt-S",
    ChoGGi.ComFuncs.Trans(302535920000665,"Concrete, metal deposits, not working, etc..."),
    "ToggleMarkers.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/[16]" .. ChoGGi.ComFuncs.Trans(302535920000666,"Toggle on-screen hints"),
    ChoGGi.MenuFuncs.OnScreenHints_Toggle,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000667,"Don't show hints for this game"),
    "HideUnselected.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/[17]" .. ChoGGi.ComFuncs.Trans(302535920000668,"Reset on-screen hints"),
    ChoGGi.MenuFuncs.OnScreenHints_Reset,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000669,"Just in case you wanted to see them again."),
    "HideSelected.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[1]Interface/[18]" .. ChoGGi.ComFuncs.Trans(302535920000670,"Never Show Hints"),
    ChoGGi.MenuFuncs.NeverShowHints_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableHints and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000671,"No more hints ever.")
    end,
    "set_debug_texture.tga"
  )
  --------------------help
  ChoGGi.ComFuncs.AddAction(
    "[999]Help/" .. ChoGGi.ComFuncs.Trans(302535920000672,"About ECM"),
    ChoGGi.MenuFuncs.MenuHelp_About,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000000,"Expanded Cheat Menu") .. " " .. ChoGGi.ComFuncs.Trans(302535920000673,"info dialog."),
    "help.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/" .. ChoGGi.ComFuncs.Trans(302535920000674,"Report Bug"),
    ChoGGi.MenuFuncs.MenuHelp_ReportBug,
    "Ctrl-F1",
    ChoGGi.ComFuncs.Trans(302535920000675,"Report Bug\n\nThis doesn't go to ECM author, if you have a bug with ECM; see Help>About."),
    "ReportBug.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "[999]Help/[999]" .. ChoGGi.ComFuncs.Trans(302535920000676,"Reset ECM Settings"),
    ChoGGi.MenuFuncs.ResetECMSettings,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000677,"Reset all ECM settings to default (restart to enable)."),
    "ToggleEnvMap.tga"
  )

end
