return PlaceObj("ModDef", {
	"title", "Notification Pause",
	"id", "ChoGGi_NotificationPause",
	"steam_id", "1411111982",
	"pops_any_uuid", "21a83d51-419f-45fe-810f-2e520b174fb1",
	"lua_revision", 1007000, -- Picard
	"version", 14,
	"version_major", 1,
	"version_minor", 4,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"has_options", true,
	"description", [[
Pauses the game on new notifications (defaults to only Critical/Important).
Doesn't pause if notification is already on-screen.

Includes all notifications in Mod Options if you want to pick 'n choose.
Red for Critical, and Blue for Important.



Warning: The notifications for mysteries could be considered spoilers.
]],
})
