return PlaceObj("ModDef", {
	"title", "Personal Shuttles v0.7",
	"version", 7,
	"saved", 1542456000,
	"id", "ChoGGi_PersonalShuttles",
	"steam_id", "1410892053",
	"author", "ChoGGi",
	"TagOther", true,
	"image", "Preview.png",
	"code", {
		"Code/Script.lua",
		"Code/OnMsgs.lua",
	},
	"lua_revision", LuaRevision,
	"description", [[Adds buttons to Shuttle Hubs to spawn personal shuttles.
Personal shuttles can pick up certain items (rovers, drones, and resource piles), scan nearby selected anomalies, and attack nearby dust devils.

They have a time limit of four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).

Attacker: Will attack nearby dust devils.
Friend: Ignores dust devils.

How to pickup items:
Select the item you want to pick up and press "Ignore Item" so it changes to "Pickup Item",
Leave it selected and keep the mouse nearby, a personal shuttle will come and pick it up.
On the shuttle click "Pickup Item" so it changes to "Drop Item" and select something nearby where you want it dropped.
Wait.

To scan anomalies:
Select it, and wait for a shuttle to come by (takes the same time as an explorer).

If you have drones or resources in un-reachable spaces you can use this to move them.


Known Issues:
Limited to 50 shuttles, too high and crash goes your game.
Shuttles will jump up sometimes when flying, just assume it's martian cocaine.]],
})