return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 3,
		}),
	},
	"title", "Solar Array Follows Sun",
	"id", "ChoGGi_SolarArrayFollowsSun",
	"steam_id", "1570918489",
	"pops_any_uuid", "105b752a-e526-4055-9009-c253bbe0e3fa",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
The panels do it, why not the array panels?

This is a purely visual mod, it just makes the panels rotate to follow the sun.

Requested by tresslessone.
]],
})
