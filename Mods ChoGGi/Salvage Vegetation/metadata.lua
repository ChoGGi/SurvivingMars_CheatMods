return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 3,
		}),
	},
	"title", "Salvage Vegetation",
	"id", "ChoGGi_SalvageVegetation",
	"steam_id", "1813398570",
	"pops_any_uuid", "4b566c4f-503e-490a-8257-d5cd8aca9e85",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagVegetation", true,
	"TagInterface", true,
	"description", [[
Salvage tool works with trees, bushes, etc.
]],
})
