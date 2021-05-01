return PlaceObj("ModDef", {
	"title", "All Sponsor Buildings",
	"id", "ChoGGi_AllSponsorBuildings",
	"steam_id", "1568521664",
	"pops_any_uuid", "da41f738-8ed0-4574-8539-9c7430477b58",
	"lua_revision", 1001514, -- Tito
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.png",
	"author", "ChoGGi",
	"has_options", true,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Removes sponsor limit placed on certain buildings/vehicles.
Some buildings are locked behind tech: Advanced Stirling Generator, Jumper ShuttleHub, and Low-G Lab.

Mod Options:
Lock Behind Tech: You need to research tech to unlock certain buildings (reload save to take effect).
See mod options to disable any buildings you find cheaty (or if you just want one or two unlocked).

You need to research Robotics>Rover Printing to build rovers.
]],
})
