return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 2,
		}),
	},
	"title", "Place-a-lake",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_Placealake",
	"steam_id", "1743037328",
	"pops_any_uuid", "9f01952e-daec-4fc8-a10b-f8754a147663",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a rock you place to mark a lake spot (with a button to raise/lower the level).
This will ignore the uneven terrain limitation.

For now rovers and whatnot will ignore the lake and walk through it.]],
	"TagTerraforming", true,
	"TagLandscaping", true,
})
