return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 9,
		}),
	},
	"title", "Notes",
	"id", "ChoGGi_Notes",
	"steam_id", "2692788508",
	"pops_any_uuid", "a754726f-1e92-450a-b2ae-61815e7d9cd0",
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
	"TagTools", true,
	"description", [[
Places big/small "note" buildings you can use to store text.
Notepad opens on building selection (there's a button to toggle in mod options).
Mod options for width/height of notepad.

Requested by samirahope.
]],
})
