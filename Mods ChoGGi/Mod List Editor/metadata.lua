return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 5,
		}),
	},
	"title", "Mod List Editor",
	"id", "ChoGGi_ModListEditor",
	"steam_id", "2792381698",
	"pops_any_uuid", "968dab7e-d3c7-429d-9a47-89056d2e748e",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
Add a button to the main menu, and the options menu in-game.
Save lists of mods to enable, and manually edit lists.
Lists are saved in your game profile folder\LocalStorage.lua (you can use notepad to edit).

The mod only changes the list of enabled mods (after pressing the "OK" button).
You have to restart the game to enable your list of mods.


Mods are [i]only[/i] enabled in the main menu when you change them in the mod manager.
^ Use this to access the editor in the main menu (make a fake mod to toggle).
]],
})
