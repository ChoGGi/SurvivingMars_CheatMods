return PlaceObj("ModDef", {
	"title", "Salvage Drop Amount",
	"id", "ChoGGi_SalvageDropsAll",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2425210552",
	"pops_any_uuid", "28891b61-907d-48a6-8fb0-1b0a3fee0de0",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[Salvaging a Building/Rover will drop the full amount of resources instead of the paltry sum tossed your way.

Mod Options:
Percent Drop: How much of full amount to drop.

Requested by Aldernut.
]],
})
