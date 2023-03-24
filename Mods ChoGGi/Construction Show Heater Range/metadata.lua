return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 8,
		}),
	},
	"title", "Construction Show Heater Range",
	"id", "ChoGGi_ConstructionShowHeaterRange",
	"pops_any_uuid", "eb644519-c6fa-425c-ad9c-bf46ca98e656",
	"steam_id", "2433762531",
	"lua_revision", 1007000,
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Shows heat radius around Subsurface Heaters when you're in construction mode.
Press Numpad 7 to toggle grid anytime (rebind in game options).

Mod Options:
Hex Colour: Change colour of hex grids (default pale blue).
Show during construction: If you don't want grids showing up during construction placement.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.
]],
})
