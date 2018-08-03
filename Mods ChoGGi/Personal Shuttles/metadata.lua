return PlaceObj("ModDef", {
	"title", "Personal Shuttles v0.3",
	"version", 3,
  "saved", 1533297600,
	"image", "Preview.png",
	"description", [[Adds buttons to Shuttles/ShuttleHubs/Drones/RCs/Res depots, so you can pick and move them around.

Spawned shuttles can pick up certain items (storage depots, resource drops, rovers and drones).
Select the item you want to pick up and press "Ignore" so it toggles to Pickup,
Leave it selected and the mouseover it, the shuttle will come and pick it up.
Move to where you want to drop it, and change the shuttle to "Drop Item" (from pickup) and select an item nearby where you want it.
Then the shuttle will drop the item next to your mouse cursor.
If you have drones or resources in un-reachable spaces you can use this to move them :)

Attacker: a shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and move items.
Pin it and right-click the pin to have it come to your position (I made it not follow if your mouse is too far away).
They have a time limit of about four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).]],
	"id", "ChoGGi_PersonalShuttles",
	"steam_id", "1410892053",
	"author", "ChoGGi",
  "code", {"Script.lua"},
	"TagOther", true,
})