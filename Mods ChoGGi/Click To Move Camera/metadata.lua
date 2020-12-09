return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 7,
		}),
	},
	"title", "Click To Move Camera",
	"id", "ChoGGi_ShiftClickToMove",
	"steam_id", "1590473613",
	"pops_any_uuid", "66775804-4873-47bf-8ffb-005195ebb5c8",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Hold down Shift and click to move the view.
Includes mod option to disable mouse edge scrolling.

You can change the shortcut in Options>Key Bindings.

Kinda requested by Pops.]],
})
