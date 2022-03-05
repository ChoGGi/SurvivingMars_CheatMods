return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 0,
		}),
	},
	"title", "Underground Cheats",
	"id", "ChoGGi_UndergroundCheats",
	"steam_id", "2599642948",
	"pops_any_uuid", "4a2eb0eb-0667-4462-9db1-5bd833a233bf",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Change radius of light tripods, and support struts.
]],
})
