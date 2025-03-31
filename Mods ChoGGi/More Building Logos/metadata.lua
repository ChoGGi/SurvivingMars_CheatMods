return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 5,
		}),
	},
	"title", "More Building Logos",
	"id", "ChoGGi_MoreBuildingLogos",
	"steam_id", "3455841960",
	"pops_any_uuid", "ab6663da-28dd-4a10-a572-da5648bec873",
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
	"TagCosmetics", true,
	"description", [[
Add mission logo to more buildings.
]],
})
