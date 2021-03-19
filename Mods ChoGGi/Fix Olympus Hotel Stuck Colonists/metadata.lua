return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 3,
		}),
	},
	"title", "Fix Olympus Hotel Stuck Colonists",
	"id", "ChoGGi_FixOlympusHotelStuckColonists",
	"steam_id", "2428732491",
	"pops_any_uuid", "1442ea5d-7d0f-4545-8a93-5c775b59d514",
	"lua_revision", 1001551,
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagOther", true,
	"description", [[The hotel uses a door model from Space Race DLC (the Mega Mall), it bugs out when you don't have that DLC.
This will allow the fake door to work properly, and unstick any colonists doing the human centipede.
]],
})
