return PlaceObj("ModDef", {
	"title", "Tourists Remove Specs",
	"id", "ChoGGi_TouristsRemoveSpecs",
	"steam_id", "2431912606",
	"pops_any_uuid", "5cabd295-b917-4324-ac87-f84a54355dfc",
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
Remove specializations from all tourists, so filters work a little better.
Mod option to disable (only applies to new tourists, existing have specs removed).

This mod does nothing if Automated Tourism is installed.

Requested by pikasnoop.
]],
})
