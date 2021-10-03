return PlaceObj("ModDef", {
	"title", "Add Planetary Anomaly Breakthroughs",
	"id", "ChoGGi_AddPlanetaryAnomalyBreakthroughs",
	"steam_id", "2459486598",
	"pops_any_uuid", "e4f00d7e-a7a8-49d9-a0e0-e92d73b144bd",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
When you apply the mod options for this mod, it'll add that amount of breakthroughs to the list grabbed from (game starts with 4).

You must be in-game before you apply the mod options or it won't do anything.
The breakthrough anomalies don't show up right away they're on a timer, use my POI Spawn Rate mod to have them spawn quicker.

Nothing happens if you've already unlocked all the breakthroughs.
]],
})
