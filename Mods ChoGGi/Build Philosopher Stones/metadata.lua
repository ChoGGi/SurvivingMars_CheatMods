return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Build Philosopher Stones",
	"id", "ChoGGi_BuildPhilosopherStones",
	"steam_id", "2473444332",
	"pops_any_uuid", "44ae546c-2ac0-43d4-8f2b-74f12fc906b8",
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
	"TagBuildings", true,
	"description", [[
Lets you build Philosopher Stones to trade electricity for rare metals.

You can also build sinkholes and spawn fireflies.


Requested by chivalry20.
]],
})
