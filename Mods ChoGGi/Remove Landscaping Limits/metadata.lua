return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 0,
		}),
	},
	"title", "Remove Landscaping Limit",
	"version", 3 + 10, -- stupid mod msg
	"version_major", 0,
	"version_minor", 3,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_AdjustLandscapingSize",
	"steam_id", "1743029792",
	"pops_any_uuid", "a4ef5012-a7d1-4f13-8b09-2e82809cf428",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Ignores most of the "errors" (NOT out of bounds as that can crash the game).



Included in Expanded Cheat Menu.]],
	"TagLandscaping", true,
	"TagInterface", true,
})
