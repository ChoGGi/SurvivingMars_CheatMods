return PlaceObj("ModDef", {
--~ 	"title", "Fix: Removed Mod Game Rules",
	"title", "Fix Blank Mission Profile",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_FixRemovedModGameRules",
	"steam_id", "1594337615",
	"pops_any_uuid", "4267e930-21b6-4c8d-a5f8-d53134f0a655",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"description", [[If you removed modded rules from your current save then the Mission Profile dialog will be blank.

You don't need to leave this enabled afterwards.

Thanks to LukeH for finding it.]],
})
