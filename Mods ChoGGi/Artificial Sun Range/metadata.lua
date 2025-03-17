return PlaceObj("ModDef", {
	"title", "Artificial Sun Range",
	"id", "ChoGGi_ArtificialSunRange",
	"steam_id", "1981650262",
	"pops_any_uuid", "f64b4c50-b2cc-4bdf-87a5-93ef596facd6",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Change the range of the Artificial Sun to add more Solar Panels (mod option defaults to default sun range).

This also fixes the issue of having more than one sun and solar panels ignoring sun + 1.
]],
})
