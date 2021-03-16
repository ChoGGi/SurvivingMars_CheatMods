return PlaceObj("ModDef", {
	"title", "Fix Locked Wind Turbine",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_FixLockedWindTurbine",
	"steam_id", "1576874324",
	"pops_any_uuid", "8be24d41-c9c9-459c-a673-c7e2a8c75485",
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Wind turbine gets locked by a game event.
This checks on load for the locked turbine and unlocks it.

This was fixed in the hotfix... but only if it hasn't happened yet, so I've left it up for anyone that it already happened on.
Includes mod option to disable fix.


https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-wind-turbine-not-available.1129749/#post-24901116]],
})
