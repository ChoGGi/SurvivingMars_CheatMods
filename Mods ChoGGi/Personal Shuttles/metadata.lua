return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Personal Shuttles",
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"id", "ChoGGi_PersonalShuttles",
	"steam_id", "1410892053",
	"pops_any_uuid", "b434660b-9a9a-4057-90d7-91bcb815402a",
	"author", "ChoGGi",
	"TagOther", true,
	"image", "Preview.png",
	"code", {
		"Code/Script.lua",
		"Code/OnMsgs.lua",
	},
	"lua_revision", 1007000, -- Picard
	"description", [[Adds buttons to Shuttle Hubs to spawn personal shuttles.
Personal shuttles can pick up certain items (rovers, drones, resource piles, and waste rock), scan nearby selected anomalies, and attack nearby dust devils.

If you have an object in un-reachable spaces you can use this to move them.

They have a time limit of four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).

Attacker: Attacks nearby dust devils.
Friend: Ignores dust devils.

How to pickup items:
Select the item you want to pick up and press "Ignore Item" so it changes to "Pickup Item",
Leave it selected and keep the mouse nearby, a personal shuttle will come and pick it up.
On the shuttle click "Pickup Item" so it changes to "Drop Item" and select something nearby where you want it dropped.
Wait.

How to scan anomalies:
Select it, and wait for a shuttle to come by (takes the same time as an explorer to scan).



Known Issues:
Limited to 50 shuttles, too high and crash goes your game.
Shuttles will jump up sometimes when flying, just assume it's martian cocaine.]],
})