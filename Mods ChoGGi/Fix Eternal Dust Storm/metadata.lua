return PlaceObj("ModDef", {
	"title", "Fix: Eternal Dust Storm",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1545134400,
	"image", "Preview.png",
	"id", "ChoGGi_FixEternalDustStorm",
	"steam_id", "1594158818",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[There's no notification, but any newly placed buildings will complain about a dust storm.
You don't need to leave this enabled afterwards.

https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-eternal-dust-storm.1139596/]],
})
