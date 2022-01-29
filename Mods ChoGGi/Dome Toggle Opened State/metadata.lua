return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 8,
		}),
	},
	"title", "Dome Toggle Opened State",
	"id", "ChoGGi_DomeToggleOpenedState",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2211515319",
	"pops_any_uuid", "25e34382-41fd-40f5-9a6e-34bc9ece44ba",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"TagTerraforming", true,
	"TagInterface", true,
	"description", [[
Adds a button to domes to toggle individual opened state (requires breathable atmosphere).
]],
})
