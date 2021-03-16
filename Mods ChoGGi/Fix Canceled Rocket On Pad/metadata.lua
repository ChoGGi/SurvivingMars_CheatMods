return PlaceObj("ModDef", {
	"title", "Fix Canceled Rocket On Pad",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_FixCanceledRocketOnPad",
	"steam_id", "1767799264",
	"pops_any_uuid", "bd3d58a5-dc56-4d3b-9764-2d8fe4de2e76",
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Start building a rocket on a pad than cancel it, and the pad is blocked.
This will check for borked pads when a save is loaded.

Includes mod option to disable fix.
]],
})
