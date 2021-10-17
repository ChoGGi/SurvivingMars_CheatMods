return PlaceObj("ModDef", {
	"title", "Clear Stuck Notifications",
	"id", "ChoGGi_ClearStuckNotifications",
	"steam_id", "2629945101",
	"pops_any_uuid", "3b729a08-b4b7-488f-8416-17a0ef10c308",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Clear any mystery notifications stuck on the game.

Mod Options:
Enable Mod: Disable mod without having to see missing mod msg.
Clear All: This will clear ALL notifications!
]],
})
