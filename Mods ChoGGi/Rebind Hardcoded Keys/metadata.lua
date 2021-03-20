return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 5,
		}),
	},
	"title", "Rebind Hardcoded Keys",
	"id", "ChoGGi_RebindHardcodedKeys",
	"lua_revision", 1001551,
	"steam_id", "2163750555",
	"pops_any_uuid", "0876037c-42bf-4f8a-8939-36638ba10a62",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
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


More keys?
]],
})
