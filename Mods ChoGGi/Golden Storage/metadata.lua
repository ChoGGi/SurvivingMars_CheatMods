return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 7,
		}),
	},
	"title", "Golden Storage",
	"version", 8,
	"version_major", 0,
	"version_minor", 8,

	"image", "Preview.png",
	"id", "ChoGGi_GoldenStorage",
	"author", "ChoGGi",
	"steam_id", "1411108831",
	"pops_any_uuid", "b939a69f-92a8-483d-a0d7-89dc76b1727b",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"lua_revision", 1001514, -- Tito
	"description", [[Converts Metals to Precious Metals (10 to 1 ratio).]],
})
