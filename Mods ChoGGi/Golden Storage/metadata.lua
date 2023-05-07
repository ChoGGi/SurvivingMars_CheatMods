return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 9,
		}),
	},
	"title", "Golden Storage",
	"id", "ChoGGi_GoldenStorage",
	"steam_id", "1411108831",
	"pops_any_uuid", "b939a69f-92a8-483d-a0d7-89dc76b1727b",
	"lua_revision", 1007000, -- Picard
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Converts Metals to Precious Metals (10 to 1 ratio).


Known Issues:
Don't enable shuttles on it.
]],
})
