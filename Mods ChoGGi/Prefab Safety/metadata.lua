return PlaceObj("ModDef", {
	"title", "Prefab Safety",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"saved", 1551441600,
	"image", "Preview.png",
	"id", "ChoGGi_PrefabSafety",
	"steam_id", "1593125913",
	"pops_any_uuid", "7a951985-0bde-425d-a242-a907a566e039",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[If you completely remove a building/rover that was a prefab, this will add back the prefab.
Only works for prefabs placed after mod activation, and yes you can remove/build it over and over to get resources (best just to use Expanded Cheat Menu by that point).

This also unlocks the decommission protocol tech, so you can remove buildings from the get-go.]],
})
