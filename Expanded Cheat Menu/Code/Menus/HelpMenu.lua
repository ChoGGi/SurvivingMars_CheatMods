-- See LICENSE for terms

local TranslationTable = TranslationTable
local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState

local Actions = ChoGGi.Temp.Actions
local c = #Actions
local str_url = "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/"

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000146--[[Delete Saved Games]]],
	ActionMenubar = "ECM.Help",
	ActionId = ".Delete Saved Games",
	ActionIcon = "CommonAssets/UI/Menu/DeleteArea.tga",
	RolloverText = TranslationTable[302535920001273--[["Shows a list of saved games, and allows you to delete more than one at a time."]]] .. "\n\n" .. TranslationTable[302535920001274--[[This is permanent!]]],
	OnAction = ChoGGi.MenuFuncs.DeleteSavedGames,
	ActionSortKey = "94.Delete Saved Games",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000504--[[List All Menu Items]]],
	ActionMenubar = "ECM.Help",
	ActionId = ".List All Menu Items",
	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
	RolloverText = TranslationTable[302535920001323--[[Show all the cheat menu items in a list dialog.]]],
	OnAction = ChoGGi.MenuFuncs.ListAllMenuItems,
	ActionSortKey = "98.List All Menu Items",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001362--[[Extract HPKs]]],
	ActionMenubar = "ECM.Help",
	ActionId = ".Extract HPKs",
	ActionIcon = "CommonAssets/UI/Menu/editmapdata.tga",
	RolloverText = TranslationTable[302535920001363--[[Shows list of Steam/Paradox downloaded mod hpk files for extraction (or use hpk.exe).
Files are placed in your profile folder\Mods.]]],
	OnAction = ChoGGi.MenuFuncs.ExtractHPKs,
	ActionSortKey = "95.Extract HPKs",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000367--[[Mod Upload]]],
	ActionMenubar = "ECM.Help",
	ActionId = ".Mod Upload",
