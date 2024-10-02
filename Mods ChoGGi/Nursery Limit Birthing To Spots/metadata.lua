return PlaceObj("ModDef", {
	"title", "Nursery Limit Birthing To Spots",
	"id", "ChoGGi_NurseryLimitBirthingToSpots",
	"steam_id", "1757251849",
	"pops_any_uuid", "6b40791e-6005-470e-b928-3d2cd08d4a94",
	"lua_revision", 1007000, -- Picard
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
No babby if there's no nursery spot available.
This uses a per-dome count; if there's no nursery in a dome it'll never have babbies (erm, the colonists will never have 'em).

If you want something more random, see my Domes: Limit Births mod.

Compatible mods: Ultimate Nursery, Incubator (this mod will do nothing on Incubator enabled domes).


Mod Options:
All Domes Count: Check spot count of all domes instead of per-dome.
Bypass No Nurseries: If there's no nurseries act like vanilla (default enabled).


Requested by BrowncoatTrekky.
]],
})
