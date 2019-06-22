return PlaceObj("ModDef", {
--~ 	"title", "Infobar Add Discharge Rates",
	"title", "Infobar More Info",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
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
	"description", [[Add more info to the infobar

Resource tooltips:
Time of resources remaining: stored / (production - (consumption + maintenance)).
N/A means you have more production than consumption.

Grid (air/water/elec) tooltips:
The max discharge from storage buildings.
Max production values (some producers will throttle on demand).

Resource/Grid tooltips:
For stuff getting mined (water, metals, concrete) the remaining amounts in currently mined deposits are shown.

Research tooltip:
Total per Sol.]],
})
