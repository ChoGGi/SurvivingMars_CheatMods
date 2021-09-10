return PlaceObj("ModDef", {
	"title", "Fix Colonists Suffocating Inside Domes",
	"id", "ChoGGi_FixColonistsSuffocatingInsideDomes",
	"pops_any_uuid", "72e37f65-c438-4a50-b25b-5dbd330256eb",
	"steam_id", "1608402660",
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
	"TagOther", true,
	"description", [[
Some colonists are allergic to doors and suffocate inside a dome with their suit still on.
This checks on load for them and removes their suits; so they can breathe...
Includes mod option to disable fix.

https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-w10-dead-colonists-no-oxygen.1141917/
]],
})
