return PlaceObj("ModDef", {
	"title", "Add Rivals",
	"id", "ChoGGi_AddRivals",
	"steam_id", "2550126745",
	"pops_any_uuid", "8c5161aa-1706-4b03-aac4-d7fda6b12c04",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Add three random rivals if you don't have any (ex: Space Race DLC added to existing save).
This will add them to any save without rivals.

Mod Options:
Rival Amount: How many rivals to spawn.
Rival Spawn Sol: Pick Sol that rivals will spawn on.
Rival Spawn Sol Random: Turn this on to randomise Rival Spawn Sol.
Min value is 1, Max value is set to Rival Spawn Sol.
You might need to re-apply mod options after starting a couple new games.


Requested by Art3mis.
]],
})
