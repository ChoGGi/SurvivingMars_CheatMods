return PlaceObj("ModDef", {
--~ 	"title", "Map Overview Show Surface Resources",
	"title", "Map Overview More Info",
	"id", "ChoGGi_MapOverviewShowSurfaceResources",
	"lua_revision", 1001514,
	"steam_id", "1768449416",
	"pops_any_uuid", "77783c38-6f89-4371-9628-a6fdb2fec8bb",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Count of surface resources (metal/polymer) added to each sector in the map overview.
Scan progress as overlay text to map sectors.

Mod Options:
Show Metals/Show Polymers/Show Scan Progress: What you'd expect.
Text Opacity: 0-255 (0 == completely visible).
Text Background: Add black background around info.
Text Style: Defaults to a larger text style, change with this (see tooltip for text styles).


Known Issues:
The info doesn't update in map overview (zoom in and out to update it).


Requested by: Nobody... Though you can thank Skye Storme, since I noticed how often he had to mouse over sectors looking for them.]],
})
