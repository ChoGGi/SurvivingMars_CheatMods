return PlaceObj("ModDef", {
	"title", "Orbital Prefab Drops v0.5",
	"version", 5,
	"saved", 1542801600,
	"image", "Preview.png",
	"id", "ChoGGi_OrbitalPrefabDrops",
	"steam_id", "1545818603",
	"pops_any_uuid", "20be6c5b-b62d-41c5-af97-de631190ea8a",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"description", [[Prefabs are now stored on a space station that will launch them down to the build site.

Something like this was removed from the beta builds? For shame ;)

Mod Config Reborn options
Inside/Outside Buildings: If you don't want them being dropped off inside (or outside).
Prefab Only: Only rocket drop prefabs (or all buildings depending on above options).
Dome Crack: If the drop is in a dome, it'll crack the glass.
Model Type: 1 = supply pod, 2 = old black hex, 3 = arc pod (needs space race).

Defaults are PrefabOnly = true,Outside = true,Inside = false,DomeCrack = true, ModelType = 1


Known Issues:
Landing doesn't actually cause any dust, it probably should...]],
})
