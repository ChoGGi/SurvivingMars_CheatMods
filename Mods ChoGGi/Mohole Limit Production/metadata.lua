return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 2,
		}),
	},
	"title", "Mohole Limit Production",
	"id", "ChoGGi_WonderCheats", -- eh might add more stuff
	"steam_id", "2532590401",
	"pops_any_uuid", "86be1e59-737d-4bb5-87e7-ad728ac714c1",
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
	"description", [[
Add buttons to Mohole to toggle producing resources.
]],
})
