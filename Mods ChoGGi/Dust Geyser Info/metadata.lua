return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 9,
		}),
	},
	"title", "Dust Geyser Info",
	"id", "ChoGGi_DustGeyserInfo",
	"steam_id", "2522466305",
	"pops_any_uuid", "b49b376f-7947-4b6b-9200-591becb1d02a",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
Select a dust geyser to see the damage radius.
]],
})
