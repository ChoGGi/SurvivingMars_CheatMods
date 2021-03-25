return PlaceObj("ModDef", {
	"title", "Fix Safari No Green Planet",
	"id", "ChoGGi_FixSafariNoGPDLC",
	"steam_id", "2428296255",
	"pops_any_uuid", "7349ec08-42ae-4601-8de9-22c1b2650e93",
	"lua_revision", 1001569,
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagOther", true,
	"description", [[Obsolete: Fixed in https://forum.paradoxplaza.com/forum/threads/tourism-update-hotfix-3.1463960/


If you don't have Green Planet DLC, then GetVisibleSights() will never return a list of sights.
Tested on Tito Hotfix 2, reported by Max Murray.
]],
})
