return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "Remove Building Limits",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_RemoveBuildingLimits",
	"steam_id", "1763802580",
	"pops_any_uuid", "02c7ead1-2851-4ad8-aeb9-019869450697",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Changes all errors to warnings (not landscaping ones, see Remove Landscaping Limits for those).

This will also attach any inside buildings placed outside to the nearest dome (there's a new Sol check for a working/closer dome).
]],
})
