return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 4,
		}),
	},
	"title", "More Keybinds",
	"id", "ChoGGi_RebindHardcodedKeys",
	"steam_id", "2163750555",
	"pops_any_uuid", "0876037c-42bf-4f8a-8939-36638ba10a62",
	"lua_revision", 1007000, -- Picard
	"version", 19,
	"version_major", 1,
	"version_minor", 9,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"TagOther", true,
	"description", [[
Adds new keybinds, and lets you rebind hardcoded keys. All keys can be changed in options>keybinds.


Cycle visual variant backward/forward: [ / ]
Place Multiple Buildings: Shift
Construction Cancel: Escape (if you change this; you'll need to reset your keybinds to restore default)
Salvage Cursor: Ctrl-Delete (You may need to reload your save when changing this)
Toggle Interface: Ctrl-Alt-I
Quicksave/Quickload: Ctrl-F5 / Ctrl-F9
Photo Mode Toggle: Shift-F12
Examine Object/Examine Object Radius: F4 / Shift-F4
Refab Building (selected or hovered): Ctrl-R
Set Speed: 1 2 3 4 5 (4/5 = *5/*10)
Dialog options: 1 2 3 4 (on-screen question dialog with list of options)
Cycle through different levels of opacity for resource icons: Ctrl-I
Fill Selected Depot: Ctrl-F
Quickly switch between maps (surface/underground/asteroids): Ctrl-* (* = 1-5, 1 being surface)


Mod Options:
Set Speed 4/Set Speed 5: Multiply speed of fastest speed by this (speed multipliers for Set Speed).
Opacity Step Size: How much to cycle through on each press (default 25%).
Examine Objects Radius: How big of a radius to use for objects around cursor (Shift-F4).


More key suggestions welcome.
]],
})
