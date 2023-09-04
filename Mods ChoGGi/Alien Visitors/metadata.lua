return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Alien Visitors",
	"id", "ChoGGi_AlienVisitors",
	"steam_id", "1569952407",
	"pops_any_uuid", "9be66a96-5731-4b56-8176-1af851ce18c4",
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
	"description", [[
It'll spawn a few aliens that walk around. Maybe I'll add some sort of ship drop-off anim...

There's a mod options to set the max spawned amount. It'll only work on new games or games that don't have aliens.
]],
})
