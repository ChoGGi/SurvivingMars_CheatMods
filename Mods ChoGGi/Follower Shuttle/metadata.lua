return PlaceObj("ModDef", {
  "saved", 1526817600,
  "version", 1,
  "title", "Follower Shuttle",
  "description", "Added a ShuttleFollower button to the cheats pane for shuttle hubs.\nClick it to spawn a shuttle that will follow your mouse around; select an anomaly to have it scan it (next step is getting to transfer resources)\nPin it and right-click the pin to have it come to your position (I made it not follow if your mouse is too far away).\nAttacks nearby dustdevils.\n\nAlso has a ShuttleReturnF if you spawned a bunch and want them back in, though they will head back after about four Sols (I was going to do it by fuel, but they get magical fuel when they stop moving...).",
  "tags", "Cheats",
  "id", "ChoGGi_FollowerShuttle",
  "author", "ChoGGi",
  "code", {
    "CommonFunctions.lua",
    "_Functions.lua",
    "InfoPaneCheats.lua",
    "OnMsgs.lua",
    "ReplacedFunctions.lua",
  },
})
