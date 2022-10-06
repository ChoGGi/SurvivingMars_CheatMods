return PlaceObj("ModDef", {
	"title", "Fix Bugs",
	"id", "ChoGGi_FixBBBugs",
	"steam_id", "2721921772",
	"pops_any_uuid", "3aff9cde-7dc1-4ad8-b38d-31a7568185ff",
	"lua_revision", 1007000, -- Picard
	"version", 33,
	"version_major", 3,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Last Updated: 1011166 https://survivingmars.paradoxwikis.com/Patches

See mod options to toggle certain fixes.

[b]List of bugs fixed:[/b]
Uneven Terrain (see mod options to enable, more info below).
No Planetary Anomaly Breakthroughs when B&B is installed.
Problem updating supply grid.
Storybit notification issue.
Probably mod related:
A rocket missing the cargo table.
g_ActiveOnScreenNotifications isn't a table.
Support struts malfunctioning and cave-ins.
Stop ceiling/floating rubble.
Log spam from IsBuildingInDomeRange().
Clean up city labels of wrong map / invalid objs (colonists showing up on wrong map in infobar).
Unpassable underground rocks stuck in path (not cavein rubble, but small rocks you can't select).
Dredger tech fix (Spoilers see: https://www.reddit.com/r/SurvivingMars/comments/xnprjg/)
Water Reclamation Spire and B&B upgrade tech caused issues (spoiler free, see more info below).



[b]Incorporated mods:[/b] (so far)
Fix Blank Mission Profile
Fix Buildings Broken Down And No Repair
Fix Colonist Daily Interest Loop
Fix Colonists Long Walks (better solution see: No More Outside Suffocation mod)
Fix Colonists Suffocating Inside Domes
Fix Defence Towers Not Firing At Rovers
Fix Double Click Select All Of Type
Fix Dust Devils Block Building
Fix Farm Oxygen
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

If you have B&B I'd recommend SkiRich's [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2619013940]Better Lander Rockets[/url]



Info from Incorporated mods/etc:

[b]Uneven Terrain[/b]
When finishing landscaping it can set some of the surrounding hexes z values (height) to 65535 (also known as UnbuildableZ).
Calling RefreshBuildableGrid() on the map seems to get rid of them without causing any major issues:
It can mark some hexes as okay to build when they weren't before, but nothing like a cliff side or anything.
If you enable the mod option and notice that you can build on some places you really shouldn't be able to then please let me know :)
If you're bored and want to dig through the funcs in LandscapeFinish() to find out exactly where it's coming from, feel free.
[b]Water Reclamation Spire and B&B[/b]
Some buildings don't properly turn off their upgrades which causes them to keep their modifiers on.
The "fix" is turning off upgrades when a building is demolished, turned off, malfunctioned (might be annoying, mod option to keep it as is).
[b]Fix Buildings Broken Down And No Repair[/b]
If you have broken down buildings the drones won't repair. This will check for them on load game.
The affected buildings will say something about exceptional circumstances.
Any buildings affected by this issue will need to be repaired with 000.1 resource after the fix happens.
This also has a fix for buildings hit with lightning during a cold wave.
[b]Fix Floating Rubble[/b]
Move any floating underground rubble to within reach of drones (might have to "push" drones to make them go for it).
[b]Fix Colonist Daily Interest Loop[/b]
A colonist will repeatedly use a daily interest building to satisfy a daily interest already satisfied.
Repeating a daily interest will gain a comfort boost "if" colonist comfort is below the service comfort threshold, but a resource will always be consumed each visit.
This mod will block the colonist from having a visit, instead: An unemployed scientist will wander around outside till the Sol is over instead of chewing up 0.6 electronics.
https://forum.paradoxplaza.com/forum/threads/surviving-mars-colonists-repeatedly-satisfy-daily-interests.1464969/
Thanks to ThereWillBeBugsToOvercome for noticing it, finding the offending code, doing a detailed write up of it, and testing the fix.
[b]Fix Stuck Malfunctioning Drones At DroneHub[/b]
If you have malfunctioning drones at a dronehub and they never get repaired (off map).
This'll check on load each time for them (once should be enough though), and move them near the hub.
[b]Fix Farm Oxygen[/b]
If you remove a farm that has an oxygen producing crop (workers not needed) the oxygen will still count in the dome.
[b]Fix Dust Devils Block Building[/b]
No more cheesing dust devils with waste rock depots (etc), by placing them on top of said devils (not by building them to block them).
[b]Fix Defence Towers Not Firing At Rovers[/b]
It's from a mystery (trying to keep spoilers to a minimum).
If you're starting a new game than this is fixed, but for older saves on this mystery you'll need this mod.


See mod options to disable fixes for stuff that you can cheese.
]],
})
