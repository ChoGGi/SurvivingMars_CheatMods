return PlaceObj("ModDef", {
	"title", "Fix Rocket Stuck",
	"version", 17,
	"version_major", 1,
	"version_minor", 7,
	"image", "Preview.png",
	"id", "ChoGGi_FixExpeditionRocketStuckUnloading",
	"steam_id", "1567028510",
	"pops_any_uuid", "cca05f79-5542-40f1-a008-e8fb4e6ecc9a",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[This will check on load game for certain rockets stuck on the ground unable to do jack.
So far:
Unloading colonists.
Unloading colonist crew from expedition.
Maintenance */5.
Drones stuck inside.
Planetary anomaly drones stuck inside.
Drones the rocket thinks are stuck inside (*2).
Trade rocket with 0 res.
Returned expedition rocket giving msg that it's still in orbit.
Canceled expedition rocket stuck in limbo canceled mode.

If this doesn't fix it for you, then I'll need a copy of your saved game.


Has mod option to disable mod (once the rocket is fixed).
]],
})
