return PlaceObj("ModDef", {
	"title", "Command Center Distance Sort",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_CommandCenterDistanceSort",
	"steam_id", "1655735750",
	"pops_any_uuid", "820b006e-9e01-4bd0-a706-0917008262ac",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"description", [[On load and every new Sol this will sort the cc list of each building by distance.
Hopefully makes the drones use the nearest first, but it's quite fast so don't worry about leaving it enabled.
]],
})
