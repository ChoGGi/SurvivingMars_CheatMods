return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 3,
		}),
	},
	"title", "Fix Olympus Hotel Stuck Colonists",
	"id", "ChoGGi_FixOlympusHotelStuckColonists",
	"steam_id", "2428732491",
	"pops_any_uuid", "1442ea5d-7d0f-4545-8a93-5c775b59d514",
	"lua_revision", 1001514,
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagOther", true,
	"has_options", true,
	"description", [[
Obsolete: Fixed in https://forum.paradoxplaza.com/forum/threads/tourism-update-hotfix-3.1463960/
(this will still unstick them, since the devs didn't bother doing that)


The hotel uses a door model from Space Race DLC (the Mega Mall), it bugs out when you don't have that DLC.
This will allow the fake door to work properly, and unstick any colonists doing the human centipede.


Turns out this mod also fixes an issue of returning expedition rockets stuck unloading colonists: https://github.com/ChoGGi/SurvivingMars_CheatMods/issues/33
]],
})
