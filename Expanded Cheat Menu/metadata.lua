return PlaceObj("ModDef", {
	"title", "Expanded Cheat Menu v6.1",
	"version", 61,
	"saved", 1529323200,
	"steam_id", "1411157810",
	"code", {"Init.lua"},
	"id", "ChoGGi_CheatMenu",
	"image", "CheatMenu.png",
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
	"author", [[ChoGGi
With thanks to chippydip, admbraden, SkiRich, BoehserOnkel, and Fling.
Random internet users reporting bugs/requesting features.]],
	"description", [[Enables cheat menu, cheat info pane, console, adds a whole bunch of menuitems: set gravity, follow camera, higher render/shadow distance, larger shadow map, change logo/sponsor/commander, unlimited wonders, build almost anywhere, instant mysteries, useful shortcuts, etc... Requests are welcome.

The only mod a modder needs.

Bleeding edge: https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Expanded%20Cheat%20Menu\
Badly outdated list of features: https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/README.md#list-of-some-stuff-added-not-up-to-date

##### Info
```
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

To edit and use files from Files.hpk, use HPK archiver to extract them into the mod folder.
If Defaults.lua is in the same place as Init.lua you did it correctly.

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua
^ delete to reset to default settings (unless it's something like changing capacity of RC Transports, that's kept in savegame)
```

##### Fixes
```
Menu>ECM>Fixes>
Drones Keep Trying Blocked Rocks:
If you have a certain dronehub who's drones keep trying to get rock they can't reach, try this.

Idle Drones Won't Build When Resources Available
If you have drones that are idle while contruction sites need to be built and resources are available then you likely have some unreachable building sites.
This removes any of those (resources won't be touched).

Remove Yellow Grid Marks
If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them

Drone Carry Amount
Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.
This forces them to pick up whenever there's more then one resource).
If you have an insane production amount set then it'll take an (in-game) hour between calling drones.

Project Morpheus Radar Fell Down
Sometimes the blue radar thingy falls off.

Cables & Pipes: Instant Repair
Instantly repair all broken pipes and cables.

And a bunch more (certain crashes with colonists rovers, etc)
```

##### Console
```
Toggle showing history/results on-screen (Menu>Debug, it's on by default)
type any name in to see it in the console log (ex: Consts)
exit : or quit
restart : or reboot
OpenExamine(Consts) : or ex(SelectedObj) or ~Object
dump(12345) : dump puts files in AppData/logs
dumplua(dlgConsole) : dump using ValueToLuaCode()
dumpobject(SelectedObj) : or dumpo
dumptable(Consts) : or dumpt
trans() : translate userdata: ********** or 6543256 to text, or use $Object
SelectedObj : or s
SelectionMouseObj() : or m, object under mouse cursor
GetPreciseCursorObj() : or mc, like SelectionMouseObj but compact
GetTerrainCursorObjSel() : or mh, just the handle
GetTerrainCursor() : or c, position of cursor: use with s:SetPos(c()), or point(c():x(), c():y(), c():z())
terminal.GetMousePos : or cs, mouse pos on screen, not map

also @ for debug.getinfo(), @@ for type(), ! to select/view, !! to examine attached objects, *r/*g to wrap code in real/game time threads

If you want to overwrite instead of append text: dumpobject(Presets.TechPreset,"w")
If you want to dump functions as well: dumptable(Presets.TechPreset,nil,true)
If you want to save the console text: Debug>Write Logs (very helpful for examining an object)

you can paste chunks of scripts to test out:
local templates = DataInstances.BuildingTemplate
for i = 1, #templates do
  local building = templates[i]
	print(building.name)
end
```

##### Known issues
```
Going above 4096 capacity will make certain buildings laggy (houses/schools), and around 64K will crash.
  >Don't go too high...

If you increase a number high enough it'll go negative.
  >Don't go too high or use the menu to reset to default (if it's still broken send me your save).

You can't cheat fill concrete deposits.
  >Got me.
```

##### Thanks
```
chippydip (for the original mod): http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
admbraden (for gifting me a Steam copy): https://steamcommunity.com/id/admbraden
HPK archiver: https://github.com/nickelc/hpk
unluac: https://sourceforge.net/projects/unluac/
```]],

})
