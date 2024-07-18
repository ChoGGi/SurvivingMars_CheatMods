return PlaceObj("ModDef", {
	"title", "Disable Disasters",
	"id", "ChoGGi_DisableDisasters",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"steam_id", "1973429171",
	"pops_any_uuid", "c2b7a541-8403-4ec8-912f-d69a34b39c86",
	"lua_revision", 1007000, -- Picard
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
See Mod Options to disable certain disasters.
Once an option is set it'll apply to all games, so remember to turn off as needed.

Applying the mod options in-game will restart any existing disaster threads, current disasters should be unaffected, but countdowns might be reset.
Toggle the mod in the mod manager (to temp enable mod options in main menu) then change the mod options before loading a save if you don't want the above to happen.


Disasters you cause by storybits/etc don't count!


Requested by did_you_read_it.
]],
})
