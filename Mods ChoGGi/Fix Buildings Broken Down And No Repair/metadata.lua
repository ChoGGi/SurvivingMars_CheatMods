return PlaceObj("ModDef", {
	"title", "Fix Buildings Broken And No Repair",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_FixBuildingsBrokenDownAndNoRepair",
	"steam_id", "1599190080",
	"pops_any_uuid", "56012643-cfef-4dd2-b358-a80d651b542f",
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[If you have broken down buildings the drones won't repair. This will check for them on load game.
The affected buildings will say something about exceptional circumstances.
Any buildings affected by this issue will need to be repaired with 000.1 resource after the fix happens.

This also has a fix for buildings hit with lightning during a cold wave.




Includes mod option to disable fix.
]],
})
