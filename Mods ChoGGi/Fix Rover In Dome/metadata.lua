return PlaceObj("ModDef", {
	"title", "Fix Rover In Dome",
	"id", "ChoGGi_FixRoverInDome",
	"steam_id", "1829688193",
	"pops_any_uuid", "050f06ea-99ba-4697-b1dd-a514eef86da5",
	"lua_revision", 1001514, -- Tito
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagGameplay", true,
	"TagOther", true,
	"has_options", true,
	"description", [[Checks on load (or when mod options are applied) for rovers stuck in domes (not open air ones).

Includes mod option to disable fix.
]],
})
