For packaged versions of these mods see [Steam](https://steamcommunity.com/workshop/filedetails/?id=1411210466) or [Nexus Mods](https://www.nexusmods.com/survivingmars/users/659381?tab=user+files).

### No warranty implied or otherwise!

Enables cheat menu, cheat info pane, console, examine object, adds a whole bunch of menuitems: set gravity, follow camera, higher render/shadow distance, larger shadow map, change logo/sponsor/commander, unlimited wonders, build almost anywhere, instant mysteries, useful shortcuts, etc... Requests are welcome.

##### Install help (non-steam/paradox)
```
Place Expanded Cheat Menu folder in %AppData%\Surviving Mars\Mods
(create Mods folder if it doesn't exist)
Other OS locations: https://pcgamingwiki.com/wiki/Surviving_Mars#Save_game_data_location
Enable with in-game mod manager
```
Also available at: [Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=1411157810), [NexusMods](https://www.nexusmods.com/survivingmars/mods/7), [ParadoxMods](https://mods.paradoxplaza.com/mods/645/Any)



##### Info
```
If you forget where a menu item is: Menu>Help>List All Menu Items (use "Filter Items" at the bottom).

Enter or Tilde: Show the console.
F2: Toggle the cheats menu (Ctrl-F2 to toggle selection panel cheats section).
F3: Set object opacity.
F4: Open object examiner (Shift/Ctrl-F4 for area examine).
F5: Open object manipulator (or use Tools>Edit obj in Examine).
F6: Change building colour (Shift-F6 or Ctrl-F6 to apply random/default).
F7: Toggle using last building orientation.
F9: Clear the console log (See console settings to turn off log).
Ctrl+F2: Toggle Cheats pane in Selection panel.
Ctrl+F: Fill resource of object.
Ctrl-Alt-Shift-R: Opens console and places "restart" in it.
Ctrl-Space: Opens placement mode with selected object/last built object.
Ctrl-Alt-Shift-D: Delete object (select multiple objects in editor and use this to delete them all).
Shift-Q: Clone selected object to mouse position.
Ctrl-Shift-T: Terrain Editor Mode (manipulate/paint ground).
Ctrl-Shift-E: Editor Mode (Buggy! I wouldn't save with it).

More shortcut keys are available; see cheat menu items.
You can edit the shortcut keys; see in-game keybindings.
If you want to be able to bind a menu item: msg me and I'll add a keybinding.

When I say object that means either the selected object or the object under the mouse cursor.

There's a cheats section in most selection panels on the right side of the screen.
Menu>ECM>Misc>Infopanel Cheats (on by default, Ctrl+F2 to toggle)
Hover over menu items for a description (will say if enabled or disabled).

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua, or in LocalStorage.lua when the blacklist is enabled.
There's also Help>ECM>Reset Settings, to manually edit see: Help>ECM>Edit Settings.
```



##### Console and Commands
```
Press Tilde (~), Enter, or Numpad Enter to show the console
Toggle showing history/results on-screen (it's on by default, see Console to change it)
type any name in to see it in the console log (ex: Consts)
exit : or quit
restart : or reboot
OpenExamine(Consts) : or ex(SelectedObj)
dump(12345) : dump puts files in AppData/logs
dumplua(dlgConsole) : dump using ValueToLuaCode()
trans() : translates "userdata: **********" or 6543256 to text
SelectedObj : or s
SelectionMouseObj() : or m(): object under mouse cursor
GetPreciseCursorObj() : or mc(): like SelectionMouseObj but compact
GetTerrainCursorObjSel() : or mh(): just the handle
GetTerrainCursor() : or c(): position of cursor: use with obj:SetPos(c())
terminal.GetMousePos : or cs(): mouse pos on screen, not map

See the console tooltip for shortcuts and other info.

you can paste chunks of code in the console to test out:
local BuildingTemplates = BuildingTemplates
for id,bld in pairs(BuildingTemplates) do
	print(id,bld.max_workers)
end

Create an "AppData/ECM Scripts" folder and any .lua files will show up in the Console menu.
```



##### Known issues
```
Going above 4096 capacity will make certain buildings laggy (houses/schools), and around 64K will crash.
	>Don't go too high...

If you increase a number high enough it'll go negative.
	>Don't go too high or you'll need to reset the value to default.

SM will freeze when you disable ECM.
	> ECM hooks into a lot of stuff, if you don't want the game to freeze when you disable it then restart SM so mods aren't loaded and then disable it.

Examine can fail to examine stuff.
	> Please let me know what it failed on.
```



##### Modder related (Misc Info)
```lua
-- If you want to examine an object that could get replaced with a new obj (and have examine refresh on the new obj):
OpenExamine("SomeTable.ThisObjCanChange", "str")
-- To choose where to open the examine dialog
OpenExamine(obj, point(x,y))
-- To have a custom title
OpenExamine(obj, nil, "Custom Title")
-- Loop the results of a function in an examine dialog
-- Set auto-refresh to how often you want the func fired
ChoGGi.ComFuncs.MonitorFunctionResults(func, arg1, arg2, etc args)
-- Get some info about a thread
ChoGGi.ComFuncs.RetThreadInfo(thread)
-- Checks a thread for a func name
ChoGGi.ComFuncs.FindThreadFunc(thread, str)
-- monitor a table (defaults to _G)
-- skip_under: don't show any tables under this length (default: 25)
-- sortby: nil = table length, 1 = table names
-- ChoGGi.ComFuncs.MonitorTableLength(HandleToObject)
ChoGGi.ComFuncs.MonitorTableLength(obj, skip_under, sortby)
-- lists the func location for all threads in ThreadsRegister
ChoGGi.ComFuncs.MonitorThreads()
```



##### New locales
```
Copy English.csv to the name of the language you want to translate it to.
Translate what you can (I don't expect anyone to bother with 1000+ strings).
Send me the file to include it.
```

##### Help it doesn't work!
```
Logs are stored at C:\Users\USERNAME\AppData\Roaming\Surviving Mars\logs
I can't help if I don't know what's wrong.
The steps you take to recreate the issue would also be useful, and maybe a save game depending on the issue.
```


##### Thank You
```
chippydip (for the original mod): http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
admbraden (for gifting me a Steam copy): https://steamcommunity.com/id/admbraden
HPK archiver: https://github.com/nickelc/hpk
unluac: https://sourceforge.net/projects/unluac/
Everyone else giving suggestions/pointing out issues.
```
