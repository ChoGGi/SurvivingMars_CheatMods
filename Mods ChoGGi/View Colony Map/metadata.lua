return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_MapImagesPack",
			"title", "Map Images Pack",
			"version_major", 0,
			"version_minor", 3,
		}),
	},
	"title", "View Colony Map",
	"id", "ChoGGi_ViewColonyMap",
	"steam_id", "1491973763",
	"pops_any_uuid", "28b23a4f-7e8f-49b0-965a-3c14a8e4b919",
	"lua_revision", 1007000, -- Picard
	"version", 27,
	"version_major", 2,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Shows the map before you load it in the select colony screen.

Includes a checkbox to show anomaly breakthroughs for each location, as well as one showing underground map.

If you use a rule that changes the breakthrough list, then ignore the breakthrough list shown as it isn't accurate anymore.
The first 13 breakthroughs are guaranteed (4 from planetary anomalies, and 9 from ground anomalies). The rest are dependant on story bits/etc.
Paradox sponsor does add an extra 2-4 (random), so if you play with it then it'll bump the count by 4. Keep in mind the last two aren't guaranteed.

Also shows map for challenges (mod option to turn it off).
Colour levels: Purple = mountainous, other colours = buildable.


Known Issues:
Not XBox compatible (it doesn't open the dialog, no idea why).
If you have B&B DLC then the planetary anomalies don't work at all. Either ignore the first four breakthroughs, or use my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2721921772]Fix Bugs[/url] mod.
If you use the game rules to disable dlc then this won't work, you need to manually remove hpk files from the DLC folder.
Doesn't show underground wonders: To pick wonders use my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2599642948]Underground Cheats[/url] mod.


See also: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2453011286]Find Map Locations[/url]
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1748327771]View all maps[/url]
]],
})