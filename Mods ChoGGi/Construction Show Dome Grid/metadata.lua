return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 2,
		}),
	},
	"title", "Construction Show Dome Grid",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,

	"id", "ChoGGi_ConstructionShowDomeGrid",
	"author", "ChoGGi",
	"image", "Preview.png",
	"steam_id", "1781388419",
	"pops_any_uuid", "e5e834a8-16ba-438a-bd03-32d9ba5d0113",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Shows grid radius around Domes when you're in construction mode with a dome.
Press Numpad 4 to toggle grids anytime (rebind in game options).

Mod Options:
Show during construction: If you don't want grids showing up during construction placement.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.
Selection Dome: Show all dome grids when selecting a dome.
Selection Outside: Show all dome grids when selecting an outside dome building.


Requested by DARK_MASTER.]],
})
