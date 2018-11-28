return PlaceObj("ModDef", {
	"title", "Fix: Rocket Stuck v0.9",
	"version", 9,
	"saved", 1543320000,
	"image", "Preview.png",
	"id", "ChoGGi_FixExpeditionRocketStuckUnloading",
	"steam_id", "1567028510",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[This will check on load game for certain rockets stuck on the ground unable to do jack.
So far:
Unloading colonists.
Unloading colonist crew from expedition.
Maintenance */5.
Drones stuck inside.
Planetary anomaly drones stuck inside.
Expedition launched rocket still "occupies" landing pad.

If this doesn't fix it for you, then I'll need a copy of your saved game.]],
})
