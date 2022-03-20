return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 1,
		}),
	},
	"title", "Building Placement Orientation",
	"id", "ChoGGi_BuildingPlacementOrientation",
	"steam_id", "1411105601",
	"pops_any_uuid", "9db8cc6e-17a6-48ea-9ef7-a507814bc471",
	"lua_revision", 1007000, -- Picard
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"has_options", true,
	"description", [[
Any object you place will have the same orientation as the last placed object. Mod option to disable orientation.

Pipette:
Ctrl-Space to activate placement mode with the selected, last placed object, or object under mouse. You can rebind in game options.
]],
})
