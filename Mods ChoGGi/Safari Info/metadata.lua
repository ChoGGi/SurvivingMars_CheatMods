return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 5,
		}),
	},
	"title", "Safari Info",
	"id", "ChoGGi_SafariInfo",
	"steam_id", "2428050982",
	"pops_any_uuid", "72136be6-4453-4f59-903f-489293aa619e",
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
	"TagInterface", true,
	"description", [[When you open a safari route this will mark attractions and show satisfaction amount.
See mod options to change text style.
]],
})
