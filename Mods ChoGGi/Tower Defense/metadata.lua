return PlaceObj("ModDef", {
	"title", "Tower Defense v0.1",
	"version", 1,
	"saved", 1536148800,
	"image", "Preview.png",
	"id", "ChoGGi_TowerDefense",
--~ 	"steam_id", "000000000",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Starting at Sol 50 this will spawn an ever increasing amount of attack rovers (with an increasing amount of ammo).

They'll be randomly spawned around the edges (mostly), so build inward.
Starts at 5 rovers with an extra 1 added each Sol (ammo = 4 + 2 each Sol).

Defense Tower tech unlocked at Sol 25.

Balancing ideas?]],
})
