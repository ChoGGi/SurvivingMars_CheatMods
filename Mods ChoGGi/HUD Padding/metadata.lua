return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 2,
		}),
	},
	"title", "HUD Padding",
	"id", "ChoGGi_HUDPadding",
	"steam_id", "2729708981",
	"pops_any_uuid", "4f4db68e-7ea7-4167-b199-fbe0c849e2fe",
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
	"TagInterface", true,
	"description", [[
Manually add padding to the HUD elements.

To bump down the infobar add 50 to the "top" of it (0,50,0,0).
If a mod option doesn't open a text input, than close the mod options and reopen it (don't ask...).


Requested by gaygeek70.
]],
})
