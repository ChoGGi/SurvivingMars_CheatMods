return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 2,
		}),
	},
	"title", "Rockets Auto Land",
	"id", "ChoGGi_RocketsAutoLand",
	"steam_id", "2562669388",
	"pops_any_uuid", "1d61ec45-44ba-4059-8abc-24b5a10066e0",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Rockets will automagically land on pads.
Pad to land on is picked alphabetically.

You need to set both the pads and the rockets for auto-landing.
Auto-landing for rockets can only be changed when landed, pads can be changed anytime.


Requested by DracoDruid.
]],
})
