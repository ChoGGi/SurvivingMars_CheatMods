return PlaceObj("ModDef", {
	"title", "Reorder Queued Research",
	"id", "ChoGGi_ReorderQueuedResearch",
	"steam_id", "2449037850",
	"pops_any_uuid", "8ec18d2c-3035-4f7a-8af3-3a6f14507bc0",
	"lua_revision", 1001569,
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Reorder the research queue with crappy looking buttons.


Known Issues:
Didn't bother finding out a way to update the list, so it closes and reopens the dialog.
It'll take a couple milliseconds, so you'll see a blink and the background animation gets reset.
]],
})
