return PlaceObj("ModDef", {
	"title", "Cold Battery Rate Limit",
	"id", "ChoGGi_ColdBatteryRateLimit",
	"steam_id", "1775280362",
	"pops_any_uuid", "09cf3e1f-24b0-4a3b-97df-d08ce2c44d56",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[
Battery charge/discharge rates are lowered by 25% in cold areas.
You can use heaters to keep them warm, see mod options to change percent.

Includes masochistic mod option to apply penalty to capacity as well.
]],
})
