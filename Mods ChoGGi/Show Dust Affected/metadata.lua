return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 2,
		}),
	},
	"title", "Show Dust Affected",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_ShowDustAffected",
	"steam_id", "1892610371",
	"pops_any_uuid", "54ae2bab-61d4-49ee-9f2e-b5bca4108e57",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"description", [[Adds a button to Dust Generators (Concrete/Metal/Water extractors) that shows which buildings are affected by the dust.
]],
})
