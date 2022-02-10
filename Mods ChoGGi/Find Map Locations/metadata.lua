return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 8,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_MapImagesPack",
			"title", "Map Images Pack",
			"version_major", 0,
			"version_minor", 2,
		}),
	},
	"title", "Find Map Locations",
	"id", "ChoGGi_FindMapLocations",
	"pops_any_uuid", "b97dbd4e-71cf-4e82-80a0-46dd104133bc",
	"steam_id", "2453011286",
	"lua_revision", 1007000, -- Picard
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagTools", true,
	"description", [[
Find landing spots with/without a combination of breakthroughs (Extractor AI), resources (metals2), threats(dust_devils4), etc.

The first 12 breakthroughs are guaranteed (4 from planetary anomalies, and 8 from ground anomalies). The rest are dependant on story bits/etc.

Left click an item to move the globe to it.
For something easier to use: [url=https://survivingmaps.com/]Surviving Maps[/url] (if the devs add new breakthroughs, then you'll have to use this mod till it gets updated).
]],
})
