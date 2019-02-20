return PlaceObj("ModDef", {
	"title", "Fix: Locked Wind Turbine v0.2",
	"version", 2,
	"saved", 1550664000,
	"image", "Preview.png",
	"id", "ChoGGi_FixLockedWindTurbine",
	"steam_id", "1576874324",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Wind turbine gets locked by a game event.
This checks on load for the locked turbine and unlocks it.

This was fixed in the hotfix... but only if it hasn't happened yet, so I've left it up for anyone that it already happened on.


https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-wind-turbine-not-available.1129749/#post-24901116]],
})
