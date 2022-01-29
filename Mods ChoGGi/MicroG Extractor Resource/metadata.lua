return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 8,
		}),
	},
	"title", "MicroG Extractor Resource",
	"id", "ChoGGi_MicroGExtractorResource",
	"steam_id", "2711881031",
	"pops_any_uuid", "5e035f2e-a22a-4ecf-b4d6-72d35289969b",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
Micro-G Extractors can be forced to extract one resource; goes back to any resource when deposit is empty.

Requested by woundupcanuck.
]],
})
