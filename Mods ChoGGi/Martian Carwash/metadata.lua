return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 7,
		}),
	},
	"title", "Martian Carwash",
	"id", "ChoGGi_MartianCarwash",
	"steam_id", "1411110474",
	"pops_any_uuid", "14858ef6-7615-493c-ba0f-5f2bce11c3f4",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"description", [[
Drive your ride through our full service car wash. You don't want to drive a dirty ride, and you shouldn't have to look at one.
Also does drones.

This only affects visuals, not maintenance points.
]],
})
