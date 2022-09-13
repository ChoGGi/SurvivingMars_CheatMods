return PlaceObj("ModDef", {
	"title", "Rocky Surface",
	"id", "ChoGGi_RockySurface",
	"steam_id", "2862224065",
	"pops_any_uuid", "63d16e1f-0bd2-4300-ad2a-ac8941f69cca",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagCosmetics", true,
	"description", [[
Spawns a bunch of rocks on the ground (mod options to change amount, do this before loading the save or reload it).
Once you save then it's stuck as is.


Yea, it isn't realistic, but it's different.


Known Issues:
25 000 takes awhile on the first load, 50 000 takes longer...
]],
})
