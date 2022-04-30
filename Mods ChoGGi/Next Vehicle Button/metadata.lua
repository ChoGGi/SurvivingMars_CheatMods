return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Next Vehicle Button",
	"id", "ChoGGi_RocketNextRocketButton",
	"steam_id", "2293455455",
	"pops_any_uuid", "0869b5fc-d5c6-47e5-ab09-fcc3b319d943",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
A button to quickly loop through your rockets (or rovers).


Requested by isntit2017.
]],
})
