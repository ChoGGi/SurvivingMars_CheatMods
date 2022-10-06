return PlaceObj("ModDef", {
	"title", "Larger Depots",
	"id", "ChoGGi_LargerDepots",
	"steam_id", "2870561106",
	"pops_any_uuid", "c3a88978-409e-4e2c-8e29-77f151cc85bf",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[
This won't change existing depots, see mod options to change amounts (on new depots only).


There is a height limit on map objects, so I'm sticking with a limit on the storage size (I wouldn't fill the uni depot up on higher plateaus).
]],
})
