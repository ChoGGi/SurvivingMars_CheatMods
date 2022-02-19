return PlaceObj("ModDef", {
	"title", "Construction Sites Start Off",
	"id", "ChoGGi_ConstructionSitesStartOff",
	"steam_id", "2098431358",
	"pops_any_uuid", "043cdf2e-81b7-46d0-85ae-208ce4730a88",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[
Newly placed construction sites will be turned off.


Mod Options:
Turn Off: Disable this to place buildings normally.
Skip Grids: Don't turn off cables and pipes.
Skip Passages: Don't turn off passages.
]],
})
