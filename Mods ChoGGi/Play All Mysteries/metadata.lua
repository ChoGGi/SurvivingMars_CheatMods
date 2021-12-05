return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 6,
		}),
	},
	"title", "Play All Mysteries",
	"id", "ChoGGi_PlayAllMysteries",
	"steam_id", "2605762368",
	"pops_any_uuid", "998e20b3-1f2b-45cd-9895-b896aac26cbb",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
After finishing your current mystery a random one will start.
Mod options shows list of mysteries to enable (can be changed anytime).

Picks first from the list of finished mysteries (see new game>mysteries checkmarks).
Second pick is from a per-save list of finished mysteries.
After that the per-save is reset and it randomly picks again.

You'll get a popup msg when a new one is starting.

Mod Options:
Switch Mystery: Turn this on to pick a new random mystery when you press Apply (may cause unexpected issues!).
Show Mystery: The popup msg will show the name of the new mystery.
]],
})
