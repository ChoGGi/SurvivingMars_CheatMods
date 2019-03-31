return PlaceObj("ModDef", {
--~ 	"title", "Expanded Cheat Menu (ECM)",
	"title", "Expanded Cheat Menu v13.4 Test",
	"version", 134,
	"saved", 1553947200,
	"image", "Preview.png",
	"id", "ChoGGi_CheatMenu",
	"author", "ChoGGi",
	"steam_id", "1411157810",
	"pops_any_uuid", "46d8ac6c-8e28-4224-b987-95c3021482b5",
	"last_changes", "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/Changelog.md#ecm-changelog",
	"lua_revision", LuaRevision,
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
	"code", {
		-- start 'er up
		"Code/Init.lua",
		-- common functions
		"Code/ECM_Functions.lua",
		-- defaults,consts,read/save settings
		"Code/Settings.lua",

		-- custom dialogs
		"Code/Dialogs/ConsoleLogWin.lua",
		"Code/Dialogs/Examine.lua",
		"Code/Dialogs/ExecCode.lua",
		"Code/Dialogs/FindValue.lua",
--~ 		"Code/Dialogs/MonitorInfo.lua",
		"Code/Dialogs/ObjectEditor.lua",
		"Code/Dialogs/3DManipulator.lua",
		"Code/Dialogs/ImageViewer.lua",
		"Code/Dialogs/DTMSlots.lua",
		"Code/Dialogs/TerminalRolloverMode.lua",

		-- stuff that can come later
		"Code/Misc/AddedFunctions.lua",
		"Code/Misc/ConsoleFuncs.lua",
		"Code/Misc/InfoPaneCheats.lua",
		"Code/Misc/HexPainter.lua",
		"Code/Misc/ReplacedFunctions.lua",
		"Code/Misc/OnMsgs.lua",
		"Code/Misc/GedSocket.lua",

		-- menus/menu items/shortcuts
		"Code/Menus/BuildingsFunc.lua",
		"Code/Menus/BuildingsMenu.lua",
		"Code/Menus/CapacityFunc.lua",
		"Code/Menus/CapacityMenu.lua",
		"Code/Menus/CheatsFunc.lua",
		"Code/Menus/CheatsMenu.lua",
		"Code/Menus/ColonistsFunc.lua",
		"Code/Menus/ColonistsMenu.lua",
		"Code/Menus/DebugFunc.lua",
		"Code/Menus/DebugMenu.lua",
		"Code/Menus/ExpandedFunc.lua",
		"Code/Menus/ExpandedMenu.lua",
		"Code/Menus/FixesFunc.lua",
		"Code/Menus/FixesMenu.lua",
		"Code/Menus/GameFunc.lua",
		"Code/Menus/GameMenu.lua",
		"Code/Menus/HelpFunc.lua",
		"Code/Menus/HelpMenu.lua",
		"Code/Menus/MiscFunc.lua",
		"Code/Menus/MiscMenu.lua",
		"Code/Menus/MissionFunc.lua",
		"Code/Menus/MissionMenu.lua",
		"Code/Menus/ResourcesFunc.lua",
		"Code/Menus/ResourcesMenu.lua",
		"Code/Menus/VehiclesFunc.lua",
		"Code/Menus/VehiclesMenu.lua",
		"Code/Menus/KeysFunc.lua",
		"Code/Menus/Keys.lua",

		-- tortoise hares and all that
		"Code/Misc/Testing.lua",

		-- gee sure would be nice to load these like the devs do, but i suppose it's too much work to limit dofile env.
	},

	"description", [[and Modding Tools. Enables cheat menu, cheat info pane, console, examine object, adds a few hundred menuitems: set gravity, follow camera, higher render/shadow distance, larger shadow map, change logo/sponsor/commander, unlimited wonders, build almost anywhere, instant mysteries, useful shortcuts, etc... Requests are welcome.

If you forget where a menu item is: Menu>Help>List All Menu Items (use "Filter Items" at the bottom).

##### Info
F2: Toggle the cheats menu (Ctrl-F2 to toggle cheats panel).
F3: Set object opacity.
F4: Open object examiner (Shift-F4 for area).
F5: Open object manipulator (or use Tools>Edit obj in Examine).
F6: Change building colour (Shift-F6 or Ctrl-F6 to apply random/default).
F7: Toggle using last building orientation.
F9: Clear the console log.
Enter or Tilde: Show the console.
Ctrl+F: Fill resource of object.
Number keys: Toggle build menu (Shift-*Num for menus above 10).
Ctrl-Alt-Shift-R: Opens console and places "restart" in it.
Ctrl-Space: Opens placement mode with the last built object.
Ctrl-Shift-Space: Opens placement mode with selected object (works with deposits).
Ctrl-Alt-Shift-D: Delete object (select multiple objects in editor and use this to delete them all).
Shift-Q: Clone selected object to mouse position.
Ctrl-Shift-T: Terrain Editor Mode (manipulate/paint ground).

More shortcut keys are available; see cheat menu items.
You can edit the shortcut keys; see in-game keybindings.
If you want to be able to bind a menu item: msg me and I'll add it to keybindings.

There's a cheats section in most selection panels on the right side of the screen.
Menu>ECM>Misc>Infopanel Cheats (on by default)

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua, or in LocalStorage.lua when the blacklist is enabled.
There's also Help>ECM>Reset Settings, to manually edit see: Help>ECM>Edit Settings.



##### For more info see Menu>Help>ECM>Readme
Bleeding edge: https://github.com/ChoGGi/SurvivingMars_CheatMods



##### Help it doesn't work!
Logs are stored at %APPDATA%\Surviving Mars\logs or C:\Users\USERNAME\AppData\Roaming\Surviving Mars\logs
I can't help if I don't know what's wrong.
The steps you take to recreate the issue would also be useful, and maybe a save game depending on the issue.



##### Access to missing functionality
Da Vinci update added a blacklist of functions, you can use this to bypass them (only really useful for modders).
]] .. ConvertToOSPath(CurrentModPath) .. [[HelperMod



##### Thanks
chippydip (for the original mod): http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
admbraden (for gifting me a Steam copy): https://steamcommunity.com/id/admbraden
HPK archiver: https://github.com/nickelc/hpk
unluac: https://sourceforge.net/projects/unluac/
Everyone else giving suggestions/pointing out issues.



##### Available From:
https://steamcommunity.com/sharedfiles/filedetails/?id=1411157810
https://www.nexusmods.com/survivingmars/mods/7
https://mods.paradoxplaza.com/mods/669/Any
https://github.com/ChoGGi/SurvivingMars_CheatMods]],
})
