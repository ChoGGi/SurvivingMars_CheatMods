return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 4,
		}),
	},
	"title", "Reorder Queued Research (Obsolete)",
	"id", "ChoGGi_ReorderQueuedResearch",
	"steam_id", "2449037850",
	"pops_any_uuid", "8ec18d2c-3035-4f7a-8af3-3a6f14507bc0",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Obsolete: devs added this in Picard.


Reorder the research queue with crappy looking buttons.
]],
})
