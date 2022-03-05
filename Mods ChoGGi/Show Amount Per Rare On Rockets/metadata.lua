return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 0,
		}),
	},
	"title", "Show Amount Per Rare On Rockets",
	"id", "ChoGGi_ShowAmountPerRareOnRockets",
	"steam_id", "1515279344",
	"pops_any_uuid", "f5775b12-1e29-495d-a786-154a2c30de74",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds a little info section showing up much loot you get per rare to the selection panel for rockets.

Requested by Bobisback.
]],
})
