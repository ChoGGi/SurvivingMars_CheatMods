return PlaceObj("ModDef", {
	"title", "Random Starting Sector",
	"id", "ChoGGi_RandomStartingSector",
	"steam_id", "1575530067",
	"pops_any_uuid", "68fc6b59-2a1c-4fdc-93a1-317193278a84",
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
Picks a random square instead of same each time.

Mod Options:
Minimum Surface Deposits: Use a sector with at least this many surface deposits (concrete and scattered metals), default 6.
Minimum Subsurface Deposits: Use a sector with at least this many subsurface deposits (metals/rare metals deposits), default 2.
If no sector has enough than return the one with the most (sorts by surface than subsurface).
Set both to 0 for actual random.


Kind of idea by niquedegraaff.
]],
})
