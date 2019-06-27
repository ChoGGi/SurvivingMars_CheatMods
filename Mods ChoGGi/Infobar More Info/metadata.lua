return PlaceObj("ModDef", {
--~ 	"title", "Infobar Add Discharge Rates",
	"title", "Infobar More Info",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_InfobarAddDischargeRates",
	"steam_id", "1775006723",
	"pops_any_uuid", "34ead2f4-80f9-4200-b73c-12e441babbe9",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"has_options", true,
	"description", [[Want to know if your battery storage will last the night? See how many resources are remaining in active deposits. Curious why you keep getting a "not enough power" msg even though capacity is almost full?


Resource tooltips:
Time of stored resources remaining: stored / (production - (consumption + maintenance)).
N/A means you have more production than consumption.

Grid (air/water/elec) tooltips:
The max discharge from storage buildings.
Max production values (some producers will throttle on demand).
Storage grid remaining time (oomph in tanks countdown, reduce build need when doing a solar overnight).
Removes the sum totals, and shows info for all individual grids (see mod options).
I merged some lines, removed the header, and split air/water to reduce vertical space.

Resource/Grid tooltips:
For stuff getting mined (water, metals, concrete) the remaining amounts in currently mined deposits are shown.

Research tooltip:
Total per Sol.



Mod Options:
Both skip options are default enabled.
Skip Grid 0: Grids with production+consumption = 0 (doesn't skip grids that aren't producing due to throttle).
Skip Grid 1: Grids that only have a single bld (sensor towers).
Aggregated info: Show sum totals instead of individual grids (skip options ignored).
Rollover Size: Game default is 45, if you want the tooltips wider use this (I use small UI scale).]],
})
