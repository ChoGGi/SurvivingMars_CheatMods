return PlaceObj("ModDef", {
	"title", "Personal Shuttles v0.6",
	"version", 6,
	"saved", 1539950400,
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
Personal shuttles can pick up certain items (rovers, drones, and resource piles).
They have a time limit of four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).

Attacker: a shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and move items.
Friend: Same as attacker, but ignores dustdevils.

How to pickup items:
Select the item you want to pick up and press "Ignore Item" so it changes to "Pickup Item",
Leave it selected and keep the mouse nearby, a personal shuttle will come and pick it up.
On the shuttle click "Pickup Item" so it changes to "Drop Item" and select something nearby where you want it dropped.
Wait.

If you have drones or resources in un-reachable spaces you can use this to move them.


Known Issues:
Limited to 50 shuttles, too high and crash goes your game.
Shuttles will jump up sometimes when flying.]],
})