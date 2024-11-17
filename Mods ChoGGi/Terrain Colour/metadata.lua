return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 3,
		}),
	},
	"title", "Terrain Colour",
	"id", "ChoGGi_TerrainColour",
	"steam_id", "2552776290",
	"pops_any_uuid", "e486dd9f-7dae-4201-9772-67c0707bedeb",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagLandscaping", true,
	"TagCosmetics", true,
	"description", [[
This mod will take a count of used terrain textures and change the four highest to the ones you pick.
(permanent per save, terraforming will probably green it)

You have to apply the mod options to change anything.
]],
})
