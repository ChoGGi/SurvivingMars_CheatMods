return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "More Heat Buildings",
	"id", "ChoGGi_MoreHeatBuildings",
	"steam_id", "2435302154",
	"pops_any_uuid", "e21529d6-d961-4df7-90f6-35523ff8d7c8",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[Baby stirling, and extractors with the fueled upgrade now heat an area.


Requested by [WPS] Lonesamurai.
]],
})
