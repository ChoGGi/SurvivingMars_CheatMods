return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 0,
		}),
	},
	"title", "Indoor Tribby",
	"id", "ChoGGi_IndoorTribby",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2191485240",
	"pops_any_uuid", "49420dc7-9154-4dc3-95b5-d6cf1a538bf7",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagBuildings", true,
	"has_options", true,
	"description", [[
Same as the usual Triboelectric Scrubber, but cleans inside buildings instead.

Mod Options:
Clean Domes: Cleans the dome it's in (no matter where in the dome it is).
Only Clean Opened Domes: Tribby will only clean if the dome is opened.
]],
})
