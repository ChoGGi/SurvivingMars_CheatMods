return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 9,
		}),
	},
	"title", "Construction Show Dust Grid",
	"id", "ChoGGi_ConstructionShowDustGrid",
	"steam_id", "1566670588",
	"pops_any_uuid", "b53b9bb2-60ca-44da-a36e-72b7d062b8f9",
	"version", 22,
	"version_major", 2,
	"version_minor", 2,
	"lua_revision", 1007000, -- Picard
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Obsolete: Devs added this to base game (you can still use it, and it works better than their implementation).


Show dust grids for all dust generating buildings during construction of any building.
Press Numpad 2 to toggle grid anytime (rebind in game options).

Mod Options:
Hex Colour: Change colour of hex grids (default red).
Show during construction: If you don't want grids showing up during construction placement.
Show Construction Site Grids: Show grid around sites.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.


Requested by still__alive.
]],
})
