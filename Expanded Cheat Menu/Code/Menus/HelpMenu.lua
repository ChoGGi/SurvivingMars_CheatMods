-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local c = #Actions

	local str_url = "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/%s"

	c = c + 1
	Actions[c] = {ActionName = S[302535920000504--[[List All Menu Items--]]],
		ActionMenubar = "ECM.Help",
		ActionId = ".List All Menu Items",
		ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
		RolloverText = S[302535920001323--[[Show all the cheat menu items in a list dialog.--]]],
		OnAction = ChoGGi.MenuFuncs.ListAllMenuItems,
		ActionSortKey = "99.List All Menu Items",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001362--[[Extract HPKs--]]],
		ActionMenubar = "ECM.Help",
		ActionId = ".Extract HPKs",
		ActionIcon = "CommonAssets/UI/Menu/editmapdata.tga",
		RolloverText = S[302535920001363--[[Shows list of Steam downloaded mod hpk files for extraction (or use hpk.exe).--]]],
		OnAction = ChoGGi.MenuFuncs.ExtractHPKs,
		ActionSortKey = "99.Extract HPKs",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000367--[[Mod Upload--]]],
		ActionMenubar = "ECM.Help",
		ActionId = ".Mod Upload",
		ActionIcon = "CommonAssets/UI/Menu/gear.tga",
		RolloverText = S[302535920001264--[[Show list of mods to upload to Steam Workshop.--]]],
		OnAction = ChoGGi.MenuFuncs.ModUpload,
		ActionSortKey = "99.Mod Upload",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000473--[[Reload ECM Menu--]]],
		ActionMenubar = "ECM.Help",
		ActionId = ".Reload ECM Menu",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = S[302535920000474--[[Fiddling around in the editor mode can break the menu / shortcuts added by ECM (use this to fix or alt-tab).--]]],
		OnAction = function()
			Msg("ShortcutsReloaded")
		end,
		ActionSortKey = "99.Reload ECM Menu",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001380--[[Report Bug--]]],
		ActionMenubar = "ECM.Help",
		ActionId = ".Report Bug",
		ActionIcon = "CommonAssets/UI/Menu/ReportBug.tga",
		RolloverText = S[302535920001381--[[Opens the bug report dialog (this will add a screenshot to AppData\BugReport).--]]],
		OnAction = ChoGGi.MenuFuncs.CreateBugReportDlg,
		ActionSortKey = "99.Report Bug",
		ActionShortcut = "Ctrl-F1",
		ActionBindable = true,
	}

	local str_Help_Screenshot = "ECM.Help.Screenshot"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000892--[[Screenshot--]]]),
		ActionMenubar = "ECM.Help",
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
		ActionShortcut = "-PrtScr",
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
		ActionShortcut = "-Ctrl-PrtScr",
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

	local str_Help_Interface = "ECM.Help.Interface"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000893--[[Interface--]]]),
		ActionMenubar = "ECM.Help",
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
		ActionShortcut = "Ctrl-Alt-I",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001387--[[Toggle Signs--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".Toggle Signs",
		ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
		RolloverText = S[302535920001388--[["Concrete, metal deposits, not working, etc..."--]]],
		OnAction = ToggleSigns,
		ActionShortcut = "Ctrl-Alt-U",
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

	c = c + 1
	Actions[c] = {ActionName = S[302535920001412--[[GUI Dock Side--]]],
		ActionMenubar = str_Help_Interface,
		ActionId = ".GUI Dock Side",
		ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.GUIDockSide and S[1000459--[[Right--]]] or S[1000457--[[Left--]]],
				302535920001413--[[Change which side (most) GUI menus are on.--]]

			)
		end,
		OnAction = ChoGGi.MenuFuncs.GUIDockSide_Toggle,
	}

	local str_Help_ECM = "ECM.Help.Expanded Cheat Menu"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000000--[[Expanded Cheat Menu--]]]),
		ActionMenubar = "ECM.Help",
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
		ActionSortKey = "001",
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
		ActionSortKey = "002",
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
		ActionSortKey = "003",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000321--[[Enable ToolTips--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Toggle ToolTips",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.EnableToolTips,
				302535920000322--[[Disabling this will remove most of the tooltips (leaves the cheat menu and cheats pane ones).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ToolTips_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001481--[[Show Startup Ticks--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Show Startup Ticks",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ShowStartupTicks,
				302535920001482--[[Prints to console how many ticks it takes the map to load.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.StartupTicks_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000142--[[Disable--]]],S[302535920000887--[[ECM--]]]),
		ActionMenubar = str_Help_ECM,
		ActionId = ".Disable ECM",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = S[302535920000465--[["Disables menu, cheat panel, and hotkeys, but leaves settings intact. You'll need to manually re-enable in settings file, or check key bindings for Disable ECM."--]]],
		OnAction = ChoGGi.MenuFuncs.DisableECM,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000676--[[Reset ECM Settings--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Reset ECM Settings",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = S[302535920000677--[[Reset all ECM settings to default (restart to enable).--]]],
		OnAction = ChoGGi.MenuFuncs.ResetECMSettings,
		ActionSortKey = "98",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001242--[[Edit ECM Settings--]]],
		ActionMenubar = str_Help_ECM,
		ActionId = ".Edit ECM Settings",
		ActionIcon = "CommonAssets/UI/Menu/UIDesigner.tga",
		RolloverText = S[302535920001243--[[Manually edit ECM settings.--]]],
		OnAction = ChoGGi.MenuFuncs.EditECMSettings,
		ActionSortKey = "99",
	}

	local str_Help_Tutorial = "ECM.Help.Tutorial"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[8982--[[Tutorial--]]]),
		ActionMenubar = "ECM.Help",
		ActionId = ".Tutorial",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Tutorial",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s*",S[126095410863--[[Info--]]]),
		ActionMenubar = str_Help_Tutorial,
		ActionId = ".*Info*",
		ActionIcon = "CommonAssets/UI/Menu/help.tga",
		RolloverText = StringFormat("%s : %s",S[302535920001028--[[Have a Tutorial, or general info you'd like to add?--]]],ChoGGi.email),
		ActionSortKey = "-0*Info*",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s & %s %s*",S[283142739680--[[Game--]]],S[302535920001355--[[Map--]]],S[126095410863--[[Info--]]]),
		ActionMenubar = str_Help_Tutorial,
		ActionId = ".*Game & Map Info*",
		ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
		RolloverText = S[302535920001282--[[Information about this saved game (mostly objects).--]]],
		OnAction = ChoGGi.MenuFuncs.RetMapInfo,
		ActionSortKey = "-1*Game & Map Info*",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s*",S[5568--[[Stats--]]]),
		ActionMenubar = str_Help_Tutorial,
		ActionId = ".*Stats*",
		ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
		RolloverText = S[302535920001281--[[Information about your computer (as seen by SM).--]]],
		OnAction = function()
			ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.ComFuncs.RetHardwareInfo())
		end,
		ActionSortKey = "-2*Stats*",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("*%s*",S[302535920000875--[[Game Functions--]]]),
		ActionMenubar = str_Help_Tutorial,
		ActionId = ".*Game Functions*",
		ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
		RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
		OnAction = function()
			OpenUrl(str_url:format("Tutorials/GameFunctions.lua"))
		end,
		ActionSortKey = "-2*Game Functions*",
	}

	local tutorial_table = {
		"Add New Trait",
		"All Nearby Objects",
		"Change Animation",
		"DroneNoBatteryNeeded",
		"Export Import CSV",
		"Hidden Milestones",
		"Locales",
		"Misc",
		"OnMsgs Load Game",
		"OnMsgs New Game",
		"point",
		"Random Colours",
		"Random number",
		"Save Load Mod Settings",
		"Show a list of choices",
		"String To Object",
		"TaskRequestFuncs",
		"Threads",
	}
	for i = 1, #tutorial_table do
		local name = tutorial_table[i]
		c = c + 1
		Actions[c] = {ActionName = name,
			ActionMenubar = str_Help_Tutorial,
			ActionId = StringFormat(".%s",name),
			ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
			RolloverText = S[302535920001285--[[Opens in webbrowser--]]],
			OnAction = function()
				OpenUrl(str_url:format(StringFormat("Tutorials/%s.md#readme",name)))
			end,
			ActionSortKey = StringFormat("-3%s",name),
		}
	end
end
