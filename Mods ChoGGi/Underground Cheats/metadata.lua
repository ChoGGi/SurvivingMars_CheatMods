return PlaceObj("ModDef", {
	"title", "Underground Cheats",
	"id", "ChoGGi_UndergroundCheats",
	"steam_id", "2599642948",
	"pops_any_uuid", "4a2eb0eb-0667-4462-9db1-5bd833a233bf",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Change radius of light tripods, support struts, skip sanity loss.
Clear rubble button on cave-ins/collapsed tunnels has an option to toggle all (also shows toggle status).

Mod Options:
Light Tripod Radius: How far the light reveals darkness.
Support Strut Radius: How far the strut blocks cave-ins.
Pin Rockets: When changing to underground, pin any rockets from surface (might have to toggle maps twice).
No Sanity Loss: Colonists don't lose sanity when there's no light.
Sort Elevator Prefabs: Sort prefabs list by display name instead of whatever they used.


Mod options to pick underground wonders (only applies to new games):
If you only pick one then the other will be random.
If all options turned off then no wonders will spawn!
]],
})
