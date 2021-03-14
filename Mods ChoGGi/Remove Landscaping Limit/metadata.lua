return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 1,
		}),
	},
	"title", "Remove Landscaping Limit",
	"version", 5 + 10, -- stupid mod msg
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.png",
	"id", "ChoGGi_AdjustLandscapingSize",
	"steam_id", "1743029792",
	"pops_any_uuid", "a4ef5012-a7d1-4f13-8b09-2e82809cf428",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"TagLandscaping", true,
	"TagInterface", true,
	"has_options", true,
	"description", [[Ignores most of the "errors" (NOT out of bounds as that can crash the game).

The landscaping needs to override the BlockingObjects status otherwise you can't flatten next to/under buildings.
This will allow you to build regular buildings on top of others, turn off the blocking objects option if it bothers you (see mod options).

This overrides max and min sizes.
]],
})
