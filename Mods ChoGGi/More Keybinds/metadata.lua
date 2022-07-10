return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 5,
		}),
	},
	"title", "More Keybinds",
	"id", "ChoGGi_RebindHardcodedKeys",
	"steam_id", "2163750555",
	"pops_any_uuid", "0876037c-42bf-4f8a-8939-36638ba10a62",
	"lua_revision", 1007000, -- Picard
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"TagOther", true,
	"description", [[
Adds new keybinds, and lets you rebind hardcoded keys.

Quicksave/Quickload: Ctrl-F5 / Ctrl-F9
Cycle visual variant backward/forward: [ / ]
Construction cancel: Escape (you'll need to reset your keybinds to restore this as you can't bind esc)
Salvage Cursor: Ctrl-Delete (You may need to reload your save when changing this)
Photo Mode Toggle: Shift-F12
Place Multiple Buildings: Shift
Toggle Interface: Ctrl-Alt-I
Examine Object/Examine Object Radius: F4 / Shift-F4
Refab Building (selected or hovered): Ctrl-R
Set Speed: 1 2 3 4 5 (4/5 = *5/*10). See mod options to change the speed multipliers.
Dialog options: 1 2 3 4.


More key suggestions welcome
]],
})
