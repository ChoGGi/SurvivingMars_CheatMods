return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 4,
		}),
	},
	"title", "Underground Surface Tunnels",
	"id", "ChoGGi_UndergroundSurfaceTunnels",
	"steam_id", "3319084893",
	"pops_any_uuid", "aa92b861-866e-484f-abb3-e45adf3c2cfc",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"TagGameplay", true,
	"description", [[
You can use tunnels to send Rovers between different maps (underground/asteroids/etc).

Build two tunnels then use the Choose Tunnel button to connect them.

[b]Grids do NOT connect![/b]


Known Issues:
Grid icons will be visible when placing pipes/etc.
]],
})
