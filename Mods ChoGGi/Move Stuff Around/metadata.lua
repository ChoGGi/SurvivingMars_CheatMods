return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 4,
		}),
	},
	"title", "Move Stuff Around",
	"id", "ChoGGi_MoveStuffAround",
	"steam_id", "2812694974",
	"pops_any_uuid", "bab23bf6-9bc1-4db0-ae72-ee64ab652617",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagInterface", true,
	"description", [[
Adds a button for moving stuff to anything you can select.
Press the button to activate placement mode, then click somewhere on the map to move it.

This places at the centre of the hex (like buildings), if you want freeform then I'll make it a mod option.

Known issues:
Domes/Passages aren't allowed to be moved with this mod, too many issues.
Keyboard + Mouse required! (may change at some period)
May not work great with some stuff (air/water/elec/passages/domes).
]],
})
