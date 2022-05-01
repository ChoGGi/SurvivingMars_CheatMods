return PlaceObj("ModDef", {
	"title", "Fix Dredger Mark Left On Ground",
	"id", "ChoGGi_FixDredgerMarkLeftOnGround",
	"steam_id", "1646258448",
	"pops_any_uuid", "f5b38d61-00d0-46b0-80bf-a98bd6bd79dd",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
(To keep spoilers to a minimum) it's a fix for this issue:
https://www.reddit.com/r/SurvivingMars/comments/mo3kjv/what_are_those_blue_circles/
https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-dredgers-mark-remains.1150177/

This isn't too tested, so you shouldn't leave it enabled if you're playing the mystery without the issue.

Includes mod option to disable fix.
]],
})
