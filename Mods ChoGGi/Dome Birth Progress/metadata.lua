return PlaceObj("ModDef", {
	"title", "Dome Birth Progress",
	"id", "ChoGGi_DomeBirthProgress",
	"steam_id", "1598169148",
	"pops_any_uuid", "e51d8425-c492-4f03-9588-f2b2aeb9c709",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Shows a percent build up to when children are spawned.
Once it hits a hundred, it'll slowly tick down afterwards to around zero (then back up again).

This is just a visual mod to let you know what's going on birth rate wise.
]],
})
