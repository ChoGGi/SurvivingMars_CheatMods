return PlaceObj("ModDef", {
	"title", "Research Filter",
	"id", "ChoGGi_ResearchFilter",
	"pops_any_uuid", "9512c863-e72d-41c6-a72f-edc4f9ab143b",
	"steam_id", "1658288931",
	"lua_revision", 1007000, -- Picard
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Add a text box to filter tech in the research screen (filter checks name, description, and id).
Press Shift+Enter to clear filter (or Backspace a bunch).

Has mod option to hide completed tech.

Requested by RustyDios.
]],
})
