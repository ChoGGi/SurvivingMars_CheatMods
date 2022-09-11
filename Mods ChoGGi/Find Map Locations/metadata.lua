return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 6,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_MapImagesPack",
			"title", "Map Images Pack",
			"version_major", 0,
			"version_minor", 3,
		}),
	},
	"title", "Find Map Locations",
	"id", "ChoGGi_FindMapLocations",
	"pops_any_uuid", "b97dbd4e-71cf-4e82-80a0-46dd104133bc",
	"steam_id", "2453011286",
	"lua_revision", 1007000, -- Picard
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagTools", true,
	"description", [[
Find landing spots with/without a combination of breakthroughs (Extractor AI), resources (metals2), threats(dust_devils4), etc.
Left click an item to move the globe to it.

The first 12 breakthroughs are guaranteed (4 from planetary anomalies, and 8 from ground anomalies). The rest are dependant on story bits/etc.


Known Issues:
If you have B&B DLC then the planetary anomalies don't work at all. Either ignore the first four breakthroughs, or use my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2721921772]Fix Bugs[/url] mod.
Rare Metals and Metals are always the same count, so don't search for raremetals2 or preciousmetals2 use metals2.
]],
})
