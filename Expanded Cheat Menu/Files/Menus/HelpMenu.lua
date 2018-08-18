-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local blacklist = ChoGGi.blacklist
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

if not blacklist then
  Actions[#Actions+1] = {
    ActionMenubar = "Help",
    ActionName = S[302535920000367--[[Mod Upload--]]],
    ActionId = "Help.Mod Upload",
    ActionIcon = "CommonAssets/UI/Menu/gear.tga",
    RolloverText = S[302535920001264--[[Show list of mods to upload to Steam Workshop.--]]],
    OnAction = ChoGGi.MenuFuncs.ModUpload,
    ActionSortKey = "99",
  }

end
Actions[#Actions+1] = {
  ActionMenubar = "Help",
  ActionName = S[302535920000473--[[Reload ECM Menu--]]],
  ActionId = "Help.Mod Upload",
  ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
  RolloverText = S[302535920000474--[[Fiddling around in the editor mod can break the menu / shortcuts added by ECM (use this to fix).--]]],
  OnAction = function()
    Msg("ShortcutsReloaded")
  end,
  ActionSortKey = "99",
}

local str_Help_Screenshot = "Help.Screenshot"
Actions[#Actions+1] = {
  ActionMenubar = "Help",
  ActionName = Concat(S[302535920000892--[[Screenshot--]]]," .."),
  ActionId = str_Help_Screenshot,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "2Screenshot",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Screenshot,
  ActionName = S[302535920000657--[[Screenshot--]]],
  ActionId = "Help.Screenshot.Screenshot",
  ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
  RolloverText = S[302535920000658--[[Write screenshot--]]],
  OnAction = ChoGGi.MenuFuncs.TakeScreenshot,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.TakeScreenshot,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Screenshot,
  ActionName = S[302535920000659--[[Screenshot Upsampled--]]],
  ActionId = "Help.Screenshot.Screenshot Upsampled",
  ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
  RolloverText = S[302535920000660--[[Write screenshot upsampled--]]],
  OnAction = function()
    ChoGGi.MenuFuncs.TakeScreenshot(true)
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.TakeScreenshotUpsampled,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Screenshot,
  ActionName = S[302535920000661--[[Show Interface in Screenshots--]]],
  ActionId = "Help.Screenshot.Show Interface in Screenshots",
  ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ShowInterfaceInScreenshots,
      302535920000662--[[Do you want to see the interface in screenshots?--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
}

local str_Help_Interface = "Help.Interface"
Actions[#Actions+1] = {
  ActionMenubar = "Help",
  ActionName = Concat(S[302535920000893--[[Interface--]]]," .."),
  ActionId = str_Help_Interface,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "1Interface",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Interface,
  ActionName = S[302535920000663--[[Toggle Interface--]]],
  ActionId = "Help.Interface.Toggle Interface",
  ActionIcon = "CommonAssets/UI/Menu/ToggleSelectionOcclusion.tga",
  RolloverText = S[302535920000663--[[Toggle Interface--]]],
  OnAction = function()
    hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.ToggleInterface,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Interface,
  ActionName = S[302535920000664--[[Toggle Signs--]]],
  ActionId = "Help.Interface.Toggle Signs",
  ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
  RolloverText = S[302535920000665--[[Concrete, metal deposits, not working, etc...--]]],
  OnAction = ChoGGi.MenuFuncs.SignsInterface_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SignsInterface_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Interface,
  ActionName = S[302535920000666--[[Toggle on-screen hints--]]],
  ActionId = "Help.Interface.Toggle on-screen hints",
  ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
  RolloverText = S[302535920000667--[[Don't show hints for this game--]]],
  OnAction = ChoGGi.MenuFuncs.OnScreenHints_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Interface,
  ActionName = S[302535920000668--[[Reset on-screen hints--]]],
  ActionId = "Help.Interface.Reset on-screen hints",
  ActionIcon = "CommonAssets/UI/Menu/HideSelected.tga",
  RolloverText = S[302535920000669--[[Just in case you wanted to see them again.--]]],
  OnAction = ChoGGi.MenuFuncs.OnScreenHints_Reset,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Interface,
  ActionName = S[302535920000670--[[Never Show Hints--]]],
  ActionId = "Help.Interface.Never Show Hints",
  ActionIcon = "CommonAssets/UI/Menu/set_debug_texture.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DisableHints,
      302535920000671--[[No more hints ever.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.NeverShowHints_Toggle,
}

local str_Help_ECM = "Help.Expanded Cheat Menu"
Actions[#Actions+1] = {
  ActionMenubar = "Help",
  ActionName = Concat(S[302535920000000--[[Expanded Cheat Menu--]]]," .."),
  ActionId = str_Help_ECM,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "0Expanded Cheat Menu",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = S[302535920000672--[[About ECM--]]],
  ActionId = "Help.Expanded Cheat Menu.About ECM",
  ActionIcon = "CommonAssets/UI/Menu/help.tga",
  RolloverText = Concat(S[302535920000000--[[Expanded Cheat Menu--]]]," ",S[302535920000673--[[info dialog.--]]]),
  OnAction = ChoGGi.MenuFuncs.AboutECM,
  ActionSortKey = "1",
}

if not blacklist then
  Actions[#Actions+1] = {
    ActionMenubar = str_Help_ECM,
    ActionName = Concat(S[302535920000887--[[ECM--]]]," ",S[302535920001020--[[Read me--]]]),
    ActionId = "Help.Expanded Cheat Menu.ECM Read me",
    ActionIcon = "CommonAssets/UI/Menu/help.tga",
    RolloverText = S[302535920001025--[[Help! I'm with stupid!--]]],
    OnAction = ChoGGi.MenuFuncs.ShowReadmeECM,
    ActionSortKey = "2",
  }

  Actions[#Actions+1] = {
    ActionMenubar = str_Help_ECM,
    ActionName = S[302535920001029--[[Change log--]]],
    ActionId = "Help.Expanded Cheat Menu.Change log",
    ActionIcon = "CommonAssets/UI/Menu/DisablePostprocess.tga",
    RolloverText = S[4915--[[Good News, Everyone!"--]]],
    OnAction = ChoGGi.MenuFuncs.ShowChangelogECM,
    ActionSortKey = "3",
  }
end

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = S[302535920001014--[[Hide Cheats Menu--]]],
  ActionId = "Help.Expanded Cheat Menu.Hide Cheats Menu",
  ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
  RolloverText = S[302535920001019--[[This will hide the Cheats menu; Use F2 to see it again (Ctrl-F2 to toggle the Cheats selection panel).--]]],
  OnAction = ChoGGi.MenuFuncs.CheatsMenu_Toggle,
  ActionSortKey = "5",
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.CheatsMenu_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = Concat(S[302535920000142--[[Disable--]]]," ",S[302535920000887--[[ECM--]]]),
  ActionId = "Help.Expanded Cheat Menu.Disable ECM",
  ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
  RolloverText = S[302535920000465--[["Disables menu, cheat panel, and hotkeys, but leaves settings intact (restart to toggle). You'll need to manually re-enable in CheatMenuModSettings.lua file."--]]],
  OnAction = ChoGGi.MenuFuncs.DisableECM,
  ActionSortKey = "6",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = S[302535920000676--[[Reset ECM Settings--]]],
  ActionId = "Help.Expanded Cheat Menu.Reset ECM Settings",
  ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
  RolloverText = S[302535920000677--[[Reset all ECM settings to default (restart to enable).--]]],
  OnAction = ChoGGi.MenuFuncs.ResetECMSettings,
  ActionSortKey = "7",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = S[302535920001242--[[Edit ECM Settings File--]]],
  ActionId = "Help.Expanded Cheat Menu.Edit ECM Settings File",
  ActionIcon = "CommonAssets/UI/Menu/UIDesigner.tga",
  RolloverText = S[302535920001243--[[Manually edit ECM settings.--]]],
  OnAction = ChoGGi.MenuFuncs.EditECMSettings,
  ActionSortKey = "8",
}

local str_Help_Text = "Help.Text"
Actions[#Actions+1] = {
  ActionMenubar = "Help",
  ActionName = Concat(S[1000145--[[Text--]]]," .."),
  ActionId = str_Help_Text,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "1Text",
}

do -- build text file menu items
  local ChoGGi = ChoGGi

  local info = Concat(S[302535920001028--[[Have a Tutorial, or general info you'd like to add?--]]]," : ",ChoGGi.email)
  Actions[#Actions+1] = {
    ActionMenubar = str_Help_Text,
    ActionName = Concat("*",S[126095410863--[[Info--]]],"*"),
    ActionId = "Help.Text.*Info*",
    ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
    RolloverText = info,
    ActionSortKey = "-1",
  }

  Actions[#Actions+1] = {
    ActionMenubar = str_Help_Text,
    ActionName = Concat("*",S[5568--[[Stats--]]],"*"),
    ActionId = "Help.Text.*Stats*",
    ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
    RolloverText = S[302535920001281--[[Information about your computer (as seen by SM).--]]],
    OnAction = function()
      ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.CodeFuncs.RetHardwareInfo())
    end,
    ActionSortKey = "0",
  }
  Actions[#Actions+1] = {
    ActionMenubar = str_Help_Text,
    ActionName = Concat("*",S[283142739680--[[Game--]]]," & ",S[987648737170--[[Map--]]]," ",S[126095410863--[[Info--]]],"*"),
    ActionId = "Help.Text.*Game & Map Info*",
    ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
    RolloverText = S[302535920001282--[[Information about this saved game (mostly objects).--]]],
    OnAction = ChoGGi.MenuFuncs.RetMapInfo,
    ActionSortKey = "1",
  }

  if not blacklist then
    local function ReadText(file)
      local file_error, text = AsyncFileToString(file)
      if file_error then
        -- close enough msg, very unlikely this will ever happen (unless user is really being a user)
        return S[1000058--[[Missing file <u(src)> referenced in entity--]]]
      else
        return text
      end
    end

    local funcs = ReadText(Concat(ChoGGi.ModPath,"Files/Text/GameFunctions.lua"))
    Actions[#Actions+1] = {
      ActionMenubar = str_Help_Text,
      ActionName = Concat("*",S[302535920000875--[[Game Functions--]]],"*"),
      ActionId = "Help.Text.*Game Functions*",
      ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
      RolloverText = funcs:sub(1,100),
      OnAction = function()
        ChoGGi.ComFuncs.OpenInExamineDlg(Concat(S[302535920001023--[[This WILL take awhile if you open it in View Text.--]]],"\n\n\n\n",funcs))
      end,
      ActionSortKey = "0",
    }
    local function LoopFiles(ext)
      local folders = ChoGGi.ComFuncs.RetFilesInFolder(Concat(ChoGGi.ModPath,"Files/Text"),ext)
      if folders then
        for i = 1, #folders do
          local text = ReadText(folders[i].path)
          Actions[#Actions+1] = {
            ActionMenubar = str_Help_Text,
            ActionName = folders[i].name,
            ActionId = Concat("Help.Text",folders[i].name),
            ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
            RolloverText = text:sub(1,100),
            OnAction = function()
              ChoGGi.ComFuncs.OpenInExamineDlg(text)
            end,
            ActionSortKey = "99",
          }
        end
      end
    end
    LoopFiles(".txt")
    LoopFiles(".md")
  end

end
