return PlaceObj("ModDef", {
	"title", "Fix Rocket Stuck",
	"id", "ChoGGi_FixExpeditionRocketStuckUnloading",
	"steam_id", "1567028510",
	"pops_any_uuid", "cca05f79-5542-40f1-a008-e8fb4e6ecc9a",
	"lua_revision", 1007000, -- Picard
	"version", 25,
	"version_major", 2,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
This will check on load game for certain rockets stuck on the ground unable to do jack.
So far:
Canceled expedition rocket stuck in limbo canceled mode.
Drones stuck inside.
Drones the rocket thinks are stuck inside (*2).
Maintenance */5.
Planetary anomaly drones stuck inside.
Previous expedition rocket shows msg it isn't landed when trying to launch.
Returned expedition rocket giving msg that it's still in orbit.
Stuck landing pad from bugged rocket construction.
Trade rocket from Beyond Earth mystery.
Trade rocket ready for takeoff stuck on pad only showing priority button.
Trade rocket unloading resources.
Trade rocket with 0 res.
Trade rockets stuck in orbit?
Unloading colonist crew from expedition.
Unloading colonists.


[b]If this doesn't fix it for you, then I'll need a copy of your saved game.[/b]


Has mod option to disable mod (once the rocket is fixed).
]],
})
