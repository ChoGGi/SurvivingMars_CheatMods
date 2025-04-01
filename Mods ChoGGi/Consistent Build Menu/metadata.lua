return PlaceObj("ModDef", {
	"title", "Consistent Build Menu",
	"id", "ChoGGi_ConsistentBuildMenu",
	"steam_id", "3456220743",
	"pops_any_uuid", "41890fe3-8730-4944-bc52-0103c68805cd",
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
	"TagInterface", true,
	"description", [[
Sort build menu items by display name.

A few items (and any subcategories) are added when showing the menu, those aren't sorted by name.

Disable mod and restart game to go back to original menu.
]],
})
