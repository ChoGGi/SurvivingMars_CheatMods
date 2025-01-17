return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 4,
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
	"version", 14,
	"version_major", 1,
	"version_minor", 4,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagTools", true,
	"description", [[
Find landing spots with/without a combination of breakthroughs (Extractor AI), resources (metals2), threats(dust_devils4), etc.
Left click an item to move the globe to it.

The first 13 breakthroughs are guaranteed (4 from planetary anomalies, and 9 from ground anomalies). The rest are dependant on story bits/etc.
Paradox sponsor does add an extra 2-4 (random), so if you play with it then it'll bump the count by 2.


Known Issues:
If you have B&B DLC then the planetary anomalies don't work at all. They'll be hidden from search if you don't use my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2721921772]Fix Bugs[/url] mod.
If you use the game rules to disable dlc then this won't work, you need to manually remove hpk files from the DLC folder.
Do not use Tech Variety or Chaos Theory game rules! (they change the breakthrough order).
This mod requires a mouse and keyboard on xbox.
Rare Metals and Metals are always the same count, so don't search for raremetals2 or preciousmetals2 use metals2.


See also: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1491973763]View Colony Map[/url]
]],
})
