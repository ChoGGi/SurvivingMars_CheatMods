return PlaceObj("ModDef", {
	"title", "Fix Missing Mod Icons",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.png",
	"id", "ChoGGi_FixMissingBuildUpgradeIcons",
	"steam_id", "1725437808",
	"pops_any_uuid", "348b873f-0bb9-4d0f-be3d-875bdeec513e",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"TagOther", true,
	"description", [[
If you have mods missing the build menu, upgrade, crop, etc icons; this is the mod for you.

This will validate images for mod items and try to fix the image path of missing ones.



Modders: See this post for info on manually doing it for your mod
https://steamcommunity.com/workshop/discussions/18446744073709551615/1734336452586149095/?appid=464920]],
})
