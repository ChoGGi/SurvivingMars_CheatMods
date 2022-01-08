return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 7,
		}),
	},
	"title", "Construction Show Drone Grid",
	"id", "ChoGGi_ConstructionShowDroneGrid",
	"pops_any_uuid", "8a21486a-8068-41a9-8790-f02074b283e3",
	"steam_id", "1424918098",
	"lua_revision", 1007000, -- Picard
	"version", 20,
	"version_major", 2,
	"version_minor", 0,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Show grid radius around these buildings when you're in construction mode:
Drone Hub, Drone Hub Extender, Elevator, Supply Rocket, RC Commander

Press Numpad 3 to toggle grid anytime (rebind in game options).

Mod Options:
Hex Colour: Change colour of hex grids for each type of building.
Show during construction: If you don't want grids showing up during construction placement.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.


Requested by mysticlife.
]],
})
