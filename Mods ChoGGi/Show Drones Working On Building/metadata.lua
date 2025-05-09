return PlaceObj("ModDef", {
	"title", "Show Drones Working On Building",
	"id", "ChoGGi_ShowDronesConstructionSite",
	"steam_id", "2089814937",
	"pops_any_uuid", "afc6fa70-2f05-4fb6-b345-756316ac9f02",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"lua_revision", 1007000, -- Picard
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Selected buildings will highlight drones hauling material, on the way, or performing work on it.
Adds a button to cycle through drones working on building (also works for drone hubs).


Requested by Funky.Bigodon.
]],
})
