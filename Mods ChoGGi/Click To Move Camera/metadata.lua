return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Click To Move Camera",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"saved", 1545134400,
	"image", "Preview.png",
	"id", "ChoGGi_ShiftClickToMove",
	"steam_id", "1590473613",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Hold down Shift and click to move the view.
Includes mod option to disable mouse edge scrolling.

You can change the shortcut in Options>Key Bindings.

Kinda requested by Pops.]],
})
