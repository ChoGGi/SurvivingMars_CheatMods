return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 5,
		}),
	},
	"title", "Bottomless Storage",
	"id", "ChoGGi_BottomlessStorage",
	"steam_id", "1411102605",
	"pops_any_uuid", "72c1a8e6-a886-4448-b726-f81f92e37faa",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", 1001569,
	"has_options", true,
	"description", [[Anything added to this storage depot will disappear (good for excess resources).

Be careful where you place it as drones will use it like a regular depot (defaults to no resources accepted).

See mod options to set a minimum amount of resources to not remove.
]],
})
