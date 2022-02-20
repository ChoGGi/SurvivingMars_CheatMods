return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 9,
		}),
	},
	"title", "ChoGGi Construction Layouts",
	"id", "ChoGGi_Construction_Layouts",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2234863273",
	"pops_any_uuid", "77fd2531-04b6-4e98-9968-f21253455476",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
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
Service slice of Infirmary, Diner, and Grocer (Dome Services).
Park slice: Three parks/ponds, and one single in middle (Decorations).
[b]DLC layouts[/b]
Green Planet:
Drone Hub, Universal Depot, Seed Depot, and Forestation Plant (Terraforming)
Colony Design Set:
Repeatable large Wind Turbines (Power).


Requests are welcome.

Known Issues:
The game will lag a bit when placing large layouts.
]],
})
