return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 5,
		}),
	},
	"title", "Rares Per Rocket",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.png",
	"id", "ChoGGi_RaresPerRocket",
	"steam_id", "1743865995",
	"pops_any_uuid", "6ba1c4f3-0855-450f-881a-0d33b5f6f64a",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Default to 90 rares per rocket.
Has Mod Option to change amount.

Requested by Mrpellaeon.]],
})