--~ 	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	ActionIcon = ChoGGi.library_path .. "UI/Steam.png",
	RolloverText = TranslationTable[302535920001264--[[Show list of mods to upload to Steam Workshop.]]],
	OnAction = ChoGGi.MenuFuncs.ModUpload,
	ActionSortKey = "95.Mod Upload",
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000000--[[Expanded Cheat Menu]]],
	ActionMenubar = "ECM.Help",
	ActionId = ".Expanded Cheat Menu",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "0Expanded Cheat Menu",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000672--[[About ECM]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".About ECM",
	ActionIcon = "CommonAssets/UI/Menu/help.tga",
	RolloverText = TranslationTable[302535920000000--[[Expanded Cheat Menu]]] .. " " .. TranslationTable[302535920000673--[[info dialog.]]],
	OnAction = ChoGGi.MenuFuncs.AboutECM,
	ActionSortKey = "001",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000002--[[ECM]]] .. " " .. TranslationTable[302535920001020--[[Read me]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".ECM Read me",
	ActionIcon = "CommonAssets/UI/Menu/help.tga",
	RolloverText = TranslationTable[302535920001025--[[Help! I'm with stupid!]]],
	OnAction = ChoGGi.MenuFuncs.OpenUrl,
	setting_url = str_url .. "Expanded Cheat Menu/README.md#no-warranty-implied-or-otherwise",
	ActionSortKey = "002",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001029--[[Changelog]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Changelog",
	ActionIcon = "CommonAssets/UI/Menu/DisablePostprocess.tga",
	RolloverText = TranslationTable[4915--[[Good News, Everyone!"]]],
	OnAction = ChoGGi.MenuFuncs.OpenUrl,
	setting_url = str_url .. "Expanded Cheat Menu/Changelog.md#ecm-changelog",
	ActionSortKey = "003",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000321--[[Enable Tooltips]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Toggle ToolTips",
	ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.EnableToolTips,
			TranslationTable[302535920000322--[[Disabling this will remove most of the tooltips (leaves the cheat menu and cheats pane ones).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ToolTips_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001481--[[Show Startup Ticks]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Show Startup Ticks",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ShowStartupTicks,
			TranslationTable[302535920001482--[[Prints to console how many ticks it takes the map to load.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.StartupTicks_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[251103844022--[[Disable]]] .. " " .. TranslationTable[302535920000002--[[ECM]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Disable ECM",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = TranslationTable[302535920000465--[["Disables menu, cheat panel, and hotkeys, but leaves settings intact. You'll need to manually re-enable in settings file, or check key bindings for Disable ECM.

Ctrl-Alt-0 to re-enable, or see Game options>Key bindings for the re-enable key."]]],
	OnAction = ChoGGi.MenuFuncs.DisableECM,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000676--[[Reset ECM Settings]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Reset ECM Settings",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = TranslationTable[302535920000677--[[Reset all ECM settings to default (restart to enable).]]],
	OnAction = ChoGGi.MenuFuncs.ResetECMSettings,
	ActionSortKey = "98",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001242--[[Edit ECM Settings]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Edit ECM Settings",
	ActionIcon = "CommonAssets/UI/Menu/UIDesigner.tga",
	RolloverText = TranslationTable[302535920001243--[[Manually edit ECM settings.]]],
	OnAction = ChoGGi.MenuFuncs.EditECMSettings,
	ActionSortKey = "99",
}
c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001647--[[Window Title]]],
	ActionMenubar = "ECM.Help.Expanded Cheat Menu",
	ActionId = ".Window Title",
	ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ChangeWindowTitle,
			TranslationTable[302535920001648--[[If you don't want ECM to change the window title than disable this (restart to take effect).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ChangeWindowTitle_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000323--[[Modding]]] .. " " .. TranslationTable[8982--[[Tutorial]]],
	ActionMenubar = "ECM.Help",
	ActionId = ".Modding Tutorial",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Modding Tutorial",
}

c = c + 1
Actions[c] = {ActionName = "*" .. TranslationTable[126095410863--[[Info]]] .. "*",
	ActionMenubar = "ECM.Help.Modding Tutorial",
	ActionId = ".*Info*",
	ActionIcon = "CommonAssets/UI/Menu/help.tga",
	RolloverText = TranslationTable[302535920001028--[[Have a Tutorial, or general info you'd like to add?]]] .. " : " .. ChoGGi.email,
	OnAction = empty_func,
	ActionSortKey = "-0*Info*",
}

c = c + 1
Actions[c] = {ActionName = "*" .. TranslationTable[283142739680--[[Game]]] .. " & " .. TranslationTable[302535920001355--[[Map]]] .. " " .. TranslationTable[126095410863--[[Info]]] .. "*",
	ActionMenubar = "ECM.Help.Modding Tutorial",
	ActionId = ".*Game & Map Info*",
	ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
	RolloverText = TranslationTable[302535920001282--[[Information about this saved game (mostly objects).]]],
	OnAction = ChoGGi.MenuFuncs.RetMapInfo,
	ActionSortKey = "-1*Game & Map Info*",
}

c = c + 1
Actions[c] = {ActionName = "*" .. TranslationTable[5568--[[Stats]]] .. "*",
	ActionMenubar = "ECM.Help.Modding Tutorial",
	ActionId = ".*Stats*",
	ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
	RolloverText = TranslationTable[302535920001281--[[Information about your computer (as seen by SM).]]],
	OnAction = function()
		ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.MenuFuncs.RetHardwareInfo(), nil, TranslationTable[5568--[[Stats]]])
	end,
	ActionSortKey = "-2*Stats*",
}

c = c + 1
Actions[c] = {ActionName = "*" .. TranslationTable[302535920000875--[[Game Functions]]] .. "*",
	ActionMenubar = "ECM.Help.Modding Tutorial",
	ActionId = ".*Game Functions*",
	ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
	RolloverText = TranslationTable[302535920001285--[[Opens in webbrowser]]],
	OnAction = ChoGGi.MenuFuncs.OpenUrl,
	setting_url = str_url .. "Tutorials/GameFunctions.lua",
	ActionSortKey = "-2*Game Functions*",
}

local tutorial_table = {
	"Add New Trait",
	"AirProdWaterConsump",
	"All Nearby Objects",
	"Change Animation",
	"DroneNoBatteryNeeded",
	"Export Import CSV",
	"Hidden Milestones",
	"Limit Debug Printing",
	"Locales",
	"Misc",
	"Msgs",
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
		ActionMenubar = "ECM.Help.Modding Tutorial",
		ActionId = "." .. name,
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = TranslationTable[302535920001285--[[Opens in webbrowser]]],
		OnAction = ChoGGi.MenuFuncs.OpenUrl,
		setting_url = str_url .. "Tutorials/" .. name .. ".md#readme",
		ActionSortKey = name == "Misc" and "-3 Misc" or "-3" .. name,
	}
end
