return PlaceObj("ModDef", {
	"title", "Map Overview Show Surface Resources",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,

	"image", "Preview.png",
	"id", "ChoGGi_MapOverviewShowSurfaceResources",
	"steam_id", "1768449416",
	"pops_any_uuid", "77783c38-6f89-4371-9628-a6fdb2fec8bb",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Adds count of surface resources (metal/polymer) to each sector in the map overview.

Mod Options:
Show Metals/Show Polymers: What you'd expect.
Text Opacity: 0-255 (0 == completely visible).
Text Background: Add black background around info.
Text Style: Defaults to a larger text style, change with this (see tooltip for text styles).


Requested by: Nobody... Though you can thank Skye Storme, since I noticed how often he had to mouse over sectors looking for them.]],
})
