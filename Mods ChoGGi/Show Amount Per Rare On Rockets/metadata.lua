return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Show Amount Per Rare On Rockets",
	"version_major", 0,
	"version_minor", 3,
	"saved", 1539950400,
	"image", "Preview.png",
	"id", "ChoGGi_ShowAmountPerRareOnRockets",
	"steam_id", "1515279344",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a little info section showing up much loot you get per rare to the selection panel for rockets.

Requested by Bobisback.]],
})
