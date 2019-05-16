return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Change Drone Type",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"saved", 1550750400,
	"image", "Preview.png",
	"id", "ChoGGi_ChangeDroneType",
	"steam_id", "1592984375",
	"pops_any_uuid", "0d35f043-f2eb-4f38-ac2c-12459370a41c",
	"author", "ChoGGi",
	"lua_revision", 244677,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adds a button to hubs and rovers that lets you switch between wasp (flying) and regular drones (global setting, not per building).

mod options:
Option to only show button when Martian Aerodynamics is researched.]],
})
