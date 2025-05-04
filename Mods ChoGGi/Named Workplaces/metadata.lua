return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "Named Workplaces",
	"id", "ChoGGi_NamedWorkplaces",
	"steam_id", "1822631100",
	"pops_any_uuid", "dd48a2c8-9647-494c-ac21-0d11eb0534fc",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"TagCosmetics", true,
	"TagOther", true,
	"description", [[
Workplaces are named after the first person to work in it.
Translations would be nice, the string I use is: "<name>'s <workplace>, est. <sol>"


You can thank mrudat for the idea.
]],
})
