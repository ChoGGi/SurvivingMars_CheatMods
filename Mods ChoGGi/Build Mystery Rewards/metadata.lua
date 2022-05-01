return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Build Mystery Rewards",
	"id", "ChoGGi_BuildPhilosopherStones",
	"steam_id", "2473444332",
	"pops_any_uuid", "44ae546c-2ac0-43d4-8f2b-74f12fc906b8",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[
Build philosopher stones to trade electricity for rare metals.
Build sinkholes and spawn fireflies.
Build mirror sphere excavation sites and spawn spheres (build capture buildings first).


Requested by chivalry20.
]],
})
