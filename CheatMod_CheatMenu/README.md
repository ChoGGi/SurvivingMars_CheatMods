You should buy a copy: http://store.steampowered.com/app/464920

### No warranty implied or otherwise!

Enables Cheat menu, Cheat info pane, Console, adds a whole bunch of menu items: set gravity, follow camera, higher render/shadow distance, change logo, unlimited wonders, build almost anywhere, etc...

##### Info
```
F2: Toggle the cheats menu.
F4: Open object examiner for selected object (now with dump button)
Ctrl+F: Fill resource of selected object
Enter or Tilde to show the console
F9 to clear the console log
Ctrl-Alt-Shift-R: opens console and places "restart" in it
Ctrl-Space: Opens placement mode with the last placed item
Ctrl-Shift-Space: Opens placement mode with the selected (or object under mouse) item
Ctrl-Shift-F: Follow Camera (select an object to follow around)
Ctrl-Alt-F: Toggle mouse cursor
Ctrl-Shift-E: Toggle editor mode
Ctrl-Alt-Shift-D: Delete object (selected or object under mouse)

There's a cheats section in most info panels on the right side of the screen.
Menu>Gameplay>QoL>Infopanel Cheats (on by default, as well as the empty cheat being disabled)

Hover over menu items for a description (will say if enabled or disabled)
If a menu has "+ *number*" then it'll increase it by that number each time

Thanks to chippydip (for the original mod) and therealshibe (for mentioning it)
http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
```

##### List of some stuff added (not up to date)
```
Disable Texture Compression
Set Shadow Map Size
Set Death Age to 250
Add 250 Applicants
Change Sponsor/Commander
Change logo
Change occurrence level of disasters
Increasable Capacity Colonist/Visitor/Battery/Air/Water
Set Colonists Age,Sex,Comfort,Health,Morale,Sanity
Traits Add All/Remove All Negative/Positive
Remove Building Limits (they can be placed almost anywhere: no uneven terrain, it messes the buildings up)
Set New Colonists Age,Sex
Sanatorium Cure All Traits
School Train All Traits
Sanatorium/School Show All Traits
Show All Traits in Sanatorium/School
Colonist Residence Capacity
Add Prefabs
Fill Resource Selected
Start Mysteries
Add Mystery Buildings
Amount of BreakThrough Techs Per Game
Research Every Breakthrough
Research Every Mystery
Research Queue Larger Toggle
Unlock Every Breakthrough
Avoid Workplace Toggle
Show Hidden Buildings
Unlimited Wonders
Building Damage Crime Toggle
Cables & Pipes: Instant Build
Cables & Pipes: Instant Repair
Cables & Pipes: No Chance Of Break
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
Add Funds/Reset Funds
Game Speed Default,Double,Triple,Quad,Octuple,Sexdecuple,Duotriguple,Quattuorsexaguple
Maintenance Free Buildings
Meteor Health Damage Toggle
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
Crop Fail Threshold Toggle (lower the threshold to 0)
Build Spires Outside of Spire Point
Allow Dome Forbidden Buildings
Allow Dome Required Buildings
Allow Tall Buildings Under Pipes
Instant Build (most items)
See Dead Sanity Damage Toggle
No Home Comfort Damage Toggle
ShuttleHub Shuttles Increase
Asteroids (single,multi,storm)
Toggle Editor (you can move stuff around (if you really want a bunch of colonists moving around inside a dome that isn't there anymore)
Open In Ged Editor (lets you open some objects in the ged editor)

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
dumplua(dlgConsole) (dump using ValueToLuaCode())
dumpobject(SelectedObj) (or dumpo)
dumptable(Consts) (or dumpt)
SelectedObj (or s)
SelectionMouseObj() (or sm)
GetTerrainCursorObjSel() (or st or cur)
GetPreciseCursorObj() (or sp)
GetTerrainCursor() (or sc)

If you want to overwrite instead of append text: dumpobject(TechTree,"w")
If you want to dump functions as well: dumptable(TechTree,nil,true)
If you want to save the console text: Debug>Write Logs (very helpful for examining an object)

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
see: Data/TechTree.lua, or ex(TechTree)

ChoGGi.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty").a
^returns 10
ChoGGi.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance").p
^ returns 0.7

it returns percentages in decimal for ease of mathing (SM removed the math.functions from lua)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - PositiveAmt, not num + NegativeAmt)

if .a is 0 or .p is 0.0 then you most likely have the wrong one
(TechTree'll always return both, I assume there's a default value somewhere)
```

##### Known issues
```
Going above 4096 or so will making clicking on certain buildings laggy (houses/schools).
  Don't go too high...

If you increase a number high enough it'll go negative.
  Don't go too high or use the menu to reset to default (if it's still broken send me your save).

Production will reset when the production changes (Solar panels, Wind turbines, etc).
  It is what it is.
```
