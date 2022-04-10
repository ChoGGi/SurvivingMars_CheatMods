return PlaceObj("ModDef", {
	"title", "Stop Camera Jumping",
	"id", "ChoGGi_StopTradeCamera",
	"steam_id", "1796377374",
	"pops_any_uuid", "7af8a51c-f8ea-4528-aee9-e42368fee80d",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"TagOther", true,
	"has_options", true,
	"description", [[
The camera likes to jump elsewhere when certain things happen (see mod options to customize).

Stop the camera from moving to the rocket on: accepted a trade/selected an expedition.
When a dome fracture happens.
]],
})
