return PlaceObj("ModDef", {
	"title", "Milestone Jonestown",
	"id", "ChoGGi_Milestones", -- Maybe I'll add some more...
	"steam_id", "2545577508",
	"pops_any_uuid", "9bd2f5d5-33bd-49f2-8db7-19c3267cd75d",
	"lua_revision", 1001514, -- Tito
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagGameplay", true,
	"description", [[
Once you hit 909 "suicides" you win the game (if a milestone counts as winning then hearty congrats!).


Known Issues:
The death count doesn't start till you load this mod (or a new game).
There is an UnnaturalDeaths var, but if you have Space Race DLC then the count is doubled (bug report filed).
]],
})
