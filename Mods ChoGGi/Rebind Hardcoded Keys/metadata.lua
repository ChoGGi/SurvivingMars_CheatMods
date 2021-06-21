return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 0,
		}),
	},
	"title", "Rebind Hardcoded Keys",
	"id", "ChoGGi_RebindHardcodedKeys",
	"steam_id", "2163750555",
	"pops_any_uuid", "0876037c-42bf-4f8a-8939-36638ba10a62",
	"lua_revision", 1001514, -- Tito
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"TagOther", true,
	"description", [[Lets you rebind hardcoded keys.

Cycle visual variant backward: [
Cycle visual variant forward: ]
Construction cancel: Escape (you'll need to reset your keybinds to restore this as you can't bind esc)
Salvage Cursor: Ctrl-Delete (You may need to reload your save when changing this)


More keys?
]],
})
