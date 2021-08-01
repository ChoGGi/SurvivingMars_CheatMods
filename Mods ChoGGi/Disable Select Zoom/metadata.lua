return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Disable Select Zoom",
	"id", "ChoGGi_DisableSelectZoom",
	"steam_id", "2431723963",
	"pops_any_uuid", "54dd7f54-1ab4-42d3-abcf-88fba81ff734",
	"lua_revision", 1001514, -- Tito
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Normally when you select something it'll zoom the camera to that location (ex: from infobar or workplace).
This will disable that; hold down Ctrl when you want to zoom.


Requested by Eriduan.
]],
})
