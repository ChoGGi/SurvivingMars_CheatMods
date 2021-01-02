return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 9,
		}),
	},
	"title", "Change Drone Type",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,

	"image", "Preview.png",
	"id", "ChoGGi_ChangeDroneType",
	"steam_id", "1592984375",
	"pops_any_uuid", "0d35f043-f2eb-4f38-ac2c-12459370a41c",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adds a button to hubs and rovers that lets you switch between wasp (flying) and regular drones (global setting, not per building). You will need to repack/unpack to change them on current hubs.

Mod Options:
Option to only show button when Martian Aerodynamics is researched.
Always Wasp Drones: Forces drones to always be wasp drones.]],
})
