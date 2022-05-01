return PlaceObj("ModDef", {
	"title", "Omega Unlocks All Slowly",
	"id", "ChoGGi_OmegaUnlocksAllSlowly",
	"steam_id", "1732442747",
	"pops_any_uuid", "b8b0933a-99cd-4580-a921-619171e39289",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
The Omega Telescope will unlock a new breakthrough every 10 Sols.

Mod Options:
Sols Between Unlock: How many Sols to wait before unlocking the next one (default 10).
Show Notification: Show a notification when a breakthrough is unlocked.
Random Chance: If you want to gamble your chance of unlocking breakthoughs each Sol (0 = disabled).

Check the Research tooltip in the Infobar to see how many Sols till next unlock (assuming you've raised Sols Between Unlock).

Requested by BrowncoatTrekky.
]],
})
