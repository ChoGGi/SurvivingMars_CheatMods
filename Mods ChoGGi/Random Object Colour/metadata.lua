return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 2,
		}),
	},
	"title", "Random Object Colour",
	"id", "ChoGGi_RandomBuildingColour",
	"steam_id", "1535187230",
	"pops_any_uuid", "be840c93-a616-4175-9049-472b297c897c",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[Changes the colours of objects to random colours when placed.

If someone wants the colours reset, let me know and I'll add something to Expanded Cheat Menu or this (whatever is easier).

Requested by McKaby]],
})
