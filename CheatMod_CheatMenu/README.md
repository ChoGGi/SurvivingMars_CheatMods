You should buy a copy: http://store.steampowered.com/app/464920

### No warranty implied or otherwise!

Enables cheat menu, cheat info pane, console, adds a whole bunch of menuitems: set gravity, follow camera, higher render/shadow distance, larger shadow map, change logo, unlimited wonders, build almost anywhere, etc... Useful for testing out mods. Requests are welcome.

##### Install help
```
Place CheatMod_CheatMenu folder in %AppData%\Surviving Mars\Mods (Create Mods folder if it doesn't exist)
Other OS locations: https://pcgamingwiki.com/wiki/Surviving_Mars#Save_game_data_location
Enable with in-game mod manager
```

##### Info
```
F2: Toggle the cheats menu.
F4: Open object examiner for object
Ctrl+F: Fill resource of object
Enter or Tilde: Show the console
F9: Clear the console log
Ctrl-Alt-Shift-R: Opens console and places "restart" in it
Ctrl-Space: Opens placement mode with the last placed object
Ctrl-Shift-Space: Opens placement mode with selected object (works with deposits)
Ctrl-Shift-F: Follow Camera (follow an object around)
Ctrl-Alt-F: Toggle mouse cursor (useful in follow mode to select stuff)
Ctrl-Shift-E: Toggle editor mode
Ctrl-Alt-Shift-D: Delete object

When I say object that means either the selected object or the object under the mouse cursor

There's a cheats section in most info panels on the right side of the screen.
Menu>Gameplay>QoL>Infopanel Cheats (on by default, as well as the empty cheat being disabled)

Hover over menu items for a description (will say if enabled or disabled)
If a menu has "+ *number*" then it'll increase it by that number each time
```

##### List of some stuff added (not up to date)
```
Add 250 Applicants
Add Funds/Reset Funds
Add Mystery Buildings
Add Prefabs
Allow Dome Forbidden Buildings
Allow Dome Required Buildings
Allow Tall Buildings Under Pipes
Amount of BreakThrough Techs Per Game
Asteroids (single,multi,storm)
Avoid Workplace Toggle
Border Scrolling Toggle
Build Spires Outside of Spire Point
Building Damage Crime Toggle
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
Colonists Morale Max Toggle
Colonists Per Rocket
Colonists Starve Toggle
Colonists Suffocate Toggle
Construction For Cheap
Crop Fail Threshold Toggle (lower the threshold to 0)
Deep Scan Toggle
Deeper Scan Enable
Disable Texture Compression
Drone Battery Infinite
Drone Build Speed
Drone Carry Amount Increase
Drone Meteor Malfunction
Drone Recharge Time Toggle
Drone Repair Supply Leak Toggle
Drones Per DroneHub Increase
Drones Per RC Rover Increase
Fill Resource Selected
Food Per Rocket Passenger Increase
Fully Automated Buildings
Game Speed Default,Double,Triple,Quad,Octuple,Sexdecuple,Duotriguple,Quattuorsexaguple
Increasable Capacity Colonist/Visitor/Battery/Air/Water
Instant Build (most items)
Maintenance Free Buildings
Meteor Health Damage Toggle
Moisture Vaporator Penalty Toggle
No Home Comfort Damage Toggle
Open In Ged Editor (lets you open some objects in the ged editor)
Outside Workplace Radius Increase
Outsource Points 1000000
Outsourcing Free Toggle
Performance Penalty Non-Specialist Toggle
Positive Playground Toggle
Project Morpheus Positive Trait Toggle
RC Rover Drone Recharge Free Toggle
RC Transport Storage Increase
RC Transport Transfer Speed
Remove Building Limits (they can be placed almost anywhere: no uneven terrain, it messes the buildings up)
Renegade Creation Toggle
Research Every Breakthrough
Research Every Mystery
Research Queue Larger Toggle
Rocket Cargo Capacity Toggle
Rocket Travel Instant Toggle
Sanatorium Cure All Traits
Sanatorium/School Show All Traits
Scanner Queue Larger Toggle
School Train All Traits
See Dead Sanity Damage Toggle
Set Colonists Age,Sex,Comfort,Health,Morale,Sanity
Set Death Age to 250
Set New Colonists Age,Sex
Set Shadow Map Size
Show All Traits in Sanatorium/School
Show Hidden Buildings
ShuttleHub Shuttles Increase
Spacing between Pipe Pillars
Start Mysteries
Storage Depot / Waste Dump increase
Toggle Editor (you can move stuff around: if you really want a bunch of colonists moving around inside a dome that isn't there anymore)
Toggle Infopanel Cheats
Traits: Add/Remove All Negative or Positive
Unlimited Wonders
Unlock Every Breakthrough
Visit Fail Penalty Toggle
Write Logs

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

##### Thanks
```
chippydip (for the original mod): http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
```
