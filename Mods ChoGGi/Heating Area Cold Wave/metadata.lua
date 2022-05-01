return PlaceObj("ModDef", {
	"title", "Heating Area Cold Wave",
	"id", "ChoGGi_HeatingAreaColdWave",
	"steam_id", "2433566423",
	"pops_any_uuid", "12b881f6-1945-4438-949c-5e0c6e2eb0d0",
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
	"description", [[The area subsurface heaters/adv stirlings heat during a cold wave is reduced by one hex, but the hex area doesn't change.
This mod bumps the heat range to match the hex area. The artificial sun is skipped since anything within it's hex range doesn't freeze.

Requested by vonBoomslang.
]],
})
