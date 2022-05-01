return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "More Asteroids",
	"id", "ChoGGi_MoreAsteroids",
	"steam_id", "2752752807",
	"pops_any_uuid", "fa5dfa47-350d-40e1-a955-f43606713ad6",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagInterface", true,
	"description", [[
Have more than three asteroids (change in mod options).
]],
})
