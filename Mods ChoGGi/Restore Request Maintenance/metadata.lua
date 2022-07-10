return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 5,
		}),
	},
	"title", "Restore Request Maintenance",
	"id", "ChoGGi_RestoreRequestMaintenance",
	"steam_id", "1411114444",
	"pops_any_uuid", "45cb4a51-9b11-463b-93ef-31bf6bb7c8db",
	"lua_revision", 1007000, -- Picard
	"version", 14,
	"version_major", 1,
	"version_minor", 4,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua"
	},
	"description", [[
Restores "Request Maintenance" button (call drones to work).
Also fixes frozen buildings that start a maintenance request during a cold wave and drones don't repair till after cold wave ends.
Use Ctrl-R as a shortcut key (change default in keybindings).


Button stays hidden when maintenance isn't required.
]],
})
