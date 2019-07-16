return PlaceObj("ModDef", {
--~ 	"title", "Construction: Show Drone Grid v0.4",
	"title", "Construction Show Drone Grid",
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"saved", 0,
	"id", "ChoGGi_ConstructionShowDroneGrid",
	"author", "ChoGGi",
	"image", "Preview.png",
	"steam_id", "1424918098",
	"pops_any_uuid", "8a21486a-8068-41a9-8790-f02074b283e3",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Shows grid radius around Drone Hubs, Rockets, and RC Commanders when you're in construction mode.

Mod Options:
Show Grids: Use to disable temporarily.
Dist From Cursor: Only show grids around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Grid Opacity: Set opacity of grid icons.
Grid Scale: Set scale of grid icons.

Requested by mysticlife.]],
})
