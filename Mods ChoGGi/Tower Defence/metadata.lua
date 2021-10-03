return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 5,
		}),
	},
	"title", "Tower Defence",
	"id", "ChoGGi_TowerDefense",
	"steam_id", "1504640997",
	"pops_any_uuid", "de575d3f-099e-4c4f-9ab0-18c174506aab",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Starting at Sol 50 this will spawn an ever increasing amount of attack rovers (with an increasing amount of ammo).

They'll be randomly spawned around the edges (mostly), so build inward.
Starts at 5 rovers with an extra 1 added each Sol (ammo = 4 + 2 each Sol).

Defense Tower tech unlocked at Sol 25.
Mod option to stop spawning rovers.

Balancing ideas?
]],
})
