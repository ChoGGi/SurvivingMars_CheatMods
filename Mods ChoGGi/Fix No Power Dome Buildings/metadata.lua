return PlaceObj("ModDef", {
	"title", "Fix No Power Dome Buildings",
	"id", "ChoGGi_FixNoPowerDomeBuildings",
	"steam_id", "2499783266",
	"pops_any_uuid", "2d626790-e286-4387-9303-f04c8f165dcc",
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
	"TagOther", true,
	"description", [[
Buildings inside a dome may show no power when dome has power (something dust storms).

Mod option to disable afterwards (or leave if you want it to check each load).
]],
})
