return PlaceObj("ModDef", {
	"title", "Construction Sites Start Off",
	"id", "ChoGGi_ConstructionSitesStartOff",
	"lua_revision", 1001514, -- Tito
	"steam_id", "2098431358",
	"pops_any_uuid", "043cdf2e-81b7-46d0-85ae-208ce4730a88",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[Newly placed construction sites will be turned off.


Mod Options:
Turn Off: Disable this to place buildings normally.
Skip Grids: Don't turn off cables and pipes.
Skip Passages: Don't turn off passages.
]],
})
