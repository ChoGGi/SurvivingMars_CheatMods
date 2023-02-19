return PlaceObj("ModDef", {
	"title", "Fix Shuttles Stuck Mid-Air",
	"id", "ChoGGi_FixShuttlesStuckMidAir",
	"steam_id", "1549680063",
	"pops_any_uuid", "fa1f8a78-767f-4322-a4ff-13f83a354bf9",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
If you've got any shuttles stuck mid-air, this checks for them on load.

You should disable it afterwards (or at least till the next time it happens) in mod options, or it'll keep resetting your shuttles.
]],
})
