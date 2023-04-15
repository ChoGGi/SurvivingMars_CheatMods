return PlaceObj("ModDef", {
	"title", "Fix Sol 2983",
	"id", "ChoGGi_FixSol2983",
	"steam_id", "2705335465",
	"pops_any_uuid", "fbf40e78-a290-47fd-9ebb-f2dcd4b25c0d",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagOther", true,
	"description", [[
[b]Leave this disabled till your playthrough reaches Sol 2981+. This is replacing a core C func with a lua one.[/b]


Stuff gets weird after about Sol 2983 hour 20 min 20.
https://en.wikipedia.org/wiki/2,147,483,647#In_video_games


If switching between your 2983 and other saves: [b]You should disable this mod and restart the game![/b]


https://forum.paradoxplaza.com/forum/threads/surviving-mars-lag-and-unplayable-after-a-certain-sol.1490083/
https://forum.paradoxplaza.com/forum/threads/surviving-mars-all-drones-stops-after-2983-sol-and-integer-oveflow-food-and-fuel.1505366/
]],
})
