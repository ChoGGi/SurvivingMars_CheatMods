return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 9,
		}),
	},
	"title", "Autonomous Drones",
	"id", "ChoGGi_AutonomousDrones",
	"lua_revision", 249143,
	"steam_id", "2313642931",
	"pops_any_uuid", "4313ca38-0202-4d35-b630-1290369995eb",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Takes care of moving drones to different drone controllers (hubs/shuttles/rovers).
Each Sol build a list of prefab drones, idle drones, drones from low/medium load controllers, then reassign to high/med load controllers.
Drones'll either drive over or pack/unpack over depending on distance (further than dist to controller).
If they're on a task; they'll wait till it's over before reassign (set delay in mod options).


Mod Options:
Enable Mod: Disable mod without having to see missing mod msg.
Sort Hub List Load: Sort hub list by drone load order (overrides random list).
Turning off means randomise list of drone controllers, so the order is different each update (helps reduce "bunching").
Use Prefabs: Use drone prefabs to adjust the loads.
Update Delay: On = Sol, Off = Hour.
Hide Pack Buttons: Hide Pack/Unpack buttons for drone controllers.
Drone Work Delay: How many "seconds" to wait before forcing the busy drone (0 to disable and wait).
Early Game: If under this amount of drones then try to evenly distribute drones across controllers instead of by load (0 to always enable, 1 to disable).
Ignore Unused Hubs: Any hubs not used will have their drones ignored (manual assignment only).
Use Drone Hubs/RC Commanders/Rockets: Toggle assigning or ignoring certain controllers.
Add Empty/Heavy/Medium: How many drones to add to empty and heavy/medium load controllers.


Known Issues:
If you turn off update delay then the drone work delay may build up a bunch of drones to be reassigned, I plan to have a system to limit "waiting" drones next update or two.
The lower delay will help shuffle drones around quicker, but it'll look like adding limits are being ignored.
]],
})
