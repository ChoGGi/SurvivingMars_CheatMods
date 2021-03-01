return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 0,
		}),
	},
	"title", "Change Object Colour",
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.png",
	"id", "ChoGGi_ChangeObjectColour",
	"author", "ChoGGi",
	"steam_id", "1411106049",
	"pops_any_uuid", "a0a607e4-0428-4f68-b507-d2785c727289",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", 249143,
	"description", [[Press F6 to change the colour of selected/moused over object, or all objects of selected type

Use the "Default" checkbox to reset colours.

You can also use Shift+F6 or Ctrl+F6 for random colours and default colours.
]],
})
