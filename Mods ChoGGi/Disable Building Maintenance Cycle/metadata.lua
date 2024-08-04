return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 2,
		}),
	},
	"title", "Disable Building Maintenance Cycle",
	"id", "ChoGGi_DisableBuildingMaintenanceCycle",
	"steam_id", "3042801784",
	"pops_any_uuid", "2ee0ad6b-b88a-4c89-9101-e9471f4d9362",
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
	"TagInterface", true,
	"description", [[
Adds a toggle to building selection dialog to have drones ignore building maintenance when it runs out.


Requested by thecppzoo.
https://www.reddit.com/r/SurvivingMars/comments/16tyqlx/question_is_there_a_mod_that_turns_off_buildings/
]],
})
