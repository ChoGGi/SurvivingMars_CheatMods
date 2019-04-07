return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Tower Defence v0.4",
	"version", 4,
	"saved", 1551441600,
	"image", "Preview.png",
	"id", "ChoGGi_TowerDefense",
	"steam_id", "1504640997",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Starting at Sol 50 this will spawn an ever increasing amount of attack rovers (with an increasing amount of ammo).

They'll be randomly spawned around the edges (mostly), so build inward.
Starts at 5 rovers with an extra 1 added each Sol (ammo = 4 + 2 each Sol).

Defense Tower tech unlocked at Sol 25.

Balancing ideas?]],
})
