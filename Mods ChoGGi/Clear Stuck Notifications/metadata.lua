return PlaceObj("ModDef", {
	"title", "Clear Stuck Notifications",
	"id", "ChoGGi_ClearStuckNotifications",
	"steam_id", "2629945101",
	"pops_any_uuid", "3b729a08-b4b7-488f-8416-17a0ef10c308",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Clear any mystery notifications stuck on the game.

Clear Mysteries defaults to enabled, the other mod options need to be enabled.

Mod Options:
Clear Mysteries: This will remove any mystery ones. (excludes Mystery Log)
Clear All: This will clear ALL notifications! (excludes Mystery Log)
Clear Mystery Log: This will remove the Mystery Log!
]],
})
