return PlaceObj("ModDef", {
	"title", "Mission Randomizer",
	"id", "ChoGGi_MissionRandomizer",
	"steam_id", "2939111511",
	"pops_any_uuid", "d1c25b58-1845-4bd5-a02e-130e32de323f",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
After picking a landing spot you get a random Location, Sponsor, Commander, Mystery, Logo, Rivals, and Game Rules.


By default this mod won't use game rules that disable achievements.
See mod options to set amount of game rules, as well as skipping random, skipping certain rules, and picking custom ones.

Known Issues:
You can cheese the start by picking IMM and loading up a rocket.


Requested by Weazul
]],
})
