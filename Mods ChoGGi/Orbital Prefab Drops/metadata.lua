return PlaceObj("ModDef", {
	"title", "Orbital Prefab Drops v0.2",
	"version", 2,
	"saved", 1540382400,
	"image", "Preview.png",
	"id", "ChoGGi_OrbitalPrefabDrops",
	"steam_id", "1545818603",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"description", [[Prefabs are now stored on a space station that will launch them down to the build site.

Something like this was removed from the beta builds? For shame ;)

ModConfig options
Inside/Outside buildings: If you don't want them being dropped off inside (or outside).
Prefab Only: Only rocket drop prefabs (or all buildings dependant on above options).
Detach Rockets: Rockets will detach and fall to the ground (the rockets are just visual, no damage will happen).
Detach Rockets Passages: Blocks the rockets detaching for passages (gets quite busy).

Defaults are PrefabOnly = true,Outside = true,Inside = false,DetachRockets = true,DetachRocketsPassages = false


Known Issues:
Landing doesn't actually cause any dust, it probably should...]],
})
