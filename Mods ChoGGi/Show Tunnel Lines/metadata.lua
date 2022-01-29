return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 8,
		}),
	},
	"title", "Show Tunnel Lines",
	"id", "ChoGGi_ShowTunnelLines",
	"steam_id", "1549819585",
	"pops_any_uuid", "6c801099-e2d0-467c-be66-ac733f4cab45",
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
	"description", [[
When any tunnel is selected; this will show lines connecting paired tunnels.

Mod Options:
Remove On Select: Remove lines when selection changes.
Random Colours: Use a few colours, disable to only use white.
]],
})
