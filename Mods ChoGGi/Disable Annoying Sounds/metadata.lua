return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 7,
		}),
	},
	"title", "Disable Annoying Sounds",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"id", "ChoGGi_DisableAnnoyingSounds",
	"steam_id", "1816633344",
	"pops_any_uuid", "03c6b6ff-1afd-489e-b923-69f171b248eb",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Stops certain sounds from happening.

You'll need to turn off the mod option and restart if you want to re-enable any disabled sounds.
]],
})
