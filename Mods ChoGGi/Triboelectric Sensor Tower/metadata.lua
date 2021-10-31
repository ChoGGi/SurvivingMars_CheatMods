return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 6,
		}),
	},
	"title", "Triboelectric Sensor Tower",
	"id", "ChoGGi_TriboelectricSensorTower",
	"steam_id", "2201623384",
	"pops_any_uuid", "aab7ae97-d2e0-42d6-bbf8-18c5a6efaee5",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[Adds a sensor tower that doubles as a Triboelectric Scrubber.
Mod option to lock it behind the tribby tech (default enabled).


Requested by sargatanus.]],
})
