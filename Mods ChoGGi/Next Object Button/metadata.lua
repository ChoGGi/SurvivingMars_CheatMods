return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 9,
		}),
	},
	"title", "Next Object Button",
	"id", "ChoGGi_RocketNextRocketButton",
	"steam_id", "2293455455",
	"pops_any_uuid", "0869b5fc-d5c6-47e5-ab09-fcc3b319d943",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
A button to quickly loop through your rockets, rovers, buildings.


Requested by isntit2017.
]],
})
