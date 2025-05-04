return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "Arcology Sanity Restore",
	"id", "ChoGGi_ArcologySanityRestore",
	"steam_id", "3441641694",
	"pops_any_uuid", "7d73bdcc-ffba-430a-a4db-f04919511349",
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
	"TagOther", true,
	"description", [[
Arcology has a Sanity boost (same as Smart Homes).
See mod options to change Sanity amount.


Requested by CptMotviyVodogriyGrozaUvelki&Uya
]],
})
