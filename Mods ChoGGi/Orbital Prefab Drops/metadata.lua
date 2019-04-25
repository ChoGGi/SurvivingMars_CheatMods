return PlaceObj("ModDef", {
	"title", "Orbital Prefab Drops",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"saved", 1542801600,
	"image", "Preview.png",
	"id", "ChoGGi_OrbitalPrefabDrops",
	"steam_id", "1545818603",
	"pops_any_uuid", "20be6c5b-b62d-41c5-af97-de631190ea8a",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Prefabs are now stored on a space station that will launch them down to the build site.

Something like this was removed from the beta builds? For shame ;)

mod optionss
Inside/Outside Buildings: If you don't want them being dropped off inside (or outside).
Prefab Only: Only rocket drop prefabs (or all buildings depending on above options).
Dome Crack: If the drop is in a dome, it'll crack the glass.
Model Type: 1 = supply pod, 2 = old black hex, 3 = arc pod (Space Race DLC).

Defaults are PrefabOnly = true,Outside = true,Inside = false,DomeCrack = true, ModelType = 1


Known Issues:
Landing doesn't actually cause any dust, it probably should...]],
})
