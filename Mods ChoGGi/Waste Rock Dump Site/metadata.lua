return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Waste Rock Dump Site",
	"id", "ChoGGi_WasteRockDumpSite",
	"steam_id", "2313588593",
	"pops_any_uuid", "8672b8b5-64ff-4965-a668-58f35c224421",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"description", [[
It's a dump site for waste rock (99k).


Requested by bloodnok/Norbe
]],
})
