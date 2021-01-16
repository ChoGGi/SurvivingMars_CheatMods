return PlaceObj("ModDef", {
	"title", "Fix Remove Blue Yellow Grid Marks",
	"id", "ChoGGi_FixRemoveBlueYellowGridMarks",
	"steam_id", "1553086208",
	"pops_any_uuid", "7486c4ab-af06-42d5-b30d-7815ac10998b",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[This will remove any blue or yellow grid marks from around objects when you load a game.
Includes mod option to disable.

This also takes care of stuck "ghost" rovers from transport tasks.
By design this will not remove the grids added by SkiRich's Toggle Hub Zone mod. You'll need to manually turn them off.
]],
})
