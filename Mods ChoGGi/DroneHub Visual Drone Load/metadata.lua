return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 8,
		}),
	},
	"title", "DroneHub Visual Drone Load",
	"id", "ChoGGi_DroneHubVisualDroneLoad",
	"steam_id", "1757808500",
	"pops_any_uuid", "ece54f73-e6a5-46e0-9751-4e213822499f",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagCosmetics", true,
	"description", [[
Set colour of DroneHub stripes depending on drone load.
Gray: Idle
Purple: No drones
Green-Orange-Red: Low-Med-Heavy

Mod Options:
Coloured Rovers: As well as changing Drone Hub colours, also change rover colours (off by default since it doesn't reset rover colours).


Requested by VladamirBegemot.

If you only want to know about heavy load ones:
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1759491711]DroneHub: Heavy Load Strobe[/url]
]],
})
--~ Change Pinned Rover Icons: Make the background colour for pinned rover status icons also show load colours.
