return PlaceObj("ModDef", {
	"title", "Camera Change Settings",
	"id", "ChoGGi_CameraChangeSettings",
	"steam_id", "2219393389",
	"pops_any_uuid", "f3ac3900-6dce-4db1-8bb4-3d1abdea4b8e",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"description", [[
Adjust camera settings: Rotation/move speed, zoom level, border scroll size.


Known Issues:
Games will be saved zoomed in from max zoom.


Partially requested by Arthurdubya.
]],
})
