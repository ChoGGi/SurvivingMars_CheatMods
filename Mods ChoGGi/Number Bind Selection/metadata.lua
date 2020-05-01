return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 1,
		}),
	},
	"title", "Number Bind Selection",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_NumberBindSelection",
	"steam_id", "1776371489",
	"pops_any_uuid", "021ac39b-83cd-46db-8217-acbc2276594e",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"TagOther", true,
	"description", [[You can use this to press a number to snap to a rover (or whatever you want).


Ctrl-Num to add selected obj(s), and Shift-Num to remove.
Press the corresponding number to activate selection.

You can have more than one type of obj in a group, but beware that multi-select will base actions on the first obj added to the list.

Mod Options:
Select & View: Instead of just selecting.
Show a marker when View option enabled.]],
})
