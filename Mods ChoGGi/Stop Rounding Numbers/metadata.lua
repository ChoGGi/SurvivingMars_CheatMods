return PlaceObj("ModDef", {
	"title", "Stop Rounding Numbers",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"id", "ChoGGi_StopRoundingNumbers",
	"steam_id", "1983626281",
	"pops_any_uuid", "60f31c5c-2b24-4e54-805d-ee4ff2c14828",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[The game now shows the full amount instead of the truncated one.
180 == 180000

This'll probably mess with the UI somewhere...


Not exactly requested by vonBoomslang.]],
})
