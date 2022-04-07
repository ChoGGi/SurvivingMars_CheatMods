return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 2,
		}),
	},
	"title", "Centred HUD",
	"id", "ChoGGi_CentredHUD",
	"steam_id", "1594140397",
	"pops_any_uuid", "55b08156-3710-4274-afdf-4e8d046da0b8",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Centres HUD for ultrawide resolutions.

Use mod option to set screen margin, when you find one that works for your resolution then please send me your res and margin, so I can add it to the lookup table.
Setting the mod option will override the lookup table.

Currently included in lookup:
5760x1080 (48:9): 2560
3840x1080 (32:9): 960
7680x1440: 1802
7680x1378: 1600
7680x1411: 1600


Known Issues:
This just fixes the in-game HUD, I didn't bother with anything else.
Some stuff isn't centred: blue pause overlay, console, console log, and cheat menu.
Messes with my Map Overview More Info, so this is disabled when zoomed into map overview with that mod enabled.
]],
})
