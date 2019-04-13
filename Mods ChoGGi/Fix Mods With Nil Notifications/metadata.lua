return PlaceObj("ModDef", {
	"title", "Fix: Mods With Nil Notifications v0.1",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1535889600,
	"image", "Preview.png",
	"id", "ChoGGi_FixModsWithNilNotifications",
	"steam_id", "1501634618",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Some mods will try to add a notification without specifying an id for it; that makes baby Jesus cry.

(also the game freezes on load)]],
})