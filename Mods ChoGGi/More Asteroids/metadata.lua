return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 2,
		}),
	},
	"title", "More Asteroids",
	"id", "ChoGGi_MoreAsteroids",
	"steam_id", "2752752807",
	"pops_any_uuid", "fa5dfa47-350d-40e1-a955-f43606713ad6",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagInterface", true,
	"description", [[
Have more than three asteroids.

Mod Options:
Max Asteroids: How many asteroids can you have.
Hide Inactive: Stop showing grayed out asteroids.
Vertical List: Displays buttons in vertical format on the left side of screen.
]],
})
