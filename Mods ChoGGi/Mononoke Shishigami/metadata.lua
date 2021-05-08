return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Mononoke Shishigami",
	"id", "ChoGGi_MononokeShishiGami",
	"steam_id", "1743035716",
	"pops_any_uuid", "9e04e844-d0be-44ab-9558-2db43478a963",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Attack of the shrubbery cursor (shrubs grow behind your cursor and quickly die off like a certain spirit walk).

Includes Mod Option to disable effect.

Does not shrub in building mode.
]],
})
