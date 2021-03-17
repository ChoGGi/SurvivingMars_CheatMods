return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 3,
		}),
	},
	"title", "Expanded Cheat Menu Test",
	"id", "ChoGGi_CheatMenu",
	"steam_id", "1411157810",
	"pops_desktop_uuid", "1b0ff48e-b493-4d34-b7be-9e6416e75827",
--~ 	"pops_any_uuid", "e2018d89-5b38-4068-b4fe-cb67352ee86a",
	"lua_revision", 1001514,
	"version", 163,
	"version_major", 16,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"last_changes", "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/Changelog.md#ecm-changelog",
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
	"has_options", true,
	"ignore_files", {
		"!examples*",
		"*.bat",
		"*.ini",
		"*.lnk",
		"*.txt",
		".gitignore",
	},
	"code", {
		-- start 'er up
		"Code/Init.lua",
		-- common functions
		"Code/ECM_Functions.lua",
		-- defaults, consts, read/save settings
		"Code/Settings.lua",
		-- new global funcs
		"Code/AddedFunctions.lua",
		-- console stuff
		"Code/ConsoleFuncs.lua",
		-- selection panel cheats pane
		"Code/InfoPaneCheats.lua",
		-- paint with hexes: HexPainter()
		"Code/HexPainter.lua",
		-- funcs that are replaced...
		"Code/ReplacedFunctions.lua",
		-- OnMsgs (most of them)
		"Code/OnMsgs.lua",
		-- not sure where to put this stuff
		"Code/Homeless.lua",
		-- used for the ged inspector and whatnot
		"Code/GedSocket.lua",
		-- Stop some errors when the editor is activated
		"Code/MapEditor.lua",

		-- custom dialogs
		"Code/Dialogs/ConsoleLogWin.lua",
		"Code/Dialogs/Examine.lua",
		"Code/Dialogs/ExecCode.lua",
		"Code/Dialogs/FindValue.lua",
		"Code/Dialogs/ObjectEditor.lua",
		"Code/Dialogs/3DManipulator.lua",
		"Code/Dialogs/ImageViewer.lua",
		"Code/Dialogs/DTMSlots.lua",
		"Code/Dialogs/TerminalRolloverMode.lua",

		-- menus/menu items/shortcuts
		"Code/Menus/BuildingsFunc.lua",
		"Code/Menus/BuildingsMenu.lua",
		"Code/Menus/CapacityFunc.lua",
		"Code/Menus/CapacityMenu.lua",
		"Code/Menus/CheatsFunc.lua",
		"Code/Menus/CheatsMenu.lua",
		"Code/Menus/ColonistsFunc.lua",
		"Code/Menus/ColonistsMenu.lua",
		"Code/Menus/ConstsFunc.lua",
		"Code/Menus/ConstsMenu.lua",
		"Code/Menus/DebugFunc.lua",
		"Code/Menus/DebugMenu.lua",
		"Code/Menus/DroneFunc.lua",
		"Code/Menus/DroneMenu.lua",
		"Code/Menus/ExpandedFunc.lua",
		"Code/Menus/ExpandedMenu.lua",
		"Code/Menus/FixesFunc.lua",
		"Code/Menus/FixesMenu.lua",
		"Code/Menus/GameFunc.lua",
		"Code/Menus/GameMenu.lua",
		"Code/Menus/HelpFunc.lua",
		"Code/Menus/HelpMenu.lua",
		"Code/Menus/MissionFunc.lua",
		"Code/Menus/MissionMenu.lua",
		"Code/Menus/ResourcesFunc.lua",
		"Code/Menus/ResourcesMenu.lua",
		"Code/Menus/RocketFunc.lua",
		"Code/Menus/RocketMenu.lua",
		"Code/Menus/RoverFunc.lua",
		"Code/Menus/RoverMenu.lua",
		"Code/Menus/ShuttleFunc.lua",
		"Code/Menus/ShuttleMenu.lua",
		"Code/Menus/TerraformingFunc.lua",
		"Code/Menus/TerraformingMenu.lua",
		"Code/Menus/KeysFunc.lua",
		"Code/Menus/Keys.lua",

		-- tortoise hares and all that
		"Code/Testing.lua",
	},

	"description", [[and Modding Tools. Enables cheat menu, cheat info pane, console, examine object, adds a few hundred menu items.
The mod for modding Surviving Mars.

Requests are welcome.

If you don't know where a menu item is; Menu>Help>List All Menu Items (use "Filter Items" at the bottom).

[url=https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/README.md]README[/url]
[url=https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/Changelog.md#ecm-changelog]Changelog[/url]
[url=https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/CheatsList.md]Menu Cheats List[/url]

Known Issues:
The game can crash if you disable this mod or my lib mod after the game has loaded mods: You have to disable from the main menu BEFORE new game/load game.

Available From:
https://steamcommunity.com/sharedfiles/filedetails/?id=1411157810
https://www.nexusmods.com/survivingmars/mods/7
https://mods.paradoxplaza.com/mods/21536/Windows
https://github.com/ChoGGi/SurvivingMars_CheatMods]],
})
