return PlaceObj("ModDef", {
	"title", "All Sponsor Buildings",
	"id", "ChoGGi_AllSponsorBuildings",
	"pops_any_uuid", "da41f738-8ed0-4574-8539-9c7430477b58",
	"steam_id", "1568521664",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"has_options", true,
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Removes sponsor limit placed on certain buildings/vehicles.
Some buildings are locked behind tech: Advanced Stirling Generator, Jumper ShuttleHub, and Low-G Lab.

Mod Options:
You need to research tech to unlock certain buildings (reload save to take effect).
See mod options to disable any buildings you find cheaty (or if you just want one or two unlocked).

You need to research Robotics>Rover Printing to build rovers.
]],
})
