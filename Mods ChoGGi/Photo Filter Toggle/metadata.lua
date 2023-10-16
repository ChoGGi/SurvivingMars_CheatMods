return PlaceObj("ModDef", {
	"title", "Photo Filter Toggle",
	"id", "ChoGGi_PhotoFilterToggle",
	"steam_id", "1825629300",
	"pops_any_uuid", "43fb08ee-07f7-4b0f-ad0b-c0e2927c2b14",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagPhotoFilters", true,
	"TagOther", true,
	"description", [[Toggle photo filters during gameplay.

If you enable more than one filter, whichever is last will be the one enabled.
]],
})
