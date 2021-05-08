return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Wide Area Forestation",
	"id", "ChoGGi_WideAreaForestation",
	"steam_id", "2072656358",
	"pops_any_uuid", "8cb80dc5-846e-4042-8f04-28f46488d8a0",
	"lua_revision", 1001514, -- Tito
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"TagTerraforming", true,
	"description", [[Set a larger grid size for the Forestation Plant (or smaller if you want to spell something).
Adds a button to change all plants to use grid size of selected plant.

Mod Options:
Max Size: Set the max size of the forestation area (can crash when set too high, save before raising).
Plant Interval: Plant vegetation interval in hours.
Remove Power: Remove the requirement for electricity.
]],
})
