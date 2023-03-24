return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 8,
		}),
	},
	"title", "Wide Area Forestation",
	"id", "ChoGGi_WideAreaForestation",
	"steam_id", "2072656358",
	"pops_any_uuid", "542a9ecf-a195-48ea-8f52-6e716ea4f1be",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"TagTerraforming", true,
	"description", [[
Set a larger grid size for the Forestation Plant (or smaller if you want to write something).
Adds a button to change all plants to use grid size of selected plant.


Mod Options:
Plant Interval: Plant vegetation interval in hours.
Remove Power: Remove the requirement for electricity.
Max Size: Set the max size of the forestation area (can crash when set too high, save before raising).

The game has a hard limit on objects, and selecting a plant makes a lot of objects (each hex is counted as one), so depending on how large your colony is...
]],
})
