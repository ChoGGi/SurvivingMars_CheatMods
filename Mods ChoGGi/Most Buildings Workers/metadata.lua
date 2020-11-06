return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 6,
		}),
	},
	"title", "Most Buildings Workers",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"id", "ChoGGi_MostBuildingsWorkers",
	"steam_id", "1823230886",
	"pops_any_uuid", "a02a0bc7-cafb-4f27-baf3-67fa87b0ee5f",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[Adds mod options to add workers to all buildings without workers.
This means buildings will require domes, even if workers is set to 0.

This defaults to not requiring workers for any buildings (that's up to you).
This won't work on mod buildings (even if they show up in the options).
If anyone is up for making a list of specs for each building? [url=https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Mods%20ChoGGi/Most%20Buildings%20Workers/specs]specs[/url]

Default Performance is the performance of buildings without workers (default 100).

This doesn't include wonders, see [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1816298791]Wonder Workers[/url] for that.
This also skips some of the goofier ones like Depots and Decorations (I can add them if they're wanted).
]],
})
