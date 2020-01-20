return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 8,
		}),
	},
	"title", "Delete Planetary Anomalies",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_DeletePlanetaryAnomalies",
	"steam_id", "1774213486",
	"pops_any_uuid", "4fa20c81-a38c-4fde-abee-ef73117c827f",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Add a delete button to planetary anomalies (it'll ask first).

Known Issues:
Stuff will look odd till you close then reopen planetary view.
Could also be unknown issues from deleting them...

Requested by MaebeKnot.]],
	"TagInterface", true,
})
