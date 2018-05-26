return PlaceObj("ModDef", {
  "saved", 1527336000,
  "version", 2,
  "title", "Personal Shuttles v0.2",
  "description", "Adds buttons to Shuttles/ShuttleHubs/Drones/RCs/Res depots, so you can pick and move them around.\n\nSpawned shuttles can pick up certain items (storage depots, resource drops, rovers and drones).\nSelect the item you want to pick up and press \"Ignore\" so it toggles to Pickup,\nLeave it selected and the mouseover it, the shuttle will come and pick it up.\nMove to where you want to drop it, and change the shuttle to \"Drop Item\" (from pickup) and select an item nearby where you want it.\nThen the shuttle will drop the item next to your mouse cursor.\nIf you have drones or resources in un-reachable spaces you can use this to move them :)\n\nAttacker: a shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and move items.\nPin it and right-click the pin to have it come to your position (I made it not follow if your mouse is too far away).\nThey have a time limit of about four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).",
  "tags", "Cheats",
  "id", "ChoGGi_PersonalShuttles",
  "author", "ChoGGi",
  "code", {
    "CommonFunctions.lua",
    "_Functions.lua",
    "ShuttleControl.lua",
    "OnMsgs.lua",
    "ReplacedFunctions.lua",
  },
})
