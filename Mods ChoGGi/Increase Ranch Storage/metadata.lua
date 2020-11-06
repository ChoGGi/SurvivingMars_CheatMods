return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 6,
		}),
	},
	"title", "Increase Ranch Storage",
	"id", "ChoGGi_IncreaseRanchStorage",
	"lua_revision", 249143,
	"steam_id", "2155123211",
	"pops_any_uuid", "b6010dad-35d6-40c4-afd7-4659b033cff7",
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
