return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Building Placement Orientation v0.8",
	"version", 8,
	"saved", 1551960000,
	"image", "Preview.png",
	"tags", "Building",
	"id", "ChoGGi_BuildingPlacementOrientation",
	"steam_id", "1411105601",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 243725,
	"description", [[Any object you place will have the same orientation as the last placed object.

Ctrl-Space to activate placement mode with the last placed object.
Ctrl-Shift-Space to activate placement mode with the selected object (or object under mouse).]],
})
