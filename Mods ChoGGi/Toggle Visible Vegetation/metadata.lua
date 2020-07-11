return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 2,
		}),
	},
	"title", "Toggle Visible Vegetation",
	"id", "ChoGGi_ToggleVisibleVegetation",
	"lua_revision", 249143,
	"steam_id", "2162375075",
	"pops_any_uuid", "e42779d0-c633-4a69-b3c4-69db21c0216f",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagCosmetics", true,
	"description", [[Adds mod option to hide trees.
Includes mod option to also toggle bushes (needs to be enabled if turning visibility back on).


Requested by jfffj.
]],
})
