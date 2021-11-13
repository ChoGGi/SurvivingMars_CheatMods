return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 6,
		}),
	},
	"title", "Waste Rock Dump Site",
	"id", "ChoGGi_WasteRockDumpSite",
	"steam_id", "2313588593",
	"pops_any_uuid", "8672b8b5-64ff-4965-a668-58f35c224421",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
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
