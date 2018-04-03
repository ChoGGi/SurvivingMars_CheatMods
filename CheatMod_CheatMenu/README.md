You should buy a copy: http://store.steampowered.com/app/464920

### No warranty implied or otherwise!

##### Info
```
Enables Cheat menu, Cheat info pane, Console, adds a whole bunch of menuitems, set gravity, follow camera, allows you to build as many Wonders as you want, build almost anywhere, etc...

F2: Toggle the cheats menu.
F4: Open object examiner for selected object (now with dump button)
Ctrl+F: Fill resource of selected object
Enter or Tilde to show the console
F9 to clear the console log
Ctrl-Alt-Shift-R: opens console and puts restart in it
Ctrl-Space: Opens placement mode with the last placed item
Ctrl-Shift-Space: Opens placement mode with the selected item
Ctrl-Shift-F: Follow Camera (select an object to follow around)
Ctrl-Alt-F: Follow Camera toggle mouse
Ctrl-Shift-E: Toggle editor mode

There's a cheats section in most info panels on the right side of the screen.
Menu>Gameplay>QoL>Infopanel Cheats (on by default, as well as the empty cheat being disabled)

Hover over menu items for a description (will say if enabled or disabled)
If a menu has "+ *number*" then it'll increase it by that number each time

Thanks to chippydip (for the original mod) and therealshibe (for mentioning it)
http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
```

##### List of some stuff added (not up to date)
```
Increasable Capacity Colonist/Visitor/Battery/Air/Water
Set Colonists Age,Sex,Comfort,Health,Morale,Sanity
Traits Add All/Remove All Negative/Positive
Remove Building Limits (Buildings can be placed almost anywhere (no uneven terrain, it messes the buildings up))
Increase Production Amounts
Set Gravity for Colonists,Drones,RCs (bouncy time)
Fire All Colonists
Turn Off All Shifts/Turn On All Shifts
Set New Colonists Age,Sex
Sanatorium Cure All Traits
School Train All Traits
Sanatorium/School Show All Traits
Show All Traits in Sanatorium/School
Colonist Residence Capacity
Add Prefabs
Fill Resource Selected
Add Mystery Breakthrough Buildings
BreakThrough Techs Per Game
Research Every Breakthrough
Research Every Mystery
Research Queue Larger Toggle
Unlock Every Breakthrough
AvoidWorkplaceToggle
Birth Threshold
Asteroid Bombardment At Cursor
Building Show Hidden
Building Wonder
Building Damage Crime Toggle
Cables And Pipes Toggle
Border Scrolling Toggle
Camera Zoom Dist
Camera Zoom Speed
Chance Of Negative Trait
Chance Of Sanity Damage
Colonists Chance Of Suicide
Colonists Add Specialization To All
Colonists Morale Max Toggle
Colonists Per Rocket
Colonists Starve Toggle
Colonists Suffocate Toggle
Construction For Cheap
Deep Scan Toggle
Deeper Scan Enable
Drone Battery Infinite
Drone Build Speed
Drone Carry Amount Increase
Drone Meteor Malfunction
Drone Recharge Time Toggle
Drone Repair Supply Leak Toggle
Drones Per DroneHub Increase
Drones Per RC Rover Increase
RC Rover Drone Recharge Free Toggle
RC Transport Transfer Speed
RC Transport Storage Increase
Food Per Rocket Passenger Increase
Fully Automated Buildings
Add Funds
Game Speed Default,Double,Triple,Quad,Octuple,Sexdecuple,Duotriguple,Quattuorsexaguple
Maintenance Free Buildings
Meteor Health Damage Toggle
Min Comfort Birth
Moisture Vaporator Penalty Toggle
Outside Workplace Radius Increase
Outsource Points 1000000
Outsourcing Free Toggle
Performance Penalty Non-Specialist Toggle
Positive Playground Toggle
Project Morpheus Positive Trait Toggle
Renegade Creation Toggle
Rocket Cargo Capacity Toggle
Rocket Travel Instant Toggle
Scanner Queue Larger Toggle
Spacing between Pipe Pillars
Storage Depot / Waste Dump increase
Toggle Infopanel Cheats
Visit Fail Penalty Toggle
Write Logs
Repair Pipes/Cables (instantly repairs them all)
Crop Fail Threshold Toggle (lower the threshold to 0)
Build Spires Outside of Spire Point
Allow Dome Forbidden Buildings
Allow Dome Required Buildings
Allow Tall Buildings Under Pipes
Instant Build
See Dead Sanity Damage Toggle
No Home Comfort Damage Toggle
ShuttleHub Shuttles Increase
Asteroids (single,multi,storm)
Toggle Editor (you can move stuff around (if you really want a bunch of colonists moving around inside a dome that isn't there anymore)
Open In Ged Editor (lets you open some objects in the ged editor)
Start Mysteries

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua
^ delete to reset to default settings (unless it's something like changing capacity of RC Transports, that's kept in savegame)
```

##### Console
```
Toggle showing history/results on-screen (Menu>Debug, it's on by default)
type any name in to see it in the console log (ex: Consts)
exit (or quit)
restart (or reboot)
examine(Consts) (or ex(SelectedObj))
dump(Consts) (dump puts files in AppData/logs)
dumplua(dlgConsole) (dumps using TupleToLuaCode())
dumpobject(SelectedObj) (or dumpo)
dumptable(Consts) (or dumpt)
SelectedObj (or s)
SelectionMouseObj() (or sm)
GetTerrainCursorObjSel() (or st or cur)
GetPreciseCursorObj() (or sp)
GetTerrainCursor() (or sc)

If you want to overwrite instead of append text: dumpobject(TechTree,"w")
If you want to dump functions as well: dumptable(TechTree,nil,true)
If you want to save the text then Debug>Write Logs

you can paste chunks of scripts to test out:
local templates = DataInstances.BuildingTemplate
for i = 1, #templates do
  local building = templates[i]
	print(building.name)
end

some functions I added that may be useful for modding:

ChoGGi.PrintIds(TechTree): Dumps table names+number (access with TechTree[6][46])
TechTree[6][46] = Breakthroughs>PrefabCompression

ChoGGi.ReturnTechAmount(Tech,Prop)
returns number from TechTree (so you know how much it changes)

ChoGGi.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket").a
^returns 10
ChoGGi.ReturnTechAmount("HullPolarization","BuildingMaintenancePointsModifier").p
^ returns 0.25

it returns percentages in decimal for ease of mathing
ie: BuildingMaintenancePointsModifier is -25 this returns it as 0.25
it also returns negative amounts as positive (I prefer doing num - Amt, not num + Amt)
```
