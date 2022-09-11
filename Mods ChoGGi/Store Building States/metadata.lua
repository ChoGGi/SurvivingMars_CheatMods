return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 6,
		}),
	},
	"title", "Store Building States",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,

	"image", "Preview.png",
	"id", "ChoGGi_StoreBuildingStates",
	"steam_id", "1713268417",
	"pops_desktop_uuid", "d80e39f7-43bc-4f8a-89a6-72bfbadcbd11",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds menus to buildings that will save/remove the state of that building (power,workshift,priority) in a profile.
You can switch profiles using the HUD button, and there's no limit on the amount of profiles or buildings in a profile.

Includes checkbox to add all buildings of the same type using the same state as the selected building.


Other building states to add, or other suggestions?]],
})
