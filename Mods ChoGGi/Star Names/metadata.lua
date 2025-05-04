return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "Star Names",
	"id", "ChoGGi_StarNames",
	"steam_id", "3040736321",
	"pops_any_uuid", "6d63edc0-7bbf-454f-92d2-69f8a46c5e30",
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
	"TagCosmetics", true,
	"description", [[
More names for B&B asteroids (names aren't translated).


There's reusable and unique lists, I went with reusable in the assumption it'll be used more often.
]],
})
