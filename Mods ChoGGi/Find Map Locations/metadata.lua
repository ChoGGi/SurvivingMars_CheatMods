return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 7,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_MapImagesPack",
			"title", "Map Images Pack",
			"version_major", 0,
			"version_minor", 2,
		}),
	},
	"title", "Find Map Locations",
	"id", "ChoGGi_FindMapLocations",
	"steam_id", "2453011286",
	"pops_any_uuid", "b97dbd4e-71cf-4e82-80a0-46dd104133bc",
	"lua_revision", 1001569,
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagTools", true,
	"description", [[
Find maps with/without a combination of breakthroughs (Neo-Concrete, Wireless Power), resources (metals2), threats(dust_devils4), etc.

Left click an item to move the globe to it.
It isn't as pretty as Surviving Maps, but it works...
]],
})
