return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 0,
		}),
	},
	"title", "Increase Ranch Storage",
	"id", "ChoGGi_IncreaseRanchStorage",
	"lua_revision", 1001514, -- Tito
	"steam_id", "2155123211",
	"pops_any_uuid", "ef3dc1b6-2657-49dc-bf0e-4d610d74eae9",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"TagCrops", true,
	"description", [[Increase the limit allowed for the ranch storage depots, so cows are practical.

Sets storage to 600, see mod options to change (if you use a mod that increases output).]],
})
