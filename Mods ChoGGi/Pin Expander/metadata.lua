return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Pin Expander",
	"version_major", 0,
	"version_minor", 6,
	"saved", 1544097600,
	"image", "Preview.png",
	"id", "ChoGGi_PinExpander",
	"steam_id", "1503773725",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Clicking a pinned object will show a list of all objects of the same type.

Left-click: View and select.
Right-click Just view.
Hold down Shift to keep the menu open post-click.

Mouse over an item to highlight it (green).

Colonists are limited to same dome if over 5000.
Hold Shift to show full list.

Hold Ctrl for old pin button functionality (might not work with a gamepad, but only console users would sink to that level).]],
})
