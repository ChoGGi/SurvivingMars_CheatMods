return PlaceObj("ModDef", {
	"title", "Fix: Colonists Suffocating Inside Domes",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1546171200,
	"image", "Preview.png",
	"id", "ChoGGi_FixColonistsSuffocatingInsideDomes",
	"steam_id", "1608402660",
	"author", "ChoGGi",
	"lua_revision", 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Some colonists are allergic to doors and suffocate inside a dome with their suit still on.
This checks on load for them and removes their suits; so they can breathe...

https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-w10-dead-colonists-no-oxygen.1141917/]],
})
