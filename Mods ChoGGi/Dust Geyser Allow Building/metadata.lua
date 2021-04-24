return PlaceObj("ModDef", {
	"title", "Dust Geyser Allow Building",
	"id", "ChoGGi_DustGeyserAllowBuilding",
	"steam_id", "2431086875",
	"pops_any_uuid", "0b91167f-84d4-4856-b763-f2f841af93bd",
	"lua_revision", 1001514, -- Tito
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagOther", true,
	"description", [[Any dust geysers on your map will be treated as regular ground (mostly), cables/pipes/passages are still blocked.

Mod Options:
Enable Mod: Disable mod without having to see missing mod msg.
Delete Geysers: Remove all geyser activity from the map (permanent per-save).
Turn this on and apply mod options, if you load a new map you will have to apply again to delete geysers from that map.
This mod option also needs "Enable Mod" turned on to work.


Requested by a few people.
]],
})
