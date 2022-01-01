return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 7,
		}),
	},
	"title", "More Heat Buildings",
	"id", "ChoGGi_MoreHeatBuildings",
	"steam_id", "2435302154",
	"pops_any_uuid", "e21529d6-d961-4df7-90f6-35523ff8d7c8",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[
Certain buildings now heat an area.

Stirling
GHG Factory
Fusion Reactor
Extractor with the fueled upgrade
Carbonate Processor with amplify


Requested by [WPS] Lonesamurai.
]],
})
