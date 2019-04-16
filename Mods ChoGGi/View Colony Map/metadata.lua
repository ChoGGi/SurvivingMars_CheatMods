return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_MapImagesPack",
			"title", "Map Images Pack",
			"version_major", 0,
			"version_minor", 1,
		}),
	},
	"title", "View Colony Map",
	"version", 20,
	"version_major", 0,
	"version_minor", 9,
	"saved", 1542888000,
	"image", "Preview.png",
	"id", "ChoGGi_ViewColonyMap",
	"steam_id", "1491973763",
	"pops_any_uuid", "28b23a4f-7e8f-49b0-965a-3c14a8e4b919",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 244275,
	"description", [[Shows the map before you load it in the select colony screen.

For those wondering: Purple = mountainous, other colours = buildable.

All maps: https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/Map%20Images%20Pack/Maps]],
})