return PlaceObj("ModDef", {
	"title", "Fix Borked Mod Building Template",
	"id", "ChoGGi_BorkedModBuildingTemplate",
	"steam_id", "2552439288",
	"pops_any_uuid", "8ac9c513-fbe0-4c94-88ab-413c1c0ff485",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"TagOther", true,
	"description", [[
If the build menu shows a category or two and doesn't open, then crashes when you try and click it.
Also this eror in your log:
[LUA ERROR] Mars/Lua/X/BuildMenu.lua:627: attempt to call a nil value (field 'GetIPDescription')


This mod "should" tell you which building is causing the issue.
]],
})
