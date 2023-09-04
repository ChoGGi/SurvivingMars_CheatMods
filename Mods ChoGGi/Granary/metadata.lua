return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Granary",
	"id", "ChoGGi_Granary",
	"steam_id", "2808719857",
	"pops_any_uuid", "52e70d94-10fe-45f7-93b8-074df97d25fe",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[
Produces food from seeds (not much else to do with them).

Mod Options:
Seed Ratio: Default seed:food ratio 6:1
Hourly Delay: How many hours per food cube.
Help Vegan Hit: When near domes with ranches, vegan comfort hit is halved.


Known Issues:
Maintenance doesn't rise.
It's really a Gristmill, but I like calling it a Granary.
]],
})
