return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 5,
		}),
	},
	"title", "Meteoroid Deposits",
	"id", "ChoGGi_MeteoroidDeposits",
	"steam_id", "2595725692",
	"pops_any_uuid", "f732d166-c37c-4ad0-9998-c01e1f72e9c1",
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
	"TagGameplay", true,
	"description", [[
Once you get below the threshold (see mod options), a new deposit will come sailing in on a large rock (random pos or away from domes).

Threshold defaults to 1 for each type of deposit.
]],
})
