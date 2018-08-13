local mod_path = ConvertToOSPath(_G.CurrentModPath)
--~ local url = "https://github.com/ChoGGi/SurvivingMars_CheatMods/HelperMod.zip"
return PlaceObj("ModDef", {
	"title", "Expanded Cheat Menu v8.0 Test",
	"version", 80,
	"saved", 1534075200,
	"steam_id", "1411157810",
	"code", {"Init.lua"},
	"id", "ChoGGi_CheatMenu",
	"image", "Preview.png",
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
--~ 	"lua_revision", LuaRevision,

  "last change" , string.format([[v8.0
Da Vinci Update:
If this mod is disabled due to version compatibility then you need to install the helper mod at:
%sHelperMod
]],mod_path),

	"author", [[ChoGGi
With thanks to chippydip, admbraden, SkiRich, BoehserOnkel, and Fling.
Random internet users reporting bugs/requesting features.]],
	"description", string.format([[Enables cheat menu, cheat info pane, console, adds a whole bunch of menuitems: set gravity, follow camera, higher render/shadow distance, larger shadow map, change logo/sponsor/commander, unlimited wonders, build almost anywhere, instant mysteries, useful shortcuts, etc... Requests are welcome.

If this mod is disabled due to version compatibility then you need to install the helper mod at:
%sHelperMod



##### Info
F2: Toggle the cheats menu (Ctrl-F2 to toggle cheats panel).
F3: Set object opacity.
F4: Open object examiner.
F5: Open object manipulator (or use edit button in examiner).
F6: Change building colour (Shift or Ctrl to apply random/default).
F7: Toggle using last building orientation.
F9: Clear the console log.
Ctrl+F: Fill resource of object.
Enter or Tilde: Show the console.
Number keys: Toggle build menu (Shift-*Num for menus above 10).
Ctrl-Alt-Shift-R: Opens console and places "restart" in it.
Ctrl-Space: Opens placement mode with the last built object.
Ctrl-Shift-Space: Opens placement mode with selected object (works with deposits).
Ctrl-Shift-F: Follow Camera (follow an object around).
Ctrl-Alt-F: Toggle mouse cursor (useful in follow mode to select stuff).
Ctrl-Shift-E: Toggle editor mode (select object then hold ctrl/shift/alt and drag mouse).
Ctrl-Alt-Shift-D: Delete object (select multiple objects in editor and use this to delete them all).
Shift-Q: Clone selected object to mouse position.
More shortcut keys are available, see menu items.

When I say object that means either the selected object or the object under the mouse cursor.

There's a cheats section in most selection panels on the right side of the screen.
Menu>Misc>Infopanel Cheats (on by default)
Hover over menu items for a description (will say if enabled or disabled).

Settings are saved at %%APPDATA%%\Surviving Mars\CheatMenuModSettings.lua
^ delete to reset to default settings (unless it's something like changing capacity of RC Transports, that's kept in savegame)

You can edit the shortcut keys in the settings file (or blank them to disable).



##### For more info see Menu>Help>ECM>Readme
Bleeding edge: https://github.com/ChoGGi/SurvivingMars_CheatMods



##### Thanks
chippydip (for the original mod): http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
admbraden (for gifting me a Steam copy): https://steamcommunity.com/id/admbraden
HPK archiver: https://github.com/nickelc/hpk
unluac: https://sourceforge.net/projects/unluac/
Everyone else giving suggestions/pointing out issues.]],mod_path),
})
