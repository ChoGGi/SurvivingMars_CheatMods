return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Add Quick Save Load Hotkeys",
	"id", "ChoGGi_AddQuickSaveLoadHotkeys",
	"steam_id", "2071297869",
	"pops_any_uuid", "b0c4b8cf-02dc-498f-b2cc-aad055a6022f",
	"lua_revision", 1001514, -- Tito
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[Adds keybinds to quickly save a game, as well as load it.


Requested by Gnith.]],
})
