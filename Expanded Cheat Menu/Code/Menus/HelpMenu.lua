-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

local str_url = "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/%s"

Actions[#Actions+1] = {
  ActionMenubar = "Help",
  ActionName = S[302535920000367--[[Mod Upload--]]],
  ActionId = "Help.Mod Upload",
  ActionIcon = "CommonAssets/UI/Menu/gear.tga",
  RolloverText = S[302535920001264--[[Show list of mods to upload to Steam Workshop.--]]],
  OnAction = ChoGGi.MenuFuncs.ModUpload,
  ActionSortKey = "99",
}

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
  RolloverText = S[302535920000244--[[Warning! This will hide everything. Remember the shortcut or have fun restarting.--]]],
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

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = Concat(S[302535920000887--[[ECM--]]]," ",S[302535920001020--[[Read me--]]]),
  ActionId = "Help.Expanded Cheat Menu.ECM Read me",
  ActionIcon = "CommonAssets/UI/Menu/help.tga",
  RolloverText = S[302535920001025--[[Help! I'm with stupid!--]]],
--~   OnAction = ChoGGi.MenuFuncs.ShowReadmeECM,
  OnAction = function()
    OpenUrl(str_url:format("Expanded Cheat Menu/README.md#no-warranty-implied-or-otherwise"))
  end,
  ActionSortKey = "2",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_ECM,
  ActionName = S[302535920001029--[[Changelog--]]],
  ActionId = "Help.Expanded Cheat Menu.Changelog",
  ActionIcon = "CommonAssets/UI/Menu/DisablePostprocess.tga",
  RolloverText = S[4915--[[Good News, Everyone!"--]]],
--~   OnAction = ChoGGi.MenuFuncs.ShowChangelogECM,
  OnAction = function()
    OpenUrl(str_url:format("Expanded Cheat Menu/Changelog.md#ecm-changelog"))
  end,
  ActionSortKey = "3",
}

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
  ActionName = S[302535920001242--[[Edit ECM Settings--]]],
  ActionId = "Help.Expanded Cheat Menu.Edit ECM Settings",
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

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = Concat("*",S[126095410863--[[Info--]]],"*"),
  ActionId = "Help.Text.*Info*",
  ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
  RolloverText = Concat(S[302535920001028--[[Have a Tutorial, or general info you'd like to add?--]]]," : ",ChoGGi.email),
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

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = Concat("*",S[302535920000875--[[Game Functions--]]],"*"),
  ActionId = "Help.Text.*Game Functions*",
  ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/GameFunctions.lua"))
  end,
  ActionSortKey = "0",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Misc]],
  ActionId = "Help.Text.Misc",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Misc.md"))
  end,
  ActionSortKey = "96",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Save Load Mod Settings]],
  ActionId = "Help.Text.Save Load Mod Settings",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Save Load Mod Settings.md"))
  end,
  ActionSortKey = "97",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[OnMsgs Easy Start]],
  ActionId = "Help.Text.OnMsgs Easy Start",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/OnMsgs Easy Start.md"))
  end,
  ActionSortKey = "98",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[OnMsgs Load Game]],
  ActionId = "Help.Text.OnMsgs Load Game",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/OnMsgs Load Game.md"))
  end,
  ActionSortKey = "98",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[OnMsgs New Game]],
  ActionId = "Help.Text.OnMsgs New Game",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/OnMsgs New Game.md"))
  end,
  ActionSortKey = "98",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Add New Trait]],
  ActionId = "Help.Text.Add New Trait",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Add New Trait.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Change Animation]],
  ActionId = "Help.Text.Change Animation",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Change Animation.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[DroneNoBatteryNeeded]],
  ActionId = "Help.Text.DroneNoBatteryNeeded",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/DroneNoBatteryNeeded.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Hidden Milestones]],
  ActionId = "Help.Text.Hidden Milestones",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Hidden Milestones.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Locales]],
  ActionId = "Help.Text.Locales",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Locales.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Random number]],
  ActionId = "Help.Text.Random number",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Random number.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Return All Nearby Objects]],
  ActionId = "Help.Text.Return All Nearby Objects",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Return All Nearby Objects.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Return Random Colours]],
  ActionId = "Help.Text.Return Random Colours",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Return Random Colours.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[Show A List of Choices]],
  ActionId = "Help.Text.Show A List of Choices",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/Show A List of Choices.md"))
  end,
  ActionSortKey = "99",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Help_Text,
  ActionName = [[TaskRequestFuncs]],
  ActionId = "Help.Text.TaskRequestFuncs",
  ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
  RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
  OnAction = function()
    OpenUrl(str_url:format("Tutorials/TaskRequestFuncs.md"))
  end,
  ActionSortKey = "99",
}
