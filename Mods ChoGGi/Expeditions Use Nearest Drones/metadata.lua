return PlaceObj("ModDef", {
	"title", "Expeditions Use Nearest Drones",
	"id", "ChoGGi_ExpeditionsUseNearestDrones",
	"lua_revision", 249143,
	"steam_id", "2287155002",
	"pops_any_uuid", "1e399bf5-1fe9-4329-871e-adb6a10a331d",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"description", [[Change how expedition rockets pick drones: Instead of a picking one drone from each controller; this will grab all it can from whichever is nearest.
I haven't changed the "use any drones controlled by the expedition rocket before looking elsewhere" part.


Requested by vizthex.
]],
})
