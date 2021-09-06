return PlaceObj("ModDef", {
	"title", "Real Time Clock",
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.png",
	"id", "ChoGGi_RealTimeClock",
	"steam_id", "1791902061",
	"pops_any_uuid", "22f725e4-1137-47fe-b6de-f92b75fff6f3",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Shows a clock at the top-right with actual hours/minutes (only updated when game isn't paused).

Mod Options:
12/24 time format.
Show Clock.
Text Styles.
Text Background.
Text Opacity.

Requested by Khyinn.]],
})
