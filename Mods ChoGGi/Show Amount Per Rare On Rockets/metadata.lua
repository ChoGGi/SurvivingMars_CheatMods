return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 5,
		}),
	},
	"title", "Show Amount Per Rare On Rockets",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,

	"image", "Preview.png",
	"id", "ChoGGi_ShowAmountPerRareOnRockets",
	"steam_id", "1515279344",
	"pops_any_uuid", "f5775b12-1e29-495d-a786-154a2c30de74",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a little info section showing up much loot you get per rare to the selection panel for rockets.

Requested by Bobisback.]],
})
