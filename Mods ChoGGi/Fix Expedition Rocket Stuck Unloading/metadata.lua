return PlaceObj("ModDef", {
	"title", "Fix: Expedition Rocket Stuck Unloading",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1542456000,
	"image", "Preview.png",
	"id", "ChoGGi_FixExpeditionRocketStuckUnloading",
	"steam_id", "1567028510",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[This will check on load game for certain rockets stuck on the ground unable to do jack.]],
})
