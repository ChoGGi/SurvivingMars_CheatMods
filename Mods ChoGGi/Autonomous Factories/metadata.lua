return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 6,
		}),
	},
	"title", "Autonomous Factories",
	"id", "ChoGGi_AutonomousFactories",
	"steam_id", "2854948983",
	"pops_any_uuid", "39ed60a2-8d5f-4fc1-87c0-2f5882ce60e9",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[
Makes factories colonist-free for people that don't like colonists?
I know it's not really autonomous, but close enough...

Mod options to set the Auto Performance of factories without workers, and individual automation.


Requested by Emlin5k.
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2792357619]Autonomous Extractors[/url]
]],
})
