return PlaceObj("ModDef", {
	"title", "Drone Controller Show Available Resources",
	"id", "ChoGGi_DroneControllerShowAvailableResources",
	"steam_id", "1822481407",
	"pops_any_uuid", "de76c1e8-9ef1-4e47-a3ff-dfcd4d516e34",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.png",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Wondering why the little buggers aren't repairing a building?

The Service Area tooltip now shows a list of resources available to the selected Drone Hub, Rocket, or Rover.
Construction placement (for Dronehubs) / rocket landing mode will display (rounded) resource counts at the cursor.
Drone selection panel "Commanded by" tooltip will also show resources (if they have a commander).

See mod options to change the text scale.
]],
})
