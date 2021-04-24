return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 8,
		}),
	},
	"title", "Drones Pickup Nearest Resource",
	"id", "ChoGGi_DronesPickupNearestResource",
	"steam_id", "2239948173",
	"pops_any_uuid", "37c4f613-4487-4016-b130-30578eec00f8",
	"lua_revision", 1001514, -- Tito
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Drones will always pick up the nearest resource.


If drones get stuck at a building/etc let me know which (screenshots help).
]],
})
