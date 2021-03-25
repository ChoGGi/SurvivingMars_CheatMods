return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 5,
		}),
	},
	"title", "Building Placement Orientation",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.png",
	"id", "ChoGGi_BuildingPlacementOrientation",
	"steam_id", "1411105601",
	"pops_any_uuid", "9db8cc6e-17a6-48ea-9ef7-a507814bc471",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", 1001569,
	"has_options", true,
	"description", [[Any object you place will have the same orientation as the last placed object. Mod option to disable orientation.

Pipette:
Ctrl-Space to activate placement mode with the selected or last placed object (or object under mouse), rebind in game options.
]],
})
