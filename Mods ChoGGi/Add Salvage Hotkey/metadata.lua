return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 5,
		}),
	},
	"title", "Add Salvage Hotkey",
	"id", "ChoGGi_AddSalvageHotkey",
	"steam_id", "2049406876",
	"pops_any_uuid", "d2df35a1-0fff-47c7-954c-fd42e3da4cba",
	"lua_revision", 1001569,
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
	"TagOther", true,
	"description", [[Add a "Salvage" hotkey to the key bindings to switch to the salvage mode.
Defaults to using Delete key.

Kinda requested by Ericus1.]],
})
