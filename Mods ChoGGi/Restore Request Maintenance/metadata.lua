return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Restore Request Maintenance",
	"version", 14,
	"version_major", 1,
	"version_minor", 4,
	"image", "Preview.jpg",
	"id", "ChoGGi_RestoreRequestMaintenance",
	"author", "ChoGGi",
	"steam_id", "1411114444",
	"pops_any_uuid", "45cb4a51-9b11-463b-93ef-31bf6bb7c8db",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", 1001514, -- Tito
	"description", [[Restores "Request Maintenance" button (call drones to work).
Also fixes frozen buildings that start a maintenance request during a cold wave and drones don't repair till after cold wave ends.
Use Ctrl-R as a shortcut key (change default in keybindings).


Button stays hidden when maintenance isn't required.]],
})
