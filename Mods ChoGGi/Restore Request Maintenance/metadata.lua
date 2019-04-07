return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Restore Request Maintenance v0.9",
	"version", 9,
	"saved", 1539950400,
	"image", "Preview.png",
	"id", "ChoGGi_RestoreRequestMaintenance",
	"author", "ChoGGi",
	"steam_id", "1411114444",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 243725,
  "description", [[Restores "Request Maintenance" button.

It's set not to show up unless you can request maintenance.]],
})
