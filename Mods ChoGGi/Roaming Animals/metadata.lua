return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 5,
		}),
	},
	"title", "Roaming Animals",
	"id", "ChoGGi_RoamingAnimals",
	"steam_id", "3325314585",
	"pops_any_uuid", "1aacc028-422d-46bc-a01f-9f54abcfa498",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagTerraforming", true,
	"TagVegetation", true,
	"description", [[
Spawns animals after 100 "promoted" trees (fully grown trees).
By default spawns all animals, see mod options to pick which to spawn.


Mod Options:
Enable Mod: This will only stop new ones from spawning.
Max Spawn: Max amount to spawn (default 50).
Random Graze Time: How long to Graze for (seconds).
Random Idle Time: How long to Idle for (seconds).
]],
})
