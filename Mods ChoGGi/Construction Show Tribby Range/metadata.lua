return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 9,
		}),
	},
	"title", "Construction Show Tribby Range",
	"id", "ChoGGi_ConstructionShowTribbyRange",
	"steam_id", "1796378101",
	"pops_any_uuid", "f115be1e-fdb0-49d8-bc44-5aca9c81a7af",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"lua_revision", 249143,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Shows (purple) grid radius around Triboelectric Scrubbers when you're in construction mode.
Press Numpad 1 to toggle grid anytime (rebind in game options).

Mod Options:
Show during construction: If you don't want grids showing up during construction placement.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.
]],
})
