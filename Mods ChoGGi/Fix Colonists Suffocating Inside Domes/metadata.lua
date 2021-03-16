return PlaceObj("ModDef", {
	"title", "Fix Colonists Suffocating Inside Domes",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_FixColonistsSuffocatingInsideDomes",
	"steam_id", "1608402660",
	"pops_any_uuid", "72e37f65-c438-4a50-b25b-5dbd330256eb",
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Some colonists are allergic to doors and suffocate inside a dome with their suit still on.
This checks on load for them and removes their suits; so they can breathe...
Includes mod option to disable fix.

https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-w10-dead-colonists-no-oxygen.1141917/]],
})
