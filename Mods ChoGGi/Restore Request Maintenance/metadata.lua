return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 8,
		}),
	},
	"title", "Restore Request Maintenance",
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"image", "Preview.png",
	"id", "ChoGGi_RestoreRequestMaintenance",
	"author", "ChoGGi",
	"steam_id", "1411114444",
	"pops_any_uuid", "45cb4a51-9b11-463b-93ef-31bf6bb7c8db",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", 249143,
	"description", [[Restores "Request Maintenance" button.
Also fixes frozen buildings that start a maintenance request during a cold wave and drones don't repair till after cold wave ends.


It stays hidden when maintenance isn't required.]],
})
