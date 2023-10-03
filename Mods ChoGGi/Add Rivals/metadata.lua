return PlaceObj("ModDef", {
	"title", "Add Rivals",
	"id", "ChoGGi_AddRivals",
	"steam_id", "2550126745",
	"pops_any_uuid", "8c5161aa-1706-4b03-aac4-d7fda6b12c04",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Add rivals to existing/new games.


Mod Options:
Rival Amount: How many rivals to spawn. This is ignored if you've manually selected rivals below!
Rival Spawn Sol: Pick Sol that rivals will spawn on.
Rival Spawn Sol Random: Turn this on to randomise Rival Spawn Sol.
Min value is 1, Max value is set to "Rival Spawn Sol".
You might need to re-apply mod options after starting a couple new games.

*list of rivals*: If you turn on any rivals here, then only those will be spawned (instead of randomly).


Requested by Art3mis.
]],
})
