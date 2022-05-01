return PlaceObj("ModDef", {
	"title", "Rocket Pin Enable",
	"id", "ChoGGi_RocketPinEnable",
	"steam_id", "1743882177",
	"pops_any_uuid", "d187dde3-9f13-4074-89c6-5d7a88003ed9",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.png",
	"author", "ChoGGi",
	"has_options", true,
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"description", [[
Adds the pin button back to rockets (if you want to unpin them).

Includes mod option to re-pin all rockets (if you unpinned an orbiting one).

Requested by naresh963.
]],
})
