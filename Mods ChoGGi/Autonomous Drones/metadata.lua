return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 7,
		}),
	},
	"title", "Autonomous Drones",
	"id", "ChoGGi_AutonomousDrones",
	"lua_revision", 249143,
	"steam_id", "2313642931",
	"pops_any_uuid", "4313ca38-0202-4d35-b630-1290369995eb",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Takes care of moving drones to different drone controllers.
Each hour build a list of prefab drones, idle drones, drones from low/medium load controllers, then reassign to high/med load controllers.
Drones'll either drive over or pack/unpack over depending on distance (further than dist to controller).
If they're on a task; they'll wait till it's over before reassign.


Mod Options:
Enable Mod: Disable mod without having to see missing mod msg.
Randomise Hub List: Randomise list of drone controllers, so the order is different each update (lowers the chance of "bunching").
Use Prefabs: Use drone prefabs to adjust the loads.
Hide Pack Buttons: Hide Pack/Unpack buttons for drone controllers.
Add Heavy: How many drones to add to heavy load controllers.
Add Medium: How many drones to add to medium load controllers.
Add Empty: How many drones to add to empty controllers.
(Recommendations for the default Add amounts?)
]],
})
