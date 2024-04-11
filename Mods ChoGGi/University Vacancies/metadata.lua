return PlaceObj("ModDef", {
	"title", "University Vacancies",
	"id", "ChoGGi_UniversityVacancies",
	"steam_id", "3218787770",
	"pops_any_uuid", "dd897658-8274-4d56-b399-a696cecf8b14",
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
	"TagGameplay", true,
	"description", [[
This adds a mod option (global not per building) that will change the default behavior of university training.

If it's enabled then universities will train based on vacancies instead of work slots (if two specs have same needs then use lower spec amount to decide).
]],
})
