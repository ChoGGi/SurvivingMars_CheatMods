return PlaceObj("ModDef", {
	"title", "Faster UI",
	"id", "ChoGGi_FasterUI",
	"steam_id", "2744055836",
	"pops_any_uuid", "7cb99512-05c3-44ba-b4b8-1fcb37540cab",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Remove some animations: build menu/pins/overview/map switch.
See mod options to enable/disable each speed up.

Known Issues:
Still a very slight delay when closing build menu and opening pins :(
]],
})
