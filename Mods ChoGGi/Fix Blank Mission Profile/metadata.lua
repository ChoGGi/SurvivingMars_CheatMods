return PlaceObj("ModDef", {
	"title", "Fix Blank Mission Profile",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_FixRemovedModGameRules",
	"steam_id", "1594337615",
	"pops_any_uuid", "4267e930-21b6-4c8d-a5f8-d53134f0a655",
	"author", "ChoGGi",
	"lua_revision", 1001569,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[If you removed modded rules from your current save then the Mission Profile dialog will be blank.

You don't need to leave this enabled afterwards.
Includes mod option to disable fix.

Thanks to LukeH for finding it.
]],
})
