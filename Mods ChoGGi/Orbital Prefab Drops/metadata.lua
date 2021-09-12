return PlaceObj("ModDef", {
	"title", "Orbital Prefab Drops",
	"id", "ChoGGi_OrbitalPrefabDrops",
	"steam_id", "1545818603",
	"pops_any_uuid", "20be6c5b-b62d-41c5-af97-de631190ea8a",
	"lua_revision", 1007000, -- Picard
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Prefabs are now stored on a space station that will launch them down to the build site.

Something like this was removed from the beta builds? For shame ;)

Mod Options:
Inside/Outside Buildings: If you don't want them being dropped off inside (or outside).
Prefab Only: Only rocket drop prefabs (or all buildings depending on above options).
Dome Crack: If the prefab site is in a dome, it'll crack the glass.
Model Type: 1 = supply pod, 2 = old black hex, 3 = arc pod, 4 = drop pod (3/4 Space Race DLC).

Defaults are PrefabOnly = true, Outside = true, Inside = false, DomeCrack = true, ModelType = 1



Known Issues:
Hills can intercept drops and make stuff weird (if you have a save that you can reproduce it on I might be able to fix it).
]],
})
