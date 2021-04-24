return PlaceObj("ModDef", {
	"title", "Fix Stuck Malfunctioning Drones At DroneHub",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"id", "ChoGGi_FixStuckMalfunctioningDronesAtDroneHub",
	"steam_id", "2042936584",
	"pops_any_uuid", "c06006b4-09d7-4cab-97eb-815a3f304589",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[If you have malfunctioning drones at a dronehub and they never get repaired (off map).

This'll check on load each time for them (once should be enough though), and move them near the hub.
Includes mod option to disable fix.


Reported by PureSp1r1t
]],
})
