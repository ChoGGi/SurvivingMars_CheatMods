--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
--~ local icon = "new_city.tga"

function ChoGGi.MsgFuncs.HelpMenu_ChoGGi_Loaded()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  --------------------screenshot
  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[2]",T(302535920000892--[[Screenshot--]]),"/",T(302535920000657--[[Screenshot--]])),
    ChoGGi.MenuFuncs.TakeScreenshot,
    ChoGGi.UserSettings.KeyBindings.TakeScreenshot,
    T(302535920000658--[[Write screenshot--]]),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[2]",T(302535920000892--[[Screenshot--]]),"/",T(302535920000659--[[Screenshot Upsampled--]])),
    function()
      ChoGGi.MenuFuncs.TakeScreenshot(true)
    end,
    ChoGGi.UserSettings.KeyBindings.TakeScreenshotUpsampled,
    T(302535920000660--[[Write screenshot upsampled--]]),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[2]",T(302535920000892--[[Screenshot--]]),"/",T(302535920000661--[[Show Interface in Screenshots--]])),
    ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowInterfaceInScreenshots,
        302535920000662--[[Do you want to see the interface in screenshots?--]]
      )
    end,
    "toggle_dtm_slots.tga"
  )

  --------------------Interface
  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[1]",T(302535920000893--[[Interface--]]),"/",T(302535920000663--[[Toggle Interface--]])),
    function()
      hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
    end,
    ChoGGi.UserSettings.KeyBindings.ToggleInterface,
    nil,
    "ToggleSelectionOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[1]",T(302535920000893--[[Interface--]]),"/",T(302535920000664--[[Toggle Signs--]])),
    ChoGGi.MenuFuncs.SignsInterface_Toggle,
    ChoGGi.UserSettings.KeyBindings.SignsInterface_Toggle,
    T(302535920000665--[[Concrete, metal deposits, not working, etc...--]]),
    "ToggleMarkers.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[1]",T(302535920000893--[[Interface--]]),"/[16]",T(302535920000666--[[Toggle on-screen hints--]])),
    ChoGGi.MenuFuncs.OnScreenHints_Toggle,
    nil,
    T(302535920000667--[[Don't show hints for this game--]]),
    "HideUnselected.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[1]",T(302535920000893--[[Interface--]]),"/[17]",T(302535920000668--[[Reset on-screen hints--]])),
    ChoGGi.MenuFuncs.OnScreenHints_Reset,
    nil,
    T(302535920000669--[[Just in case you wanted to see them again.--]]),
    "HideSelected.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/[1]",T(302535920000893--[[Interface--]]),"/[18]",T(302535920000670--[[Never Show Hints--]])),
    ChoGGi.MenuFuncs.NeverShowHints_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisableHints,
        302535920000671--[[No more hints ever.--]]
      )
    end,
    "set_debug_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/",T(302535920000674--[[Report Bug--]])),
    ChoGGi.MenuFuncs.ReportBugDlg,
    ChoGGi.UserSettings.KeyBindings.ReportBugDlg,
    T(302535920000675--[[Report Bug

This doesn't go to ECM author, if you have a bug with ECM; see Help>About.--]]),
    "ReportBug.tga"
  )

  ----------------------------------ECM
  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/",T(302535920000000--[[Expanded Cheat Menu--]]),"/",T(302535920000672--[[About ECM--]])),
    ChoGGi.MenuFuncs.AboutECM,
    nil,
    Concat(T(302535920000000--[[Expanded Cheat Menu--]])," ",T(302535920000673--[[info dialog.--]])),
    "help.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/",T(302535920000000--[[Expanded Cheat Menu--]]),"/",T(302535920001029--[[Change log--]])),
    ChoGGi.MenuFuncs.ShowChangelogECM,
    nil,
    T(4915--[[Good News, Everyone!"--]]),
    "DisablePostprocess.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/",T(302535920000000--[[Expanded Cheat Menu--]]),"/",T(302535920001014--[[Hide Cheats Menu--]])),
    ChoGGi.MenuFuncs.CheatsMenu_Toggle,
    ChoGGi.UserSettings.KeyBindings.CheatsMenu_Toggle,
    T(302535920001019--[[This will hide the Cheats menu, Use F2 to see it again, and use Ctrl-F2 to toggle the Cheats selection panel.--]]),
    "ToggleEnvMap.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/",T(302535920000000--[[Expanded Cheat Menu--]]),"/[997]",T(302535920000676--[[Reset ECM Settings--]])),
    ChoGGi.MenuFuncs.ResetECMSettings,
    nil,
    T(302535920000677--[[Reset all ECM settings to default (restart to enable).--]]),
    "ToggleEnvMap.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat("[999]",T(487939677892--[[Help--]]),"/",T(302535920000000--[[Expanded Cheat Menu--]]),"/[998]",T(302535920000887--[[ECM--]])," ",T(302535920001020--[[Read me--]])),
    ChoGGi.MenuFuncs.ShowReadmeECM,
    nil,
    T(302535920001025--[[Help! I'm with stupid!--]]),
    "help.tga"
  )

  --build text file menu items
  do
    local ChoGGi = ChoGGi
    local folders = ChoGGi.ComFuncs.RetFilesInFolder(Concat(ChoGGi.MountPath,"Text"),".txt")
    local function ReadText(file)
      local file_error, text = AsyncFileToString(file)
      if file_error then
        -- close enough, very unlikely this will ever happen (unless user is really being a user)
        return T(1000058--[[Missing file <u(src)> referenced in entity--]])
      else
        return text
      end
    end

    local info = Concat(T(302535920001028--[[Have a Tutorial, or general info you'd like to add?--]])," : ",ChoGGi.email)
    ChoGGi.ComFuncs.AddAction(
      Concat("[999]",T(487939677892--[[Help--]]),"/[999]",T(1000145--[[Text--]]),"/[-1]*",T(126095410863--[[Info--]]),"*"),
      function()
        OpenExamine({info})
      end,
      nil,
      info,
      "AreaProperties.tga"
    )

    local funcs = ReadText(Concat(ChoGGi.MountPath,"Text/GameFunctions.lua"))
    ChoGGi.ComFuncs.AddAction(
      Concat("[999]",T(487939677892--[[Help--]]),"/[999]",T(1000145--[[Text--]]),"/[0]*",T(1575--[[Functionality--]]),"*"),
      function()
        OpenExamine({Concat(T(302535920001023--[[This WILL take awhile if you open it in dump text.--]]),"\n\n\n\n",funcs)})
      end,
      nil,
      funcs:sub(1,100),
      "AreaProperties.tga"
    )

    if folders then
      for i = 1, #folders do
        local text = ReadText(folders[i].path)
        ChoGGi.ComFuncs.AddAction(
          Concat("[999]",T(487939677892--[[Help--]]),"/[999]",T(1000145--[[Text--]]),"/[",i,"]",folders[i].name),
          function()
            OpenExamine({text})
          end,
          nil,
          text:sub(1,100),
          "Voice.tga"
        )
      end
    end
  end

end
