return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 5,
		}),
	},
	"title", "ChoGGi Construction Layouts",
	"id", "ChoGGi_Construction_Layouts",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2234863273",
	"pops_any_uuid", "77fd2531-04b6-4e98-9968-f21253455476",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagBuildings", true,
	"description", [[A bunch of construction layouts:

Repeatable Stirlings + Tribby (Infrastructure).
Repeatable large Solar Panels (Power).
Repeatable small Wind Turbines (Power).
Service slices (Dome Services):
Infirmary, Diner, and Grocer / Amphitheater, Diner, and Grocer.
Park slice: Three parks/ponds, and one single in middle (Decorations).

[b]DLC layouts[/b]
Green Planet:
Drone Hub, Universal Depot, Seed Depot, and Forestation Plant (Terraforming)
Colony Design Set:
Repeatable large Wind Turbines (Power).

[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1814592067]Artificial Sun Array[/url]

Known Issues:
The game will lag a bit when placing large layouts.
]],
})
