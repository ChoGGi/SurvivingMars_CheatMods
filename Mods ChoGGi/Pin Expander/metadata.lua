return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 4,
		}),
	},
	"title", "Pin Expander",
	"id", "ChoGGi_PinExpander",
	"steam_id", "1503773725",
	"pops_any_uuid", "5c641ef5-a427-402c-b4f7-d3b579a445fb",
	"lua_revision", 1007000, -- Picard
	"version", 14,
	"version_major", 1,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Clicking a pinned object will show a list of all objects of the same type.

Left-click: View and select.
Right-click: Just view.
Hold down Shift to keep the menu open post-click.

Mouse over an item to highlight it (green).

Colonists are limited to same dome if over 5000.
Hold Shift to show full list.

Hold Ctrl for old pin button functionality (might not work with a gamepad).
Mod option to reverse how ctrl works.
]],
})
