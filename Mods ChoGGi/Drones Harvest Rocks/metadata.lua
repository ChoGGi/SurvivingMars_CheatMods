return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Drones Harvest Rocks",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"id", "ChoGGi_DronesHarvestRocks",
	"steam_id", "1680679455",
	"pops_any_uuid", "05b09756-8673-4cfb-aa0e-6972134cda0a",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"description", [[Use the Salvage button to make drones harvest waste rock from small rocks.

Requested by Truthowl.]],
})
