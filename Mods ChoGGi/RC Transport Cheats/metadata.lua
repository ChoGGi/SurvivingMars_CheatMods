return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "RC Transport Cheats",
	"id", "ChoGGi_RCTransportCheats",
	"steam_id", "2744688978",
	"pops_any_uuid", "648aa047-e33b-4074-9574-513fbd4eec3a",
	"lua_revision", 1007000, -- Picard
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Transports in auto mode will pick up any loose resources (excluding those within range of drone hubs/commanders).
Mod option to change storage amount / speed it takes to harvest from surface, and option to auto mode wasterock.


Known Issues:
If you have a few dozen rovers then weird things may happen (though that might just be the game).
]],
})
