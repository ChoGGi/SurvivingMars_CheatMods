return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_MapImagesPack",
			"title", "Map Images Pack",
			"version_major", 0,
			"version_minor", 2,
		}),
	},
	"title", "View Colony Map",
	"id", "ChoGGi_ViewColonyMap",
	"steam_id", "1491973763",
	"pops_any_uuid", "28b23a4f-7e8f-49b0-965a-3c14a8e4b919",
	"lua_revision", 1007000, -- Picard
	"version", 19,
	"version_major", 1,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Shows the map before you load it in the select colony screen.

Includes a checkbox to show anomaly breakthroughs/buried wonders for each location.
If you use a rule that changes the breakthrough list, then ignore the breakthrough list shown as it isn't accurate anymore.
The first 12 breakthroughs are guaranteed (4 from planetary anomalies, and 8 from ground anomalies). The rest are dependant on story bits/etc.

Also shows map for challenges (mod option to turn it off).

Colour levels: Purple = mountainous, other colours = buildable.

[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1748327771]View all maps[/url]
[url=http://www.survivingmaps.com/]Filtered list of all locations[/url]
]],
})