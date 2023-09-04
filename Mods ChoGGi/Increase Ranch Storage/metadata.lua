return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Increase Ranch Storage",
	"id", "ChoGGi_IncreaseRanchStorage",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2155123211",
	"pops_any_uuid", "ef3dc1b6-2657-49dc-bf0e-4d610d74eae9",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"TagCrops", true,
	"description", [[
Increase the limit allowed for the ranch storage depots, so cows are practical.

Sets storage to 600, see mod options to change (if you use a mod that increases output).
]],
})
