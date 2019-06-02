return PlaceObj("ModDef", {
	"title", "Nursery: Limit Birthing To Spots",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_NurseryLimitBirthingToSpots",
	"steam_id", "1757251849",
	"pops_any_uuid", "6b40791e-6005-470e-b928-3d2cd08d4a94",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[No babby if there's no nursery spot available.
This uses a per-dome count; if there's no nursery in a dome it'll never have babbies (erm, the colonists will never have 'em).

If you want something more random, see my Domes: Limit Births mod.

Mod Options:
All Domes Count: Check spot count of all domes instead of per-dome.
Bypass No Nurseries: If there's no nurseries act like vanilla (default enabled).
Respect Incubator: Allow SkiRich's Incubator mod to relocate newborns to incubator dome.
Ultimate Nursery: Count Ultimate Nurseries INSTEAD of regular ones.


Requested by BrowncoatTrekky.]],
})
