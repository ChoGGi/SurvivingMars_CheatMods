return PlaceObj("ModDef", {
	"title", "Cold Battery Rate Limit",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_ColdBatteryRateLimit",
	"steam_id", "1775280362",
	"pops_any_uuid", "09cf3e1f-24b0-4a3b-97df-d08ce2c44d56",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[Battery charge/discharge rates are lowered by 25% in cold areas.
You can use heaters to keep them warm.

Includes masochistic option to apply 25% to capacity as well.

Anyone want percent slider options instead of 25?]],
})
