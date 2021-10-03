return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 5,
		}),
	},
	"title", "Disable Dust Storm Maintenance",
	"id", "ChoGGi_DisableDustStormMaintenance",
	"steam_id", "2481711517",
	"pops_any_uuid", "00238afb-5c0f-4c47-aea6-037b74cc006d",
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
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[
When a dust storm starts all MOXIEs and Moisture Vaporators will have maintenance disabled for the duration.
]],
})
