return PlaceObj("ModDef", {
	"title", "Fix Transport Negative Amounts",
	"id", "ChoGGi_FixTransportNegativeAmounts",
	"steam_id", "2535851924",
	"pops_any_uuid", "84fcafe9-c8b4-45dd-af5e-3a9557dc85b4",
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
	"TagOther", true,
	"description", [[
On game load check for transport rovers with negative amounts of resources carried (works for DLC rovers as well).


Requested by sammieaurelia.
]],
})
