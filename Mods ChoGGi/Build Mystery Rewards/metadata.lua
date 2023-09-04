return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Build Mystery Rewards",
	"id", "ChoGGi_BuildPhilosopherStones",
	"steam_id", "2473444332",
	"pops_any_uuid", "44ae546c-2ac0-43d4-8f2b-74f12fc906b8",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
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
Build mirror sphere excavation sites and spawn spheres (and build capture buildings).


Requested by chivalry20.
]],
})
