Last Updated: [1011166](https://survivingmars.paradoxwikis.com/Patches)

See mod options to toggle certain fixes.


**List of bugs fixed:**
```Uneven Terrain (see mod options to enable, more info below).
No Planetary Anomaly Breakthroughs when B&B is installed (more info below).
Problem updating supply grid.
Storybit notification issue.
Support struts malfunctioning and cave-ins.
Stop ceiling/floating rubble.
Log spam from IsBuildingInDomeRange().
Colonists showing up on wrong map in infobar.
Unpassable underground rocks stuck in path (not cave-in rubble, but small rocks you can't select).
Dredger tech fix ([Spoilers](https://www.reddit.com/r/SurvivingMars/comments/xnprjg/)).
Water Reclamation Spire and B&B upgrade tech caused issues (more info below).
Add rocket sound effects to SupplyPods (mod option to disable).
Force heat grid to update (more info below).
Personal Space storybit changes capacity, but building menu doesn't show it.
Underground Rare Anomaly can give you underground dome prefabs, but locks them to surface.
The Philosopher's Stone Mystery doesn't update sector scanned count when paused.
Future Contemporary Asset Pack when placing spires (more info below).
Leftover transport_ticket in colonist objs (assign to residence grayed out, from Trains DLC).
Possible fix for main menu music playing in-game on new games (mod option to disable, since there's no fade out).
The Bottomless Pit and Anomaly is missing (more info below).
Refabbing rare extractors left the "working" dust plumes around them.
```

**Mods**:
```Silva's Orion Heavy Rocket (you must disable his Essential files mod, then enable it AFTER enabling this mod, or use my Mod List Editor mod).
Horticulture Workshop not unlocking.
(4) Fixes for mods (no idea which mods / they're abandoned).
```


**Incorporated mods:** (so far)
```Fix Blank Mission Profile
Fix Buildings Broken Down And No Repair
Fix Colonist Daily Interest Loop
Fix Colonists Long Walks (better solution: Use my "No More Outside Suffocation" mod)
Fix Colonists Suffocating Inside Domes
Fix Defence Towers Not Firing At Rovers
Fix Destroyed Tunnels Still Work
Fix Double Click Select All Of Type
Fix Dust Devils Block Building
Fix Farm Oxygen
Fix FindDroneToRepair Log Spam
Fix Landscaping Freeze
Fix Layout Construction Tech Lock
Fix Locked Wind Turbine
Fix Meteor Stuck On Map
Fix Mods With Nil Notifications
Fix No Power Dome Buildings
Fix Projector Lamp
Fix RC Commander Drone Freeze
Fix Resupply Menu Not Opening
Fix Stuck Malfunctioning Drones At DroneHub
Fix Transport Negative Amounts
Fix Transports Don't Move After Route Set
```

If you have B&B I'd recommend SkiRich's [Better Lander Rockets](https://steamcommunity.com/sharedfiles/filedetails/?id=2619013940)


**See also**:
[Fix Cold Wave Stuck](https://steamcommunity.com/sharedfiles/filedetails/?id=2601527081)

[Fix Deposits Wrong Map](https://steamcommunity.com/sharedfiles/filedetails/?id=2703206312)

[Fix Dredger Mark Left On Ground](https://steamcommunity.com/sharedfiles/filedetails/?id=1646258448)

[Fix Eternal Dust Storm](https://steamcommunity.com/sharedfiles/filedetails/?id=1594158818)

[Fix Flying Drones MidAir Malfunction](https://steamcommunity.com/sharedfiles/filedetails/?id=2473394779)

[Fix Mirror Graphics](https://steamcommunity.com/sharedfiles/filedetails/?id=2549884520)

[Fix Missing Mod Buildings](https://steamcommunity.com/sharedfiles/filedetails/?id=1443225581)

[Fix Missing Mod Icons](https://steamcommunity.com/sharedfiles/filedetails/?id=1725437808)

[Fix Remove Invalid Label Buildings](https://steamcommunity.com/sharedfiles/filedetails/?id=1575894376)

[Fix Remove Invalid Label Buildings](https://steamcommunity.com/sharedfiles/filedetails/?id=1575894376)

[Fix Remove Blue Yellow Marks And Ghosts](https://steamcommunity.com/sharedfiles/filedetails/?id=1553086208)

[Fix Rocket Stuck](https://steamcommunity.com/sharedfiles/filedetails/?id=1567028510)

[Fix Rover In Dome](https://steamcommunity.com/sharedfiles/filedetails/?id=1829688193)

[Fix Shuttles Stuck Mid-Air](https://steamcommunity.com/sharedfiles/filedetails/?id=1549680063)[Fix Sol 2983](https://steamcommunity.com/sharedfiles/filedetails/?id=2705335465) < Don't enable unless needed!

[Fix Stuck Mirror Sphere Devices](https://steamcommunity.com/sharedfiles/filedetails/?id=2082012035)

[Fix Unlock RC Safari Resupply](https://steamcommunity.com/sharedfiles/filedetails/?id=2427995890)



Info from Incorporated mods/etc:

**Uneven Terrain**
```When finishing landscaping it can set some of the surrounding hexes z values (height) to 65535 (also known as UnbuildableZ).
Calling RefreshBuildableGrid() on the map seems to get rid of them without causing any major issues:
It can mark some hexes as okay to build when they weren't before, but nothing like a cliff side or anything.
If you enable the mod option and notice that you can build on some places you really shouldn't be able to then please let me know :)
If you're bored and want to dig through the funcs in LandscapeFinish() to find out exactly where it's coming from, feel free.
```
**No Planetary Anomaly Breakthroughs when B&B is installed**
```It's probably a bug, but the underground wonders do add Breakthroughs.
Mod option to disable this "fix" (and receieve less Breakthroughs).
```
**The Bottomless Pit and Anomaly is missing**
```SpawnAnomaly() calls FindUnobstructedDepositPos() which for whatever reason,
takes the pos from in front of the wonder and sticks it in the passage behind it... (BlankUnderground_02 map)
SpawnAnomaly() freaks out and changes it to an underground water instead
It works fine once the sector the pit is in is scanned, so I check for the water deposit when the pit is selected.
It's not like anyone goes underground for water...
```
**Future Contemporary Asset Pack**
```When placing a building you can change skins, if you use the spire skins from this DLC when placing skins
then it blocks an extra hex (you can see it when placing). This removes that hex on new buildings.
```
**Fix FindDroneToRepair Log Spam**
```This seems to be an issue from flying drones and a drone hub being destroyed.
Your log will "fill" up with this error:
Mars/Lua/Units/Drone.lua(256): method FindDroneToRepair
```
```**Fix Destroyed Tunnels Still Work**
Rovers will still use destroyed tunnels (in certain situations).
https://forum.paradoxplaza.com/forum/threads/hello-can-you-address-this-little-issue.1463333
```
**Force heat grid to update**
```If you paused game on new game load then cold areas don't update till you get a working Subsurface Heater.
```
**Water Reclamation Spire and B&B**
```Some buildings don't properly turn off their upgrades which causes them to keep their modifiers on.
The "fix" is turning off upgrades when a building is demolished, turned off, malfunctioned (might be annoying, mod option to keep it as is).
```
**Fix Buildings Broken Down And No Repair**
```If you have broken down buildings the drones won't repair. This will check for them on load game.
The affected buildings will say something about exceptional circumstances.
Any buildings affected by this issue will need to be repaired with 000.1 resource after the fix happens.
This also has a fix for buildings hit with lightning during a cold wave.
```
**Fix Floating Rubble**
```Move any floating underground rubble to within reach of drones (might have to "push" drones to make them go for it).
```
**Fix Colonist Daily Interest Loop**
```A colonist will repeatedly use a daily interest building to satisfy a daily interest already satisfied.
Repeating a daily interest will gain a comfort boost "if" colonist comfort is below the service comfort threshold, but a resource will always be consumed each visit.
This mod will block the colonist from having a visit, instead: An unemployed scientist will wander around outside till the Sol is over instead of chewing up 0.6 electronics.
https://forum.paradoxplaza.com/forum/threads/surviving-mars-colonists-repeatedly-satisfy-daily-interests.1464969/
Thanks to ThereWillBeBugsToOvercome for noticing it, finding the offending code, doing a detailed write up of it, and testing the fix.
```
**Fix Stuck Malfunctioning Drones At DroneHub**
```If you have malfunctioning drones at a dronehub and they never get repaired (off map).
This'll check on load each time for them (once should be enough though), and move them near the hub.
```
**Fix Farm Oxygen**
```If you remove a farm that has an oxygen producing crop (workers not needed) the oxygen will still count in the dome.
```
**Fix Dust Devils Block Building**
```No more cheesing dust devils with waste rock depots (etc), by placing them on top of said devils (not by building them to block them).
```
**Fix Defence Towers Not Firing At Rovers**
```It's from a mystery (trying to keep spoilers to a minimum).
If you're starting a new game than this is fixed, but for older saves on this mystery you'll need this mod.
```
**Fix Landscaping Freeze**
```For some reason LandscapeLastMark gets set to around 4090, when LandscapeMark hits 4095 bad things happen.
This resets LandscapeLastMark to whatever is the highest number in Landscapes when a save is loaded (assuming it's under 2000, otherwise 0).
For those wondering LandscapeLastMark is increased each time you open flatten/ramp (doesn't need to be placed).
Thanks to Quirquie for the bug report (and persistance).
```
