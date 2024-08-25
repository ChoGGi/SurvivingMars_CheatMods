return PlaceObj("ModDef", {
	"title", "Fix Unlock RC Safari Resupply",
	"id", "ChoGGi_Fix UnlockRCSafariResupply",
	"steam_id", "2427995890",
	"pops_any_uuid", "581fb4dc-b070-480e-9633-6af6eaf68d90",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
RC Safaris aren't automagically unlocked in the resupply screen for games saved before Tito/Tourism update.

Not exactly requested by Ataginez.
]],
})
