return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 4,
		}),
	},
	"title", "Autonomous Drones",
	"id", "ChoGGi_AutonomousDrones",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2313642931",
	"pops_any_uuid", "4313ca38-0202-4d35-b630-1290369995eb",
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
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
This will hide the now useless pack/unpack drone prefab buttons (use mod option to show them).


Mod Options:
[b]Sort Hub List Load[/b]: Sort hub list by drone load order (overrides random list).
Turning off means randomise order of drone controllers for receiving drones.
[b]Use Prefabs[/b]: Use drone prefabs to adjust the loads.
[b]Update Delay[/b]: On = Sol, Off = Hour.
[b]Hide Pack Buttons[/b]: Hide Pack/Unpack buttons for drone controllers.
[b]Drone Work Delay[/b]: How many "seconds" to wait before forcing the busy drone (0 to disable and wait).
[b]Early Game[/b]: If under this amount of drones then try to evenly distribute drones across controllers instead of by load (0 to always enable, 1 to disable).
[b]Add Empty/Heavy/Medium[/b]: How many drones to add to empty and heavy/medium load controllers.
[b]Ignore Unused Hubs[/b]: Any hubs not "used" will have their drones ignored (manual assignment only).
[b]Use Drone Hubs/RC Commanders/Rockets[/b]: Toggle assigning or ignoring certain controllers.


Known Issues:
If you turn off update delay then the drone work delay may build up a bunch of drones to be reassigned, I plan to have a system to limit "waiting" drones next update or two.
The lower delay will help shuffle drones around quicker, but it'll look like adding limits are being ignored.
]],
})
