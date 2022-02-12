return PlaceObj("ModDef", {
	"title", "Remove SupplyPod Limit",
	"id", "ChoGGi_RemoveSupplyPodLimit",
	"steam_id", "2037219360",
	"pops_any_uuid", "b13bcfad-df78-47f5-8834-c991e2d25a86",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagGameplay", true,
	"description", [[
Remove limit for Rovers/Drones (1/8 > 2/20) on supply pods.

Also removes 20 limit for drones (and anything else with a limit).
]],
})
