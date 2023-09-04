return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Stop Current Disasters",
	"id", "ChoGGi_StopCurrentDisasters",
	"steam_id", "1411115645",
	"pops_any_uuid", "a5c6f132-f1f9-4e98-b637-a180732cb923",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"image", "Preview.png",
	"has_options", true,
	"description", [[
Stops any running disasters when you load a save.

Includes mod option to disable mod (to leave it installed without that missing mod msg each load).
]],
})
