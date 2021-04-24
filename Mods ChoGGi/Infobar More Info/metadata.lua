return PlaceObj("ModDef", {
	"title", "Infobar More Info",
	"id", "ChoGGi_InfobarAddDischargeRates",
	"steam_id", "1775006723",
	"pops_any_uuid", "34ead2f4-80f9-4200-b73c-12e441babbe9",
	"lua_revision", 1001514, -- Tito
	"version", 24,
	"version_major", 2,
	"version_minor", 4,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"has_options", true,
	"description", [[Want to know if your battery storage will last the night? See how many resources are remaining in occupied deposits. Curious why you keep getting a "not enough power" warning even though capacity is full?


Resource tooltips:
[b]Stored Resources Remaining Time[/b]: Estimate of time till consumption + maintenance overtake production + stored.
N/A means you have more production than consumption.
[b]Maintenance[/b]: Amounts reflect benefits of nearby Triboelectric Scrubbers.
Deposit remaining amount added to resources (shows how much is left in occupied deposits).

Grid (air/water/elec) tooltips:
Removes the sum totals, and shows info for all individual grids (see mod options to split grids).
I merged some lines, removed the header, and split air/water to reduce vertical space.
(I'm using electricity for the text, but the below applies to all three grid resource tooltips)
[b]Production/Max production[/b]: Amount of power the grid is producing/Maximum power the grid can produce (stuff can throttle based on demand).
[b]Capacity/Consumption[/b]: Battery storage capacity/Current demand levels.
[b]Storage/Max output[/b]: Amount of electricity in battery storage/Amount of juice the batteries can output hourly.
[b]Storage Remaining Time[/b]: Amount of time you can sustain your current power requirements.

Research tooltip:
[b]Research per Sol[/b]: Total points per Sol.
[b]Research Remaining Time[/b]: Time left for current research.

Food:
[b]MAX Food Consumption[/b]: Current max food consumption (daily): 0.2 for each colonist (0.4 for gluttons).

Drones:
Right-click Drones icon to cycle through all borked drones (also adds count):
[b]Malfunctioned Drones[/b]: NoBattery, Malfunction, Freeze, Dead, WaitingCommand (orphaned).
[b]Shuttles Max/Total/Current[/b]: Max shuttles that can be built / Shuttles that are built (flying+in hub) / Shuttles flying.

Jobs:
On the end of the spec counts is the count of vacant workplace slots.

Colonists:
On the end of the age/nationality are percentage counts (rounded).



Mod Options:
[b]Aggregated info[/b]: Show sum totals instead of individual grids (skip grid options ignored if enabled).
[b]Skip Grid 0[/b]: Grids with production+consumption = 0 (doesn't skip grids that aren't producing due to throttle).
[b]Skip Grid 1[/b]: Grids that only have a single bld (sensor towers).
[b]Skip Grid X[/b]: Grids that only have X amount of buildings (for smaller clusters, like a concrete "hub", 0 to disable).
[b]Rollover Size[/b]: Game default is 45, if you want the tooltips wider use this.
[b]Disable Transparency[/b]: Disable transparency of Infobar.
[b]Always Show Remaining[/b]: Keep showing remaining amount of resources instead of N/A when prod over consump (time formatting only shows hours for neg numbers, this game uses 24 per Sol).
[b]Enable Mod[/b]: Disable mod without having to see missing mod msg (still adds some text to certain tooltips).


Suggestions of info you'd like to see?
]],
})
