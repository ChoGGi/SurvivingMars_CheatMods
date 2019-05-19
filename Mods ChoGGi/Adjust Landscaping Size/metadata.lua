return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Adjust Landscaping Size",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1555675200,
	"image", "Preview.png",
	"id", "ChoGGi_AdjustLandscapingSize",
	"steam_id", "1743029792",
	"pops_any_uuid", "302aab05-f259-496d-92c2-6092c3134c88",
	"author", "ChoGGi",
	"lua_revision", 244677,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adjust the size of Landscaping areas.
Press Shift-Q/Shift-E to increase/decrease the size (rebind them in the controls).

Mod Options:
Step Size: How much to change the size each press.
Remove Landscaping Limits: Ignores most of the errors (NOT out of bounds as that can crash the game).]],
	"TagLandscaping", true,
	"TagInterface", true,
})
