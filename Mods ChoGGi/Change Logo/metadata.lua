return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Change Logo",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_ChangeLogo",
	"steam_id", "1815122803",
	"pops_any_uuid", "cea590e1-39a4-4e4f-98af-78a7276fb09a",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagColonyLogos", true,
	"description", [[Change the logo after you start a game.

Don't worry about leaving a mod option logo enabled for a different save, this only changes them when you click apply in the mod options.
If you enable more than one mod option it'll change the logo to each one, so whatever is last will win.


[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2206869172]Random Rocket Logo[/url]
]],
})
