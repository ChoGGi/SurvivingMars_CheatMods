return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 0,
		}),
	},
	"title", "Stop Current Disasters",
	"version", 8,
	"version_major", 0,
	"version_minor", 8,

	"id", "ChoGGi_StopCurrentDisasters",
	"author", "ChoGGi",
	"steam_id", "1411115645",
	"pops_any_uuid", "a5c6f132-f1f9-4e98-b637-a180732cb923",
	"code", {
		"Code/Script.lua"
	},
	"image", "Preview.png",
	"lua_revision", 249143,
	"has_options", true,
	"description", [[Stops any running disasters when you load a save.

Includes mod option to disable mod (to leave it installed without that missing mod msg each load).
]],
})
