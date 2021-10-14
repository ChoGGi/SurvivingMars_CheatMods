return PlaceObj("ModDef", {
	"title", "Log Flush",
	"id", "ChoGGi_LogFlush",
	"steam_id", "1414089790",
	"pops_any_uuid", "7d2ffef4-855b-400a-9b23-ad5384d979bc",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"has_options", true,
	"TagTools", true,
	"TagOther", true,
	"description", [[
This calls the FlushLogFile() function as soon as the game loads, as well as each new Sol.
Now if SM crashes a certain way (that doesn't create the log), you still have a log to look at (unless you're on Xbox).

Also included are mod options to flush more often.

Logs can be found in the logs folder in your game profile:
https://steamcommunity.com/sharedfiles/filedetails/?id=1777493789
]],
})
