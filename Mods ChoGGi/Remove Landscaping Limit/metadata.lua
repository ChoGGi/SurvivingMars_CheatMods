return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 7,
		}),
	},
	"title", "Remove Landscaping Limit",
	"id", "ChoGGi_AdjustLandscapingSize",
	"steam_id", "1743029792",
	"pops_any_uuid", "a4ef5012-a7d1-4f13-8b09-2e82809cf428",
	"lua_revision", 1007000, -- Picard
	"version", 6 + 10, -- stupid mod msg
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagLandscaping", true,
	"TagInterface", true,
	"has_options", true,
	"description", [[
Ignores most of the "errors", so you can place in more places.

The landscaping needs to override the BlockingObjects status otherwise you can't flatten next to/under buildings.
This will allow you to build regular buildings on top of others, turn off the blocking objects option if it bothers you (see mod options).

This overrides max and min sizes.

Mod Options:
Step Size: How much to adjust the size of the landscaping area by.
Skip Blocking Objects: Turn on to be able to paint terrain near buildings. This will also allow you to place buildings in odd places.
Allow Out Of Bounds: Turn on to landscape out of bounds (warning can crash when used near the edge of map, save first).
]],
})
