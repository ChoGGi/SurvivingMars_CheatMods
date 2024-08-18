return PlaceObj("ModDef", {
	"title", "Custom Map",
	"id", "ChoGGi_CustomMap",
	"steam_id", "3076952392",
	"pops_any_uuid", "c79e4055-7e9d-43c2-aed1-aff0aee69c05",
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
	"TagGameplay", true,
	"description", [[
Shows list of map names in mod options, turn one on to use that at any location (shouldn't touch breakthroughs/etc).


The game comes with two maps, that aren't actually used anywhere...
BlankBigCanyonCMix_10 and BlankBigCratersCMix_02 (thanks kaki_gamet).
They both use prefab_red for some ground, so I had to change it to something else.


Known Issues:
You can load asteroids as your main map, but I wouldn't unless you have some cheaty mods to help you along.
If you don't have my Map Images Pack mod then won't get a preview.
]],
})
