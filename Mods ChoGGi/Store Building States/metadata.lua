return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Store Building States",
	"version", 20,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1555243200,
	"image", "Preview.png",
	"id", "ChoGGi_StoreBuildingStates",
	"steam_id", "1713268417",
	"pops_desktop_uuid", "0defb259-a312-4a66-930a-c17112004766",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds menus to buildings that will save/remove the state of that building (power,workshift,priority) in a profile.
You can switch profiles using the HUD button, and there's no limit on the amount of profiles or buildings in a profile.

Includes checkbox to add all buildings of the same type using the same state as the selected building.


Other building states to add, or other suggestions?]],
})
