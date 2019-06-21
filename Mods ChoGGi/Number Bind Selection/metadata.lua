return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 0,
		}),
	},
	"title", "Number Bind Selection",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_NumberBindSelection",
	"steam_id", "1776371489",
	"pops_any_uuid", "021ac39b-83cd-46db-8217-acbc2276594e",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"TagOther", true,
	"description", [[Use number keys (0-9) to switch between saved groups.

Ctrl-Num to add selected obj(s), and Shift-Num to remove.
Press the corresponding number to activate selection.

You can have more than one type of obj in a group, but beware that multi-select will base actions on the first obj added to the list.

Defaults to just selection, has mod option to select & view.]],
})
