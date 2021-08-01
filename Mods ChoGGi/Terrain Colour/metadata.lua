return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Terrain Colour",
	"id", "ChoGGi_TerrainColour",
	"steam_id", "2552776290",
	"pops_any_uuid", "e486dd9f-7dae-4201-9772-67c0707bedeb",
	"lua_revision", 1001514, -- Tito
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagLandscaping", true,
	"TagCosmetics", true,
	"description", [[
Change the four largest ground textures (permanent per save, terraforming will probably green it).
You have to apply the mod options to change anything.


This mod will take a count of used terrain textures and change the four highest to the ones you pick.
]],
})
