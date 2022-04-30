return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Drones Harvest Rocks",
	"id", "ChoGGi_DronesHarvestRocks",
	"steam_id", "1680679455",
	"pops_any_uuid", "05b09756-8673-4cfb-aa0e-6972134cda0a",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Use the Salvage button to make drones harvest waste rock from small rocks.

Requested by Truthowl.
]],
})
