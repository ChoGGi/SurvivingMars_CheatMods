return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 7,
		}),
	},
	"title", "Disable Drone Maintenance",
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"image", "Preview.png",
	"id", "ChoGGi_DisableDroneMaintenance",
	"author", "ChoGGi",
	"steam_id", "1411107464",
	"pops_any_uuid", "dbd5a1c1-7bf3-4631-9d55-9b8c9ea76b0d",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", 1001569,
	"description", [[Adds a menu button to buildings to disable drones from performing maintenance (on all of type or just selected).]],
})
