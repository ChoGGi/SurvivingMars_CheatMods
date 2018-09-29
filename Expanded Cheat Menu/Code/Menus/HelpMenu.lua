-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local c = #Actions

	local str_url = "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/%s"

	c = c + 1
	Actions[c] = {ActionName = S[302535920000504--[[List All Menu Items--]]],
		ActionMenubar = "Help",
		ActionId = ".List All Menu Items",
		ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
		RolloverText = S[302535920001323--[[Show all the cheat menu items in a list dialog.--]]],
		OnAction = ChoGGi.MenuFuncs.ListAllMenuItems,
		ActionSortKey = "99.List All Menu Items",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001362--[[Extract HPKs--]]],
		ActionMenubar = "Help",
		ActionId = ".Extract HPKs",
		ActionIcon = "CommonAssets/UI/Menu/editmapdata.tga",
		RolloverText = S[302535920001363--[["Shows list of Steam downloaded mod hpk files, so you can extract them."--]]],
		OnAction = ChoGGi.MenuFuncs.ExtractHPKs,
		ActionSortKey = "99.Extract HPKs",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000367--[[Mod Upload--]]],
		ActionMenubar = "Help",
		ActionId = ".Mod Upload",
		ActionIcon = "CommonAssets/UI/Menu/gear.tga",
		RolloverText = S[302535920001264--[[Show list of mods to upload to Steam Workshop.--]]],
		OnAction = ChoGGi.MenuFuncs.ModUpload,
		ActionSortKey = "99.Mod Upload",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000473--[[Reload ECM Menu--]]],
		ActionMenubar = "Help",
		ActionId = ".Reload ECM Menu",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = S[302535920000474--[[Fiddling around in the editor mode can break the menu / shortcuts added by ECM (use this to fix).--]]],
		OnAction = function()
			Msg("ShortcutsReloaded")
		end,
		ActionSortKey = "99.Reload ECM Menu",
	}

	local str_Help_Screenshot = "Help.Screenshot"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000892--[[Screenshot--]]]),
		ActionMenubar = "Help",
		ActionId = ".Screenshot",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "2Screenshot",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000657--[[Screenshot--]]],
		ActionMenubar = str_Help_Screenshot,
		ActionId = ".Screenshot",
		ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
		RolloverText = S[302535920000658--[[Write screenshot--]]],
		OnAction = ChoGGi.MenuFuncs.TakeScreenshot,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.TakeScreenshot,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000659--[[Screenshot Upsampled--]]],
		ActionMenubar = str_Help_Screenshot,
		ActionId = ".Screenshot Upsampled",
		ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
		RolloverText = S[302535920000660--[[Write screenshot upsampled--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.TakeScreenshot(true)
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.TakeScreenshotUpsampled,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000661--[[Show Interface in Screenshots--]]],
		ActionMenubar = str_Help_Screenshot,
		ActionId = ".Show Interface in Screenshots",
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
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000893--[[Interface--]]]),
		ActionMenubar = "Help",
		ActionId = ".Interface",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Interface",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000663--[[Toggle Interface--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".Toggle Interface",
		ActionIcon = "CommonAssets/UI/Menu/ToggleSelectionOcclusion.tga",
		RolloverText = S[302535920000244--[[Warning! This will hide everything. Remember the shortcut or have fun restarting.--]]],
		OnAction = ChoGGi.MenuFuncs.Interface_Toggle,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ToggleInterface,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000664--[[Toggle Signs--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".Toggle Signs",
		ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
		RolloverText = S[302535920000665--[[Concrete, metal deposits, not working, etc...--]]],
		OnAction = ChoGGi.MenuFuncs.SignsInterface_Toggle,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.SignsInterface_Toggle,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000666--[[Toggle on-screen hints--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".Toggle on-screen hints",
		ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				HintsEnabled,
				302535920000667--[[Don't show hints for this game.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.OnScreenHints_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000668--[[Reset on-screen hints--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".Reset on-screen hints",
		ActionIcon = "CommonAssets/UI/Menu/HideSelected.tga",
		RolloverText = S[302535920000669--[[Just in case you wanted to see them again.--]]],
		OnAction = ChoGGi.MenuFuncs.OnScreenHints_Reset,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000670--[[Never Show Hints--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".Never Show Hints",
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
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000000--[[Expanded Cheat Menu--]]]),
		ActionMenubar = "Help",
		ActionId = ".Expanded Cheat Menu",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "0Expanded Cheat Menu",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000672--[[About ECM--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".About ECM",
		ActionIcon = "CommonAssets/UI/Menu/help.tga",
		RolloverText = StringFormat("%s %s",S[302535920000000--[[Expanded Cheat Menu--]]],S[302535920000673--[[info dialog.--]]]),
		OnAction = ChoGGi.MenuFuncs.AboutECM,
		ActionSortKey = "1",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000887--[[ECM--]]],S[302535920001020--[[Read me--]]]),
		ActionMenubar = str_Help_ECM,
		ActionId = ".ECM Read me",
		ActionIcon = "CommonAssets/UI/Menu/help.tga",
		RolloverText = S[302535920001025--[[Help! I'm with stupid!--]]],
		OnAction = function()
			OpenUrl(str_url:format("Expanded Cheat Menu/README.md#no-warranty-implied-or-otherwise"))
		end,
		ActionSortKey = "2",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001029--[[Changelog--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Changelog",
		ActionIcon = "CommonAssets/UI/Menu/DisablePostprocess.tga",
		RolloverText = S[4915--[[Good News, Everyone!"--]]],
		OnAction = function()
			OpenUrl(str_url:format("Expanded Cheat Menu/Changelog.md#ecm-changelog"))
		end,
		ActionSortKey = "3",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001014--[[Hide Cheats Menu--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Hide Cheats Menu",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = S[302535920001019--[[This will hide the Cheats menu; Use F2 to see it again (Ctrl-F2 to toggle the Cheats selection panel).--]]],
		OnAction = ChoGGi.CodeFuncs.CheatsMenu_Toggle,
		ActionSortKey = "5",
		ActionShortcut = ChoGGi.Defaults.KeyBindings.CheatsMenu_Toggle,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000142--[[Disable--]]],S[302535920000887--[[ECM--]]]),
		ActionMenubar = str_Help_ECM,
		ActionId = ".Disable ECM",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = S[302535920000465--[["Disables menu, cheat panel, and hotkeys, but leaves settings intact (restart to toggle). You'll need to manually re-enable in CheatMenuModSettings.lua file."--]]],
		OnAction = ChoGGi.MenuFuncs.DisableECM,
		ActionSortKey = "6",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000676--[[Reset ECM Settings--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Reset ECM Settings",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = S[302535920000677--[[Reset all ECM settings to default (restart to enable).--]]],
		OnAction = ChoGGi.MenuFuncs.ResetECMSettings,
		ActionSortKey = "7",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001242--[[Edit ECM Settings--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Edit ECM Settings",
		ActionIcon = "CommonAssets/UI/Menu/UIDesigner.tga",
		RolloverText = S[302535920001243--[[Manually edit ECM settings.--]]],
		OnAction = ChoGGi.MenuFuncs.EditECMSettings,
		ActionSortKey = "8",
	}

	local str_Help_Text = "Help.Text"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[1000145--[[Text--]]]),
		ActionMenubar = "Help",
		ActionId = ".Text",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Text",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s*",S[126095410863--[[Info--]]]),
		ActionMenubar = str_Help_Text,
		ActionId = ".*Info*",
		ActionIcon = "CommonAssets/UI/Menu/help.tga",
		RolloverText = StringFormat("%s : %s",S[302535920001028--[[Have a Tutorial, or general info you'd like to add?--]]],ChoGGi.email),
		ActionSortKey = "-0*Info*",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s & %s %s*",S[283142739680--[[Game--]]],S[302535920001355--[[Map--]]],S[126095410863--[[Info--]]]),
		ActionMenubar = str_Help_Text,
		ActionId = ".*Game & Map Info*",
		ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
		RolloverText = S[302535920001282--[[Information about this saved game (mostly objects).--]]],
		OnAction = ChoGGi.MenuFuncs.RetMapInfo,
		ActionSortKey = "-1*Game & Map Info*",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s*",S[5568--[[Stats--]]]),
		ActionMenubar = str_Help_Text,
		ActionId = ".*Stats*",
		ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
		RolloverText = S[302535920001281--[[Information about your computer (as seen by SM).--]]],
		OnAction = function()
			ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.CodeFuncs.RetHardwareInfo())
		end,
		ActionSortKey = "-2*Stats*",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s*",S[302535920000875--[[Game Functions--]]]),
		ActionMenubar = str_Help_Text,
		ActionId = ".*Game Functions*",
		ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/GameFunctions.lua"))
		end,
		ActionSortKey = "-2*Game Functions*",
	}

	c = c + 1
	Actions[c] = {ActionName = [[OnMsgs Easy Start]],
		ActionMenubar = str_Help_Text,
		ActionId = ".OnMsgs Easy Start",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/OnMsgs Easy Start.md"))
		end,
		ActionSortKey = "-3OnMsgs Easy Start",
	}

	c = c + 1
	Actions[c] = {ActionName = [[OnMsgs Load Game]],
		ActionMenubar = str_Help_Text,
		ActionId = ".OnMsgs Load Game",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/OnMsgs Load Game.md"))
		end,
		ActionSortKey = "-3OnMsgs Load Game",
	}

	c = c + 1
	Actions[c] = {ActionName = [[OnMsgs New Game]],
		ActionMenubar = str_Help_Text,
		ActionId = ".OnMsgs New Game",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/OnMsgs New Game.md"))
		end,
		ActionSortKey = "-3OnMsgs New Game",
	}

	c = c + 1
	Actions[c] = {ActionName = [[Misc]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Misc",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Misc.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Save Load Mod Settings]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Save Load Mod Settings",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Save Load Mod Settings.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Add New Trait]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Add New Trait",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Add New Trait.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Change Animation]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Change Animation",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Change Animation.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[DroneNoBatteryNeeded]],
		ActionMenubar = str_Help_Text,
		ActionId = ".DroneNoBatteryNeeded",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/DroneNoBatteryNeeded.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Hidden Milestones]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Hidden Milestones",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Hidden Milestones.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Locales]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Locales",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Locales.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Random number]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Random number",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Random number.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Return All Nearby Objects]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Return All Nearby Objects",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Return All Nearby Objects.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Return Random Colours]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Return Random Colours",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Return Random Colours.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Show A List of Choices]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Show A List of Choices",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Show A List of Choices.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[TaskRequestFuncs]],
		ActionMenubar = str_Help_Text,
		ActionId = ".TaskRequestFuncs",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/TaskRequestFuncs.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[String To Object]],
		ActionMenubar = str_Help_Text,
		ActionId = ".String To Object",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/String To Object.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[Threads]],
		ActionMenubar = str_Help_Text,
		ActionId = ".Threads",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/Threads.md"))
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = [[point]],
		ActionMenubar = str_Help_Text,
		ActionId = ".point",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/point.md"))
		end,
	}

end
