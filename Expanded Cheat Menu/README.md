You should buy a copy: [GOG](https://www.gog.com/game/surviving_mars) or [Steam](http://store.steampowered.com/app/464920)

### No warranty implied or otherwise!

Enables cheat menu, cheat info pane, console, examine object, adds a whole bunch of menuitems: set gravity, follow camera, higher render/shadow distance, larger shadow map, change logo/sponsor/commander, unlimited wonders, build almost anywhere, instant mysteries, useful shortcuts, etc... Requests are welcome.

##### Install help
```
Place CheatMod_CheatMenu folder in %AppData%\Surviving Mars\Mods
(create Mods folder if it doesn't exist)
Other OS locations: https://pcgamingwiki.com/wiki/Surviving_Mars#Save_game_data_location
Enable with in-game mod manager
```



##### Info
```
If you forget where a menu item is: Menu>Help>List All Menu Items (use "Filter Items" at the bottom).

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

When I say object that means either the selected object or the object under the mouse cursor.

There's a cheats section in most selection panels on the right side of the screen.
Menu>ECM>Misc>Infopanel Cheats (on by default)
Hover over menu items for a description (will say if enabled or disabled).

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua, or in-game when blacklist isn't disabled.
Help>Reset Settings will also do the same thing.

To manually edit see: Help>ECM>Edit Settings.
```



##### List of some stuff added (not up to date)
```
Add Applicants
Add Funds/Reset Funds
Add Mystery Buildings
Add Prefabs
Add Research Points
Allow Dome Forbidden Buildings
Allow Dome Required Buildings
Allow Tall Buildings Under Pipes
Amount of BreakThrough Techs Per Game
Asteroids (single,multi,storm)
Avoid Workplace
Border Scrolling
Build Spires Outside of Spire Point
Building Damage Crime
Cables & Pipes: Instant Build
Cables & Pipes: Instant Repair
Cables & Pipes: No Chance of Break
Camera Zoom Dist
Chance of Negative Trait
Chance of Sanity Damage
Change Logo
Change Occurrence Level of Disasters
Change Sponsor/Commander
Colonist Residence Capacity
Colonists Add Specialization To All
Colonists Chance of Suicide
Colonists Morale Max
Colonists Min birth threshold
Colonists Per Rocket
Colonists Starve
Colonists Suffocate
Construction For Cheap
Crop Fail Threshold (lower the threshold to 0)
Deep Scan
Deeper Scan Enable
Disable Texture Compression
Drone Battery Infinite
Drone Build Speed
Drone Carry Amount Increase
Drone Meteor Malfunction
Drone Recharge Time
Drone Repair Supply Leak
Drones Per DroneHub Increase
Drones Per RC Rover Increase
Fill Resource Selected
Food Per Rocket Passenger Increase
Fully Automated Buildings
Game Speed Default,Double,Triple,Quad,Octuple,Sexdecuple,Duotriguple,Quattuorsexaguple
Increasable Capacity Colonist/Visitor/Battery/Air/Water
Instant Build (most items)
Maintenance Free Buildings
Meteor Health Damage
Moisture Vaporator Penalty
No Home Comfort Damage
Open In Ged Editor (lets you open some objects in the ged editor)
Outside Workplace Radius Increase
Outsource Points 1000000
Outsourcing Free
Performance Penalty Non-Specialist
Positive Playground
Project Morpheus Positive Trait
RC Rover Drone Recharge Free
RC Transport Storage Increase
RC Transport Transfer Speed
Remove Building Limits (they can be placed almost anywhere: no uneven terrain, it messes the buildings up)
Renegade Creation
Research Every Breakthrough
Research Every Mystery
Research Queue Larger
Rocket Cargo Capacity
Rocket Travel Instant
Sanatorium Cure All Traits
Sanatorium/School Show All Traits
Scanner Queue Larger
School Train All Traits
See Dead Sanity Damage
Set Colonists Age,Sex,Comfort,Health,Morale,Sanity
Set Death Age
Set New Colonists Age,Sex
Set Shadow Map Size
Set Transparency of UI items
Set Opacity of objects
Show All Traits in Sanatorium/School
Show Hidden Buildings
ShuttleHub Shuttles Increase
Spacing between Pipe Pillars
Start Mysteries (mysteries don't start till after you have 100 colonists, and an amount of time has passed. they stack up, so I wouldn't start too many)
Storage Depot / Waste Dump capacity increase
Toggle Editor (you can move stuff around: if you really want a bunch of colonists moving around inside a dome that isn't there anymore)
Toggle Infopanel Cheats
Traits: Add/Remove All Negative or Positive
Unlimited Wonders
Unlock Every Breakthrough
Visit Fail Penalty
Write Logs
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
dumptable(Consts) : or dumpt
trans() : translates "userdata: **********" or 6543256 to text
SelectedObj : or s
SelectionMouseObj() : or m(), object under mouse cursor
GetPreciseCursorObj() : or mc(), like SelectionMouseObj but compact
GetTerrainCursorObjSel() : or mh(), just the handle
GetTerrainCursor() : or c(), position of cursor: use with s:SetPos(c()), or point(c():x(), c():y(), c():z())
terminal.GetMousePos : or cs, mouse pos on screen, not map

~example for OpenExamine()
@function for debug.getinfo()
@@example for type()
$example to translate userdata/stringbase
!example to select/view
!!example to examine attached objects
&handle to open object in examiner
*r/*g/*m to wrap code in real/game/mapreal time threads

you can paste chunks of code in the console to test out (no -- comments allowed, since DA update merges pasted lines):
 local BuildingTemplates = BuildingTemplates
 for _,bld in pairs(BuildingTemplates) do
    local building = bld
    print(bld.id)
  end
Or create an "AppData/ECM Scripts" folder and any .lua files will show up in the Console menu.
```



##### Known issues
```
Going above 4096 capacity will make certain buildings laggy (houses/schools), and around 64K will crash.
  >Don't go too high...

If you increase a number high enough it'll go negative.
  >Don't go too high or you'll need to reset the value to default.

Depot capacities have been limited, so adding too much won't crash and delete your game when you save.
  >Best I can tell is a height limit of 65536 for any objects.

SM will freeze when you disable ECM
	> ECM hooks into a lot of stuff, if you don't want the game to freeze when you disable it then restart SM so mods aren't loaded and then disable it.

Silva's Modular Apartments and the Cheats pane upgrade 1/2/3 == game freezing
	> Do it manually; Select building, in console paste: s:ApplyUpgrade(1,true)
```



##### Modder related (Misc Info)
```
If you want to examine an object that could get replaced with a new obj (and have examine refresh on the new obj):
OpenExamine("ChoGGi.UserSetting.ThisObjCanChange","str")
To choose where to open the examine dialog
OpenExamine(obj,point(x,y))
To have a custom title
OpenExamine(obj,nil,"Custom Title")
```



##### New locales
```
Copy English.csv to the name of the language you want to translate it to.
Translate what you can (I don't expect anyone to bother with 1000+ strings).
Send me the file to include it.

OpenExamine(AllLanguages) for a list of language names (use the "value" for the file name).
```

##### Help it doesn't work!
```
Logs are stored at C:\Users\USERNAME\AppData\Roaming\Surviving Mars\logs
I can't help if I don't know what's wrong.
The steps you take to recreate the issue would also be useful, and maybe a save game depending on the issue.
```



##### Access to missing functionality
```
Da Vinci update added a blacklist of functions, you can use The HelperMod included to bypass them (only really useful for modders).
```

##### Thank You
```
chippydip (for the original mod): http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
admbraden (for gifting me a Steam copy): https://steamcommunity.com/id/admbraden
HPK archiver: https://github.com/nickelc/hpk
unluac: https://sourceforge.net/projects/unluac/
Everyone else giving suggestions/pointing out issues.
```
