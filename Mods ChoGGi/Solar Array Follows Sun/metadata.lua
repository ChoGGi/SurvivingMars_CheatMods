return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 2,
		}),
	},
	"title", "Solar Array Follows Sun",
	"id", "ChoGGi_SolarArrayFollowsSun",
	"steam_id", "1570918489",
	"pops_any_uuid", "105b752a-e526-4055-9009-c253bbe0e3fa",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
The panels do it, why not the array panels?
I also made the arrays sink into the ground at night.

Requested by tresslessone.
]],
})
