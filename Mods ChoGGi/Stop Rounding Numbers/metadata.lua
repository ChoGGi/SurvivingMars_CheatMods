return PlaceObj("ModDef", {
	"title", "Stop Rounding Numbers",
	"id", "ChoGGi_StopRoundingNumbers",
	"steam_id", "1983626281",
	"pops_any_uuid", "60f31c5c-2b24-4e54-805d-ee4ff2c14828",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
The game now shows the full amount instead of the truncated one.
180 == 180000

This'll probably mess with the UI somewhere...


Not exactly requested by vonBoomslang.
]],
})
