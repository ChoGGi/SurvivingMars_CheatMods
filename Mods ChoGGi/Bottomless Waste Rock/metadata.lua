return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 4,
		}),
	},
	"title", "Bottomless Waste Rock",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,

	"image", "Preview.png",
	"id", "ChoGGi_BottomlessWasteRock",
	"author", "ChoGGi",
	"steam_id", "1465688997",
	"pops_any_uuid", "546e8019-e9c2-4ddb-9c97-d8783973e199",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", 249143,
	"description", [[Any rocks dumped at this depot will disappear (good for excess resources).

Be careful where you place it as drones will use it like a regular depot.

Requested by Black Jesus.]],
})
