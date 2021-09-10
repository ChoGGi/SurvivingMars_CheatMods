return PlaceObj("ModDef", {
	"title", "Fix Passenger Rocket Resupply Empty",
	"id", "ChoGGi_FixPassengerRocketResupplyEmpty",
	"steam_id", "2597134592",
	"pops_any_uuid", "3174a7b0-cd1f-42d9-af25-8dc8e0411027",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Fix for old saved games and picard update.


for some reason some traits show up as booleans instead of numbers, no idea why... this skips them so the screen works.
]],
})
