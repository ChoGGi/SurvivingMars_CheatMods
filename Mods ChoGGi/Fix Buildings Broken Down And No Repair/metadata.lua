return PlaceObj("ModDef", {
	"title", "Fix Buildings Broken And No Repair",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,

	"image", "Preview.png",
	"id", "ChoGGi_FixBuildingsBrokenDownAndNoRepair",
	"steam_id", "1599190080",
	"pops_any_uuid", "56012643-cfef-4dd2-b358-a80d651b542f",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"description", [[The Long Winter event seems to be responsible.

If you have broken down buildings the drones won't repair. This will check for them on load game.
The affected buildings will say something about exceptional circumstances.
Any buildings affected by this issue will need to be repaired with 000.1 resource after the fix happens.



There'll be a fix whenever the next update hits:
https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-wind-turbines-are-no-longer-repaired-by-drones.1141272/#post-25040223]],
})
