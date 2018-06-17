return PlaceObj("ModDef", {
	"title", "Personal Shuttles v0.3",
	"id", "ChoGGi_PersonalShuttles",
	"steam_id", "1410892053",
	"author", "ChoGGi",
	"version", 3,
	"code", {
		"Script.lua",
	},
	"saved", 1528918364,
	"TagOther", true,
	"image", "Preview.png",
	"description", [[Adds buttons to Drones/RCs/Res depots, so you can pick up and move them with follower shuttles.

If you have drones, resources, or anomalies in un-reachable spaces you can use this to reach them.

Follower shuttles can pick up certain items (storage depots, resource drops, rovers and drones).
Select the item you want to pick up and press "Ignore" so it toggles to "Pickup",
Leave the item selected and keep the mouse near it, a follower shuttle will come and pick it up.
Move to where you want to drop it, and change the shuttle to "Drop Item" (by toggling the "Pickup" button) and select an item nearby where you want it to drop.
Then the shuttle will drop the item close to your mouse cursor.

Attacker: a shuttle that will follow your cursor, scan nearby selected anomalies for you, move items, and attack nearby dustdevils.
Friend: Same as attacker, but ignores dustdevils.

They have a time limit of about four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).

To change the colours, time limit, and so on:
Open Code/UserSettings.lua
I'll build this into a GUI one of these days.



Known Issues
Limited to 50 shuttles, too high and crash goes your game.
Shuttles will glitch sometimes when flying, I'm working on a better way of stopping them mid-flight, but for now, enjoy a little spazzing.]],
})