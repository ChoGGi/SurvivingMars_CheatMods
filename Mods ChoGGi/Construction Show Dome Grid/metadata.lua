return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 6,
		}),
	},
	"title", "Construction Show Dome Grid",
	"id", "ChoGGi_ConstructionShowDomeGrid",
	"pops_any_uuid", "e5e834a8-16ba-438a-bd03-32d9ba5d0113",
	"steam_id", "1781388419",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Shows grid radius around Domes when you're in construction mode with a dome.
Press Numpad 4 to toggle grid anytime (rebind in game options).

Mod Options:
Hex Colour: Change colour of hex grids (default reddish).
Show during construction: If you don't want grids showing up during construction placement.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.
Selection Dome: Show all dome grids when selecting a dome.
Selection Outside: Show all dome grids when selecting an outside dome building.


Requested by DARK_MASTER.
]],
})
