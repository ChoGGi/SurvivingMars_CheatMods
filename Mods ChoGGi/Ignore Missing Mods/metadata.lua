return PlaceObj("ModDef", {
	"title", "Ignore Missing Mods",
	"id", "ChoGGi_IgnoreMissingMods",
	"steam_id", "2609826623",
	"pops_any_uuid", "9f2ce7d4-63ad-4253-9e86-50eb955345b3",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Stops confirmation dialog about missing mods when loading saved games with disabled mods.
]],
})
