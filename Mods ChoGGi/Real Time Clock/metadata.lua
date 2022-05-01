return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Real Time Clock",
	"id", "ChoGGi_RealTimeClock",
	"steam_id", "1791902061",
	"pops_any_uuid", "22f725e4-1137-47fe-b6de-f92b75fff6f3",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Shows a clock at the top-right with actual hours/minutes (only updated when game isn't paused).

Mod Options:
12/24 time format.
Show Clock.
Text Styles.
Text Background.
Text Opacity.

Requested by Khyinn.
]],
})
