return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 9,
		}),
	},
	"title", "Multi-Select",
	"id", "ChoGGi_MultiSelect",
	"steam_id", "1673928672",
	"pops_any_uuid", "d9ea47ff-e175-416f-bcf0-fa8ce3ac4cc0",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[Press Shift-Left mouse and drag to create a radius and select all units within that radius (drones/rovers).
Double Shift-Click a unit to select all units of the same class in the last used radius.
Shift-Click a unit to add/remove that unit from the selection.

Works with most actions, anything that opens up a menu to pick from a list will not work.]],
})
