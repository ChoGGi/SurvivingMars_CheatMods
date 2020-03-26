return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 9,
		}),
	},
	"title", "Building Placement Orientation",
	"version", 8,
	"version_major", 0,
	"version_minor", 8,

	"image", "Preview.png",
	"id", "ChoGGi_BuildingPlacementOrientation",
	"steam_id", "1411105601",
	"pops_any_uuid", "9db8cc6e-17a6-48ea-9ef7-a507814bc471",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", 249143,
	"description", [[Any object you place will have the same orientation as the last placed object.

Ctrl-Space to activate placement mode with the selected or last placed object (or object under mouse).]],
})
