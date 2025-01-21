return PlaceObj("ModDef", {
	"title", "Underground Cheats",
	"id", "ChoGGi_UndergroundCheats",
	"steam_id", "2599642948",
	"pops_any_uuid", "4a2eb0eb-0667-4462-9db1-5bd833a233bf",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Change radius of light tripods, support struts, skip sanity loss.
Pin rockets when changing to underground map (might have to toggle maps twice).
Press Ctrl when using drones to clear cave-in rubble to toggle clearing all (added status text to rubble for drones).

Mod options to pick underground wonders (only applies to new games):
If you only pick one then the other will be random.
If all options turned off then no wonders will spawn!
]],
})
