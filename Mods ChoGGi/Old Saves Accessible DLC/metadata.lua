return PlaceObj("ModDef", {
	"title", "Old Saves Accessible DLC",
	"id", "ChoGGi_OldSavesAccessibleDLC",
	"steam_id", "2809470263",
	"pops_any_uuid", "7f47b4d8-3e06-4a41-968f-9289ce3284a2",
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
	"TagOther", true,
	"description", [[
The game has two tables, g_AvailableDlc and g_AccessibleDlc. ava means it's installed, acc means you can use it during the current save.
This takes anything in ava and sticks it acc, allowing you to partially use dlc on existing saves (This will NOT work for terraforming).


If you want to build space race stuff with an older save then use this mod.


Requested by Kkat.
]],
})
