return PlaceObj("ModDef", {
	"title", "University Vacancies",
	"id", "ChoGGi_UniversityVacancies",
	"steam_id", "3218787770",
	"pops_any_uuid", "dd897658-8274-4d56-b399-a696cecf8b14",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
This adds a mod option (global not per building) that will change the default behavior of university training.

If it's enabled then universities will train based on vacancies instead of work slots.
If two specs have the same vacancies then it'll use whatever spec has less trained colonists.
This won't change how the game fills university slots.

Mod options to exclude certain specs from ever being trained (if you exclude all then it'll pick a random spec).
]],
})
