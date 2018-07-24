--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

--~ local icon = "new_city.tga"

--~ AddAction(Menu,Action,Key,Des,Icon)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000367--[[Mod Upload--]]]),
  ChoGGi.MenuFuncs.ModUpload,
  nil,
  302535920001264--[[Show list of mods to upload to Steam Workshop.--]],
  "gear.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000674--[[Report Bug--]]]),
  ChoGGi.MenuFuncs.ReportBugDlg,
  ChoGGi.UserSettings.KeyBindings.ReportBugDlg,
  302535920000675--[[Report Bug

This doesn't go to ECM author, if you have a bug with ECM; see Help>About.--]],
  "ReportBug.tga"
)

--------------------screenshot
AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[2]",S[302535920000892--[[Screenshot--]]],"/",S[302535920000657--[[Screenshot--]]]),
  ChoGGi.MenuFuncs.TakeScreenshot,
  ChoGGi.UserSettings.KeyBindings.TakeScreenshot,
  302535920000658--[[Write screenshot--]],
  "light_model.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[2]",S[302535920000892--[[Screenshot--]]],"/",S[302535920000659--[[Screenshot Upsampled--]]]),
  function()
    ChoGGi.MenuFuncs.TakeScreenshot(true)
  end,
  ChoGGi.UserSettings.KeyBindings.TakeScreenshotUpsampled,
  302535920000660--[[Write screenshot upsampled--]],
  "light_model.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[2]",S[302535920000892--[[Screenshot--]]],"/",S[302535920000661--[[Show Interface in Screenshots--]]]),
  ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ShowInterfaceInScreenshots,
      302535920000662--[[Do you want to see the interface in screenshots?--]]
    )
  end,
  "toggle_dtm_slots.tga"
)

--------------------Interface
AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[1]",S[302535920000893--[[Interface--]]],"/",S[302535920000663--[[Toggle Interface--]]]),
  function()
    hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
  end,
  ChoGGi.UserSettings.KeyBindings.ToggleInterface,
  nil,
  "ToggleSelectionOcclusion.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[1]",S[302535920000893--[[Interface--]]],"/",S[302535920000664--[[Toggle Signs--]]]),
  ChoGGi.MenuFuncs.SignsInterface_Toggle,
  ChoGGi.UserSettings.KeyBindings.SignsInterface_Toggle,
  302535920000665--[[Concrete, metal deposits, not working, etc...--]],
  "ToggleMarkers.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[1]",S[302535920000893--[[Interface--]]],"/[16]",S[302535920000666--[[Toggle on-screen hints--]]]),
  ChoGGi.MenuFuncs.OnScreenHints_Toggle,
  nil,
  302535920000667--[[Don't show hints for this game--]],
  "HideUnselected.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[1]",S[302535920000893--[[Interface--]]],"/[17]",S[302535920000668--[[Reset on-screen hints--]]]),
  ChoGGi.MenuFuncs.OnScreenHints_Reset,
  nil,
  302535920000669--[[Just in case you wanted to see them again.--]],
  "HideSelected.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/[1]",S[302535920000893--[[Interface--]]],"/[18]",S[302535920000670--[[Never Show Hints--]]]),
  ChoGGi.MenuFuncs.NeverShowHints_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DisableHints,
      302535920000671--[[No more hints ever.--]]
    )
  end,
  "set_debug_texture.tga"
)
--------------------Interface

----------------------------------ECM
AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[1]",S[302535920000672--[[About ECM--]]]),
  ChoGGi.MenuFuncs.AboutECM,
  nil,
  Concat(S[302535920000000--[[Expanded Cheat Menu--]]]," ",S[302535920000673--[[info dialog.--]]]),
  "help.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[2]",S[302535920000887--[[ECM--]]]," ",S[302535920001020--[[Read me--]]]),
  ChoGGi.MenuFuncs.ShowReadmeECM,
  nil,
  302535920001025--[[Help! I'm with stupid!--]],
  "help.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[3]",S[302535920001029--[[Change log--]]]),
  ChoGGi.MenuFuncs.ShowChangelogECM,
  nil,
  4915--[[Good News, Everyone!"--]],
  "DisablePostprocess.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[4]",S[302535920001014--[[Hide Cheats Menu--]]]),
  ChoGGi.MenuFuncs.CheatsMenu_Toggle,
  ChoGGi.UserSettings.KeyBindings.CheatsMenu_Toggle,
  302535920001019--[[This will hide the Cheats menu; Use F2 to see it again (Ctrl-F2 to toggle the Cheats selection panel).--]],
  "ToggleEnvMap.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[5]",S[302535920000142--[[Disable--]]]," ",S[302535920000887--[[ECM--]]]),
  ChoGGi.MenuFuncs.DisableECM,
  nil,
  302535920000465--[["Disables menu, cheat panel, and hotkeys, but leaves settings intact (restart to toggle). You'll need to manually re-enable in CheatMenuModSettings.lua file."--]],
  "ToggleEnvMap.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[6]",S[302535920000676--[[Reset ECM Settings--]]]),
  ChoGGi.MenuFuncs.ResetECMSettings,
  nil,
  302535920000677--[[Reset all ECM settings to default (restart to enable).--]],
  "ToggleEnvMap.tga"
)

AddAction(
  Concat("[999]",S[487939677892--[[Help--]]],"/",S[302535920000000--[[Expanded Cheat Menu--]]],"/[7]",S[302535920001242--[[Edit ECM Settings File--]]]),
  ChoGGi.MenuFuncs.EditECMSettings,
  nil,
  302535920001243--[[Manually edit ECM settings.--]],
  "UIDesigner.tga"
)
----------------------------------ECM



do -- build text file menu items
  local ChoGGi = ChoGGi
  local folders = ChoGGi.ComFuncs.RetFilesInFolder(Concat(ChoGGi.MountPath,"Text"),".txt")
  local function ReadText(file)
    local file_error, text = AsyncFileToString(file)
    if file_error then
      -- close enough msg, very unlikely this will ever happen (unless user is really being a user)
      return S[1000058--[[Missing file <u(src)> referenced in entity--]]]
    else
      return text
    end
  end

  local info = Concat(S[302535920001028--[[Have a Tutorial, or general info you'd like to add?--]]]," : ",ChoGGi.email)
  AddAction(
    Concat("[999]",S[487939677892--[[Help--]]],"/[999]",S[1000145--[[Text--]]],"/[-1]*",S[126095410863--[[Info--]]],"*"),
    function()
      OpenExamine(info)
    end,
    nil,
    info,
    "AreaProperties.tga"
  )

  local funcs = ReadText(Concat(ChoGGi.MountPath,"Text/GameFunctions.lua"))
  AddAction(
    Concat("[999]",S[487939677892--[[Help--]]],"/[999]",S[1000145--[[Text--]]],"/[0]*",S[302535920000875--[[Game Functions--]]],"*"),
    function()
      OpenExamine(Concat(S[302535920001023--[[This WILL take awhile if you open it in View Text.--]]],"\n\n\n\n",funcs))
    end,
    nil,
    funcs:sub(1,100),
    "AreaProperties.tga"
  )

  if folders then
    for i = 1, #folders do
      local text = ReadText(folders[i].path)
      AddAction(
        Concat("[999]",S[487939677892--[[Help--]]],"/[999]",S[1000145--[[Text--]]],"/[",i,"]",folders[i].name),
        function()
          OpenExamine(text)
        end,
        nil,
        text:sub(1,100),
        "Voice.tga"
      )
    end
  end
end
