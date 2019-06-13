return PlaceObj("ModDef", {
	"title", "Notification Pause",
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"saved", 0,
	"id", "ChoGGi_NotificationPause",
	"author", "ChoGGi",
	"steam_id", "1411111982",
	"pops_any_uuid", "21a83d51-419f-45fe-810f-2e520b174fb1",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"lua_revision", 245618,
	"has_options", true,
	"description", [[Pauses the game on new notifications (defaults to only Critical/Important).

Includes all notifications in Mod Options if you want to pick 'n choose.
We can't add tooltips to options and some titles are the same, so I had to use the id instead (which doesn't always match up to the title/text).]],
})
