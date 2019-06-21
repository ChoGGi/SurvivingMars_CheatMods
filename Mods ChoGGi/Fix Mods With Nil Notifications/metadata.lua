return PlaceObj("ModDef", {
	"title", "Fix Mods With Nil Notifications",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_FixModsWithNilNotifications",
	"steam_id", "1501634618",
	"pops_any_uuid", "76b215c4-7c45-4861-b0ac-5e618ddd2483",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Some mods will try to add a notification without specifying an id for it; that makes baby Jesus cry.

(also the game freezes on load)]],
})